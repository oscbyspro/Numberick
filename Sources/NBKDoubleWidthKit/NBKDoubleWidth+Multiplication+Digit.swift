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
// MARK: * NBK x Double Width x Multiplication x Digit
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func multiplyReportingOverflow(by other: Digit) -> Bool {
        let pvo: PVO<Self> = self.multipliedReportingOverflow(by: other)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @_disfavoredOverload @inlinable public func multipliedReportingOverflow(by other: Digit) -> PVO<Self> {
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
    
    @_disfavoredOverload @inlinable public mutating func multiplyFullWidth(by other: Digit) -> Digit {
        let product = self.multipliedFullWidth(by: other) as HL<Digit, Magnitude>
        self = Self(bitPattern: product.low)
        return product.high as  Digit
    }
    
    @_disfavoredOverload @inlinable public func multipliedFullWidth(by other: Digit) -> HL<Digit, Magnitude> {
        var minus = self.isLessThanZero != other.isLessThanZero
        var product = self.magnitude.multipliedFullWidth(by: other.magnitude) as HL<UInt, Magnitude>
        //=--------------------------------------=
        if  minus {
            minus = product.low .formTwosComplementSubsequence(minus)
            minus = product.high.formTwosComplementSubsequence(minus)
        }
        //=--------------------------------------=
        return NBK.bitCast(product) as HL<Digit, Magnitude>
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable mutating func multiplyReportingOverflow(by other: Digit) -> Bool {
        !self.multiplyFullWidth(by: other).isZero
    }
    
    @_disfavoredOverload @inlinable func multipliedReportingOverflow(by other: Digit) -> PVO<Self> {
        var pvo = PVO(self, false)
        pvo.overflow = pvo.partialValue.multiplyReportingOverflow(by: other)
        return pvo as PVO<Self>
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable mutating func multiplyFullWidth(by other: Digit) -> Digit {
        var carry = UInt.zero
        
        for index in self.indices {
            var (high, low) = self[index].multipliedFullWidth(by: other)
            high &+= UInt(bit: low.addReportingOverflow(carry))
            (carry, self[index]) = (high, low) as HL<UInt, UInt>
        }
        
        return carry as Digit
    }
    
    @_disfavoredOverload @inlinable func multipliedFullWidth(by other: Digit) -> HL<Digit, Magnitude> {
        var product  = HL(UInt.zero, self)
        product.high = product.low.multiplyFullWidth(by: other)
        return product as HL<Digit, Magnitude>
    }
}
