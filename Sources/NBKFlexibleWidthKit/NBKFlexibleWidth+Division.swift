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
        let otherMinLastIndex = other.storage.index(before: other.storage.endIndex)
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  other.isZero {
            return PVO(QR(self, self), true)
        }
        //=--------------------------------------=
        // divisor is one word
        //=--------------------------------------=
        if  other.storage.count == 1 {
            let divisor = other.storage.first! as UInt
            let qro: PVO<QR<Self, Digit>> = self.quotientAndRemainderReportingOverflow(dividingBy: divisor)
            return   PVO(QR(qro.partialValue.quotient, Self(digit: qro.partialValue.remainder)),  qro.overflow)
        }
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        if  self <= other {
            return self == other ? PVO(QR(1, Self.zero), false) : PVO(QR(Self.zero, self), false)
        }
        //=--------------------------------------=
        let gap = self.storage.count  - other.storage.count as Int
        let shift = other.storage.last!.leadingZeroBitCount as Int
        //=--------------------------------------=
        // shift to clamp approximation
        //=--------------------------------------=
        var remainder = self .bitshiftedLeft(words: 000, bits: shift) as Self
        var increment = other.bitshiftedLeft(words: gap, bits: shift) as Self
        let discriminant = increment.storage.last! as UInt
        assert(discriminant.mostSignificantBit)
        //=--------------------------------------=
        // division
        //=--------------------------------------=
        var quotient = Storage(repeating: UInt.zero, count: gap + 1)
        for quotientIndex in quotient.indices.reversed() {
            //=------------------------------=
            // approximate quotient digit
            //=------------------------------=
            var digit: UInt = {
                let remainderIndex  = otherMinLastIndex + quotientIndex + 1
                let remainderLast0  = remainderIndex < remainder.storage.endIndex ? remainder.storage[remainderIndex] : UInt.zero
                if  remainderLast0 >= discriminant { return UInt.max }
                let remainderLast1  = remainder.storage[remainderIndex - 1]
                return discriminant.dividingFullWidth(HL(remainderLast0, remainderLast1)).quotient
            }()
            
            var approximation = increment.multiplied(by: digit)
            //=------------------------------=
            // decrement if overestimated
            //=------------------------------=
            if  approximation > remainder {
                brrrrrrrrrrrrrrrrrrrrrrr: do { digit -= 1; approximation -= increment }
                if approximation > remainder { digit -= 1; approximation -= increment }
            }
            
            assert(approximation <= remainder)
            //=------------------------------=
            remainder -= approximation
            quotient[quotientIndex] = digit
            //=------------------------------=
            guard !quotientIndex.isZero else { break }
            increment.bitshiftRight(words: 1)
        }
        //=--------------------------------------=
        // undo shift before division
        //=--------------------------------------=
        remainder.bitshiftRight(words: Int.zero, bits: shift)
        return PVO(QR(Self(words: quotient), remainder), false)
    }
}
