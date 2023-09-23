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
        }   else if comparison.isZero {
            self.updateZeroValue()
            return PVO(001, false)
        }   else {
            return PVO(000, false)
        }
        //=--------------------------------------=
        // shift to clamp approximation
        //=--------------------------------------=
        var divisor: Storage = other.storage
        let divisorLastIndex = divisor.elements.endIndex - 1 as Int
        let shift = divisor.elements[divisorLastIndex].leadingZeroBitCount as Int
        
        var remainderIndex =  self.storage.elements.endIndex as Int
        self.storage.append(0 as UInt)
        
        if !shift.isZero {
            divisor/*-*/.withUnsafeMutableBufferPointer({ SUI.bitshiftLeft(&$0, major: 0 as Int, minorAtLeastOne: shift) })
            self.storage.withUnsafeMutableBufferPointer({ SUI.bitshiftLeft(&$0, major: 0 as Int, minorAtLeastOne: shift) })
        }
        
        let divisorLast0 = divisor.elements[divisorLastIndex] as UInt
        assert(divisorLast0.mostSignificantBit)
        //=--------------------------------------=
        // division: approximate quotient digits
        //=--------------------------------------=
        var quotientIndex = remainderIndex - divisor.elements.endIndex as Int
        let quotient = Self.uninitialized(count:  quotientIndex + 1) { quotient in
            self.storage.withUnsafeMutableBufferPointer { storage in
                loop: repeat {
                    let remainderLast0 = storage[remainderIndex]
                    storage.formIndex(before:   &remainderIndex)
                    let remainderLast1 = storage[remainderIndex]
                    //=--------------------------=
                    var digit:  UInt
                    if  divisorLast0 == remainderLast0 {
                        digit = UInt.max
                    }   else {
                        digit = divisorLast0.dividingFullWidth(HL(remainderLast0, remainderLast1)).quotient
                    }
                    //=--------------------------=
                    if !digit.isZero {
                        var overflow =  SUISS.decrement(&storage, by: divisor.elements, times: digit, at: quotientIndex).overflow
                        while overflow  {
                            overflow = !SUISS.increment(&storage, by: divisor.elements, at: quotientIndex).overflow; digit &-= 01
                        }
                    }
                    //=--------------------------=
                    quotient[quotientIndex] = digit
                    quotient.formIndex(before: &quotientIndex)
                }   while quotientIndex >= quotient.startIndex
            }
        }
        //=--------------------------------------=
        // undo shift before division
        //=--------------------------------------=
        if !shift.isZero {
            self.storage.withUnsafeMutableBufferPointer({ SUI.bitshiftRight(&$0, major: 0 as Int, minorAtLeastOne: shift) })
        }
        
        self.storage.normalize()
        return PVO(partialValue: quotient, overflow: false)
    }
}
