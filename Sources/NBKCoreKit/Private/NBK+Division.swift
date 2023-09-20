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
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    ///
    /// - Note: In the case of `overflow`, the result is the truncated `dividend`.
    ///
    @inlinable public static func leastPositiveResidueReportingOverflow<T>(
    of dividend: T, dividingBy divisor: UInt) -> PVO<UInt> where T: BinaryInteger {
        //=--------------------------------------=
        if  divisor.isPowerOf2 {
            return PVO(dividend._lowWord & (divisor &- 1), false)
        }
        //=--------------------------------------=
        if  divisor.isZero {
            return PVO(dividend._lowWord, true)
        }
        //=--------------------------------------=
        let minus = T.isSigned && dividend < T.zero
        var remainder = 000000000000000000 as  UInt
        
        for word in dividend.magnitude.words.reversed() {
            remainder = divisor.dividingFullWidth(HL(high: remainder, low: word)).remainder
        }
        
        return PVO((minus && !remainder.isZero) ? (divisor &- remainder) : remainder, false)
    }
    
    /// Returns the least positive `residue` of dividing the `dividend` by `source.bitWidth`.
    ///
    /// - Note: Numberick integers have positive, nonzero, bit widths.
    ///
    @inlinable public static func leastPositiveResidue<T: NBKFixedWidthInteger>(
    of dividend: some BinaryInteger, dividingByBitWidthOf source: T.Type) -> Int {
        Int(bitPattern: NBK.leastPositiveResidueReportingOverflow(of: dividend, dividingBy: UInt(bitPattern: T.bitWidth)).partialValue)
    }
}
