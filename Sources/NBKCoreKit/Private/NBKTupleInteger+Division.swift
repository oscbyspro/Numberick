//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Tuple Integer x Division
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBK.TupleInteger where High: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformation
    //=------------------------------------------------------------------------=
    
    /// Divides 3 halves by 2 normalized halves, assuming the quotient fits in 1 half.
    ///
    /// - Returns: The `quotient` is returned and the `remainder` replaces the dividend.
    ///
    /// ### Development 1
    ///
    /// The profiler says comparing is faster than overflow checking.
    ///
    /// ### Development 2
    ///
    /// The approximation needs at most two adjustments, but a loop is faster.
    ///
    @_transparent public static func divide3212MSBUnchecked(_ lhs: inout Wide3, by rhs: Wide2) -> High {
        assert(rhs.high.mostSignificantBit, "divisor must be normalized")
        assert(self.compare22S(rhs, to: HL(lhs.high, lhs.mid)) == 1, "quotient must fit in one half")
        //=--------------------------------------=
        var quotient = lhs.high == rhs.high ? High.max : rhs.high.dividingFullWidth(HL(lhs.high, lhs.mid)).quotient
        var approximation = self.multiplying213(rhs, by: quotient)
        //=--------------------------------------=
        // decrement when overestimated (max 2)
        //=--------------------------------------=
        while self.compare33S(lhs, to: approximation) == -1 {
            _ = quotient.subtractReportingOverflow(1  as High.Digit)
            _ = self.decrement32B(&approximation, by: rhs)
        }
        //=--------------------------------------=
        let _ = self.decrement33B(&lhs, by: approximation)
        return  quotient as High
    }
}
