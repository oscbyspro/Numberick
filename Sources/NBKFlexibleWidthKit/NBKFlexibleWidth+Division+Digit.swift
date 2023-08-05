//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKResizableWidthKit

//*============================================================================*
// MARK: * NBK x Flexible Width x Division x Digit x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
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
        let otherSign = Sign(other.isLessThanZero)
        let qro: PVO<QR<Magnitude, Magnitude.Digit>> = self.magnitude.quotientAndRemainderReportingOverflow(dividingBy: other.magnitude)
        let quotient  = Self(sign: self.sign ^   otherSign, magnitude: qro.partialValue.quotient )
        let remainder = Self.Digit.exactly(sign: self.sign, magnitude: qro.partialValue.remainder)!
        return PVO(QR(quotient, remainder), qro.overflow)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Division x Digit x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
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
        var quotient  = self
        let remainder = quotient.formQuotientWithRemainderReportingOverflow(dividingBy: other)
        return PVO(QR(quotient, remainder.partialValue), remainder.overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Private
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable mutating func formQuotientWithRemainderReportingOverflow(dividingBy other: Digit) -> PVO<Digit> {
        defer {
            Swift.assert(self.storage.isNormal)
        }
        //=--------------------------------------=
        if  other.isZero {
            return NBK.bitCast(PVO(self.storage.first, true))
        }
        //=--------------------------------------=
        var remainder = UInt.zero
        
        for index in self.storage.indices.reversed() {
            (self.storage[index], remainder) = other.dividingFullWidth(HL(remainder, self.storage[index]))
        }
        
        self.storage.normalize()
        return PVO(remainder, false)
    }
}
