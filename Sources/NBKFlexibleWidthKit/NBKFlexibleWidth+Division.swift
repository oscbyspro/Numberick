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
    
    @inlinable public func quotientAndRemainderReportingOverflow(dividingBy other: Self) -> PVO<QR<Self, Self>> {
        self.quotientAndRemainderReportingOverflowAsNormal(dividingBy: other)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Normal
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Private
    //=------------------------------------------------------------------------=
    
    @inlinable func quotientAndRemainderReportingOverflowAsNormal(dividingBy other: Self) -> PVO<QR<Self, Self>> {
        var (remainder) = self
        let (quotient, overflow) = remainder.formRemainderWithQuotientReportingOverflowAsNormal(dividingBy: other)
        return PVO(QR(quotient, remainder), overflow)
    }
    
    @inlinable mutating func formRemainderWithQuotientReportingOverflowAsNormal(dividingBy other: Self) -> PVO<Self> {
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
            let qr: QR<Self, Digit> = self.quotientAndRemainder(dividingBy: other.first)
            self.update(qr.remainder)
            return PVO(qr.quotient, false)
        }
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        let comparison = other.compared(to: self)
        if  comparison.isLessThanZero {
            // such empty. much wow.
        }   else if comparison.isZero {
            self.updateZeroValue()
            return PVO(001, false)
        }   else {
            return PVO(000, false)
        }
        //=--------------------------------------=
        // shift to clamp approximation
        //=--------------------------------------=
        let shift = other.last.leadingZeroBitCount as Int
        var divisor = other.storage as Storage
        divisor.bitshiftLeft(words: 0 as Int,  bits: shift)
        let divisorLast0 = divisor.elements[divisor.elements.endIndex - 1] as UInt
        assert(divisorLast0.mostSignificantBit)
        
        var remainderIndex = self.storage.elements.endIndex
        self.storage.append(0)
        self.storage.bitshiftLeft(words: 0 as Int, bits: shift)
        //=--------------------------------------=
        // division: approximate quotient digits
        //=--------------------------------------=
        var quotientIndex = remainderIndex - divisor.elements.endIndex as Int
        var quotient = Storage.uninitialized(count: quotientIndex + 1) { quotient in
            loop: repeat {
                let remainderLast0 = self.storage.elements[remainderIndex]
                self.storage.elements.formIndex(before:   &remainderIndex)
                let remainderLast1 = self.storage.elements[remainderIndex]
                //=------------------------------=
                var digit: UInt
                if  divisorLast0 == remainderLast0 {
                    digit = UInt.max
                }   else {
                    digit = divisorLast0.dividingFullWidth(HL(remainderLast0, remainderLast1)).quotient
                }
                //=------------------------------=
                if !digit.isZero {
                    self.storage.withUnsafeMutableStrictUnsignedInteger {
                        var overflow =  $0.decrement(by: divisor.elements, times: digit, plus: 0 as UInt, plus: false, at: quotientIndex).overflow
                        decrement: while overflow {
                            digit  &-= 1 as Digit
                            overflow = !$0.increment(by: divisor.elements, plus: false, at: quotientIndex).overflow
                        }
                    }
                }
                //=------------------------------=
                quotient[quotientIndex] = digit
                quotient.formIndex(before: &quotientIndex)
            }   while quotientIndex >= quotient.startIndex
        }
        //=--------------------------------------=
        // undo shift before division
        //=--------------------------------------=
        quotient.normalize()
        self.storage.bitshiftRight(words: 0 as Int, bits: shift)
        self.storage.normalize()
        return PVO(Self(unchecked: quotient), false)
    }
}
