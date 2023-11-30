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
public final class NBKPrimeSieve: CustomStringConvertible {
    
    /// The number of elements sieved per `increment()`.
    public static let increment = UInt(Cache.bitCount * 2)
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// All prime `elements` from zero through `limit`.
    ///
    /// The max `limit` is `UInt.max` so all `UInt` values can be sieved.
    ///
    /// - Requires: `limit == page * increment &- 1`
    ///
    /// - Requires: `elements.last! == last prime in 0 ... limit`
    ///
    @usableFromInline var state: State
    
    /// A collection of bits represeted by a collection of words.
    ///
    /// - Requires: Each bit must be set at the start and end of each access.
    ///
    @usableFromInline var cache: Cache
    
    @usableFromInline let wheel: Wheel
    
    @usableFromInline let small: [UInt]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance and sieves the first number page.
    public init() {
        self.cache = Cache()
        self.wheel = Wheel(primes: [2, 3, 5, 7, 11])
        self.small = Self.pattern(primes: Array(wheel.primes[1...]))
        self.state = Self.makeInitialState(&cache, wheel, small)
    }
    
    /// Generates a list of all primes from zero through `limit`.
    ///
    /// This initializer is equivalent to the following code snippet:
    ///
    /// ```swift
    /// var sieve = NBKPrimeSieve()
    /// while sieve.limit < limit {
    ///     sieve.increment()
    /// }
    /// ```
    ///
    /// - Note: The list of primes may exceed the requested size.
    ///
    @inlinable public convenience init(through limit: UInt) {
        self.init(); while self.limit < limit { self.increment() }
    }
    
