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
    // MARK: Transformation where Divisor is Power of 2
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` of dividing this the `dividend` by the `divisor`.
    @inlinable public static func quotient<T: NBKCoreInteger>(
    of  dividend: ZeroOrMore<T>, dividingBy divisor: PowerOf2<T>) -> T {
        dividend.value &>> divisor.value.trailingZeroBitCount
    }
    
    /// Returns the `remainder` of dividing this the `dividend` by the `divisor`.
    @inlinable public static func remainder<T: NBKCoreInteger>(
    of  dividend: ZeroOrMore<T>, dividingBy divisor: PowerOf2<T>) -> T {
        dividend.value & (divisor.value &- 1 as T)
    }
}

//*============================================================================*
// MARK: * NBK x Division x Least Positive Residue x Int or UInt
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
    of  dividend: T, dividingBy divisor: U) -> PVO<U> where U.Magnitude == UInt {
        NBK.bitCast(self.leastPositiveResidueReportingOverflow(of: dividend, dividingBy: divisor.magnitude))
    }
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    ///
    /// - Note: In the case of `overflow`, the result is the truncated `dividend`.
    ///
    @inlinable public static func leastPositiveResidueReportingOverflow<T: BinaryInteger>(
    of  dividend: T, dividingBy divisor: UInt) -> PVO<UInt> {
        //=--------------------------------------=
        if  divisor.isZero {
            return PVO(dividend._lowWord, true)
        }
        //=--------------------------------------=
        return PVO(self.leastPositiveResidue(of: dividend, dividingBy: NonZero(unchecked: divisor)), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x where Divisor is Non Zero
    //=------------------------------------------------------------------------=
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    @inlinable public static func leastPositiveResidue<T: BinaryInteger, U: NBKCoreInteger>(
    of  dividend: T,  dividingBy divisor: NonZero<U>) -> U where U.Magnitude == UInt {
        U(bitPattern: NBK.leastPositiveResidue(of: dividend, dividingBy: NBK.NonZero(unchecked: divisor.value.magnitude)))
    }
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    @inlinable public static func leastPositiveResidue<T: BinaryInteger>(
    of  dividend: T, dividingBy divisor: NonZero<UInt>) -> UInt {
        typealias SUI = StrictUnsignedInteger<T.Magnitude.Words>
        //=--------------------------------------=
        if  let divisor = PowerOf2(exactly: divisor.value) {
            return self.leastPositiveResidue(of: dividend, dividingBy: divisor)
        }
        //=--------------------------------------=
        let minus = T.isSigned && dividend < T.zero
        let remainder = SUI.SubSequence.remainder(dividend.magnitude.words, dividingBy: divisor)
        return minus && !remainder.isZero ? divisor.value &- remainder : remainder
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x where Divisor is Power of 2
    //=------------------------------------------------------------------------=
    
    /// Returns the least positive `residue` of dividing the `dividend` by the `divisor`.
    @inlinable public static func leastPositiveResidue<T: BinaryInteger, U: NBKCoreInteger>(
    of  dividend: T, dividingBy divisor: PowerOf2<U>) -> U where U.Magnitude == UInt {
        U(bitPattern: dividend._lowWord & UInt(bitPattern: divisor.value &- 1 as U))
    }
}
