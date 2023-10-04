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
// MARK: * NBK x Signed x Comparisons
//*============================================================================*

extension NBKSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// Returns whether this value is equal to zero.
    @inlinable public var isZero: Bool {
        self.magnitude.isZero
    }
    
    /// Returns whether this value is less than zero.
    @inlinable public var isLessThanZero: Bool {
        self.sign != Sign.plus && !self.isZero
    }
    
    /// Returns whether this value is more than zero.
    @inlinable public var isMoreThanZero: Bool {
        self.sign == Sign.plus && !self.isZero
    }
    
    /// Returns whether this value is a power of two.
    @inlinable public var isPowerOf2: Bool {
        self.sign == Sign.plus && self.magnitude.isPowerOf2
    }
    
    /// Returns `1` if this value is positive, `-1` if it is negative, and `0` otherwise.
    @inlinable public func signum() -> Int {
        self.isZero ? 0 : self.sign == Sign.plus ? 1 : -1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func hash(into hasher: inout Hasher) {
        hasher.combine(self.magnitude)
        hasher.combine(self.normalizedSign)
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
        NBK.SAM.compare(self.components, to: other.components, using:{ $0.compared(to: $1) })
    }
    
    @_disfavoredOverload @inlinable public func compared(to other: Digit) -> Int {
        NBK.SAM.compare(self.components, to: other.components, using:{ $0.compared(to: $1) })
    }
}
