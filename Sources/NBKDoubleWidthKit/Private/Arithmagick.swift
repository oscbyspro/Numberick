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
// MARK: * NBK x Arithmagick x Binary Integer
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns `self` modulo `other.bitWidth`.
    @inlinable func moduloBitWidth<T>(of other: T.Type) -> Int where T: FixedWidthInteger {
        Int(bitPattern: self.modulo(UInt(bitPattern: other.bitWidth)))
    }
    
    /// Returns `self` modulo `modulus`.
    @inlinable func modulo(_ modulus: UInt) -> UInt {
        //=--------------------------------------=
        if  modulus.isPowerOf2 {
            return self._lowWord & (modulus &- 1)
        }
        //=--------------------------------------=
        let minus = Self.isSigned && self < (0 as Self)
        var residue = (0 as UInt)
        
        for word in self.magnitude.words.reversed() {
            residue = modulus.dividingFullWidth(HL(residue, word)).remainder
        }
        
        return (minus && !residue.isZero) ? (modulus &- residue) : (residue)
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
    /// ┌─────────── → ────────┐
    /// │ lhs vs rhs │ signum  │
    /// ├─────────── → ────────┤
    /// │ lhs <  rhs | Int(-1) | - less
    /// │ lhs == rhs | Int( 0) | - same
    /// │ lhs >  rhs | Int( 1) | - more
    /// └─────────── → ────────┘
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
    @_transparent @usableFromInline static func increment32B(_ lhs: inout Wide3<Self>, by rhs: Wide2<Self>) -> Bool {
        let a = lhs.low .addReportingOverflow(rhs.low )
        let b = lhs.mid .addReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .addReportingOverflow(1 as Digit)
        let y = (b || x) && lhs.high.addReportingOverflow(1 as Digit)
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
    @_transparent @usableFromInline static func increment33B(_ lhs: inout Wide3<Self>, by rhs: Wide3<Self>) -> Bool {
        let a = lhs.low .addReportingOverflow(rhs.low )
        let b = lhs.mid .addReportingOverflow(rhs.mid )
        let c = lhs.high.addReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .addReportingOverflow(1 as Digit)
        let y = (b || x) && lhs.high.addReportingOverflow(1 as Digit)
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
    @_transparent @usableFromInline static func decrement32B(_ lhs: inout Wide3<Self>, by rhs: Wide2<Self>) -> Bool {
        let a = lhs.low .subtractReportingOverflow(rhs.low )
        let b = lhs.mid .subtractReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .subtractReportingOverflow(1 as Digit)
        let y = (b || x) && lhs.high.subtractReportingOverflow(1 as Digit)
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
    /// ├────────┼──── → ───────────┤
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
