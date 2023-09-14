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
// MARK: * NBK x Flexible Width x Division x Digit
//*============================================================================*

extension IntXLOrUIntXL {
    
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
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Division x Digit x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public func quotientAndRemainderReportingOverflow(dividingBy other: Digit) -> PVO<QR<Self, Digit>> {
        let lhsSign = FloatingPointSign(self .isLessThanZero)
        let rhsSign = FloatingPointSign(other.isLessThanZero)
        
        let qro: PVO<QR<Magnitude, Magnitude.Digit>> = self.magnitude.quotientAndRemainderReportingOverflow(dividingBy: other.magnitude)
        
        let quotient  = Self(sign: rhsSign  ^ lhsSign, magnitude: qro.partialValue.quotient )
        let remainder = Self.Digit.init(sign: lhsSign, magnitude: qro.partialValue.remainder)!
        return PVO(QR(quotient, remainder), qro.overflow)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Division x Digit x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public func quotientAndRemainderReportingOverflow(dividingBy other: Digit) -> PVO<QR<Self, Digit>> {
        var quotient  = self
        let remainder = quotient.formQuotientWithRemainderReportingOverflow(dividingBy: other)
        return PVO(QR(quotient, remainder.partialValue), remainder.overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Private
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func formQuotientWithRemainderReportingOverflow(dividingBy other: Digit) -> PVO<Digit> {
        defer{ self.storage.normalize() }
        return NBK.formQuotientWithRemainderReportingOverflowAsLenientUnsignedInteger(of: &self.storage.elements, dividingBy: other)
    }
}
