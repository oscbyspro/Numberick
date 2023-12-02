//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Prime Sieve
//*============================================================================*

/// A generator of all prime `elements` through some `limit`.
///
/// ### Sieve all primes through some « limit »
///
/// ```swift
/// let ((sieve)) = NBKPrimeSieve(size: .KiB(64))
/// while sieve.limit < 1_000_000 {
///     ((sieve)).increment()
/// }
/// ```
///
/// ### Sieve at least « count » number of primes
///
/// ```swift
/// let ((sieve)) = NBKPrimeSieve(size: .KiB(64))
/// while sieve.elements.count < 1_000_000 {
///     ((sieve)).increment()
/// }
/// ```
///
///
public final class NBKPrimeSieve: CustomStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// All prime `elements` from zero through `limit`.
    ///
    /// The max `limit` is `UInt.max` so all `UInt` values can be sieved.
    ///
    /// - Requires: `limit == page * increment &- 1`
    ///
    /// - Requires: `elements == all primes in 0 ... limit`
    ///
    @usableFromInline var state: State
    
    /// A collection of bits represeted by a collection of words.
    ///
    /// - Requires: Each bit must be set at the start and end of each access.
    ///
    @usableFromInline var cache: Cache
    
    /// A cyclical pattern used to skip multiples of small primes.
    @usableFromInline let wheel: Wheel
    
    /// A cyclical pattern used to cull multiples of small primes.
    @usableFromInline let small: Small
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance and sieves the first page.
    ///
    /// - Note: A page contains `1` odd number per bit in `size`.
    ///
    public init(size: Size) {
        self.cache = Cache(size: size)
        self.wheel = Wheel(primes: [2, 3, 5, 7])
        self.small = Small(primes: Array(wheel.primes[1...]))
        self.state = Self.makeInitialState(&cache, wheel, small)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The highest value checked for primality.
    @inlinable public var limit: UInt {
        self.state.limit
    }
    
    /// A list of all primes from zero through `limit`.
    @inlinable public var elements: [UInt] {
        self.state.elements
    }
    
    /// The number of elements sieved per `increment()`.
    @inlinable public var stride: UInt {
        self.cache.count &<< 1 as UInt // OK, see size
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public var description: String {
        "\(Self.self)(limit: \(self.limit), count: \(self.elements.count))"
    }
    
    //*========================================================================*
    // MARK: * Size
    //*========================================================================*
    
    /// The size of the sieve.
    ///
    /// Larger sieves evaluate more numbers per page and use more memory.
    ///
    /// - Note: The first KiB yields all 1900 prime numbers through 16383.
    ///
    /// - Note: The CPU's L1 data cache is the sweet spot (128 KiB on Apple M1).
    ///
    /// ### Page Alignment
    ///
    /// The last page near will overflow unless the page ends at `UInt.max`.
    ///
    /// - Note: All values can be sieved when the page size is a power of two.
    ///
    @frozen public struct Size {

        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// The number of words per page.
        ///
        /// It represents at most `Int.max` bits so the odd number stride fits.
        ///
        /// - Requires: `2 * UInt.bitWidth * words <= UInt.max`
        ///
        @usableFromInline let words: Int
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @usableFromInline init(@NBK.MoreThanZero words: Int) {
            self.words = words
            precondition(words <= (Int.max / UInt.bitWidth),
            "the prime sieve's increment must fit in UInt")
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        /// The size per page measured in KiB (i.e. 1024 B).
        @inlinable public static func KiB(_ count: Int) -> Self {
            Self(words: count * (8 * 1024 / UInt.bitWidth))
        }
        
        /// The size per page measured in words.
        @inlinable public static func words(_ count: Int) -> Self {
            Self(words: count)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NBKPrimeSieve {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Sieves the next page of ``NBKPrimeSieve/increment`` number of values.
    @inline(never) @inlinable public func increment() {
        precondition(!self.limit.addingReportingOverflow(self.stride).overflow)
        Swift.assert((self.cache.base).allSatisfy({ $0.onesComplement().isZero }))
        //=--------------------------------------=
        let start = self.limit &+ 00000000002
        let limit = self.limit &+ self.stride
        var inner = NBK.CyclicIterator(self.wheel.increments)!
        //=--------------------------------------=
        // mark composites not hit by the wheel
        //=--------------------------------------=
        precull: do {
            var pattern = NBK.CyclicIterator(self.small.pattern)!
            pattern.set(iteration: 1  &+ NBK.PBI.quotient(dividing: NBK.ZeroOrMore(self.limit &>> 1), by: NBK.PowerOf2(bitWidth: UInt.self)))
            self.cache.sieve(pattern: pattern)
        }
        //=--------------------------------------=
        // mark composites using prime elements
        //=--------------------------------------=
        for prime in self.elements.dropFirst(self.wheel.primes.count) {
            let square = prime.multipliedReportingOverflow(by: prime)
            guard square.partialValue <= limit, !square.overflow else { break }
            
            var lowerBound  = start / prime
            Swift.assert(lowerBound < start / 2)
            if  lowerBound &* prime < start {
                lowerBound &+= 0001 as UInt
            }
            
            let index =  lowerBound.quotientAndRemainder(dividingBy: self.wheel.circumference)
            let multiple = index.quotient &* self.wheel.circumference &+ self.wheel.values[Int(bitPattern: index.remainder)]
            let product  = prime.multipliedReportingOverflow(by: multiple)
            guard product.partialValue <= limit, !product.overflow else { continue }
            Swift.assert(start <= product.partialValue)
            
            inner.set(unchecked: Int(bitPattern: self.wheel.indices[Int(bitPattern: multiple % self.wheel.circumference)]))
            cache.sieve(from: (product.partialValue &- start) &>> 1 as UInt,stride:{ prime &* inner.next() &>> 1 as UInt }) // OK
        }
        //=--------------------------------------=
        Self.commit(&self.cache, to: &self.state)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// - Note: It wraps around, so preconditions should be checked prior to it.
    @inline(never) @inlinable static func commit(_ cache: inout Cache, to state: inout State) {
        for index in cache.base.indices {
            var chunk = cache.base[index]
            var position = state.limit
            
            while !chunk.isZero {
                let shift  = UInt(bitPattern: chunk.trailingZeroBitCount)
                chunk   &>>= shift
                position &+= shift &<< 1 as UInt
                chunk   &>>= 1 as UInt
                position &+= 2 as UInt
                state.elements.append(position)
            }
            
            cache.base[index] = chunk.onesComplement()
            state.limit &+= UInt(bitPattern: UInt.bitWidth) &<< 1 as UInt
        }
    }
    
    @inline(never) @inlinable static func makeInitialState(_ cache: inout Cache, _ wheel: Wheel, _ small: Small) -> State {
        Swift.assert(cache.base.allSatisfy({ $0.onesComplement().isZero }))
        //=--------------------------------------=
        let limit = cache.count * 2 - 1 // OK, see size
        var outer = NBK.CyclicIterator(wheel.increments)!
        var inner = NBK.CyclicIterator(wheel.increments)!
        var state = State(limit: UInt.max, elements: wheel.primes)
        //=--------------------------------------=
        // mark each number in: 1, small
        //=--------------------------------------=
        cache.base[cache.base.startIndex] = ~1
        cache.sieve(pattern: NBK.CyclicIterator(small.pattern)!)
        //=--------------------------------------=
        // mark each number in: composites
        //=--------------------------------------=
        var value = 1 &+ outer.next(); while true {
            let square = value.multipliedReportingOverflow(by: value)
            guard square.partialValue <= limit, !square.overflow else { break }
            
            defer { value &+= outer.next() }
            guard cache[value &>> 1 as UInt] else { continue }
            
            inner.set(unchecked: (wheel).indices[Int(bitPattern: value % wheel.circumference)])
            cache.sieve(from: square.partialValue &>> 1 as UInt, stride:{ value &* inner.next() &>> 1 as UInt }) // OK
        }
        //=--------------------------------------=
        Self.commit(&cache, to: &state)
        return state as State as State
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details x State
//=----------------------------------------------------------------------------=

extension NBKPrimeSieve {
    
    //*========================================================================*
    // MARK: * State
    //*========================================================================*
    
    @frozen @usableFromInline struct State {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// The highest value checked for primality.
        @usableFromInline var limit: UInt
        
        /// A list of all primes from zero through `limit`.
        @usableFromInline var elements: [UInt]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(limit: UInt, elements: [UInt]) {
            self.limit = limit; self.elements = elements
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details x Cache
//=----------------------------------------------------------------------------=

extension NBKPrimeSieve {
    
    //*========================================================================*
    // MARK: * Cache
    //*========================================================================*
    
    /// ### Development
    ///
    /// Size overflow is prevented by the size model's preconditions.
    ///
    @frozen @usableFromInline struct Cache {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var base: [UInt]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(size: Size) {
            self.base = Array(repeating: UInt.max, count: size.words)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=
        
        /// The number of bits in this collection.
        @inlinable var count: UInt {
            UInt(bitPattern: self.base.count) &* UInt(bitPattern: UInt.bitWidth)
        }
                
        /// The bit at the given `index`.
        @inlinable subscript(index: UInt) -> Bool {
            let index = NBK.PBI.dividing(NBK.ZeroOrMore(index), by: NBK.PowerOf2(bitWidth: UInt.self))
            return self.base[Int(bitPattern: (index).quotient)] &>> index.remainder & 1 == 1 as UInt
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        /// Sieves the `marks` with the given pattern `cycle`.
        @inlinable mutating func sieve(pattern cycle: NBK.CyclicIterator<[UInt]>) {
            var cycle = cycle; for index in self.base.indices { self.base[index] &= cycle.next() }
        }
        
        /// Sieves the `marks` from `start` with strides of `increment`.
        ///
        /// - Requires: `increment() <= UInt.max - UInt.bitWidth + 1`
        ///
        @inlinable mutating func sieve(from start: UInt, stride increment: () -> UInt) {
            var index = NBK.PBI.dividing(NBK.ZeroOrMore(start), by: NBK.PowerOf2(bitWidth: UInt.self))
            while index.quotient < UInt(bitPattern: self.base.count) {
                var chunk = UInt.zero
                
                while index.remainder < UInt.bitWidth {
                    chunk &+= 1 &<< index.remainder
                    index.remainder &+= increment()
                }
                
                self.base[Int(bitPattern:  index.quotient)] &= chunk.onesComplement()
                index.quotient &+= NBK.PBI .quotient(dividing: NBK.ZeroOrMore(index.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
                index.remainder  = NBK.PBI.remainder(dividing: NBK.ZeroOrMore(index.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
            }
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details x Wheel
//=----------------------------------------------------------------------------=

extension NBKPrimeSieve {
    
    //*========================================================================*
    // MARK: * Wheel
    //*========================================================================*
    
    /// A cyclical pattern used to skip small prime multiples.
    @frozen @usableFromInline struct Wheel {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// The primes used to create this instance.
        @usableFromInline let primes: [UInt]
        
        /// Returns the next `value` from the `index`.
        ///
        /// It is more or less equivalent to:
        ///
        ///     wheel[index...].first!
        ///
        /// The [2, 3, 5] wheel uses the following value:
        ///
        ///     01, 01, 07, 07, 07, 07,
        ///     07, 07, 11, 11, 11, 11,
        ///     13, 13, 17, 17, 17, 17,
        ///     19, 19, 23, 23, 23, 23,
        ///     29, 29, 29, 29, 29, 29,
        ///
        @usableFromInline var values: [UInt]
        
        /// Returns the `index` of the next `value`.
        ///
        /// It is more or less equivalent to:
        ///
        ///     wheel[index...].indices.first!
        ///
        /// The [2, 3, 5] wheel uses the following value:
        ///
        ///     00, 00, 01, 01, 01, 01,
        ///     01, 01, 02, 02, 02, 02,
        ///     03, 03, 04, 04, 04, 04,
        ///     05, 05, 06, 06, 06, 06,
        ///     07, 07, 07, 07, 07, 07,
        ///
        @usableFromInline var indices: [Int]
        
        /// A collection of `increments` from `1`.
        ///
        /// The [2, 3, 5] wheel uses the following value:
        ///
        ///     06, 04, 02, 04, 02, 04, 06, 02
        ///
        @usableFromInline var increments: [UInt]
        
        /// The distance traveled in one rotation.
        ///
        /// The [2, 3, 5] wheel uses the following value:
        ///
        ///     30 == 02 * 03 * 05
        ///
        @usableFromInline let circumference: UInt
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @usableFromInline init(primes: [UInt]) {
            //=----------------------------------=
            Swift.assert(primes.allSatisfy({ $0 >= 0000002 }))
            Swift.assert(primes.allSatisfy({ $0 <= Int.max }))
            Swift.assert(primes == primes.sorted())
            //=----------------------------------=
            self.primes  = primes
            self.values  = []
            self.increments = []
            self.indices = []
            self.circumference = primes.reduce(1, *)
            //=----------------------------------=
            for value in 0 ..< self.circumference where primes.allSatisfy({ value % $0 != 0 as UInt }) {
                if  let last = self.values.last {
                    self.increments.append(value - last)
                }
                
                let count = Int(bitPattern: 1 + value) - self.values.count
                self.values .append(contentsOf: repeatElement(value, count: count))
                self.indices.append(contentsOf: repeatElement(self.increments.count, count: count))
            };  self.increments.append(self.circumference - self.values.last! + self.values.first!)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details x Small
//=----------------------------------------------------------------------------=

extension NBKPrimeSieve {
    
    //*========================================================================*
    // MARK: * Small
    //*========================================================================*
    
    /// A cyclical pattern used to cull multiples of small primes.
    ///
    /// ### Development
    ///
    /// Consider multiple patterns formed by chunking:
    ///
    ///     [03, 67], [05, 61], [07, 59], 
    ///     [11, 53], [13, 47], [17, 43],
    ///     [19, 41], [23, 37], [29, 31],
    ///
    @frozen @usableFromInline struct Small {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// The primes used to create this instance.
        @usableFromInline var primes:  [UInt]
        
        /// A cyclical pattern used to cull multiples of small primes.
        @usableFromInline var pattern: [UInt]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(primes: [UInt]) {
            self.primes  = primes
            self.pattern = Self.pattern(primes: primes)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @usableFromInline static func pattern(primes: [UInt]) -> [UInt] {
            var pattern = [UInt](repeating: UInt.max, count: Int(primes.reduce(1, *)))
            var next:(prime: UInt, product: UInt); next.prime = primes.first!; next.product = next.prime
            var primeIndex = primes.startIndex; while primeIndex < primes.endIndex {
                //=----------------------------------=
                let current: (prime: UInt, product: UInt) = next
                var patternIndex = NBK.PBI.dividing(NBK.ZeroOrMore(current.prime &>> 1), by: NBK.PowerOf2(bitWidth: UInt.self))
                while patternIndex.quotient < current.prime {
                    var chunk = UInt.zero
                    
                    while patternIndex.remainder < UInt.bitWidth {
                        chunk |= 1 &<< patternIndex.remainder
                        patternIndex.remainder &+= current.prime
                    };  chunk.formOnesComplement()
                    
                    var destination = patternIndex.quotient; while destination < current.product {
                        pattern[Int(bitPattern: destination)] &= chunk
                        destination &+= current.prime
                    }
                    
                    patternIndex.quotient &+= NBK.PBI.quotient (dividing: NBK.ZeroOrMore(patternIndex.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
                    patternIndex.remainder  = NBK.PBI.remainder(dividing: NBK.ZeroOrMore(patternIndex.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
                }
                //=----------------------------------=
                primes.formIndex(after: &primeIndex)
                //=----------------------------------=
                if  primeIndex < primes.endIndex {
                    next.prime = primes[primeIndex]
                    next.product &*= next.prime
                }
                
                var destination = current.product; while destination < next.product {
                    for source in 0 as UInt ..< current.product {
                        pattern[Int(bitPattern: destination)] &= pattern[Int(bitPattern: source)]
                        destination += 1 as UInt
                    }
                }
            }
            
            return pattern as [UInt] as [UInt] as [UInt]
        }
    }
}
