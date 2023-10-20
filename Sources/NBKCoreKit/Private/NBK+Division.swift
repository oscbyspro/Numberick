//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Division
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation x where Divisor is Power of 2
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing this the `dividend` by the `divisor`.
    ///
    /// ### Development
    ///
    /// Must use `init(bitPattern)` for performance reasons (see Int256 division).
    ///
    @inlinable public static func quotient<T: NBKCoreInteger>(
    dividing dividend: ZeroOrMore<T>, by divisor: PowerOf2<T>) -> T where T.Magnitude == UInt {
        dividend.value &>> T(bitPattern: divisor.value.trailingZeroBitCount)
    }
    
    /// Returns the `remainder` of dividing this the `dividend` by the `divisor`.
    @inlinable public static func remainder<T: NBKCoreInteger>(
    dividing dividend: ZeroOrMore<T>, by divisor: PowerOf2<T>) -> T {
        dividend.value & (divisor.value &- 1 as T)
    }
}

//*============================================================================*
// MARK: * NBK x Division x Least Positive Residue x Binary Integer By Word
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Overflow
    //=------------------------------------------------------------------------=

    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    ///
    /// - Note: In the case of `overflow`, the result is the truncated `dividend`.
    ///
    @inlinable public static func leastPositiveResidueReportingOverflow<T: BinaryInteger, U: NBKCoreInteger>(
    dividing dividend: T, by divisor: U) -> PVO<U> where U.Magnitude == UInt {
        NBK.bitCast(self.leastPositiveResidueReportingOverflow(dividing: dividend, by: divisor.magnitude))
    }
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    ///
    /// - Note: In the case of `overflow`, the result is the truncated `dividend`.
    ///
    @inlinable public static func leastPositiveResidueReportingOverflow<T: BinaryInteger>(
    dividing dividend: T, by divisor: UInt) -> PVO<UInt> {
        //=--------------------------------------=
        guard let divisor = NBK.NonZero(exactly: divisor) else {
            return PVO(dividend._lowWord, true)
        }
        //=--------------------------------------=
        return PVO(self.leastPositiveResidue(dividing: dividend, by: divisor), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x where Divisor is Non Zero
    //=------------------------------------------------------------------------=
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    @inlinable public static func leastPositiveResidue<T: BinaryInteger, U: NBKCoreInteger>(
    dividing dividend: T, by divisor: NonZero<U>) -> U where U.Magnitude == UInt {
        U(bitPattern: NBK.leastPositiveResidue(dividing: dividend, by: NBK.NonZero(unchecked: divisor.value.magnitude)))
    }
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    @inlinable public static func leastPositiveResidue<T: BinaryInteger>(
    dividing dividend: T, by divisor: NonZero<UInt>) -> UInt {
        typealias SUI = StrictUnsignedInteger<T.Magnitude.Words>
        //=--------------------------------------=
        if  let divisor = PowerOf2(exactly: divisor.value) {
            return self.leastPositiveResidue(dividing: dividend, by: divisor)
        }
        //=--------------------------------------=
        let minus = T.isSigned && dividend < T.zero
        let remainder = SUI.SubSequence.remainder(dividing: dividend.magnitude.words, by: divisor)
        return minus && !remainder.isZero ? divisor.value &- remainder : remainder
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x where Divisor is Power of 2
    //=------------------------------------------------------------------------=
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    @inlinable public static func leastPositiveResidue<T: BinaryInteger, U: NBKCoreInteger>(
    dividing dividend: T, by divisor: PowerOf2<U>) -> U where U.Magnitude == UInt {
        U(bitPattern: dividend._lowWord & UInt(bitPattern: divisor.value &- 1 as U))
    }
}
