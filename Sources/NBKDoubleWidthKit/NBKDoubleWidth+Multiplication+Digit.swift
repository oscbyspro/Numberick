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
    
    @_disfavoredOverload @inlinable public mutating func multiplyReportingOverflow(by amount: Digit) -> Bool {
        let pvo: PVO<Self> = self.multipliedReportingOverflow(by: amount)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @_disfavoredOverload @inlinable public func multipliedReportingOverflow(by amount: Digit) -> PVO<Self> {
        let product: HL<Digit, Magnitude> = self.multipliedFullWidth(by: amount)
        //=--------------------------------------=
        let overflow: Bool
        if !Self.isSigned {
            // overflow = product > Self.max
            overflow = !(product.high.isZero)
        }   else if self.isLessThanZero == amount.isLessThanZero {
            // overflow = product > Self.max, but more efficient
            overflow = !(product.high.isZero && !product.low.mostSignificantBit)
        }   else {
            // overflow = product < Self.min, but more efficient
            overflow = !(product.high.isFull &&  product.low.mostSignificantBit) && product.high.mostSignificantBit
        }
        //=--------------------------------------=
        return PVO(Self(bitPattern: product.low), overflow)
    }
    
    @_disfavoredOverload @inlinable public mutating func multiplyFullWidth(by amount: Digit) -> Digit {
        let product: HL<Digit, Magnitude> = self.multipliedFullWidth(by: amount)
        self = Self(bitPattern: product.low)
        return product.high as  Digit
    }
    
    @_disfavoredOverload @inlinable public func multipliedFullWidth(by amount: Digit) -> HL<Digit, Magnitude> {
        var product: HL<UInt, Magnitude> = self.bitPattern.multipliedFullWidth(by: amount.bitPattern)
        //=--------------------------------------=
        if  amount.isLessThanZero {
            var high  = UInt()
            var carry = true
            
            for index in self.indices {
                let bit = (product.low[index]).addReportingOverflow(high)
                (high, carry) = (~self[index]).addingReportingOverflow(UInt(bit: bit) &+ UInt(bit: carry))
            }
            
            product.high &+= high
        }
        
        if  self.isLessThanZero {
            product.high &+= amount.bitPattern.twosComplement()
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
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public func multipliedFullWidth(by amount: Digit) -> HL<Digit, Magnitude> {
        var product = HL(Digit(), Magnitude())
        for index in self.indices {
            (product.high, product.low[index]) = product.high.addingFullWidth(multiplicands:(self[index], amount))
        }
        
        return product as HL<Digit, Magnitude>
    }
}
