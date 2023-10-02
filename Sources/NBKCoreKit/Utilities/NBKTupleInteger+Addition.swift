//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Tuple Integer x Addition
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBK.TupleInteger where High: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the `sum` of `lhs` and `rhs`, and returns an `overflow` indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```
    /// ┌────────────┬─────── → ───────────┬──────────┐
    /// │ lhs        │ rhs    │ sum        │ overflow │
    /// ├────────────┼─────── → ───────────┼──────────┤
    /// │  0,  0,  0 │ ~4, ~5 │  0, ~4, ~5 │ false    │
    /// │  1,  2,  3 │ ~4, ~5 │  1, ~2, ~2 │ false    │
    /// │ ~1, ~2, ~3 │  4,  5 │ ~0,  2,  1 │ false    │
    /// │ ~0, ~0, ~0 │  4,  5 │  0,  4,  4 │ true     │
    /// └────────────┴─────── → ───────────┴──────────┘
    /// ```
    ///
    @_transparent public static func increment32B(_ lhs: inout Wide3, by rhs: Wide2) -> Bool {
        let a = lhs.low .addReportingOverflow(rhs.low )
        let b = lhs.mid .addReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .addReportingOverflow(1 as High.Digit)
        let y = (b || x) && lhs.high.addReportingOverflow(1 as High.Digit)
        return  (     y) as Bool
    }
    
    /// Forms the `sum` of `lhs` and `rhs`, and returns an `overflow` indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ sum        │ overflow │
    /// ├────────────┼─────────── → ───────────┼──────────┤
    /// │  0,  0,  0 │ ~4, ~5, ~6 │ ~4, ~5, ~6 │ false    │
    /// │  1,  2,  3 │ ~4, ~5, ~6 │ ~3, ~3, ~3 │ false    │
    /// │ ~1, ~2, ~3 │  4,  5,  6 │  3,  3,  2 │ true     │
    /// │ ~0, ~0, ~0 │  4,  5,  6 │  4,  5,  5 │ true     │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    @_transparent public static func increment33B(_ lhs: inout Wide3, by rhs: Wide3) -> Bool {
        let a = lhs.low .addReportingOverflow(rhs.low )
        let b = lhs.mid .addReportingOverflow(rhs.mid )
        let c = lhs.high.addReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .addReportingOverflow(1 as High.Digit)
        let y = (b || x) && lhs.high.addReportingOverflow(1 as High.Digit)
        return  (c || y) as Bool
    }
}
