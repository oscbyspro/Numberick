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
@frozen public struct NBKPrimeSieve {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The highest value checked for primality.
    @inlinable public var  limit: UInt { self._limit }
    @usableFromInline var _limit: UInt
    
    /// A list of all primes from zero through `limit`.
    @inlinable public var  elements: [UInt] { self._elements }
    @usableFromInline var _elements: [UInt]
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Generates a list of the first `count` number of primes.
    public init(first count: PrimeCountLimit) {
        self.init(through: count.rawValue)
    }
    
    /// Generates a list of all primes from zero through `limit`.
    public init(through limit: UInt) {
        self._limit = limit
        self._elements = []
        Self.primesByEratosthenesBitSetWheel(through: limit, appending: &self._elements)
    }
    
    //*========================================================================*
    // MARK: * Prime Count Limit
    //*========================================================================*
    
    public enum PrimeCountLimit: UInt { case thousand = 7919, million = 15485863 }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKPrimeSieve {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Sieve of Eratosthenes
    //=------------------------------------------------------------------------=
    
    /// An adaptation of [the Sieve of Eratosthenes][sieve].
    ///
    /// [sieve]: https://en.wikipedia.org/wiki/sieve_of_eratosthenes
    ///
    /// - Complexity: O(limit × log(log(limit)))
    ///
    /// - Note: 1 million takes 0.0s on MacBook Pro (13-inch, M1, 2020).
    ///
    /// - Note: 1 billion takes 3.6s on MacBook Pro (13-inch, M1, 2020).
    ///
    static func primesByEratosthenes(through limit: UInt, appending elements: inout [UInt]) {
        //=--------------------------------------=
        if  limit < 2 as UInt { return }
        //=--------------------------------------=
        // mark each number in: 3, 5, 7, 9, ...
        //=--------------------------------------=
        let count = Int(bitPattern:  (limit &- 1) &>> 1)
        var marks = Array(repeating: true, count: count) // UInt.max at Int.max - 1
        
        var value = 3 as UInt; loop: while true {
            var index: Int; defer { value &+= 2 }
            
            let (first, overflow) = value.multipliedReportingOverflow(by: value)
            
            done: if first >  limit || overflow { break }
            
            index = Int(bitPattern: value &>> 1 &- 1)
            
            composite: if !marks[index] { continue loop }
            
            index = Int(bitPattern: first &>> 1 &- 1)
            
            composite: while marks.indices ~= index { marks[index] = false; index &+= Int(bitPattern: value) }
        }
        
        unmarked: do {
            elements.append(2 as UInt)
        }
        
        for index in marks.indices where marks[index] {
            elements.append(UInt(bitPattern: index) &<< 1 &+ 3) // UInt.max at Int.max - 1
        }
    }
    
