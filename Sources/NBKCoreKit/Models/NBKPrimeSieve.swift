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
    /// - Note: 1 billion takes 1.7s on MacBook Pro (13-inch, M1, 2020).
    ///
    static func primesByEratosthenesBitSetWheel(through limit: UInt, appending elements: inout [UInt]) {
        //=--------------------------------------=
        if  limit < 2 as UInt { return }
        //=--------------------------------------=
        var value : UInt
        let split = NBK.PBI.dividing(NBK.ZeroOrMore((limit &- 1) &>> 1), by: NBK.PowerOf2(bitWidth: UInt.self))
        var marks = Array(repeating: UInt.max, count: Int(split.quotient + UInt(bit: !split.remainder.isZero)))
        let wheel = Wheel(primes:[2, 3, 5, 7])
        var outer = Cycle(wheel.increments)
        var inner = Cycle(wheel.increments)
        //=--------------------------------------=
        // mark each number in: 3, 5, 7, ...
        //=--------------------------------------=
        unmarked: do {
            elements.append(2 as UInt)
        }
        
        if  let value =  wheel.primes.dropFirst(1).first, value <= limit {
            var array = Array(repeating: UInt.max, count: Int(value))
            sieve(&array, multiples: value, from: (value) &>> 1 &- 1)
            elements.append(value)
            
            for value in wheel.primes.dropFirst(2) where  value <= limit {
                var after = Array(repeating: UInt.max, count: array.count * Int(bitPattern: value))
                sieve(&after, multiples: value, from: value &>> 1 &- 1)
                sieve(&after, by: Cycle(array))
                
                array = after
                elements.append(value)
            };  sieve(&marks, by: Cycle(array))
        }
        //=--------------------------------------=
        // mark each number in: 11, 13, 17, ...
        //=--------------------------------------=
        value = 1 + outer.next(); while true { var index: QR<UInt,UInt>; defer { value &+= outer.next() }; inner.reset()
            
            let (first, overflow) = value.multipliedReportingOverflow(by: value)
            
            done: if  first > limit || overflow { break }
            
            index = NBK.PBI.dividing(NBK.ZeroOrMore(value &>> 1 &- 1), by: NBK.PowerOf2(bitWidth: UInt.self))
            
            composite: if (marks[Int(bitPattern: index.quotient)] & (1 &<< index.remainder)).isZero { continue }
            
            var start  = value // some wheel position <= value * value
            start/**/ += value * (value / wheel.circumference) * wheel.circumference
            if  value  < wheel.circumference {
                start += value * (inner).next()
            }
            
            index = NBK.PBI.dividing(NBK.ZeroOrMore(start &>> 1 &- 1), by: NBK.PowerOf2(bitWidth: UInt.self))
            
            composite: while index.quotient < UInt(bitPattern: marks.count) {
                var mask = UInt.zero; while index.remainder < UInt.bitWidth { 
                    mask &+= 1 &<< index.remainder
                    index.remainder &+= value * inner.next() &>> 1
                }
                
                marks[Int(bitPattern: index.quotient)] &= mask.onesComplement()
                index.quotient &+= NBK.PBI .quotient(dividing: NBK.ZeroOrMore(index.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
                index.remainder  = NBK.PBI.remainder(dividing: NBK.ZeroOrMore(index.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
            }
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

    @usableFromInline static func sieve(_ outer: inout [UInt], by inner: Cycle) {
        var inner =  inner
        for index in outer.indices {
            outer[index] &= inner.next()
        }
    }
    
    @usableFromInline static func sieve(_ marks: inout [UInt], multiples value: UInt, from start: UInt) {
        var index: QR<UInt, UInt>
        
        index = NBK.PBI.dividing(NBK.ZeroOrMore(start), by: NBK.PowerOf2(bitWidth: UInt.self))
        
        composite: while index.quotient < UInt(bitPattern: marks.count) {
            var mask = UInt.zero; while index.remainder < UInt.bitWidth { mask &+= 1 &<< index.remainder; index.remainder &+= value }
            marks[Int(bitPattern: index.quotient)] &= mask.onesComplement()
            index.quotient &+= NBK.PBI .quotient(dividing: NBK.ZeroOrMore(index.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
            index.remainder  = NBK.PBI.remainder(dividing: NBK.ZeroOrMore(index.remainder), by: NBK.PowerOf2(bitWidth: UInt.self))
        }
    }
    
    //*========================================================================*
    // MARK: * Cycle
    //*========================================================================*
    
    @frozen @usableFromInline struct Cycle {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let wheel: [UInt]
        @usableFromInline var index: Int
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ wheel: [UInt]) {
            self.wheel  = wheel
            self.index  = wheel.startIndex
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Transformations
        //=--------------------------------------------------------------------=
        
        @inlinable mutating func reset() {
            self.index = self.wheel.startIndex
        }
        
        @inlinable mutating func next() -> UInt {
            defer {
                self.wheel.formIndex(after: &self.index)
                if  self.index == self.wheel.endIndex {
                    self.reset()
                }
            }

            return self.wheel[self.index] as UInt
        }
    }
    
    //*============================================================================*
    // MARK: * Wheel
    //*============================================================================*

    @frozen @usableFromInline struct Wheel {
        
        //=------------------------------------------------------------------------=
        // MARK: State
        //=------------------------------------------------------------------------=
        
        @usableFromInline let primes: [UInt]
        @usableFromInline var circumference: UInt
        @usableFromInline var increments: [UInt]
        
        //=------------------------------------------------------------------------=
        // MARK: Initializers
        //=------------------------------------------------------------------------=
        
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
