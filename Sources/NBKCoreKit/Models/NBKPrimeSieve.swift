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
/// It sieves one page on creation, then one per call to `increment()`.
///
/// ### Sieve all primes through some « limit »
///
/// ```swift
/// let ((sieve)) = NBKPrimeSieve()
/// while sieve.limit < 1_000_000 {
///     ((sieve)).increment()
/// }
/// ```
///
/// ### Sieve at least « count » number of primes
///
/// ```swift
/// let ((sieve)) = NBKPrimeSieve()
/// while sieve.elements.count < 1_000_000 {
///     ((sieve)).increment()
/// }
/// ```
///
/// ### Customization
///
/// This sieve offers multiple customization options, which may improve performance.
/// Here's an example that's suitable for numbers up to a billion on a 64-bit machine
/// where the CPU's L1 data cache is 128 KiB:
///
/// ```swift
/// NBKPrimeSieve(cache: .KiB(128), wheel: .x11, culls: .x67, capacity: 50863957)
/// ```
///
/// - Note: The size of the cache determines the size of each increment.
///
public final class NBKPrimeSieve: CustomStringConvertible {
    
    /// A collection of all primes that fit in one byte.
    ///
    /// - Note: It contains `54` elements.
    ///
    @usableFromInline static let primes = [
    0002, 0003, 0005, 0007, 0011, 0013, 0017, 0019,
    0023, 0029, 0031, 0037, 0041, 0043, 0047, 0053,
    0059, 0061, 0067, 0071, 0073, 0079, 0083, 0089,
    0097, 0101, 0103, 0107, 0109, 0113, 0127, 0131,
    0137, 0139, 0149, 0151, 0157, 0163, 0167, 0173,
    0179, 0181, 0191, 0193, 0197, 0199, 0211, 0223,
    0227, 0229, 0233, 0239, 0241, 0251] as [UInt8]
    
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
    
    /// A finite sequence of odd numbers represented by a collection of bits.
    ///
    /// - Requires: Each bit must be set at the start and end of each access.
    ///
    @usableFromInline var cache: Cache
    
    /// A cyclical pattern used to skip multiples of small primes.
    @usableFromInline let wheel: Wheel
    
    /// A collection of cyclical patterns used to cull multiples of small primes.
    @usableFromInline let culls: Culls
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance and sieves the first page.
    ///
    /// - Note: It uses the default arguments of the main initialization method.
    ///
    @inlinable public convenience init() {
        self.init()!
    }
    
    /// Creates a new instance and sieves the first page.
    /// 
    /// - Parameter cache: A collection of bits used to mark composite numbers.
    ///
    /// - Parameter wheel: A cyclical pattern used to skip multiples of small primes.
    ///
    /// - Parameter culls: A collection of cyclical patterns used to cull multiples of small primes.
    ///
    /// - Parameter capacity: The prime buffer's minimum capacity.
    ///
    /// - Requires: The order of `wheel` must not exceed the order of `culls`.
    ///
    /// - Note: A page contains `1` odd number per bit in `cache`.
    ///
    /// - Note: The defaults strike a balance between size and performance.
    ///
    public init?(cache: Cache = .KiB(4), wheel: Wheel = .x07, culls: Culls = .x11, capacity: Int? = nil) {
        //=--------------------------------------=
        guard wheel.primes.last! <= culls.primes.last! else { return nil }
        //=--------------------------------------=
        self.cache = cache
        self.wheel = wheel
        self.culls = culls
        self.state = Self.makeInitialState(&self.cache, self.wheel, self.culls, capacity)
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
    
    /// Sieves the next page of numbers.
    ///
    /// A page contains `1` odd number per bit in `cache`.
    ///
    @inline(never) @inlinable public func increment() {
        Swift.assert(self.cache.base.allSatisfy({ $0.onesComplement().isZero }))
        //=--------------------------------------=
        // trap overflow and max-on-setup-sieve
        //=--------------------------------------=
        let start = self.limit + 0000000000000002
        let limit = self.limit + self.cache.count * 2 as UInt
        var inner = NBK.CyclicIterator(self.wheel.increments)!
        //=--------------------------------------=
        // mark composites not hit by the wheel
        //=--------------------------------------=
        let iteration = 1 &+ NBK.PBI.quotient(dividing: NBK.ZeroOrMore(self.limit &>> 1 as UInt), by: NBK.PowerOf2(bitWidth: UInt.self))
        self.cache.sieve(patterns: self.culls.patterns, iteration: iteration)
        //=--------------------------------------=
        // mark composites using prime elements
        //=--------------------------------------=
        for prime in self.elements.dropFirst(1 + self.culls.primes.count) {
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
            
            inner.setIndex(unchecked: Int(bitPattern: self.wheel.indices[Int(bitPattern: multiple % self.wheel.circumference)] ))
            self.cache.sieve(from: (product.partialValue &- start) &>> 1 as UInt, stride:{ prime &* inner.next() &>> 1 as UInt }) // OK
        }
        //=--------------------------------------=
        Self.commit(&self.cache, to: &self.state)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// - Important: It wraps around, so preconditions should be checked prior to it.
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
            
            cache.base[index] = UInt.max
            state.limit &+= UInt(bitPattern: UInt.bitWidth) &<< 1 as UInt
        }
    }
    
