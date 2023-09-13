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
// MARK: * NBK x Flexible Width x Division
//*============================================================================*

extension IntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func divideReportingOverflow(by other: Self) -> Bool {
        let pvo: PVO<Self> = self.dividedReportingOverflow(by: other)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @inlinable public func dividedReportingOverflow(by other: Self) -> PVO<Self> {
        let qro: PVO<QR<Self, Self>> = self.quotientAndRemainderReportingOverflow(dividingBy: other)
        return   PVO(qro.partialValue.quotient, qro.overflow)
    }
    
    @inlinable public mutating func formRemainderReportingOverflow(dividingBy other: Self) -> Bool {
        let pvo: PVO<Self> = self.remainderReportingOverflow(dividingBy: other)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @inlinable public func remainderReportingOverflow(dividingBy other: Self) -> PVO<Self> {
        let qro: PVO<QR<Self, Self>> = self.quotientAndRemainderReportingOverflow(dividingBy: other)
        return   PVO(qro.partialValue.remainder, qro.overflow)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Division x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func quotientAndRemainderReportingOverflow(dividingBy other: Self) -> PVO<QR<Self, Self>> {
        fatalError("TODO")
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Division x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public func quotientAndRemainderReportingOverflow(dividingBy other: Self) -> PVO<QR<Self, Self>> {
        self.quotientAndRemainderReportingOverflowAsNormal(dividingBy: other)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Normal
//=----------------------------------------------------------------------------=

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Private
    //=------------------------------------------------------------------------=
    
    @inlinable func quotientAndRemainderReportingOverflowAsNormal(dividingBy other: Self) -> PVO<QR<Self, Self>> {
        var (remainder) = self
        let (quotient, overflow) = remainder.formRemainderWithQuotientReportingOverflowAsNormal(dividingBy: other)
        return PVO(QR(quotient, remainder), overflow)
    }
    
    @inlinable mutating func formRemainderWithQuotientReportingOverflowAsNormal(dividingBy other: Self) -> PVO<Self> {
        fatalError("TODO")
    }
}
