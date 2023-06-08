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
        let minus = self.isLessThanZero != other.isLessThanZero
        var pvo = NBK.bitCast(self.magnitude.multipliedReportingOverflow(by: other.magnitude)) as PVO<Self>
        //=--------------------------------------=
        var suboverflow = (pvo.partialValue.isLessThanZero)
        if  minus {
            suboverflow = !pvo.partialValue.formTwosComplementSubsequence(true) && suboverflow
        }
        
        pvo.overflow = (pvo.overflow || suboverflow) as Bool
        //=--------------------------------------=
        return pvo as PVO<Self>
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func multiplyFullWidth(by other: Self) -> Self {
        let product: HL<Self, Magnitude> = self.multipliedFullWidth(by: other)
        self = Self(bitPattern: product.low)
        return product.high as Self
    }
    
    @inlinable public func multipliedFullWidth(by other: Self) -> HL<Self, Magnitude> {
        var minus = self.isLessThanZero != other.isLessThanZero
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
        var lo = self.low .multipliedFullWidth(by: other.low)
        let ay = self.low .multipliedReportingOverflow(by: other.high)
        let bx = self.high.multipliedReportingOverflow(by: other.low )
        //=--------------------------------------=
        let o0 = lo.high.addReportingOverflow(ay.partialValue) as Bool
        let o1 = lo.high.addReportingOverflow(bx.partialValue) as Bool
        //=--------------------------------------=
        let overflow = !(self.high.isZero || other.high.isZero) || ay.overflow || bx.overflow || o0 || o1
        //=--------------------------------------=
        return PVO(Self(descending: lo), overflow)
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
        var m0 = self.low .multipliedFullWidth(by: other.low ) as HL<High, Low>
        let m1 = self.low .multipliedFullWidth(by: other.high) as HL<High, Low>
        let m2 = self.high.multipliedFullWidth(by: other.low ) as HL<High, Low>
        var m3 = self.high.multipliedFullWidth(by: other.high) as HL<High, Low>
        //=--------------------------------------=
        let a0 = m0.high.addReportingOverflow(m1.low) as Bool
        let a1 = m0.high.addReportingOverflow(m2.low) as Bool
        let a2 = UInt(bit: a0) &+ UInt(bit: a1)
        
        let b0 = m3.low.addReportingOverflow(m1.high) as Bool
        let b1 = m3.low.addReportingOverflow(m2.high) as Bool
        let b2 = UInt(bit: b0) &+ UInt(bit: b1)
        //=--------------------------------------=
        let lo = Magnitude(descending: m0)
        var hi = Magnitude(descending: m3)
        
        let o0 = hi.low .addReportingOverflow(a2) as Bool
        let _  = hi.high.addReportingOverflow(b2  &+ UInt(bit: o0)) as Bool
        
        return HL<Self, Magnitude>(high: hi, low: lo)
    }
}