    @inline(never) @inlinable static func makeInitialState(_ cache: inout Cache, _ wheel: Wheel, _ culls: Culls, _ capacity: Int?) -> State {
        Swift.assert(wheel.primes.first == 00000000000000002)
        Swift.assert(culls.primes.first != 00000000000000002)
        Swift.assert(wheel.primes.last! <= culls.primes.last!, "must cull multiples of each element in wheel")
        Swift.assert(wheel.primes[1...].allSatisfy(culls.primes.contains))
        Swift.assert(cache.base.allSatisfy { $0.onesComplement().isZero })
        //=--------------------------------------=
        let limit = cache.count &* 2 &- 1 // OK, see size
        var outer = NBK.CyclicIterator(wheel.increments)!
        var inner = NBK.CyclicIterator(wheel.increments)!
        var state = State(limit: UInt.max, elements: [])
        
        if  let capacity {
            state.elements.reserveCapacity(capacity)
        }
        //=--------------------------------------=
        // mark each number in: 1, culls
        //=--------------------------------------=
        cache.base[cache.base.startIndex] = ~1
        cache.sieve(patterns: culls.patterns)
        //=--------------------------------------=
        // mark each number in: composites
        //=--------------------------------------=
        var value = 1 &+ outer.next(); while true {
            let square = value.multipliedReportingOverflow(by: value)
            guard square.partialValue <= limit, !square.overflow else { break }
            
            defer { value &+= outer.next() }
            guard cache[value &>> 1 as UInt] else { continue }
            
            inner.setIndex(unchecked: wheel.indices[Int(bitPattern: value % wheel.circumference)])
            cache.sieve(from: square.partialValue &>> 1 as UInt, stride:{ value &* inner.next() &>> 1 as UInt }) // OK
        }
        //=--------------------------------------=
        state.elements.append(0000000002)
        state.elements.append(contentsOf: culls.primes)
        
        Self.commit(&cache, to: &state)
        
        state.elements.removeLast(state.elements.reversed().prefix(while:{ $0 > limit }).count) // if limit < culls
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
    
    /// A finite sequence of odd numbers represented by a collection of bits.
    ///
    /// Larger sieves evaluate more numbers per page and use more memory.
    ///
    /// - Note: The first KiB yields all 1900 prime numbers through 16383.
    ///
    /// - Note: The CPU's L1 data cache is the sweet spot (128 KiB on Apple M1).
    ///
    /// ### Alignment
    ///
    /// The last page will overflow unless the last page ends at `UInt.max`.
    ///
    /// - Note: All values can be sieved when its size is a power of two.
    ///
    @frozen public struct Cache {
        
        /// The size per page measured in KiB (i.e. 1024 B).
        @inlinable public static func KiB(_ count: Int) -> Self {
            Self(words: count * (8 * 1024 / UInt.bitWidth))
        }
        
        /// The size per page measured in words.
        @inlinable public static func words(_ count: Int) -> Self {
            Self(words: count)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var base: [UInt]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        /// ### Development
        ///
        /// The maximum number of bits is `Int.max + 1`. This is the number of bits
        /// needed to represent each odd number in `0 ... UInt`. The maximum stride
        /// is therefore not representable by `UInt`. But, the sieve is still valid
        /// if there is proper overflow checking past setup.
        ///
        /// - Requires: `words > 0`
        ///
        /// - Requires: `words * UInt.bitWidth * 2 <= UInt.max + 1`
        ///
        @inlinable init(words: Int) {
            let limit = (UInt.max / UInt(UInt.bitWidth * 2)) + 1
            Swift.assert(limit >= 1  &&  limit  &* UInt(UInt.bitWidth * 2) == 0 as UInt)
            precondition(UInt(words) >=  00001, "prime sieve's stride must be greater than zero")
            precondition(UInt(words) <=  limit, "prime sieve's stride must not exceed number of elements in UInt")
            self.base = Array(repeating: UInt.max, count: words)
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
        
        /// Sieves this instance using cyclical bit `patterns` from `iteration`.
        @inlinable mutating func sieve(patterns: [[UInt]], iteration: UInt = 0) {
            self.base.withUnsafeMutableBufferPointer { base in
                for var pattern in patterns.lazy.map({ NBK.CyclicIterator($0)! }) {
                    pattern.formIteration(iteration)
                    for index in base.indices {
                        base[index] &= pattern.next()
                    }
                }
            }
        }
        
        /// Sieves this instance from `start` with strides of `increment`.
        ///
        /// - Requires: `increment() <= UInt.max - UInt.bitWidth + 1`
        ///
        @inlinable mutating func sieve(from start: UInt, stride increment: () -> UInt) {
            self.base.withUnsafeMutableBufferPointer { base in
                var ((index)): QR<UInt,UInt> = NBK.PBI.dividing(NBK.ZeroOrMore(start), by: NBK.PowerOf2(bitWidth: UInt.self))
                while index.quotient < UInt(bitPattern: base.count) {
                    var chunk = UInt.zero
                    
                    while index.remainder < UInt(bitPattern: UInt.bitWidth) {
                        chunk &+= 1 &<< index.remainder
                        index.remainder &+= increment()
                    }
                    
                    base[Int(bitPattern: index.quotient)] &= chunk.onesComplement()
                    index.quotient &+= NBK.PBI .quotient(dividing: NBK.ZeroOrMore(index.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
                    index.remainder  = NBK.PBI.remainder(dividing: NBK.ZeroOrMore(index.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
                }
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
    @frozen public struct Wheel {
        
        /// A wheel formed by the sequence: `2`.
        ///
        /// - Note: It covers `2` elements in `1` increment.
        ///
        @inlinable public static var x02: Self {
            Self(primes: NBKPrimeSieve.primes[...0])
        }
        
        /// A wheel formed by the sequence: `2`, `3`.
        ///
        /// - Note: It covers `6` elements in `2` increments.
        ///
        @inlinable public static var x03: Self {
            Self(primes: NBKPrimeSieve.primes[...1])
        }
        
        /// A wheel formed by the sequence: `2`, `3`, `5`.
        ///
        /// - Note: It covers `30` elements in `8` increments.
        ///
        @inlinable public static var x05: Self {
            Self(primes: NBKPrimeSieve.primes[...2])
        }
        
        /// A wheel formed by the sequence: `2`, `3`, `5`, `7`.
        ///
        /// - Note: It covers `210` elements in `48` increments.
        ///
        @inlinable public static var x07: Self {
            Self(primes: NBKPrimeSieve.primes[...3])
        }
        
        /// A wheel formed by the sequence: `2`, `3`, `5`, `7`, `11`.
        ///
        /// - Note: It covers `2310` elements in `480` increments.
        ///
        @inlinable public static var x11: Self {
            Self(primes: NBKPrimeSieve.primes[...4])
        }
        
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
        
        @inlinable init(primes: ArraySlice<UInt8>) {
            self.init(primes: primes.map(UInt.init(truncatingIfNeeded:)))
        }
        
        @usableFromInline init(primes: [UInt]) {
            //=----------------------------------=
            Swift.assert(primes.allSatisfy({ $0 >= 2 }))
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
            }
            
            let last  = self.values.last!  // default to zero if empty is allowed
            let first = self.values.first! // default to zero if empty is allowed
            self.increments.append(self.circumference  - last  + first)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details x Culls
//=----------------------------------------------------------------------------=

extension NBKPrimeSieve {
    
    //*========================================================================*
    // MARK: * Culls
    //*========================================================================*
    
    /// A collection of cyclical patterns used to cull multiples of small primes.
    ///
    /// - Note: Even numbers are culled by omission, not by bit pattern.
    ///
    @frozen public struct Culls {
        
        /// Cyclical bit patterns for multiples of primes from `3` through `5`.
        ///
        /// - Note: It stores `15` elements and culls `2` primes in `1` loop.
        ///
        @inlinable public static var x05: Self {
            Self(primes: NBKPrimeSieve.primes[1...02])
        }
        
        /// Cyclical bit patterns for multiples of primes from `3` through `11`.
        ///
        /// - Note: It stores `68` elements and culls `4` primes in `2` loops.
        ///
        @inlinable public static var x11: Self {
            Self(primes: NBKPrimeSieve.primes[1...04])
        }
        
        /// Cyclical bit patterns for multiples of primes from `3` through `17`.
        ///
        /// - Note: It stores `193` elements and culls `6` primes in `3` loops.
        ///
        @inlinable public static var x17: Self {
            Self(primes: NBKPrimeSieve.primes[1...06])
        }
        
        /// Cyclical bit patterns for multiples of primes from `3` through `23`.
        ///
        /// - Note: It stores `426` elements and culls `8` primes in `4` loops.
        ///
        @inlinable public static var x23: Self {
            Self(primes: NBKPrimeSieve.primes[1...08])
        }
        
        /// Cyclical bit patterns for multiples of primes from `3` through `31`.
        ///
        /// - Note: It stores `829` elements and culls `10` primes in `5` loops.
        ///
        @inlinable public static var x31: Self {
            Self(primes: NBKPrimeSieve.primes[1...10])
        }
        
        /// Cyclical bit patterns for multiples of primes from `3` through `41`.
        ///
        /// - Note: It stores `1466` elements and culls `12` primes in `6` loops.
        ///
        @inlinable public static var x41: Self {
            Self(primes: NBKPrimeSieve.primes[1...12])
        }
        
        /// Cyclical bit patterns for multiples of primes from `3` through `47`.
        ///
        /// - Note: It stores `2383` elements and culls `14` primes in `7` loops.
        ///
        @inlinable public static var x47: Self {
            Self(primes: NBKPrimeSieve.primes[1...14])
        }
        
        /// Cyclical bit patterns for multiples of primes from `3` through `59`.
        ///
        /// - Note: It stores `3662` elements and culls `16` primes in `8` loops.
        ///
        @inlinable public static var x59: Self {
            Self(primes: NBKPrimeSieve.primes[1...16])
        }
        
        /// Cyclical bit patterns for multiples of primes from `3` through `67`.
        ///
        /// - Note: It stores `5373` elements and culls `18` primes in `9` loops.
        ///
        @inlinable public static var x67: Self {
            Self(primes: NBKPrimeSieve.primes[1...18])
        }
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// The primes used to create this instance.
        @usableFromInline var primes: [UInt]
        
        /// A collection of cyclical patterns used to cull multiples of small primes.
        ///
        /// The [3, ..., 31] instance uses the following value:
        ///
        ///     [03, 31], [05, 29], [07, 23], [11, 19], [13, 17]
        ///
        @usableFromInline var patterns: [[UInt]]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(primes: ArraySlice<UInt8>) {
            self.init(primes: primes.map(UInt.init(truncatingIfNeeded:)))
        }
        
        @inlinable init(primes: [UInt]) {
            self.primes   = primes
            self.patterns = Culls.patterns(primes: self.primes)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// Patterns grow multiplicatively, so chunking reduces memory cost.
        ///
        ///     g([3, 5, 7, 11]) -> [f([3, 11]), f([5, 7])]
        ///
        /// - Requires: The number of primes should be even for performance reasons.
        ///
        @usableFromInline static func patterns(primes: [UInt]) -> [[UInt]] {
            Swift.assert(primes.count.isEven)
            
            var patterns = [[UInt]]()
            var lhsIndex = primes.startIndex
            var rhsIndex = primes.index(before: primes.endIndex)
            
            while lhsIndex < rhsIndex {
                patterns.append(self.pattern(primes: [primes[lhsIndex], primes[rhsIndex]]))
                patterns.formIndex(after:  &lhsIndex)
                patterns.formIndex(before: &rhsIndex)
            }
            
            return patterns as [[UInt]]
        }
        
        /// A cyclical pattern marking odd multiples of each prime in `primes`.
        ///
        /// The following illustrates the creation of a `[2,3]` pattern.
        ///
        ///     0) [--, --, --, --, --, --] // --
        ///     1) [2A, --, --, --, --, --] // 2A
        ///     2) [2A, 2B, --, --, --, --] // 2B
        ///     3) [2A, 2B, 2A, 2B, 2A, 2B] // extend to 2 * 3
        ///     4) [6A, 2B, 2A, 6D, 2A, 2B] // 6A, 6D
        ///     5) [6A, 6B, 2A, 6D, 6E, 2B] // 6B, 6E
        ///     6) [6A, 6B, 6C, 6D, 6E, 6F] // 6C, 6F
        ///
        /// The idea is to reuse elements and subsequences whenever possible.
        ///
        /// - Important: The sieve culls even numbers by omission, so start with `[3,5]`.
        ///
        @usableFromInline static func pattern(primes: [UInt]) -> [UInt] {
            var pattern = Array(repeating: UInt.max,  count: Int(primes.reduce(1, *)))
            var next: (prime: UInt, product:  UInt);  next.prime = primes.first!; next.product = next.prime
            var primeIndex = primes.startIndex; while primeIndex < primes.endIndex {
                //=------------------------------=
                let current: (prime: UInt, product: UInt) = next
                var ((patternIndex)) = NBK.PBI.dividing(NBK.ZeroOrMore(current.prime &>> 1), by: NBK.PowerOf2(bitWidth: UInt.self))
                while patternIndex.quotient < current.prime {
                    //=--------------------------=
                    var chunk = 00000000 as UInt
                    while patternIndex.remainder < UInt.bitWidth {
                        chunk &+= 001 &<< patternIndex.remainder
                        patternIndex.remainder &+= current.prime
                    };  chunk.formOnesComplement()
                    //=--------------------------=
                    // pattern: reuse elements
                    //=--------------------------=
                    var ((destination)) = patternIndex.quotient
                    while destination < current.product {
                        pattern[Int(bitPattern: destination)] &= chunk
                        destination &+= current.prime
                    }
                    
                    patternIndex.quotient &+= NBK.PBI.quotient (dividing: NBK.ZeroOrMore(patternIndex.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
                    patternIndex.remainder  = NBK.PBI.remainder(dividing: NBK.ZeroOrMore(patternIndex.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
                }
                //=------------------------------=
                primes.formIndex(after: &primeIndex)
                //=------------------------------=
                if  primeIndex < primes.endIndex {
                    next.prime = primes[primeIndex]
                    next.product &*= next.prime
                }
                //=------------------------------=
                // pattern: reuse subsequences
                //=------------------------------=
                var ((destination)) = current.product
                while destination < next.product {
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
