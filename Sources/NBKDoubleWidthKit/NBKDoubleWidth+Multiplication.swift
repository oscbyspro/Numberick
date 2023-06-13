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
// MARK: * NBK x Double Width x Multiplication
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func multiplyReportingOverflow(by  other: Self) -> Bool {
        let pvo: PVO<Self> = self.multipliedReportingOverflow(by: other)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @inlinable public func multipliedReportingOverflow(by other: Self) -> PVO<Self> {
        let lhsIsLessThanZero: Bool = self .isLessThanZero
        let rhsIsLessThanZero: Bool = other.isLessThanZero
        let minus = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var pvo = NBK.bitCast(self.magnitude.multipliedReportingOverflow(by: other.magnitude)) as PVO<Self>
        //=--------------------------------------=
        var suboverflow = (pvo.partialValue.isLessThanZero)
        if  minus {
            suboverflow = !pvo.partialValue.formTwosComplementSubsequence(true) && suboverflow
        }
        
        pvo.overflow = pvo.overflow || suboverflow as Bool
        //=--------------------------------------=
        return pvo  as PVO<Self>
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func multiplyFullWidth(by other: Self) -> Self {
        let product = self.multipliedFullWidth(by: other) as HL<Self, Magnitude>
        self = Self(bitPattern: product.low)
        return product.high as Self
    }
    
    @inlinable public func multipliedFullWidth(by other: Self) -> HL<Self, Magnitude> {
        let lhsIsLessThanZero: Bool = self .isLessThanZero
        let rhsIsLessThanZero: Bool = other.isLessThanZero
        var minus = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var product = self.magnitude.multipliedFullWidth(by: other.magnitude)
        //=--------------------------------------=
        if  minus {
            minus = product.low .formTwosComplementSubsequence(minus)
            minus = product.high.formTwosComplementSubsequence(minus)
        }
        //=--------------------------------------=
        return NBK.bitCast(product) as HL<Self, Magnitude>
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// An adaptation of Anatoly Karatsuba's multiplication algorithm.
    @inlinable func multipliedReportingOverflow(by other: Self) -> PVO<Self> {
        var ax = self.low .multipliedFullWidth(by: other.low)
        let ay = self.low .multipliedReportingOverflow(by: other.high)
        let bx = self.high.multipliedReportingOverflow(by: other.low )
        let by = !(self.high.isZero || other.high.isZero)
        //=--------------------------------------=
        let o0 = ax.high.addReportingOverflow(ay.partialValue) as Bool
        let o1 = ax.high.addReportingOverflow(bx.partialValue) as Bool
        //=--------------------------------------=
        let overflow = by || ay.overflow || bx.overflow || o0 || o1
        //=--------------------------------------=
        return PVO(Self(descending: ax), overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    /// An adaptation of Anatoly Karatsuba's multiplication algorithm.
    ///
    /// ### Order of operations
    ///
    /// The order of operations matters a lot, so don't reorder it without a profiler.
    ///
    @inlinable func multipliedFullWidth(by  other: Self) -> HL<Self, Magnitude> {
        var ax = self.low .multipliedFullWidth(by: other.low ) as HL<High, Low>
        let ay = self.low .multipliedFullWidth(by: other.high) as HL<High, Low>
        let bx = self.high.multipliedFullWidth(by: other.low ) as HL<High, Low>
        var by = self.high.multipliedFullWidth(by: other.high) as HL<High, Low>
        //=--------------------------------------=
        let a0 = ax.high.addReportingOverflow(ay.low) as Bool
        let a1 = ax.high.addReportingOverflow(bx.low) as Bool
        let a2 = UInt(bit: a0) &+ UInt(bit: a1)
        
        let b0 = by.low.addReportingOverflow(ay.high) as Bool
        let b1 = by.low.addReportingOverflow(bx.high) as Bool
        let b2 = UInt(bit: b0) &+ UInt(bit: b1)
        //=--------------------------------------=
        let lo = Magnitude(descending: ax)
        var hi = Magnitude(descending: by)
        
        let o0 = hi.low .addReportingOverflow(a2) as Bool
        let _  = hi.high.addReportingOverflow(b2  &+ UInt(bit: o0)) as Bool
        return HL(high: hi, low: lo)
    }
}
