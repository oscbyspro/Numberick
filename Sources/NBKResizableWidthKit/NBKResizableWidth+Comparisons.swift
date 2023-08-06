//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

//*============================================================================*
// MARK: * NBK x Resizable Width x Comparisons x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var isZero: Bool {
        self.count == 1 && self.first.isZero
    }
    
    @inlinable public var isLessThanZero: Bool {
        false
    }
    
    @inlinable public var isMoreThanZero: Bool {
        !self.isZero
    }
    
    @inlinable public var isPowerOf2: Bool {
        NBK.nonzeroBitCount(of: self.storage, equals: 1)
    }
    
    @inlinable public func signum() -> Int {
        Int(bit: !self.isZero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func hash(into hasher: inout Hasher) {
        hasher.combine(self.storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) ==  0
    }
    
    @inlinable public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == -1
    }
    
    @inlinable public func compared(to other: Self) -> Int {
        self .withContiguousStorage { lhs in
        other.withContiguousStorage { rhs in
            Self.compareWordsUnchecked(lhs, to: rhs)
        }}
    }
    
    @inlinable public func compared(to other: Self, at index: Int) -> Int {
        self .withContiguousStorage { lhs in
        other.withContiguousStorage { rhs in
            Self.compareWordsUnchecked(lhs, to: rhs, at: index)
        }}
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit) -> Int {
        self.withContiguousStorage { lhs in
        NBK .withUnsafeWords(of: other) { rhs in
            Self.compareWordsUnchecked(lhs, to: rhs)
        }}
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit, at index: Int) -> Int {
        self.withContiguousStorage { lhs in
        NBK .withUnsafeWords(of: other) { rhs in
            Self.compareWordsUnchecked(lhs, to: rhs, at: index)
        }}
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    ///
    /// - Requires: The last element in `lhs` and `rhs` must not be zero.
    ///
    @inlinable static func compareWordsUnchecked(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords, at index: Int) -> Int {
        let partition = Swift.min(index, lhs.endIndex)
        let suffix = NBK.UnsafeWords(rebasing: lhs.suffix(from: partition))
        let comparison = Self.compareWordsUnchecked(suffix, to: rhs)
        if !comparison.isZero { return comparison }
        let prefix = NBK.UnsafeWords(rebasing: lhs.prefix(upTo: partition))
        return Int(bit: !prefix.allSatisfy({ $0.isZero }))
    }
    
    /// A three-way comparison of `lhs` against `rhs`.
    @inlinable static func compareWordsUnchecked(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords) -> Int {
        let lhs = NBK.UnsafeWords(rebasing: NBK.dropLast(from: lhs, while:{ $0.isZero }))
        let rhs = NBK.UnsafeWords(rebasing: NBK.dropLast(from: rhs, while:{ $0.isZero }))
        return Self.compareMinTwosComplementWordsUnchecked(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs`.
    ///
    /// - Requires: The last element in `lhs` and `rhs` must not be zero.
    ///
    @inlinable static func compareMinTwosComplementWordsUnchecked(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords) -> Int {
        assert(lhs.last != 0 && rhs.last != 0)
        //=--------------------------------------=
        if  lhs.count != rhs.count {
            return lhs.count < rhs.count ? -1 : 1
        }
        //=--------------------------------------=
        return Self.compareSameSizeWordsUnchecked(lhs, to: rhs)
    }
    
    /// A three-way comparison of `lhs` against `rhs`.
    ///
    /// - Requires: The number of elements in `lhs` and `rhs` must be equal.
    ///
    @inlinable static func compareSameSizeWordsUnchecked(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords) -> Int {
        assert(lhs.count == rhs.count)
        
        for index in lhs.indices.reversed() {
            let lhsWord  = lhs[index] as UInt
            let rhsWord  = rhs[index] as UInt
            if  lhsWord != rhsWord { return lhsWord < rhsWord ? -1 : 1 }
        }
        
        return Int.zero
    }
}
