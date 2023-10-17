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
    
    @inlinable public func quotientAndRemainderReportingOverflow(dividingBy  other: Self) -> PVO<QR<Self, Self>> {
        self.quotientAndRemainderReportingOverflowByLongDivision(dividingBy: other)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Normal
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Private
    //=------------------------------------------------------------------------=
    
    /// Performs long division after some fast-path checks.
    @inlinable func quotientAndRemainderReportingOverflowByLongDivision(dividingBy other: Self) -> PVO<QR<Self, Self>> {
        var (remainder) = self
        let (quotient, overflow) = remainder.formRemainderWithQuotientReportingOverflowByLongDivision(dividingBy: other)
        return PVO(QR(quotient, remainder), overflow)
    }
    
    /// Performs long division after some fast-path checks.
    @inlinable mutating func formRemainderWithQuotientReportingOverflowByLongDivision(dividingBy other: Self) -> PVO<Self> {
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  other.isZero {
            return PVO(self, true)
        }
        //=--------------------------------------=
        // divisor is one word
        //=--------------------------------------=
        if  other.count == 1 {
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
            self.updateZeroValue()
            return PVO(Self.one,  false)
        }   else {
            return PVO(Self.zero, false)
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        self.storage.append(0 as UInt)
        
        var other: Self = other
        let shift: Int  = other.last.leadingZeroBitCount
        
        if !shift.isZero {
            self .storage.withUnsafeMutableBufferPointer({ NBK.SUI.bitshiftLeft(&$0, major: 0 as Int, minorAtLeastOne: shift) })
            other.storage.withUnsafeMutableBufferPointer({ NBK.SUI.bitshiftLeft(&$0, major: 0 as Int, minorAtLeastOne: shift) })
        }
        //=--------------------------------------=
        // division
        //=--------------------------------------=
        let quotient = Self.uninitialized(count: self.count - other.count) { quotient in
            self.storage.withUnsafeMutableBufferPointer { remainder in
                other.storage.withUnsafeBufferPointer { divisor in
                    //=--------------------------=
                    let divisorLast: UInt = divisor.last!
                    var remainderIndex = remainder.index(before: remainder.endIndex)
                    for quotientIndex in quotient.indices.reversed() {
                        //=----------------------=
                        let remainderLast0 = remainder[remainderIndex]
                        remainder.formIndex(before:   &remainderIndex)
                        let remainderLast1 = remainder[remainderIndex]
                        //=----------------------=
                        var digit:  UInt
                        if  divisorLast == remainderLast0 {
                            digit = UInt.max
                        }   else {
                            digit = divisorLast.dividingFullWidth(HL(high: remainderLast0, low: remainderLast1)).quotient
                        }
                        //=----------------------=
                        if !digit.isZero {
                            var overflow = (NBK).SUISS.decrement(&remainder, by: divisor, times: digit, at: quotientIndex).overflow
                            correctQuotientAtMostTwice: while overflow {
                                digit  &-= 1 as  Digit // the quotient digit is decremented until product ≤ remainder
                                overflow = !NBK .SUISS.increment(&remainder, by: divisor, at: quotientIndex).overflow
                            }
                        }
                        //=----------------------=
                        quotient.baseAddress!.advanced(by: quotientIndex).initialize(to: digit)
                    }
                }
            }
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        if !shift.isZero {
            self.storage.withUnsafeMutableBufferPointer({ NBK.SUI.bitshiftRight(&$0, major: 0 as Int, minorAtLeastOne: shift) })
        }
        
        self.storage.normalize()
        //=--------------------------------------=
        return PVO(partialValue: quotient, overflow: false)
    }
}
