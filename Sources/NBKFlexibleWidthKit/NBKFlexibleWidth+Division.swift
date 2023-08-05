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
// MARK: * NBK x Flexible Width x Division x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
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
        let qro: PVO<QR<Magnitude, Magnitude>> = self.magnitude.quotientAndRemainderReportingOverflow(dividingBy: other.magnitude)
        let quotient  = Self(sign: self.sign ^ other.sign, magnitude: qro.partialValue.quotient )
        let remainder = Self(sign: self.sign,  /*------*/  magnitude: qro.partialValue.remainder)
        return PVO(QR(quotient, remainder), qro.overflow)
    }
}

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
        if  other.storage.count == 1 {
            let qr = self.quotientAndRemainder(dividingBy: other.storage.first)
            self.assign(qr.remainder)
            return PVO(qr.quotient, false)
        }
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        let comparison  = other.compared(to: self)
        if  comparison >= 0 {
            if  comparison.isZero {
                self.assign(UInt.zero)
                return PVO(001, false)
            }   else {
                return PVO(000, false)
            }
        }
        //=--------------------------------------=
        // shift to clamp approximation
        //=--------------------------------------=
        var divisor = other.storage
        let shift = divisor.last.leadingZeroBitCount as Int
        divisor.bitshiftLeft(words: Int.zero, bits: shift)
        let divisorLast0 = divisor[divisor.endIndex - 1] as UInt
        assert(divisorLast0.mostSignificantBit)
        
        var remainderIndex = self.storage.endIndex
        self.storage.append(0)
        self.storage.bitshiftLeft(words: Int.zero, bits: shift)
        //=--------------------------------------=
        // division: approximate quotient digits
        //=--------------------------------------=
        var quotientIndex = remainderIndex - divisor.endIndex as Int
        var quotient = Storage.uninitialized(count: quotientIndex + 1) { quotient in
            loop: repeat {
                let remainderLast0 = self.storage[remainderIndex]
                self.storage.formIndex(before:   &remainderIndex)
                let remainderLast1 = self.storage[remainderIndex]
                //=------------------------------=
                var digit: UInt
                if  divisorLast0 == remainderLast0 {
                    digit = UInt.max
                }   else {
                    digit = divisorLast0.dividingFullWidth(HL(remainderLast0, remainderLast1)).quotient
                }
                //=------------------------------=
                if !digit.isZero {
                    var overflow = self.storage.subtract(divisor, times: digit, plus: UInt.zero, at: quotientIndex)
                    decrement: while overflow {
                        _ = digit.subtractReportingOverflow(1 as UInt)
                        overflow = !self.storage.add(divisor, plus: false, at: quotientIndex)
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
        self.storage.bitshiftRight(words: Int.zero, bits: shift)
        self.storage.normalize()
        return PVO(Self(unchecked: quotient), false)
    }
}
