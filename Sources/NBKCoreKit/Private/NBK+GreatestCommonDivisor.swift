//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Greatest Common Divisor
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Finds the greatest common divisor of `lhs` and `rhs` by using [this binary algorithm][algorithm].
    ///
    /// - TODO: Use `bitShift(...)` methods if/when NBKBinaryInteger...
    ///
    /// [algorithm]: https://en.wikipedia.org/wiki/binary_GCD_algorithm
    ///
    @inlinable public static func greatestCommonDivisorByBinaryAlgorithm<T>(
    of  lhs: T, and rhs: T) -> T.Magnitude where T: NBKBinaryInteger {
        //=--------------------------------------=
        var lhs = lhs.magnitude as  T.Magnitude
        if  rhs.isZero { return lhs }
        var rhs = rhs.magnitude as  T.Magnitude
        if  lhs.isZero { return rhs }
        
        let lhsShift: Int = lhs.trailingZeroBitCount
        let rhsShift: Int = rhs.trailingZeroBitCount
        //=--------------------------------------=
        lhs >>= lhsShift
        rhs >>= rhsShift
        
        while   lhs  != rhs {
            if  lhs   < rhs {
                let _ = rhs.subtractReportingOverflow(lhs)
                rhs >>= rhs.trailingZeroBitCount
            }   else {
                let _ = lhs.subtractReportingOverflow(rhs)
                lhs >>= lhs.trailingZeroBitCount
            }
        }
        
        lhs <<= Swift.min(lhsShift, rhsShift)
        return  lhs as T.Magnitude
    }
}
