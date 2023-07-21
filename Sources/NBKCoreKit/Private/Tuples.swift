//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Tuples x Unsigned
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison that returns: `-1` (less), `0` (same), or `1` (more).
    ///
    /// ```
    /// ┌─────────── → ────────┐
    /// │ lhs vs rhs │ signum  │
    /// ├─────────── → ────────┤
    /// │ lhs <  rhs | Int(-1) | - less
    /// │ lhs == rhs | Int( 0) | - same
    /// │ lhs >  rhs | Int( 1) | - more
    /// └─────────── → ────────┘
    /// ```
    ///
    @_transparent public static func compare22S<T>(_ lhs: Wide2<T>, to rhs: Wide2<T>) -> Int {
        let a = lhs.high.compared(to: rhs.high); if !a.isZero { return a }
        return  lhs.low .compared(to: rhs.low );
    }
    
    /// A three-way comparison that returns: `-1` (less), `0` (same), or `1` (more).
    ///
    /// ```
    /// ┌─────────── → ────────┐
    /// │ lhs vs rhs │ signum  │
    /// ├─────────── → ────────┤
    /// │ lhs <  rhs | Int(-1) | - less
    /// │ lhs == rhs | Int( 0) | - same
    /// │ lhs >  rhs | Int( 1) | - more
    /// └─────────── → ────────┘
    /// ```
    ///
    @_transparent public static func compare33S<T>(_ lhs: Wide3<T>, to rhs: Wide3<T>) -> Int {
        let a = lhs.high.compared(to: rhs.high); if !a.isZero { return a }
        let b = lhs.mid .compared(to: rhs.mid ); if !b.isZero { return b }
        return  lhs.low .compared(to: rhs.low );
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
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
    @_transparent public static func increment32B<T>(_ lhs: inout Wide3<T>, by rhs: Wide2<T>) -> Bool where T: NBKUnsignedInteger {
        let a = lhs.low .addReportingOverflow(rhs.low )
        let b = lhs.mid .addReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .addReportingOverflow(1 as T.Digit)
        let y = (b || x) && lhs.high.addReportingOverflow(1 as T.Digit)
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
    @_transparent public static func increment33B<T>(_ lhs: inout Wide3<T>, by rhs: Wide3<T>) -> Bool where T: NBKUnsignedInteger {
        let a = lhs.low .addReportingOverflow(rhs.low )
        let b = lhs.mid .addReportingOverflow(rhs.mid )
        let c = lhs.high.addReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .addReportingOverflow(1 as T.Digit)
        let y = (b || x) && lhs.high.addReportingOverflow(1 as T.Digit)
        return  (c || y) as Bool
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Subtraction
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
    @_transparent public static func decrement32B<T>(_ lhs: inout Wide3<T>, by rhs: Wide2<T>) -> Bool where T: NBKUnsignedInteger {
        let a = lhs.low .subtractReportingOverflow(rhs.low )
        let b = lhs.mid .subtractReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .subtractReportingOverflow(1 as T.Digit)
        let y = (b || x) && lhs.high.subtractReportingOverflow(1 as T.Digit)
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
    @_transparent public static func decrement33B<T>(_ lhs: inout Wide3<T>, by rhs: Wide3<T>) -> Bool where T: NBKUnsignedInteger {
        let a = lhs.low .subtractReportingOverflow(rhs.low )
        let b = lhs.mid .subtractReportingOverflow(rhs.mid )
        let c = lhs.high.subtractReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .subtractReportingOverflow(1 as T.Digit)
        let y = (b || x) && lhs.high.subtractReportingOverflow(1 as T.Digit)
        return  (c || y) as Bool
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    /// Returns the `product` of multiplying `lhs` by `rhs`.
    ///
    /// ```
    /// ┌────────┬──── → ───────────┐
    /// │ lhs    │ rhs │ product    │
    /// ├────────┼──── → ───────────┤
    /// │  1,  2 │  3, │  0,  3,  6 │
    /// │ ~1, ~2 │ ~3, │ ~4,  1, 12 │
    /// │ ~0, ~0 │ ~0, │ ~1, ~0,  1 │
    /// └────────┴──── → ───────────┘
    /// ```
    ///
    @_transparent public static func multiplying213<T>(_ lhs: Wide2<T>, by rhs: T) -> Wide3<T> where T: NBKUnsignedInteger {
        let a = lhs.low .multipliedFullWidth(by: rhs)
        var b = lhs.high.multipliedFullWidth(by: rhs)
                
        let x = b.low.addReportingOverflow(a.high)
        let _ = x && b.high.addReportingOverflow(1 as T.Digit)
        return Wide3(high: b.high, mid: b.low, low: a.low)
    }
}
