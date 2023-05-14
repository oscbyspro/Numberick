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
        //=--------------------------------------=
        if  amount.isZero {
            return HL(Digit(), Magnitude())
        }
        //=--------------------------------------=
        let lhsIsLessThanZero: Bool =   self.isLessThanZero
        let rhsIsLessThanZero: Bool = amount.isLessThanZero
        //=--------------------------------------=
        var high = UInt()
        let low  = Magnitude.fromUnsafeMutableWords { low in
            self.withUnsafeWords { lhs in
                //=------------------------------=
                let rhsWord = UInt(bitPattern: amount)
                var rhsIsLessThanZeroCarry = rhsIsLessThanZero
                //=------------------------------=
                for index: Int in lhs.indices {
                    let lhsWord: UInt  = lhs[index]
                    (high, low[index]) = high.addingFullWidth(multiplicands:(lhsWord, rhsWord))
                    
                    if  rhsIsLessThanZero {
                        rhsIsLessThanZeroCarry = high.addReportingOverflow(~lhsWord, rhsIsLessThanZeroCarry)
                    }
                }
                //=------------------------------=
                high = lhsIsLessThanZero ? high &+ rhsWord.twosComplement() : high
            }
        }
        //=--------------------------------------=
        return HL(Digit(bitPattern: high), low)
    }
}
