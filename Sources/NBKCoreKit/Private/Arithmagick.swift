//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Arithmagick x Int or UInt
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing this value by its bit width.
    ///
    /// - Parameter value: `0 <= value <= max`
    ///
    @inlinable public static func quotientDividingByBitWidthAssumingIsAtLeastZero(_ value: Int) -> Int {
        assert(value >= 0, NBK.callsiteOutOfBoundsInfo())
        return Int(bitPattern: NBK.quotientDividingByBitWidth(UInt(bitPattern: value)))
    }
    
    /// Returns the `remainder` of dividing this value by its bit width.
    ///
    /// - Parameter value: `0 <= value <= max`
    ///
    @inlinable public static func remainderDividingByBitWidthAssumingIsAtLeastZero(_ value: Int) -> Int {
        assert(value >= 0, NBK.callsiteOutOfBoundsInfo())
        return Int(bitPattern: NBK.remainderDividingByBitWidth(UInt(bitPattern: value)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation x UInt
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing this value by its bit width.
    ///
    /// - Parameter value: `0 <= value <= max`
    ///
    @inlinable public static func quotientDividingByBitWidth(_ value: UInt) -> UInt {
        value &>> UInt(bitPattern: UInt.bitWidth.trailingZeroBitCount)
    }
    
    /// Returns the `remainder` of dividing this value by its bit width.
    ///
    /// - Parameter value: `0 <= value <= max`
    ///
    @inlinable public static func remainderDividingByBitWidth(_ value: UInt) -> UInt {
        value & UInt(bitPattern: UInt.bitWidth &- 1)
    }
}
