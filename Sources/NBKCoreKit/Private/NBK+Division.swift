//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Division x Int or UInt
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

//*============================================================================*
// MARK: * NBK x Division x Binary Integer
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the least `residue` of `value` modulo `modulus`.
    ///
    /// - Note: In the case of `overflow`, the result is `value.first`.
    ///
    @inlinable public static func residueReportingOverflow<T>(of value: T, modulo modulus: UInt) -> PVO<UInt> where T: BinaryInteger {
        //=--------------------------------------=
        if  modulus.isPowerOf2 {
            return PVO(value._lowWord & (modulus &- 1), false)
        }
        //=--------------------------------------=
        let minus = T.isSigned && value < T.zero
        let pvo = NBK.remainderReportingOverflowAsLenientUnsignedInteger(of: value.magnitude.words, dividingBy: modulus)
        return PVO((minus && !pvo.partialValue.isZero) ? (modulus &- pvo.partialValue) : pvo.partialValue, pvo.overflow)
    }
    
    /// Returns `value` modulo `source.bitWidth`.
    ///
    /// - Note: Numberick integers have positive, nonzero, bit widths.
    ///
    @inlinable public static func residue<T>(of value: some BinaryInteger, moduloBitWidthOf source: T.Type) -> Int where T: NBKFixedWidthInteger {
        Int(bitPattern: NBK.residueReportingOverflow(of: value, modulo: UInt(bitPattern: T.bitWidth)).partialValue)
    }
}
