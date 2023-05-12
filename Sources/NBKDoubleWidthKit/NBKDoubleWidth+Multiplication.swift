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
    
    @inlinable public func multipliedReportingOverflow(by amount:  Self) -> PVO<Self> {
        let product = DoubleWidth(descending: self.multipliedFullWidth(by: amount))
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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func multiplyFullWidth(by amount: Self) -> Self {
        let product: HL<Self, Magnitude> = self.multipliedFullWidth(by: amount)
        self = Self(bitPattern: product.low)
        return product.high as Self
    }
    
    @inlinable public func multipliedFullWidth(by amount: Self) -> HL<Self, Magnitude> {
        let minus: Bool = self.isLessThanZero != amount.isLessThanZero
        let unsigned = DoubleWidth.Magnitude(descending: self.magnitude.multipliedFullWidth(by: amount.magnitude))
        return DoubleWidth(bitPattern: minus ? unsigned.twosComplement() : unsigned).descending
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func multiplyFullWidth(by amount: Self) -> Self {
        let product = self.multipliedFullWidth(by: amount)
        self = product.low  as Self
        return product.high as Self
    }
    
    @inlinable public func multipliedFullWidth(by  amount: Self) -> HL<Self, Magnitude> {
        //=--------------------------------------=
        let m0 = self.low .multipliedFullWidth(by: amount.low  ) as HL<Low, Low>
        let m1 = self.low .multipliedFullWidth(by: amount.high ) as HL<Low, Low>
        let m2 = self.high.multipliedFullWidth(by: amount.low  ) as HL<Low, Low>
        let m3 = self.high.multipliedFullWidth(by: amount.high ) as HL<Low, Low>
        //=--------------------------------------=
        let s0 = Low.sum(m0.high, m1.low,  m2.low) as HL<UInt, Low>
        let s1 = Low.sum(m1.high, m2.high, m3.low) as HL<UInt, Low>
        //=--------------------------------------=
        let r0 = Magnitude(descending: HL(s0.low,  m0.low))
        var r1 = Magnitude(descending: HL(m3.high, Low(digit: s0.high)))
        let o0 = r1.low .addReportingOverflow(s1.low) as Bool
        let o1 = r1.high.addReportingOverflow(s1.high &+ UInt(bit:  o0)) as Bool
        //=--------------------------------------=
        assert(s0.high < 3)
        assert(s1.high < 3)
        assert(o1 == false)
        //=--------------------------------------=
        return HL(high: r1, low: r0)
    }
}

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
        }}
        //=--------------------------------------=
        return HL(Digit(bitPattern: high), low)
    }
}
