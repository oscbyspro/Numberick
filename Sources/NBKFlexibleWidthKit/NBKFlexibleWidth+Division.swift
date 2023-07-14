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
        //=--------------------------------------=
        // divisor is one word
        //=--------------------------------------=
        if  other.storage.count == 1 {
            // TODO: test truncation semantcs
            let divisor = other.storage.first! as UInt
            let qro = self.quotientAndRemainderReportingOverflow(dividingBy: divisor)
            let remainder = qro.overflow ? self : Self(digit: qro.partialValue.remainder)
            return PVO(QR(qro.partialValue.quotient, remainder), qro.overflow)
        }
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        if  self <= other {
            return self == other ? PVO(QR(1, Self.zero), false) : PVO(QR(Self.zero, self), false)
        }
        //=--------------------------------------=
        // shift to clamp approximation
        //=--------------------------------------=
        let shift = other.storage.last!.leadingZeroBitCount as Int
        var remainderIndex = self.storage.endIndex
        var remainder = self.bitshiftedLeft(words: 0, bits: shift) as Self
        let divisor = other .bitshiftedLeft(words: 0, bits: shift) as Self
        let divisorLast0 = divisor.storage[divisor.storage.endIndex - 1] as UInt
        assert(divisorLast0.mostSignificantBit)
        //=--------------------------------------=
        // division: approximate quotient digits
        //=--------------------------------------=
        var quotientIndex = remainderIndex - divisor.storage.endIndex as Int
        var quotient = Self.uninitialized(count: quotientIndex + 1) { quotient in
            // TODO: denormalized or fixed-width operations
            
            repeat {
                //=------------------------------=
                let remainderLast0 = remainderIndex < remainder.storage.endIndex ? remainder.storage[remainderIndex] : UInt.zero
                remainder.storage.formIndex(before: &remainderIndex)
                let remainderLast1 = remainderIndex < remainder.storage.endIndex ? remainder.storage[remainderIndex] : UInt.zero
                //=------------------------------=
                var digit = remainderLast0 == divisorLast0 ? UInt.max : divisorLast0.dividingFullWidth(HL(remainderLast0, remainderLast1)).quotient
                if !digit.isZero {
                    var approximation = divisor.multiplied(by: digit)
                    
                    while remainder.compared(to: approximation, at: quotientIndex) < 0 as Int {
                        _ = digit.subtractReportingOverflow(1 as UInt)
                        _ = approximation.subtractReportingOverflow(divisor,   at: quotientIndex)
                    }
                    
                    let _ = remainder.subtractReportingOverflow(approximation, at: quotientIndex)
                }
                //=----------------------------------=
                quotient[quotientIndex] =  digit
                quotient.formIndex(before: &quotientIndex)
            }   while quotientIndex >= quotient.startIndex
        }
        //=--------------------------------------=
        // undo shift before division
        //=--------------------------------------=
        quotient .normalize()
        remainder.bitshiftRight(words: Int.zero, bits: shift)
        return PVO(QR(quotient, remainder), false)
    }
}