    /// Generates a list of the first `count` number of primes.
    ///
    /// This initializer is equivalent to the following code snippet:
    ///
    /// ```swift
    /// var sieve = NBKPrimeSieve()
    /// while sieve.elements.count < count {
    ///     sieve.increment()
    /// }
    /// ```
    ///
    /// - Note: The list of primes may exceed the requested size.
    ///
    @inlinable public convenience init(first count: Int) {
        self.init(); while self.elements.count < count { self.increment() }
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
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    public var description: String {
        "\(Self.self)(limit: \(self.limit), count: \(self.elements.count))"
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
        precondition(!self.limit.addingReportingOverflow(Self.increment).overflow)
        Swift.assert((self.cache.base).allSatisfy({ $0.onesComplement().isZero }))
        Swift.assert((self.limit &+ 1) % Self.increment == 0, "limit must be aligned to end-of-page")
        //=--------------------------------------=
        let start = self.limit &+ 00000000000002
        let limit = self.limit &+ Self.increment
        var inner = NBK.CyclicIterator(self.wheel.increments)!
        //=--------------------------------------=
        // mark composites not hit by the wheel
        //=--------------------------------------=
        let cycle = NBK.PBI.quotient(dividing: NBK.ZeroOrMore(start), by: NBK.PowerOf2(Self.increment))
        self.cache.sieve(pattern: NBK.CyclicIterator(self.small, spin: cycle &* UInt(bitPattern: self.cache.base.count))!)
        //=--------------------------------------=
        // mark composites using prime elements
        //=--------------------------------------=
        for prime in self.elements.dropFirst(self.wheel.primes.count) {
            let square = prime.multipliedReportingOverflow(by: prime)
            guard square .partialValue <= limit, !square .overflow else { break }
            
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
            cache.sieve(from:(product.partialValue &- start) &>> 1 as UInt, stride:{ prime &* inner.next() &>> 1 }) // OK
        }
        //=--------------------------------------=
        Self.commit(&self.cache, to: &self.state)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inline(never) @inlinable static func commit(_ cache: inout Cache, to state: inout State) {
        Swift.assert((state.limit &+ 1) % Self.increment == 0, "limit must be aligned to end-of-page")
        
        for index in cache.base.indices {
            var chunk = cache.base[index]
            var position = state.limit as UInt
            
            while !chunk.isZero {
                let shift  = UInt(bitPattern: chunk.trailingZeroBitCount)
                chunk   &>>= shift
                position &+= shift &<< 1 as UInt
                chunk   &>>= 1 as UInt
                position &+= 2 as UInt
                state.elements .append(position)
            }
            
            cache.base[index] = chunk.onesComplement()
            state.limit &+= UInt(bitPattern: UInt.bitWidth) &<< 1 as UInt
        }
    }
    
    @inline(never) @inlinable static func makeInitialState(_ cache: inout Cache, _ wheel: Wheel, _ small: [UInt]) -> State {
        //=--------------------------------------=
        Swift.assert(cache.base.allSatisfy({ $0.onesComplement().isZero }))
        //=--------------------------------------=
        let limit = Self.increment - 1 // is << UInt.max
        var outer = NBK.CyclicIterator(wheel.increments)!
        var inner = NBK.CyclicIterator(wheel.increments)!
        var state = State(limit: UInt.max, elements: wheel.primes)
        //=--------------------------------------=
        // mark each number in: 1, wheel
        //=--------------------------------------=
        cache.base[0] = ~001 as UInt
        cache.sieve(pattern: NBK.CyclicIterator(small)!)
        //=--------------------------------------=
        // mark each number in: composites
        //=--------------------------------------=
        var value = 1 as UInt &+ outer.next(); while value <= limit {
            let square = value.multipliedReportingOverflow(by: value)
            guard square.partialValue <= limit, !square.overflow else { break }
            
            defer { value &+= outer.next() }
            guard cache[value &>> 1 as UInt] else { continue }
            
            inner.set(unchecked: Int(bitPattern: wheel.indices[Int(bitPattern: value % wheel.circumference)]))
            cache.sieve(from: square.partialValue &>> 1 as UInt,stride:{ value &* inner.next() &>> 1 }) // OK
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
            self.limit = limit
            self.elements = elements
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
    
    @frozen @usableFromInline struct Cache {
        
        /// The number of bits per page.
        ///
        /// - Note: The CPU's L2 data cache is the sweet spot.
        ///
        @usableFromInline static let bitCount: Int = 524288
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var base: [UInt]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init() {
            self.base = Array(repeating:  UInt.max, count:  Self.bitCount / UInt.bitWidth)
            Swift.assert(Self.bitCount == self.base.count * UInt.bitWidth)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Accessors
        //=--------------------------------------------------------------------=

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
    
    @frozen @usableFromInline struct Wheel {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// The primes used to create this wheel.
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
        @usableFromInline var indices: [UInt]
        
        /// A collection of `increments` from `1`.
        ///
        /// The [2, 3, 5] wheel uses the following value:
        ///
        ///     06, 04, 02, 04, 02, 04, 06, 02
        ///
        @usableFromInline var increments: [UInt]
        
        /// The from the start of one rotation to the start of the next rotation.
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
            for value in 0 ..< circumference where primes.allSatisfy({ value % $0 != 0 as UInt }) {
                if  let (last) = values.last {
                    self.increments.append(value &- last)
                }
                
                let (count) = Int(bitPattern: value &+ 1) &- self.values.count
                self.values .append(contentsOf: repeatElement(value, count: count))
                self.indices.append(contentsOf: repeatElement(UInt(bitPattern: self.increments.count), count: count))
            };  self.increments.append(self.circumference &- self.values.last! &+ self.values.first!)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Miscellaneous
//=----------------------------------------------------------------------------=

extension NBKPrimeSieve {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @usableFromInline static func pattern(primes: [UInt]) -> [UInt] {
        var pattern = [UInt](repeating: UInt.max, count: Int(primes.reduce(1, *)))
        var primeIndex = primes.startIndex
        var next: (prime: UInt, product: UInt)
        next.prime = primes[primeIndex]
        next.product = next.prime
        while primeIndex < primes.endIndex {
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
            //=----------------------------------=
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
