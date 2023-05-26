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
// MARK: * NBK x Arithmetic x Int or UInt
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
// MARK: * NBK x Arithmetic x Tuples
//*============================================================================*

@usableFromInline typealias Each2<T> = (first: T, second: T) where T: NBKFixedWidthInteger

@usableFromInline typealias Each3<T> = (first: T, second: T, third: T) where T: NBKFixedWidthInteger

@usableFromInline typealias Wide2<T> = (high: T, low: T.Magnitude) where T: NBKFixedWidthInteger

@usableFromInline typealias Wide3<T> = (high: T, mid: T.Magnitude, low: T.Magnitude) where T: NBKFixedWidthInteger

extension NBKFixedWidthInteger where Self: NBKUnsignedInteger, Digit == UInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    @_transparent @usableFromInline static func increment12(_ lhs: inout Self, by rhs: Each2<Self>) -> UInt {
        let o0 = lhs.addReportingOverflow(rhs.first )
        let o1 = lhs.addReportingOverflow(rhs.second)
        return UInt(bit: o0) &+ UInt(bit: o1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    @_transparent @usableFromInline static func compare33(_ lhs: Wide3<Self>, to rhs: Wide3<Self>) -> Int {
        let a = lhs.high.compared(to: rhs.high); if !a.isZero { return a }
        let b = lhs.mid .compared(to: rhs.mid ); if !b.isZero { return b }
        return  lhs.low .compared(to: rhs.low )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    #warning("TEST: code coverage")
    @_transparent @usableFromInline static func multiplying21(_ lhs: Wide2<Self>, by rhs: Self) -> Wide3<Self> {
        let a = lhs.low .multipliedFullWidth(by: rhs)
        var b = lhs.high.multipliedFullWidth(by: rhs)
        
        let x =      b.low .addReportingOverflow(a.high)
        let _ = x && b.high.addReportingOverflow(1 as UInt)
        return Wide3(high: b.high, mid: b.low, low: a.low)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Subtraction
    //=------------------------------------------------------------------------=
    
    @_transparent @usableFromInline static func decrement32(_ lhs: inout Wide3<Self>, by rhs: Wide2<Self>) -> Bool {
        let a = lhs.low .subtractReportingOverflow(rhs.low )
        let b = lhs.mid .subtractReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .subtractReportingOverflow(1 as UInt)
        let y = (b || x) && lhs.high.subtractReportingOverflow(1 as UInt)
        return  (     y) as Bool
    }
    
    @_transparent @usableFromInline static func decrement33(_ lhs: inout Wide3<Self>, by rhs: Wide3<Self>) -> Bool {
        let a = lhs.low .subtractReportingOverflow(rhs.low )
        let b = lhs.mid .subtractReportingOverflow(rhs.mid )
        let c = lhs.high.subtractReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .subtractReportingOverflow(1 as UInt)
        let y = (b || x) && lhs.high.subtractReportingOverflow(1 as UInt)
        return  (c || y) as Bool
    }
}
