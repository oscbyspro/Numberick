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
// MARK: * NBK x Double Width x Division x Digit
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func divideReportingOverflow(by other: Digit) -> Bool {
        let pvo: PVO<Self> = self.dividedReportingOverflow(by: other)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @_disfavoredOverload @inlinable public func dividedReportingOverflow(by other: Digit) -> PVO<Self> {
        let qro: PVO<QR<Self, Digit>> = self.quotientAndRemainderReportingOverflow(dividingBy: other)
        return   PVO(qro.partialValue.quotient, qro.overflow)
    }
    
    @_disfavoredOverload @inlinable public mutating func formRemainderReportingOverflow(dividingBy other: Digit) -> Bool {
        let pvo: PVO<Digit> = self.remainderReportingOverflow(dividingBy: other)
        self = Self(digit: pvo.partialValue)
        return pvo.overflow as Bool
    }
    
    @_disfavoredOverload @inlinable public func remainderReportingOverflow(dividingBy other: Digit) -> PVO<Digit> {
        let qro: PVO<QR<Self, Digit>> = self.quotientAndRemainderReportingOverflow(dividingBy: other)
        return   PVO(qro.partialValue.remainder, qro.overflow)
    }
    
    @_disfavoredOverload @inlinable public func quotientAndRemainderReportingOverflow(dividingBy other: Digit) -> PVO<QR<Self, Digit>> {
        let lhsIsLessThanZero: Bool = self .isLessThanZero
        let rhsIsLessThanZero: Bool = other.isLessThanZero
        //=--------------------------------------=
        var qro = self.magnitude.quotientAndRemainderReportingOverflow(dividingBy: other.magnitude)
        //=--------------------------------------=
        if  lhsIsLessThanZero != rhsIsLessThanZero {
            qro.partialValue.quotient.formTwosComplement()
        }
        
        if  lhsIsLessThanZero {
            qro.partialValue.remainder.formTwosComplement()
        }
        
        if  lhsIsLessThanZero, rhsIsLessThanZero, qro.partialValue.quotient.mostSignificantBit {
            qro.overflow = true
        }
        //=--------------------------------------=
        return PVO(QR(Self(bitPattern: qro.partialValue.quotient), Digit(bitPattern: qro.partialValue.remainder)), qro.overflow)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable func quotientAndRemainderReportingOverflow(dividingBy other: Digit) -> PVO<QR<Self, Digit>> {
        var quotient  = self
        let remainder = quotient.formQuotientWithRemainderReportingOverflow(dividingBy: other)
        return PVO(QR(quotient, remainder.partialValue), remainder.overflow)
    }
    
    @_disfavoredOverload @inlinable mutating func formQuotientWithRemainderReportingOverflow(dividingBy other: Digit) -> PVO<Digit> {
        //=--------------------------------------=
        if  other.isZero {
            return PVO(0, true)
        }
        //=--------------------------------------=
        var remainder = UInt()
        for index in self.indices.reversed() {
            (self[index], remainder) = other.dividingFullWidth(HL(remainder, self[index]))
        }
        
        return PVO(remainder, false)
    }
}
