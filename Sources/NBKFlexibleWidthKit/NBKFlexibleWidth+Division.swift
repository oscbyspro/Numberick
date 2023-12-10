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
// MARK: * NBK x Flexible Width x Division x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Overflow
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
    
    @inlinable public func quotientAndRemainderReportingOverflow(dividingBy  other: Self) -> PVO<QR<Self, Self>> {
        self.quotientAndRemainderReportingOverflowUsingLongAlgorithm(dividingBy: other)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Long Division Algorithms
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Overflow x Private
    //=------------------------------------------------------------------------=
    
    /// Performs long division after some fast-path checks.
    @inlinable func quotientAndRemainderReportingOverflowUsingLongAlgorithm(dividingBy other: Self) -> PVO<QR<Self, Self>> {
        var (remainder) = self
        let (quotient, overflow) = remainder.formRemainderWithQuotientReportingOverflowUsingLongAlgorithm(dividingBy: other)
        return PVO(QR(quotient, remainder), overflow)
    }
    
    /// Performs long division after some fast-path checks.
    @inlinable mutating func formRemainderWithQuotientReportingOverflowUsingLongAlgorithm(dividingBy other: Self) -> PVO<Self> {
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  other.isZero {
            return PVO(self, true)
        }
        //=--------------------------------------=
        // divisor is one word
        //=--------------------------------------=
        if  other.count == Int.one {
            let (q, r)  = self.quotientAndRemainder(dividingBy: other.first)
            self.update(r)
            return PVO((q), false)
        }
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        let comparison = other.compared(to: self)
        if  comparison.isLessThanZero {
        }   else if comparison.isZero {
            self.update(UInt.zero)
            return PVO(Self.one,  false)
        }   else {
            return PVO(Self.zero, false)
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        self.storage.append(UInt.zero)
        
        var other: Self = other
        let shift: Int  = other.last.leadingZeroBitCount
        
        if !shift.isZero {
            self .storage.withUnsafeMutableBufferPointer({ NBK.SUI.bitShiftLeft(&$0, major: 0 as Int, minorAtLeastOne: shift) })
            other.storage.withUnsafeMutableBufferPointer({ NBK.SUI.bitShiftLeft(&$0, major: 0 as Int, minorAtLeastOne: shift) })
        }
        //=--------------------------------------=
        // division
        //=--------------------------------------=
        let quotient = Self.uninitialized(count: self.count - other.count) { quotient in
        self .storage.withUnsafeMutableBufferPointer { dividend in
        other.storage.withUnsafeBufferPointer/*---*/ { divisor  in
            NBK.SUI.initializeToQuotientFormRemainderByLongAlgorithm2111MSB(&quotient, dividing: &dividend, by: divisor)
        }}}
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        if !shift.isZero {
            self.storage.withUnsafeMutableBufferPointer({ NBK.SUI.bitShiftRight(&$0, major: 0 as Int, minorAtLeastOne: shift) })
        }
        
        self.storage.normalize()
        Swift.assert(quotient.storage.isNormal)
        //=--------------------------------------=
        return PVO(partialValue: quotient, overflow: false)
    }
}
