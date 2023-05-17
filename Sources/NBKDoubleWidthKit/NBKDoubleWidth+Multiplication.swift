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
    
    @inlinable public mutating func multiplyReportingOverflow(by  amount: Self) -> Bool {
        let pvo: PVO<Self> = self.multipliedReportingOverflow(by: amount)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @inlinable public func multipliedReportingOverflow(by amount: Self) -> PVO<Self> {
        let minus: Bool = self.isLessThanZero != amount.isLessThanZero
        let unsigned: PVO<Magnitude> = self.magnitude.multipliedReportingOverflow(by: amount.magnitude)
        let product = Self(bitPattern: minus ? unsigned.partialValue.twosComplement() : unsigned.partialValue)
        return PVO(product, unsigned.overflow || (minus ? product.isMoreThanZero : product.isLessThanZero))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func multiplyFullWidth(by amount: Self) -> Self {
        let product: HL<Self, Magnitude> = self.multipliedFullWidth(by: amount)
        self = Self(bitPattern: product.low)
        return product.high as Self
    }
    
    @inlinable public func multipliedFullWidth(by amount: Self) -> HL<Self, Magnitude> {
        let minus = self.isLessThanZero != amount.isLessThanZero
        var product = DoubleWidth.Magnitude(descending: self.magnitude.multipliedFullWidth(by: amount.magnitude))
        if  minus { product.formTwosComplement() }
        return HL(Self(bitPattern: product.high), product.low)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable internal func multipliedReportingOverflow(by amount: Self) -> PVO<Self> {
        var lo = self.low .multipliedFullWidth(by: amount.low)
        let ay = self.low .multipliedReportingOverflow(by: amount.high )
        let bx = self.high.multipliedReportingOverflow(by: amount.low  )
        
        let o0 = lo.high.addReportingOverflow(ay.partialValue)
        let o1 = lo.high.addReportingOverflow(bx.partialValue)
        
        let complete = !self.high.isZero && !amount.high.isZero
        let overflow =  complete || ay.overflow || bx.overflow || o0 || o1
        return PVO(Self(descending: lo), overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    /// An adaptation of Anatoly Karatsuba's multiplication algorithm.
    @inlinable internal func multipliedFullWidth(by amount: Self) -> HL<Self, Magnitude> {
        var lo = Self(descending: self.low .multipliedFullWidth(by: amount.low ))
        let ay = Self(descending: self.low .multipliedFullWidth(by: amount.high))
        let bx = Self(descending: self.high.multipliedFullWidth(by: amount.low ))
        var hi = Self(descending: self.high.multipliedFullWidth(by: amount.high))
        
        let _  = hi/*-*/.addReportingOverflow(Low.increment12(&lo.high, by: Each2(ay.low,  bx.low )))
        let _  = hi.high.addReportingOverflow(Low.increment12(&hi.low,  by: Each2(ay.high, bx.high)))
        return HL(high: hi, low: lo)
    }
}
