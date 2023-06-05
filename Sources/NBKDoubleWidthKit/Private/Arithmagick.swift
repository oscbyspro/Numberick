//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

//*============================================================================*
// MARK: * NBK x Arithmagick x Int or UInt
//*============================================================================*

extension NBKCoreInteger<UInt> {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the quotient of dividing this value by its bit width.
    @_transparent @usableFromInline func quotientDividingByBitWidth() -> Self {
        self &>> Self(bitPattern: Self.bitWidth.trailingZeroBitCount)
    }
    
    /// Returns the remainder of dividing this value by its bit width.
    @_transparent @usableFromInline func remainderDividingByBitWidth() -> Self {
        self & Self(bitPattern: Self.bitWidth &- 1)
    }
    
    /// Returns the quotient and remainder of dividing this value by its bit width.
    @_transparent @usableFromInline func dividedByBitWidth() -> QR<Self, Self> {
        QR(self.quotientDividingByBitWidth(), self.remainderDividingByBitWidth())
    }
}

//*============================================================================*
// MARK: * NBK x Arithmagick x Tuples
//*============================================================================*

@usableFromInline typealias Wide2<T> = (high: T, low: T.Magnitude) where T: NBKFixedWidthInteger

@usableFromInline typealias Wide3<T> = (high: T, mid: T.Magnitude, low: T.Magnitude) where T: NBKFixedWidthInteger

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKFixedWidthInteger where Self: NBKUnsignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    /// A three-way comparison that returns: `-1` (less), `0` (same), or `1` (more).
    ///
    /// ```
    /// ┌─────────── → ───────┐
    /// │ lhs vs rhs │ signum │
    /// ├─────────── → ───────┤
    /// │ lhs <  rhs | -1     | - less
    /// │ lhs == rhs |  0     | - same
    /// │ lhs >  rhs |  1     | - more
    /// └─────────── → ───────┘
    /// ```
    ///
    @_transparent @usableFromInline static func compare33S(_ lhs: Wide3<Self>, to rhs: Wide3<Self>) -> Int {
        let a = lhs.high.compared(to: rhs.high)
        guard a.isZero else { return  a }
        
        let b = lhs.mid .compared(to: rhs.mid )
        guard b.isZero else { return  b }
        
        return  lhs.low .compared(to: rhs.low )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Subtraction
    //=------------------------------------------------------------------------=
    
    /// Forms the `difference` of subtracting `rhs` from `lhs`, and returns an `overflow` indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```
    /// ┌────────────┬─────── → ───────────┬──────────┐
    /// │ lhs        │ rhs    │ difference │ overflow │
    /// ├────────────┼────────┼────────────┼──────────┤
    /// │  0,  0,  0 │ ~0, ~0 │ ~0,  0,  1 │ true     │
    /// │  1,  2,  3 │  4,  5 │  0,  6,  9 │ false    │
    /// │ ~1, ~2, ~3 │ ~4, ~5 │ ~1, ~6, ~8 │ false    │
    /// │ ~0, ~0, ~0 │  0,  0 │ ~0, ~0, ~0 │ false    │
    /// └────────────┴─────── → ───────────┴──────────┘
    /// ```
    ///
    @_transparent @usableFromInline static func decrement32B(_ lhs: inout Wide3<Self>, by rhs: Wide2<Self>) -> Bool {
        let a = lhs.low .subtractReportingOverflow(rhs.low )
        let b = lhs.mid .subtractReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .subtractReportingOverflow(1 as Digit)
        let y = (b || x) && lhs.high.subtractReportingOverflow(1 as Digit)
        return  (     y) as Bool
    }
    
    /// Forms the `difference` of subtracting `rhs` from `lhs`, and returns an `overflow` indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ difference │ overflow │
    /// ├────────────┼────────────┼────────────┼──────────┤
    /// │  0,  0,  0 │ ~0, ~0, ~0 │  0,  0,  1 │ true     │
    /// │  1,  2,  3 │ ~4, ~5, ~6 │  5,  7, 10 │ true     │
    /// │ ~1, ~2, ~3 │  4,  5,  6 │ ~5, ~7, ~9 │ false    │
    /// │ ~0, ~0, ~0 │  0,  0,  0 │ ~0, ~0, ~0 │ false    │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    @_transparent @usableFromInline static func decrement33B(_ lhs: inout Wide3<Self>, by rhs: Wide3<Self>) -> Bool {
        let a = lhs.low .subtractReportingOverflow(rhs.low )
        let b = lhs.mid .subtractReportingOverflow(rhs.mid )
        let c = lhs.high.subtractReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .subtractReportingOverflow(1 as Digit)
        let y = (b || x) && lhs.high.subtractReportingOverflow(1 as Digit)
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
    /// ├────────┼─────┼────────────┤
    /// │  1,  2 │  3, │  0,  3,  6 │
    /// │ ~1, ~2 │ ~3, │ ~4,  1, 12 │
    /// │ ~0, ~0 │ ~0, │ ~1, ~0,  1 │
    /// └────────┴──── → ───────────┘
    /// ```
    ///
    @_transparent @usableFromInline static func multiplying213(_ lhs: Wide2<Self>, by rhs: Self) -> Wide3<Self> {
        let a = lhs.low .multipliedFullWidth(by: rhs)
        var b = lhs.high.multipliedFullWidth(by: rhs)
                
        let x = b.low.addReportingOverflow(a.high)
        let _ = x && b.high.addReportingOverflow(1 as Digit)
        return  Wide3(high: b.high, mid: b.low, low: a.low)
    }
}
