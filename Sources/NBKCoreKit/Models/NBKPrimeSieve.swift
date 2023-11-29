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
    
    /// All prime `elements` through the current `limit`.
    ///
    /// The `limit` is incremented from `0` through `UInt.max`. 
    /// This means all values that fit in `UInt` can be sieved.
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
    
    /// Creates a new instance and sieves the first page of prime elements.
    public init() {
        self.cache = Cache()
        self.wheel = Wheel(primes:[00002,  3, 5, 7])
        self.small = Self.pattern(primes: [3, 5, 7])
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
    
    /// Sieves the next page of values.
    @inline(never) @inlinable public func increment() {
        //=--------------------------------------=
        Swift.assert((self.cache.base).allSatisfy({ $0.onesComplement().isZero }))
        Swift.assert((self.limit &+ 1) % Self.increment == 0, "limit must be aligned to end-of-page")
        //=--------------------------------------=
        let start = self.limit + 2
        let limit = self.limit + Self.increment // TODO: try no pre-computation
        //=--------------------------------------=
        let cycle = NBK.PBI.quotient(dividing: NBK.ZeroOrMore(start),by: NBK.PowerOf2(Self.increment))
        var small = NBK.CyclicIterator(self.small)!; small.set(distance: cycle * UInt(bitPattern: self.cache.base.count))
        self.cache.sieve(pattern: small)
        //=--------------------------------------=
        // mark composites using prime elements
        //=--------------------------------------=
        for prime in self.elements.dropFirst(self.wheel.primes.count) {
            
            // TODO: better limit check
            
            let  (first, overflow) = prime.multipliedReportingOverflow(by: prime)
            guard first <= (limit), !overflow else { break }
            
            // TODO: use the wheel here
            
            var position = start.dividedReportingOverflow(by: prime).partialValue * prime
            if  position .isEven {  position += prime  }
            if  position < start {  position += prime  &<< 1 }
            
            self.cache.sieve(from: (position &- start) &>> 1, stride:{ prime }) // OK
        }
        //=--------------------------------------=
        Self.commit(&self.cache, to: &self.state)
        precondition(self.limit >= Self.increment, NBK.callsiteOverflowInfo())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inline(never) @inlinable static func commit(_ cache: inout Cache, to state: inout State) {
        //=--------------------------------------=
        Swift.assert((state.limit &+ 1) % Self.increment == 0, "limit must be aligned to end-of-page")
        //=--------------------------------------=
        for index in cache.base.indices {
            var chunk = cache.base[index]
            var position = state.limit as UInt
            
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
    
    @inline(never) @inlinable static func makeInitialState(_ cache: inout Cache, _ wheel: Wheel, _ small: [UInt]) -> State {
        var state = State(limit: UInt.max, elements: [])
        //=--------------------------------------=
        Swift.assert(cache.base.allSatisfy({ $0.onesComplement().isZero }))
        //=--------------------------------------=
        let limit = Self.increment - 1
        var outer = NBK.CyclicIterator(wheel.increments)!
        var inner = NBK.CyclicIterator(wheel.increments)!
        //=--------------------------------------=
        // mark each number in: 1, wheel
        //=--------------------------------------=
        cache.base[0] = ~1 as UInt
        cache.sieve(pattern: NBK.CyclicIterator(small)!)
        //=--------------------------------------=
        // mark each number in: composites
        //=--------------------------------------=
        var value = 1 as UInt; while value < limit { value &+= outer.next()
            let  (first, overflow) = value.multipliedReportingOverflow(by: value)
            guard first <= limit, !overflow  else { break    }
            guard cache[value &>> 1 as UInt] else { continue }
            inner.set(distance: wheel.indices[Int(bitPattern: value % wheel.circumference)])
            cache.sieve(from: first &>> 1 as UInt,   stride:{ value &* inner.next() &>> 1 }) // OK
        }
        //=--------------------------------------=
        state.elements.append(contentsOf: wheel.primes)
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
        
        @usableFromInline var limit: UInt
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
    }
}

extension NBKPrimeSieve.Cache {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=

    @inlinable subscript(index: UInt) -> Bool {
        let index = NBK.PBI.dividing(NBK.ZeroOrMore(index), by: NBK.PowerOf2(bitWidth: UInt.self))
        return self.base[Int(bitPattern: index.quotient)] &>> index.remainder & 1 == 1 as UInt
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Sets each bit to `1`.
    @inlinable mutating func reset() {
        for index in self.base.indices {
            self.base[index] = UInt.max
        }
    }
    
    /// Sieves the `marks` with the given pattern `cycle`.
    @inlinable mutating func sieve(pattern cycle: NBK.CyclicIterator<[UInt]>) {
        var cycle =  cycle
        for index in self.base.indices {
            self.base[index] &= cycle.next()
        }
    }
    
    /// Sieves the `marks` from `start` with strides of `increment`.
    ///
    /// - Requires: `increment() <= UInt.max - UInt.bitWidth + 1`
    ///
    @usableFromInline mutating func sieve(from start: UInt, stride increment: () -> UInt) {
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
        
        @usableFromInline let primes: [UInt]
        @usableFromInline var increments: [UInt]
        @usableFromInline var indices: [UInt]
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
            self.primes = primes
            self.increments = []
            self.indices = []
            self.circumference = primes.reduce(1, *)
            //=----------------------------------=
            var count =  1 as UInt
            for value in 2 as UInt ..< circumference &+ 2 {
                indices.append(UInt(bitPattern: increments.count))
                if  primes.allSatisfy({ value % $0 != 0 }) {
                    increments.append(((value)) &- count)
                    count = ((((((((((((value))))))))))))
                }
            }
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