    /// An adaptation of [the Sieve of Eratosthenes][sieve].
    ///
    /// [sieve]: https://en.wikipedia.org/wiki/sieve_of_eratosthenes
    ///
    /// - Complexity: O(limit × log(log(limit)))
    ///
    /// - Note: 1 million takes 0.0s on MacBook Pro (13-inch, M1, 2020).
    ///
    /// - Note: 1 billion takes 2.2s on MacBook Pro (13-inch, M1, 2020).
    ///
    static func primesByEratosthenesBitSet(through limit: UInt, appending elements: inout [UInt]) {
        //=--------------------------------------=
        if  limit < 2 as UInt { return }
        //=--------------------------------------=
        var value : UInt
        let split = NBK.PBI.dividing(NBK.ZeroOrMore((limit &- 1) &>> 1), by: NBK.PowerOf2(bitWidth: UInt.self))
        var marks = Array(repeating: UInt.max, count: Int(split.quotient + UInt(bit: !split.remainder.isZero)))
        //=--------------------------------------=
        // mark each number in: 3, 5, 7, 9, ...
        //=--------------------------------------=
        value = 3 as UInt; while true { var index: QR<UInt,UInt>; defer { value &+= 2 }
            
            let (first, overflow) = value.multipliedReportingOverflow(by: value)
            
            done: if  first > limit || overflow { break }
                        
            index = NBK.PBI.dividing(NBK.ZeroOrMore(value &>> 1 &- 1), by: NBK.PowerOf2(bitWidth: UInt.self))
            
            composite: if (marks[Int(bitPattern: index.quotient)] & (1 &<< index.remainder)).isZero { continue }
                        
            index = NBK.PBI.dividing(NBK.ZeroOrMore(first &>> 1 &- 1), by: NBK.PowerOf2(bitWidth: UInt.self))
            
            composite: while index.quotient < UInt(bitPattern: marks.count) {
                var mask = UInt.zero; while index.remainder < UInt.bitWidth { mask &+= 1 &<< index.remainder; index.remainder &+= value }
                marks[Int(bitPattern: index.quotient)] &= mask.onesComplement()
                index.quotient &+= NBK.PBI .quotient(dividing: NBK.ZeroOrMore(index.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
                index.remainder  = NBK.PBI.remainder(dividing: NBK.ZeroOrMore(index.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
            }
        }
        //=--------------------------------------=
        // add each un/marked number to the list
        //=--------------------------------------=
        unmarked: do {
            elements.append(2 as UInt)
        }
        
        value = 3 as UInt; loop: for var chunk in marks { var position = value

            while !chunk.isZero {
                let shift = UInt(bitPattern: chunk.trailingZeroBitCount)
                if  position.addReportingOverflow(shift &<< 1) || position > limit { break loop }
                
                elements.append(position)
                
                if  position.addReportingOverflow(00000000002) || position > limit { break loop }
                chunk >>= shift &+ 1 // smart shifting because it may exceed the bit width
            }
            
            if (value).addReportingOverflow(UInt(bitPattern: UInt.bitWidth) &<< 1) { break loop }
        }
    }
    
    /// An adaptation of [the Sieve of Eratosthenes][sieve].
    ///
    /// [sieve]: https://en.wikipedia.org/wiki/sieve_of_eratosthenes
    ///
    /// - Complexity: O(limit × log(log(limit)))
    ///
    /// - Note: 1 million takes 0.0s on MacBook Pro (13-inch, M1, 2020).
    ///
    /// - Note: 1 billion takes 1.5s on MacBook Pro (13-inch, M1, 2020).
    ///
    static func primesByEratosthenesBitSetWheel(through limit: UInt, appending elements: inout [UInt]) {
        //=--------------------------------------=
        if  limit < 2 as UInt { return }
        //=--------------------------------------=
        var value : UInt
        var index = NBK.PBI.dividing(NBK.ZeroOrMore((limit &- 1) &>> 1), by: NBK.PowerOf2(bitWidth: UInt.self))
        var marks = Array(repeating: UInt.max, count: Int(index.quotient + UInt(bit: !index.remainder.isZero)))
        let wheel = Wheel(primes:[2, 3, 5, 7])
        var outer = NBK.CyclicIterator(wheel.increments)!
        var inner = NBK.CyclicIterator(wheel.increments)!
        //=--------------------------------------=
        // mark each number in: 3, 5, 7, ...
        //=--------------------------------------=
        unmarked: do {
            elements.append(2 as UInt)
        }
        
        if  let value =  wheel.primes.dropFirst(1).first, value <= limit {
            var array = Array(repeating: UInt.max, count: Int(bitPattern: value))
            sieve(&array, from: value &>> 1 &- 1, stride:{ value })
            elements.append(value)
            
            for value in wheel.primes.dropFirst(2) where  value <= limit {
                var after = Array(repeating: UInt.max, count: Int(bitPattern: value) * array.count)
                sieve(&after, from: value &>> 1 &- 1, stride:{ value })
                sieve(&after, pattern: NBK.CyclicIterator.init(array)!)
                array = after
                elements.append(value)
            };  sieve(&marks, pattern: NBK.CyclicIterator.init(array)!)
        }
        //=--------------------------------------=
        // mark each number in: 11, 13, 17, ...
        //=--------------------------------------=
        value = 1 as UInt; while true { value &+= outer.next(); inner.reset()
            
            let (first, overflow) = value.multipliedReportingOverflow(by: value)
            
            done: if  first > limit || overflow { break }
            
            index = NBK.PBI.dividing(NBK.ZeroOrMore(value &>> 1 &- 1), by: NBK.PowerOf2(bitWidth: UInt.self))
            
            composite: if (marks[Int(bitPattern: index.quotient)] & (1 &<< index.remainder)).isZero { continue }
            
            var start  = value // some wheel position <= value * value
            start/**/ += value * (value / wheel.circumference) * wheel.circumference
            if  value  < wheel.circumference {
                start += value * (inner).next()
            }
            
            sieve(&marks, from: start &>> 1 &- 1, stride:{ value &* inner.next() &>> 1 }) // the wheel is small
        }
        //=--------------------------------------=
        // add each marked number to the list
        //=--------------------------------------=
        value = 3 as UInt; loop: for var chunk in marks { var position = value
            
            while !chunk.isZero {
                let shift = UInt(bitPattern: chunk.trailingZeroBitCount)
                if  position.addReportingOverflow(shift &<< 1) || position > limit { break loop }
                
                elements.append(position)
                
                if  position.addReportingOverflow(00000000002) || position > limit { break loop }
                chunk >>= shift &+ 1 // smart shifting because it may exceed the bit width
            }
            
            if (value).addReportingOverflow(UInt(bitPattern: UInt.bitWidth) &<< 1) { break loop }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    /// Sieves the `marks` with the given pattern `cycle`.
    @usableFromInline static func sieve(_ marks: inout [UInt], pattern cycle: NBK.CyclicIterator<[UInt]>) {
        var cycle =  cycle
        for index in marks.indices {
            marks[index] &= cycle.next()
        }
    }
    
    /// Sieves the `marks` from `start` with strides of `increment`.
    ///
    /// This method is hot, and uses wrapping arithmetic for performance reasons.
    /// The overflow condition is in the requirements section.
    ///
    /// - Requires: `increment <= UInt.max - UInt.bitWidth + 1`.
    ///
    @usableFromInline static func sieve(_ marks: inout [UInt], from start: UInt, stride increment: () -> UInt) {
        var index: QR<UInt, UInt> = NBK.PBI.dividing(NBK.ZeroOrMore(start), by: NBK.PowerOf2(bitWidth: UInt.self))
        
        while index.quotient < UInt(bitPattern: marks.count) {
            var mask = UInt.zero; while index.remainder < UInt.bitWidth {
                mask &+= 1 &<< index.remainder
                index.remainder &+= increment()
            }
            
            marks[Int(bitPattern: index.quotient)] &= mask.onesComplement()
            index.quotient &+= NBK.PBI .quotient(dividing: NBK.ZeroOrMore(index.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
            index.remainder  = NBK.PBI.remainder(dividing: NBK.ZeroOrMore(index.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Miscellaneous
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
        @usableFromInline var circumference: UInt
        @usableFromInline var increments: [UInt]
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=

        /// - TODO: Consider type-safe primes.
        @usableFromInline init(primes: [UInt]) {
            Swift.assert(primes.allSatisfy({ $0 >= 2 }))
            
            self.primes = primes
            self.circumference = primes.reduce(1, *)
            
            var increments: [UInt] = []
            var predecessor: UInt  = 01
            for successor in 02 ..< self.circumference {
                if  primes.allSatisfy({ successor % $0 != 0 }) {
                    increments.append(((successor)) &- predecessor)
                    predecessor = ((((((successor))))))
                }
            }
            
            increments.append(self.circumference &+ 1 &- predecessor)
            self.increments = increments
        }
    }
}
