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
    // MARK: Details x Complements
    //=------------------------------------------------------------------------=
    
    /// Returns the `magnitude` of the given `value`.
    ///
    /// ```
    /// ┌─────────────────── → ───────────────────┐
    /// │ value              │ magnitude          │
    /// ├─────────────────── → ───────────────────┤
    /// │ Int(-1), UInt.max  │ UInt( 0), UInt( 1) │
    /// │ Int( 0), UInt( 1)  │ UInt( 0), UInt( 1) │
    /// │ Int(-2), UInt( 1)  │ UInt( 1), UInt.max │
    /// │ Int( 1), UInt.max  │ UInt( 1), UInt.max │
    /// └─────────────────── → ───────────────────┘
    /// ```
    ///
    @_transparent public static func magnitude<T>(of value: Wide2<T>) -> Wide2<T.Magnitude> {
        var value = value as Wide2<T>
        if  value.high.isLessThanZero {
            var carry = true
            carry = value.low .formTwosComplementSubsequence(carry)
            carry = value.high.formTwosComplementSubsequence(carry)
        }
        
        return NBK.bitCast(value) as Wide2<T.Magnitude>
    }
    
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
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Division
    //=------------------------------------------------------------------------=
    
    /// Divides 3 halves by 2 normalized halves, assuming the quotient fits in 1 half.
    ///
    /// ### Approximation Adjustment
    ///
    /// The approximation needs at most two adjustments, but the while loop is faster.
    ///
    /// ### Notes
    ///
    /// Skipping the comparison does not make it faster. Try it out with this approach:
    ///
    /// ```swift
    /// if  NBK.decrement33B(&lhs, by: rhs, times: quotient) {
    ///     if  NBK.increment32B(&lhs, by: rhs) {
    ///         _ = quotient.subtractReportingOverflow(1 as T.Digit)
    ///     }   else {
    ///         _ = NBK.increment32B(&lhs, by: rhs)
    ///         _ = quotient.subtractReportingOverflow(2 as T.Digit)
    ///     }
    /// }
    /// ```
    ///
    /// - Returns: The `quotient` is returned and the `remainder` replaces the dividend.
    ///
    @_transparent public static func divide3212MSBUnchecked<T>(_ lhs: inout Wide3<T>, by rhs: Wide2<T>) -> T where T: NBKUnsignedInteger {
        assert(rhs.high.mostSignificantBit, "divisor must be normalized")
        assert(NBK.compare22S(rhs, to: HL(lhs.high, lhs.mid)) == 1, "quotient must fit in one half")
        //=--------------------------------------=
        var quotient = lhs.high == rhs.high ? T.max : rhs.high.dividingFullWidth(HL(lhs.high, lhs.mid)).quotient
        var approximation = NBK.multiplying213(rhs, by: quotient)
        //=--------------------------------------=
        // decrement when overestimated (max 2)
        //=--------------------------------------=
        while NBK.compare33S(lhs, to: approximation) == -1 {
            _ = quotient.subtractReportingOverflow(1 as T.Digit)
            _ = NBK.decrement32B(&approximation, by: rhs)
        }
        //=--------------------------------------=
        let _ = NBK.decrement33B(&lhs, by: approximation)
        return (quotient) as T
    }
}
