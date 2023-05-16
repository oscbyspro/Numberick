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
// MARK: * NBK x Asymmetric
//*============================================================================*

@usableFromInline internal typealias X2<T> = (high: T, low: T.Magnitude) where T: NBKFixedWidthInteger

@usableFromInline internal typealias X3<T> = (high: T, mid: T.Magnitude, low: T.Magnitude) where T: NBKFixedWidthInteger

//*============================================================================*
// MARK: * NBK x Asymmetric x Comparisons
//*============================================================================*

extension NBKFixedWidthInteger where Self: NBKUnsignedInteger, Digit == UInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @_transparent @usableFromInline internal static func compare33(_ lhs: X3<Self>, to rhs: X3<Self>) -> Int {
        let a = lhs.high.compared(to: rhs.high); if !a.isZero { return a }
        let b = lhs.mid .compared(to: rhs.mid ); if !b.isZero { return b }
        return  lhs.low .compared(to: rhs.low )
    }
}

//*============================================================================*
// MARK: * NBK x Asymmetric x Multiplication
//*============================================================================*

extension NBKFixedWidthInteger where Self: NBKUnsignedInteger, Digit == UInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_transparent @usableFromInline internal static func multiplying21(_ lhs: X2<Self>, by rhs: Self) -> X3<Self> {
        let a = lhs.low .multipliedFullWidth(by: rhs)
        var b = lhs.high.multipliedFullWidth(by: rhs)
        
        let x =      b.low .addReportingOverflow(a.high)
        let _ = x && b.high.addReportingOverflow(1 as UInt)
        return X3(high: b.high, mid: b.low, low: a.low )
    }
}


//*============================================================================*
// MARK: * NBK x Asymmetric x Subtraction
//*============================================================================*

extension NBKFixedWidthInteger where Self: NBKUnsignedInteger, Digit == UInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_transparent @usableFromInline internal static func decrement32(_ lhs: inout X3<Self>, by rhs: X2<Self>) -> Bool {
        let a = lhs.low .subtractReportingOverflow(rhs.low )
        let b = lhs.mid .subtractReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .subtractReportingOverflow(1 as UInt)
        let y = (b || x) && lhs.high.subtractReportingOverflow(1 as UInt)
        return  (y) as Bool
    }
    
    @_transparent @usableFromInline internal static func decrement33(_ lhs: inout X3<Self>, by rhs: X3<Self>) -> Bool {
        let a = lhs.low .subtractReportingOverflow(rhs.low )
        let b = lhs.mid .subtractReportingOverflow(rhs.mid )
        let c = lhs.high.subtractReportingOverflow(rhs.high)
        
        let x = (a     ) && lhs.mid .subtractReportingOverflow(1 as UInt)
        let y = (b || x) && lhs.high.subtractReportingOverflow(1 as UInt)
        return  (c || y) as Bool
    }
}
