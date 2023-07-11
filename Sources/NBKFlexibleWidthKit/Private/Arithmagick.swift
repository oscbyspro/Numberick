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
// MARK: * NBK x Arithmagick x Int
//*============================================================================*

extension Int {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing this value by its bit width.
    ///
    /// - Parameter self: `0 <= self <= Self.max`
    ///
    @inlinable func quotientDividingByBitWidthAssumingIsAtLeastZero() -> Self {
        assert(self >= 0, "this value must be at least zero")
        return Self(bitPattern: Magnitude(bitPattern: self).quotientDividingByBitWidth())
    }
    
    /// Returns the `remainder` of dividing this value by its bit width.
    ///
    /// - Parameter self: `0 <= self <= Self.max`
    ///
    @inlinable func remainderDividingByBitWidthAssumingIsAtLeastZero() -> Self {
        assert(self >= 0, "this value must be at least zero")
        return Self(bitPattern: Magnitude(bitPattern: self).remainderDividingByBitWidth())
    }
}

//*============================================================================*
// MARK: * NBK x Arithmagick x UInt
//*============================================================================*

extension UInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing this value by its bit width.
    @inlinable func quotientDividingByBitWidth() -> Self {
        self &>> Self(bitPattern: Self.bitWidth.trailingZeroBitCount)
    }
    
    /// Returns the `remainder` of dividing this value by its bit width.
    @inlinable func remainderDividingByBitWidth() -> Self {
        self & Self(bitPattern: Self.bitWidth &- 1)
    }
}
