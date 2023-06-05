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
        let minus: Bool = self.isLessThanZero != other.isLessThanZero
        let unsigned: PVO<Magnitude> = self.magnitude.multipliedReportingOverflow(by: other.magnitude)
        let product = Self(bitPattern: minus ? unsigned.partialValue.twosComplement() : unsigned.partialValue)
        return PVO(product, unsigned.overflow || (minus ? product.isMoreThanZero : product.isLessThanZero))
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
        let minus = self.isLessThanZero != other.isLessThanZero
        var product = DoubleWidth.Magnitude(descending: self.magnitude.multipliedFullWidth(by: other.magnitude))
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
    
    /// An adaptation of Anatoly Karatsuba's multiplication algorithm.
    @inlinable func multipliedReportingOverflow(by other: Self) -> PVO<Self> {
        var lo = self.low .multipliedFullWidth(by: other.low)
        let ay = self.low .multipliedReportingOverflow(by: other.high)
        let bx = self.high.multipliedReportingOverflow(by: other.low )
        
        let o0 = lo.high.addReportingOverflow(ay.partialValue)
        let o1 = lo.high.addReportingOverflow(bx.partialValue)
        
        let complete = !self.high.isZero && !other.high.isZero
        let overflow =  complete || ay.overflow || bx.overflow || o0 || o1
        return PVO(Self(descending: lo), overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    /// An adaptation of Anatoly Karatsuba's multiplication algorithm.
    @inlinable func multipliedFullWidth(by other: Self) -> HL<Self, Magnitude> {
        var lo = Self(descending: self.low .multipliedFullWidth(by: other.low ))
        let ay = Self(descending: self.low .multipliedFullWidth(by: other.high))
        let bx = Self(descending: self.high.multipliedFullWidth(by: other.low ))
        var hi = Self(descending: self.high.multipliedFullWidth(by: other.high))
        //=--------------------------------------=
        let o0 = lo.high.addReportingOverflow(ay.low )
        let o1 = lo.high.addReportingOverflow(bx.low )
        let _  = hi/*-*/.addReportingOverflow(UInt(bit: o0) &+ UInt(bit: o1))
        
        let o2 = hi.low .addReportingOverflow(ay.high)
        let o3 = hi.low .addReportingOverflow(bx.high)
        let _  = hi.high.addReportingOverflow(UInt(bit: o2) &+ UInt(bit: o3))
        //=--------------------------------------=
        return HL(high: hi, low: lo)
    }
}
