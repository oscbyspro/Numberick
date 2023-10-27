//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor
//*============================================================================*

extension NBK.ProperBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Finds the GCD of `lhs` and `rhs` by using [this binary algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/binary_GCD_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByBinaryAlgorithm(
    of lhs: Integer, and rhs: Integer) -> Integer.Magnitude {
        NBK.PUI.greatestCommonDivisorByBinaryAlgorithm(of: lhs.magnitude, and: rhs.magnitude)
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor x Unsigned
//*============================================================================*

extension NBK.ProperBinaryInteger where Integer: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    /// Finds the GCD of `lhs` and `rhs` by using [this binary algorithm][algorithm].
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/binary_GCD_algorithm
    ///
    /// - TODO: Use `bitShift(...)` methods if/when NBKBinaryInteger...
    ///
    @inlinable public static func greatestCommonDivisorByBinaryAlgorithm(
    of  lhs: Integer, and rhs: Integer) -> Integer {
        //=--------------------------------------=
        if  rhs.isZero { return lhs }
        if  lhs.isZero { return rhs }
        //=--------------------------------------=
        let lhs2sCount = lhs.trailingZeroBitCount // lhs == 2 ^ a * b
        let rhs2sCount = rhs.trailingZeroBitCount // rhs == 2 ^ x * y
        //=--------------------------------------=
        var lhs: Integer = lhs >> lhs2sCount
        var rhs: Integer = rhs >> rhs2sCount
        
        while   lhs  != rhs {
            if  lhs   < rhs {
                let _ = rhs.subtractReportingOverflow(lhs)
                rhs >>= rhs.trailingZeroBitCount
            }   else {
                let _ = lhs.subtractReportingOverflow(rhs)
                lhs >>= lhs.trailingZeroBitCount
            }
        }
        
        lhs <<= Swift.min(lhs2sCount, rhs2sCount) // the 2s in common
        return  lhs as Integer.Magnitude
    }
}
