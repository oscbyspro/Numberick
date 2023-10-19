//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Tuple Binary Integer x Subtraction x Unsigned
//*============================================================================*

extension NBK.TupleBinaryInteger where High: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the `difference` of `lhs` and `rhs`, and returns an `overflow` indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```
    /// ┌────────────┬─────── → ───────────┬──────────┐
    /// │ lhs        │ rhs    │ difference │ overflow │
    /// ├────────────┼─────── → ───────────┼──────────┤
    /// │  0,  0,  0 │ ~4, ~5 │ ~0,  4,  6 │ true     │
    /// │  1,  2,  3 │ ~4, ~5 │  0,  6,  9 │ false    │
    /// │ ~1, ~2, ~3 │  4,  5 │ ~1, ~6, ~8 │ false    │
    /// │ ~0, ~0, ~0 │  4,  5 │ ~0, ~4, ~5 │ false    │
    /// └────────────┴─────── → ───────────┴──────────┘
    /// ```
    ///
    @_transparent public static func decrement32B(_ lhs: inout Wide3, by rhs: Wide2) -> Bool {
        let a = lhs.low .subtractReportingOverflow(rhs.low )
        let b = lhs.mid .subtractReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .subtractReportingOverflow(1 as High.Digit)
        let y = (b || x) && lhs.high.subtractReportingOverflow(1 as High.Digit)
        return  (     y) as Bool
    }
    
    /// Forms the `difference` of `lhs` and `rhs`, and returns an `overflow` indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ difference │ overflow │
    /// ├────────────┼─────────── → ───────────┼──────────┤
    /// │  0,  0,  0 │ ~4, ~5, ~6 │  4,  5,  7 │ true     │
    /// │  1,  2,  3 │ ~4, ~5, ~6 │  5,  7, 10 │ true     │
    /// │ ~1, ~2, ~3 │  4,  5,  6 │ ~5, ~7, ~9 │ false    │
    /// │ ~0, ~0, ~0 │  4,  5,  6 │ ~4, ~5, ~6 │ false    │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    @_transparent public static func decrement33B(_ lhs: inout Wide3, by rhs: Wide3) -> Bool {
        let a = lhs.low .subtractReportingOverflow(rhs.low )
        let b = lhs.mid .subtractReportingOverflow(rhs.mid )
        let c = lhs.high.subtractReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .subtractReportingOverflow(1 as High.Digit)
        let y = (b || x) && lhs.high.subtractReportingOverflow(1 as High.Digit)
        return  (c || y) as Bool
    }
}
