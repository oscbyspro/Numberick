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
        let minus: Bool = self.isLessThanZero != other.isLessThanZero
        let unsigned: PVO<Magnitude> = self.magnitude.multipliedReportingOverflow(by: other.magnitude)
        let product = Self(bitPattern: minus ? unsigned.partialValue.twosComplement() : unsigned.partialValue)
        return PVO(product, unsigned.overflow || (minus ? product.isMoreThanZero : product.isLessThanZero))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func multiplyFullWidth(by other: Digit) -> Digit {
        let product: HL<Digit, Magnitude> = self.multipliedFullWidth(by: other)
        self = Self(bitPattern: product.low)
        return product.high as  Digit
    }
    
    @_disfavoredOverload @inlinable public func multipliedFullWidth(by other: Digit) -> HL<Digit, Magnitude> {
        var product: HL<UInt, Magnitude> = Magnitude(bitPattern: self).multipliedFullWidth(by: UInt(bitPattern: other))
        //=--------------------------------------=
        if  self.isLessThanZero {
            product.high &+= UInt(bitPattern: other).twosComplement()
        }
        
        if  other.isLessThanZero {
            var (high, carry) = self.first.twosComplementSubsequence(true)
            
            for index in self.indices.dropFirst() {
                let bit = product.low[index].addReportingOverflow(high)
                
                high  = self[index]
                carry = high.formTwosComplementSubsequence(carry)
                carry = high.addReportingOverflow(UInt(bit: bit)) || carry
            }
            
            product.high &+= high
        }
        //=--------------------------------------=
        return HL(Digit(bitPattern: product.high), product.low)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable func multipliedReportingOverflow(by other: Digit) -> PVO<Self> {
        let product: HL<Digit, Magnitude> = self.multipliedFullWidth(by: other)
        return PVO(partialValue: product.low, overflow: !product.high.isZero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable mutating func multiplyFullWidth(by other: Digit) -> Digit {
        var high = UInt.zero
        
        for index in self.indices {
            var xy = self[index].multipliedFullWidth(by: other)
            xy.high &+= UInt(bit: xy.low.addReportingOverflow(high))
            (high,   self[index]) = xy as HL<UInt, UInt>
        }
        
        return high as Digit
    }
    
    @_disfavoredOverload @inlinable func multipliedFullWidth(by other: Digit) -> HL<Digit, Magnitude> {
        var product  = HL(UInt.zero, self)
        product.high = product.low.multiplyFullWidth(by: other)
        return product as HL<Digit, Magnitude>
    }
}
