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
        if  lhs.isZero { return rhs.magnitude }
        if  rhs.isZero { return lhs.magnitude }
        //=--------------------------------------=
        var lhs: T.Magnitude =  lhs.magnitude
        var rhs: T.Magnitude =  rhs.magnitude
        //=--------------------------------------=
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
        
        lhs >>= Swift.min(lhsShift, rhsShift)
        return  lhs as T.Magnitude
    }
}
