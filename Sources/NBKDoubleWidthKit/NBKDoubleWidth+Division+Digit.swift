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
    // MARK: Transformations x Overflow
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
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Overflow
    //=------------------------------------------------------------------------=
    
    /// Forms the `quotient` of dividing `self` by `other`, and returns
    /// the `remainder` along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    3) │ Int256( 2) │ Int(    0) │ false    │
    /// │ Int256( 7) │ Int(   -3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(    3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(   -3) │ Int256( 2) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    0) │ Int256( 7) │ Int(    7) │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.min │ Int(    0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is either truncated or,
    /// if undefined, the `self` and `self.first`.
    ///
    @_disfavoredOverload @inlinable public mutating func formQuotientWithRemainderReportingOverflow(dividingBy other: Digit) -> PVO<Digit> {
        NBK.bitCast(NBK.SBI.formQuotientWithRemainderReportingOverflow(dividing: &self, by: UInt(bitPattern: other), signedness: Digit.self))
    }
}
