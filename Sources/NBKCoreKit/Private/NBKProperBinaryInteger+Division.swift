//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Division x Core Integer
//*============================================================================*

extension NBK.ProperBinaryInteger where Integer: NBKCoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation x Zero Or More By Power of 2
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` and `remainder` of dividing the `dividend` by the `divisor`.
    ///
    /// ### Development
    ///
    /// Must use `init(bitPattern:)` for performance reasons (see Int256 division).
    ///
    @inlinable public static func dividing(
    _   dividend: NBK.ZeroOrMore<Integer>, by divisor: NBK.PowerOf2<Integer>)
    ->  QR<Integer, Integer> where Integer.Magnitude == UInt {
        return QR(
        quotient:  self.quotient (dividing: dividend, by: divisor),
        remainder: self.remainder(dividing: dividend, by: divisor))
    }
    
    /// Returns the `quotient` of dividing the `dividend` by the `divisor`.
    ///
    /// ### Development
    ///
    /// Must use `init(bitPattern:)` for performance reasons (see Int256 division).
    ///
    @inlinable public static func quotient(
    dividing dividend: NBK.ZeroOrMore<Integer>, by divisor: NBK.PowerOf2<Integer>) 
    ->  Integer where Integer.Magnitude == UInt {
        dividend.value &>> Integer(bitPattern: divisor.value.trailingZeroBitCount)
    }
    
    /// Returns the `remainder` of dividing the `dividend` by the `divisor`.
    @inlinable public static func remainder(
    dividing dividend: NBK.ZeroOrMore<Integer>, by divisor: NBK.PowerOf2<Integer>) -> Integer {
        dividend.value & (divisor.value &- 1 as Integer)
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Division x Binary Integer By Word
//*============================================================================*
//=----------------------------------------------------------------------------=
// NOTE: We still need to interact with Swift's generic protocol requirements.
//=----------------------------------------------------------------------------=
//=----------------------------------------------------------------------------=
// MARK: + Least Positive Residue
//=----------------------------------------------------------------------------=

extension NBK.ProperBinaryInteger where Integer: NBKCoreInteger<UInt> {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Overflow
    //=------------------------------------------------------------------------=
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    ///
    /// - Note: In the case of `overflow`, the result is the truncated `dividend`.
    ///
    @inlinable public static func leastPositiveResidueReportingOverflow(
    dividing dividend: some BinaryInteger, by divisor: Integer) -> PVO<Integer> {
        NBK.bitCast(NBK.PBI.leastPositiveResidueReportingOverflow(dividing: dividend, by: divisor.magnitude))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Dividing By Non Zero
    //=------------------------------------------------------------------------=
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    @inlinable public static func leastPositiveResidue(
    dividing dividend: some BinaryInteger, by divisor: NBK.NonZero<Integer>) ->  Integer {
        Integer(bitPattern: NBK.PBI.leastPositiveResidue(dividing: dividend, by: NBK.NonZero(unchecked: divisor.value.magnitude)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Dividing By Power Of 2
    //=------------------------------------------------------------------------=
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    @inlinable public static func leastPositiveResidue(
    dividing dividend: some BinaryInteger, by divisor: NBK.PowerOf2<Integer>)  -> Integer {
        Integer(bitPattern: dividend._lowWord & UInt(bitPattern: divisor.value &- 1 as Integer))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Least Positive Residue x Unsigned
//=----------------------------------------------------------------------------=

extension NBK.ProperBinaryInteger where Integer: NBKCoreInteger<UInt> & NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Overflow
    //=------------------------------------------------------------------------=
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    ///
    /// - Note: In the case of `overflow`, the result is the truncated `dividend`.
    ///
    @inlinable public static func leastPositiveResidueReportingOverflow(
    dividing dividend: some BinaryInteger, by divisor: Integer) -> PVO<Integer> {
        //=--------------------------------------=
        guard let divisor = NBK.NonZero(exactly: divisor) else {
            return PVO(dividend._lowWord, true)
        }
        //=--------------------------------------=
        return PVO(self.leastPositiveResidue(dividing: dividend, by: divisor), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Dividing By Non Zero
    //=------------------------------------------------------------------------=
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    @inlinable public static func leastPositiveResidue<T: BinaryInteger>(
    dividing dividend: T, by divisor: NBK.NonZero<Integer>) -> Integer {
        //=--------------------------------------=
        if  let divisor = NBK.PowerOf2(exactly: divisor.value) {
            return NBK.PBI.leastPositiveResidue(dividing: dividend, by: divisor)
        }
        //=--------------------------------------=
        let minus: Bool = T.isSigned && dividend < T.zero
        let remainder = NBK.SUISS.remainder(dividing: dividend.magnitude.words, by: divisor)
        return minus && !remainder.isZero ? divisor.value &- remainder : remainder
    }
}
