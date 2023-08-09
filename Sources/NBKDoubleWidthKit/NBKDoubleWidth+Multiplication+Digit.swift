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
    // MARK: Transformations x Overflow
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func multiplyReportingOverflow(by other: Digit) -> Bool {
        let pvo: PVO<Self> = self.multipliedReportingOverflow(by: other)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @_disfavoredOverload @inlinable public func multipliedReportingOverflow(by other: Digit) -> PVO<Self> {
        let lhsIsLessThanZero: Bool = self .isLessThanZero
        let rhsIsLessThanZero: Bool = other.isLessThanZero
        let minus = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var pvo = NBK.bitCast(self.magnitude.multipliedReportingOverflow(by: other.magnitude, adding: UInt.zero)) as PVO<Self>
        //=--------------------------------------=
        var suboverflow = (pvo.partialValue.isLessThanZero)
        if  minus {
            suboverflow = !pvo.partialValue.formTwosComplementReportingOverflow() && suboverflow
        }

        pvo.overflow = pvo.overflow || suboverflow as Bool
        //=--------------------------------------=
        return pvo  as PVO<Self>
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
        let lhsIsLessThanZero: Bool = self .isLessThanZero
        let rhsIsLessThanZero: Bool = other.isLessThanZero
        var minus = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var product = self.magnitude.multipliedFullWidth(by: other.magnitude, adding: UInt.zero) as HL<UInt, Magnitude>
        //=--------------------------------------=
        if  minus {
            minus = product.low .formTwosComplementSubsequence(minus)
            minus = product.high.formTwosComplementSubsequence(minus)
        }
        //=--------------------------------------=
        return NBK.bitCast(product) as HL<Digit, Magnitude>
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Multiplication x Digit x Unsigned
//*============================================================================*

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func multiply(by other: Digit, add carry: Digit) {
        let overflow: Bool = self.multiplyReportingOverflow(by: other, add: carry)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }

    @_disfavoredOverload @inlinable public func multiplied(by other: Digit, adding carry: Digit) -> Self {
        let pvo: PVO<Self> = self.multipliedReportingOverflow(by: other, adding: carry)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as Self
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Overflow
    //=------------------------------------------------------------------------=

    @_disfavoredOverload @inlinable public mutating func multiplyReportingOverflow(by other: Digit, add carry: Digit) -> Bool {
        !self.multiplyFullWidth(by: other, add: carry).isZero
    }

    @_disfavoredOverload @inlinable public func multipliedReportingOverflow(by other: Digit, adding carry: Digit) -> PVO<Self> {
        var pvo = PVO(self, false)
        pvo.overflow = pvo.partialValue.multiplyReportingOverflow(by: other, add: carry)
        return pvo  as PVO<Self>
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=

    @_disfavoredOverload @inlinable public mutating func multiplyFullWidth(by other: Digit, add carry: Digit) -> Digit {
        NBK.multiplyFullWidthAsUnsigned(&self, by: other, add: carry)
    }
    
    @_disfavoredOverload @inlinable public func multipliedFullWidth(by other: Digit, adding carry: Digit) -> HL<Digit, Magnitude> {
        var product  = HL(UInt.zero, self)
        product.high = product.low.multiplyFullWidth(by: other, add: carry)
        return product as HL<Digit, Magnitude>
    }
}
