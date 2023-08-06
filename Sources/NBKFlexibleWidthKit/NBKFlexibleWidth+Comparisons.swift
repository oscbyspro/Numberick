//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKResizableWidthKit

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
        lhs.compared(to: rhs).isZero
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
        self.compared(to: Int.min, at: self.magnitude.storage.lastIndex).isZero
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
        self.storage.isZero
    }
    
    @inlinable public var isLessThanZero: Bool {
        self.storage.isLessThanZero
    }
    
    @inlinable public var isMoreThanZero: Bool {
        self.storage.isMoreThanZero
    }
    
    @inlinable public var isPowerOf2: Bool {
        self.storage.isPowerOf2
    }
    
    @inlinable public func signum() -> Int {
        self.storage.signum()
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
        lhs.compared(to: rhs).isZero
    }
    
    @inlinable public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.compared(to: rhs) == -1
    }
    
    @inlinable public func compared(to other: Self) -> Int {
        self.storage.compared(to: other.storage)
    }
    
    @inlinable public func compared(to other: Self, at index: Int) -> Int {
        self.storage.compared(to: other.storage, at: index)
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit) -> Int {
        self.storage.compared(to: other)
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit, at index: Int) -> Int {
        self.storage.compared(to: other, at: index)
    }
}
