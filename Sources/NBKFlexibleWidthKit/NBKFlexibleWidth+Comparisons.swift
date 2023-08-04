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
// MARK: * NBK x Flexible Width x Comparisons x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var isZero: Bool {
        self.magnitude.isZero
    }
    
    @inlinable public var isLessThanZero: Bool {
        self.sign != Sign.plus && !self.isZero
    }
    
    @inlinable public var isMoreThanZero: Bool {
        self.sign == Sign.plus && !self.isZero
    }
    
    @inlinable public var isPowerOf2: Bool {
        self.sign == Sign.plus && self.magnitude.isPowerOf2
    }
    
    @inlinable public func signum() -> Int {
        self.isZero ? 0 : self.sign == Sign.plus ? 1 : -1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func hash(into hasher: inout Hasher) {
        hasher.combine(self.sign == Sign.minus && self.isZero ? Sign.plus : self.sign)
        hasher.combine(self.magnitude)
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
        Self.compare(self, to: other, magnitude:{ $0.compared(to: $1) })
    }
    
    @inlinable public func compared(to other: Self, at index: Int) -> Int {
        Self.compare(self, to: other, magnitude:{ $0.compared(to: $1, at: index) })
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit) -> Int {
        Self.compare(self, to: other, magnitude:{ $0.compared(to: $1) })
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit, at index: Int) -> Int {
        Self.compare(self, to: other, magnitude:{ $0.compared(to: $1, at: index) })
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors x Private
    //=------------------------------------------------------------------------=
    
    @inlinable var isTwosComplementMinValue: Bool {
        guard !self.magnitude.storage.elements.isEmpty else { return false }
        return self.compared(to: Int.min, at: self.magnitude.storage.elements.count - 1).isZero
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    @inlinable static func compare<T>(_ lhs: Self, to rhs: T, magnitude: (Magnitude, T.Magnitude) -> Int) -> Int where T: NBKBinaryInteger {
        //=--------------------------------------=
        if  lhs.sign.bit != rhs.isLessThanZero {
            return lhs.isZero && rhs.isZero ? 0 : lhs.sign.bit ? -1 : 1
        }
        //=--------------------------------------=
        let magnitude = magnitude(lhs.magnitude, rhs.magnitude)
        return lhs.sign.bit ? magnitude.negated()  : magnitude
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Comparisons x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var isZero: Bool {
        self.storage.elements.isEmpty
    }
    
    @inlinable public var isLessThanZero: Bool {
        false
    }
    
    @inlinable public var isMoreThanZero: Bool {
        !self.isZero
    }
    
    @inlinable public var isPowerOf2: Bool {
        NBK.nonzeroBitCount(of: self.storage.elements, equals: 1)
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
        self .storage.elements.withUnsafeBufferPointer { lhs in
        other.storage.elements.withUnsafeBufferPointer { rhs in
            Self.compareWordsUnchecked(lhs, to: rhs)
        }}
    }
    
    @inlinable public func compared(to other: Self, at index: Int) -> Int {
        self .storage.elements.withUnsafeBufferPointer { lhs in
        other.storage.elements.withUnsafeBufferPointer { rhs in
            Self.compareWordsUnchecked(lhs, to: rhs, at: index)
        }}
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit) -> Int {
        self.storage.elements.withUnsafeBufferPointer { lhs in
        Self.withUnsafeWords(of: other) { rhs in
            Self.compareWordsUnchecked(lhs, to: rhs)
        }}
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit, at index: Int) -> Int {
        self.storage.elements.withUnsafeBufferPointer { lhs in
        Self.withUnsafeWords(of: other) { rhs in
            Self.compareWordsUnchecked(lhs, to: rhs, at: index)
        }}
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison of `lhs` against `rhs`.
    ///
    /// - Requires: The last element in `lhs` and `rhs` must not be zero.
    ///
    @inlinable static func compareWordsUnchecked(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords) -> Int {
        assert(lhs.last != 0 && rhs.last != 0)
        //=--------------------------------------=
        if  lhs.count != rhs.count {
            return lhs.count < rhs.count ? -1 : 1
        }
        //=--------------------------------------=
        for index in lhs.indices.reversed() {
            let lhsWord  = lhs[index] as UInt
            let rhsWord  = rhs[index] as UInt
            if  lhsWord != rhsWord { return lhsWord < rhsWord ? -1 : 1 }
        }
        
        return Int.zero
    }
    
    /// A three-way comparison of `lhs` against `rhs` at `index`.
    ///
    /// - Requires: The last element in `lhs` and `rhs` must not be zero.
    ///
    @inlinable static func compareWordsUnchecked(_ lhs: NBK.UnsafeWords, to rhs: NBK.UnsafeWords, at index: Int) -> Int {
        assert(lhs.last != 0 && rhs.last != 0 && index >= 0)
        //=--------------------------------------=
        let partition = Swift.min(index, lhs.endIndex)
        let suffix = NBK.UnsafeWords(rebasing: lhs.suffix(from: partition))
        let comparison = Self.compareWordsUnchecked(suffix, to: rhs)
        if !comparison.isZero { return comparison }
        let prefix = NBK.UnsafeWords(rebasing: lhs.prefix(upTo: partition))
        return Int(bit: !prefix.allSatisfy({ $0.isZero }))
    }
}
