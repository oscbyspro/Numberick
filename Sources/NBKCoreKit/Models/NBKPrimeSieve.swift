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
    
    /// Generates a list of all primes from zero through `limit`.
    public init(through limit: UInt) {
        self._limit = limit
        self._elements = []
        Self.primesByEratosthenes(through: limit, appending: &self._elements)
    }
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
    /// - Complexity: O(n × log(log(n)))
    ///
    /// - Note: 1 million takes 0.0s on MacBook Pro (13-inch, M1, 2020).
    ///
    /// - Note: 1 billion takes 3.6s on MacBook Pro (13-inch, M1, 2020).
    ///
    @inlinable static func primesByEratosthenes(through limit: UInt, appending elements: inout some RangeReplaceableCollection<UInt>) {
        //=--------------------------------------=
        if  limit < 2 { return }
        //=--------------------------------------=
        // mark each number in: 3, 5, 7, 9, ...
        //=--------------------------------------=
        let count = Int(bitPattern:  (limit &- 1) &>> 1)
        var marks = Array(repeating: true, count: count) // UInt.max at Int.max - 1
        
        var value = 3 as UInt; loop: while true { defer { value &+= 2 }
            let (square, overflow) = value.multipliedReportingOverflow(by: value)
            done: if square > limit || overflow { break }
            composite: if !marks[Int(bitPattern: value &>> 1 &- 1)] { continue }
            var index = Int(bitPattern: square &>> 1 &- 1)
            composite: while marks.indices ~= index { marks[index] = false; index &+= Int(bitPattern: value) }
        }
        
        unmarked: do {
            elements.append(2 as UInt)
        }
        
        for index in marks.indices where marks[index] {
            elements.append(UInt(bitPattern: index) &<< 1 &+ 3)
        }
    }
}
