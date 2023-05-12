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
// MARK: * NBK x Double Width x Division
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func divideReportingOverflow(by divisor: Self) -> Bool {
        let pvo: PVO<Self> = self.dividedReportingOverflow(by: divisor)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @inlinable public func dividedReportingOverflow(by divisor: Self) -> PVO<Self> {
        let qro: PVO<QR<Self, Self>> = self.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        return   PVO(qro.partialValue.quotient, qro.overflow)
    }
    
    @inlinable public mutating func formRemainderReportingOverflow(dividingBy divisor: Self) -> Bool {
        let pvo: PVO<Self> = self.remainderReportingOverflow(dividingBy: divisor)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @inlinable public func remainderReportingOverflow(dividingBy divisor: Self) -> PVO<Self> {
        let qro: PVO<QR<Self, Self>> = self.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        return   PVO(qro.partialValue.remainder, qro.overflow)
    }
    
    @inlinable public func quotientAndRemainderReportingOverflow(dividingBy divisor: Self) -> PVO<QR<Self, Self>> {
        let dividendIsLessThanZero: Bool =    self.isLessThanZero
        let  divisorIsLessThanZero: Bool = divisor.isLessThanZero
        //=--------------------------------------=
        let qro_ = self.magnitude.quotientAndRemainderReportingOverflow(dividingBy: divisor.magnitude)
        var qro  = PVO(QR(Self(bitPattern: qro_.partialValue.quotient), Self(bitPattern: qro_.partialValue.remainder)), qro_.overflow)
        //=--------------------------------------=
        if  qro.overflow {
            assert(divisor.isZero)
            assert(qro.partialValue.quotient  == self)
            assert(qro.partialValue.remainder == self)
            return qro
        }

        if  dividendIsLessThanZero != divisorIsLessThanZero {
            qro.partialValue.quotient.formTwosComplement()
        }
        
        if  dividendIsLessThanZero && divisorIsLessThanZero && qro.partialValue.quotient.isLessThanZero {
            assert(Self.isSigned && self == Self.min && divisor == -1)
            assert(qro.partialValue.quotient  == self)
            assert(qro.partialValue.remainder == Self())
            qro.overflow = true
            return qro
        }
        
        if  dividendIsLessThanZero {
            qro.partialValue.remainder.formTwosComplement()
        }
        //=--------------------------------------=
        return qro as PVO<QR<Self, Self>>
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @inlinable public func dividingFullWidth(_ dividend: HL<Self, Magnitude>) -> QR<Self, Self> {
        let dividend = DoubleWidth(descending: dividend)
        let dividendIsLessThanZero: Bool = dividend.isLessThanZero
        let  divisorIsLessThanZero: Bool = /**/self.isLessThanZero
        //=--------------------------------------=
        var qr: QR<Magnitude, Magnitude> = self.magnitude._dividingFullWidthAsUnsigned(dividend.magnitude)
        //=--------------------------------------=
        if  dividendIsLessThanZero != divisorIsLessThanZero {
            qr.quotient.formTwosComplement()
        }
        
        if  dividendIsLessThanZero {
            qr.remainder.formTwosComplement()
        }
        //=--------------------------------------=
        return QR(Self(bitPattern: qr.quotient), Self(bitPattern: qr.remainder))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the quotient and remainder of dividing this value by the divisor.
    ///
    /// Performs unsigned long division with `UInt` digits.
    ///
    @_specialize(where Self == UInt128)
    @_specialize(where Self == UInt256)
    @_specialize(where Self == UInt512)
    @inlinable func quotientAndRemainderReportingOverflow(dividingBy divisor: Self) -> PVO<QR<Self, Self>> {
        let divisor_ = divisor.minLastIndexReportingIsZeroOrMinusOne()
        if  divisor_.isZeroOrMinusOne {
            return PVO(QR(self, self), true)
        }
        //=--------------------------------------=
        // Fast: Dividend <= Divisor
        //=--------------------------------------=
        if  self <= divisor {
            return self == divisor ? PVO(QR(1, Self()), false) : PVO(QR(Self(), self), false)
        }
        //=--------------------------------------=
        // Fast: Divisor Is One Word
        //=--------------------------------------=
        if  divisor_.minLastIndex.isZero {
            let qro: PVO<QR<Self, Digit>> = self.quotientAndRemainderReportingOverflow(dividingBy: divisor.first)
            return   PVO(QR(qro.partialValue.quotient, Self(digit: qro.partialValue.remainder)), qro.overflow)
        }
        //=--------------------------------------=
        let dividend_  = self.minLastIndexReportingIsZeroOrMinusOne()
        let minLastIndexGapSize: Int = dividend_.minLastIndex &- divisor_.minLastIndex
        let shift: Int = divisor[unchecked: divisor_.minLastIndex].leadingZeroBitCount
        //=--------------------------------------=
        // Shift To Clamp Approximation
        //=--------------------------------------=
        var remainder = DoubleWidth(descending: HL(Self(), self))
        remainder._bitshiftLeft(words: Int(), bits:  shift)
        
        var increment = DoubleWidth(descending: HL(Self(), divisor))
        increment.low._bitshiftLeft(words: minLastIndexGapSize, bits: shift)
        assert(increment.high.isZero)
        
        let discriminant: UInt = increment.low[unchecked: dividend_.minLastIndex]
        assert(discriminant.mostSignificantBit)
        //=--------------------------------------=
        // Division
        //=--------------------------------------=
        let quotient = Self.fromUnsafeMutableWords { quotient in
            for quotientIndex in quotient.indices  {
                quotient[quotientIndex] = UInt()
            }
            //=----------------------------------=
            for quotientIndex in quotient.indices[...minLastIndexGapSize].reversed() {
                //=------------------------------=
                // Approximate Quotient Digit
                //=------------------------------=
                var digit: UInt = remainder.withUnsafeWords { remainder in
                    let  remainderIndex  = divisor_.minLastIndex &+ quotientIndex
                    let  remainderLast0  = remainder[remainderIndex &+ 1]
                    if   remainderLast0 >= discriminant { return UInt.max }
                    let  remainderLast1  = remainder[remainderIndex /**/]
                    return discriminant.dividingFullWidth(HL(remainderLast0, remainderLast1)).quotient
                }
                //=------------------------------=
                var approximation = DoubleWidth(descending: increment.low.multipliedFullWidth(by: digit))
                //=------------------------------=
                // Decrement If Overestimated
                //=------------------------------=
                if  approximation > remainder {
                    brrrrrrrrrrrrrrrrrrrrrrr: do { digit &-= 1; approximation &-= increment }
                    if approximation > remainder { digit &-= 1; approximation &-= increment }
                }
                //=------------------------------=
                assert(approximation <= remainder)
                remainder &-= approximation
                quotient[quotientIndex] = digit
                increment.low._bitshiftRight(words: 1, bits: Int())
            }
        }
        //=--------------------------------------=
        // Undo Shift Before Division
        //=--------------------------------------=
        assert(remainder.high.isZero)
        remainder.low._bitshiftRight(words: Int(), bits: shift)
        return PVO(QR(quotient, remainder.low), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @inlinable func _dividingFullWidthAsUnsigned(_ dividend: DoubleWidth) -> QR<Self, Self> {
        let divisor = DoubleWidth(descending: HL(Self(), self))
        let qro: PVO<QR<DoubleWidth, DoubleWidth>> = dividend.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        precondition(!qro.overflow, "overflow in division")
        return QR(qro.partialValue.quotient.low, qro.partialValue.remainder.low)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Division x Digit
//*============================================================================*

extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @_transparent public mutating func divideReportingOverflow(by divisor: Digit) -> Bool {
        let pvo: PVO<Self> = self.dividedReportingOverflow(by: divisor)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @_disfavoredOverload @_transparent public func dividedReportingOverflow(by divisor: Digit) -> PVO<Self> {
        let qro: PVO<QR<Self, Digit>> = self.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        return   PVO(qro.partialValue.quotient, qro.overflow)
    }
    
    @_disfavoredOverload @_transparent public mutating func formRemainderReportingOverflow(dividingBy divisor: Digit) -> Bool {
        let pvo: PVO<Digit> = self.remainderReportingOverflow(dividingBy: divisor)
        self = Self(digit: pvo.partialValue)
        return pvo.overflow as Bool
    }
    
    @_disfavoredOverload @_transparent public func remainderReportingOverflow(dividingBy divisor: Digit) -> PVO<Digit> {
        let qro: PVO<QR<Self, Digit>> = self.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        return   PVO(qro.partialValue.remainder, qro.overflow)
    }
    
    @_disfavoredOverload @inlinable public func quotientAndRemainderReportingOverflow(dividingBy divisor: Digit) -> PVO<QR<Self, Digit>> {
        let dividendIsLessThanZero: Bool =    self.isLessThanZero
        let  divisorIsLessThanZero: Bool = divisor.isLessThanZero
        //=--------------------------------------=
        let qro_ = self.magnitude.quotientAndRemainderReportingOverflow(dividingBy: divisor.magnitude)
        var qro  = PVO(QR(Self(bitPattern: qro_.partialValue.quotient), Digit(bitPattern: qro_.partialValue.remainder)), qro_.overflow)
        //=--------------------------------------=
        if  qro.overflow {
            assert(divisor.isZero)
            assert(qro.partialValue.quotient  == self)
            assert(qro.partialValue.remainder == Digit())
            return qro
        }

        if  dividendIsLessThanZero != divisorIsLessThanZero {
            qro.partialValue.quotient.formTwosComplement()
        }
        
        if  dividendIsLessThanZero && divisorIsLessThanZero && qro.partialValue.quotient.isLessThanZero {
            assert(Self.isSigned && self == Self.min && divisor == -1)
            assert(qro.partialValue.quotient  == self)
            assert(qro.partialValue.remainder == Digit())
            qro.overflow = true
            return qro
        }
        
        if  dividendIsLessThanZero {
            qro.partialValue.remainder.formTwosComplement()
        }
        //=--------------------------------------=
        return qro as PVO<QR<Self, Digit>>
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public func quotientAndRemainderReportingOverflow(dividingBy divisor: Digit) -> PVO<QR<Self, Digit>> {
        var quotient  = self
        let remainder = quotient._formQuotientReportingRemainderAndOverflow(dividingBy: divisor)
        return PVO(QR(quotient, remainder.partialValue), remainder.overflow)
    }
    
    @inlinable mutating func _formQuotientReportingRemainderAndOverflow(dividingBy divisor: Digit) -> PVO<Digit> {
        //=--------------------------------------=
        if  divisor.isZero {
            return PVO(UInt(), true)
        }
        //=--------------------------------------=
        var remainder = UInt()
        
        self.withUnsafeMutableWords { words in
            var index: Int = words.endIndex
            backwards: while index != words.startIndex {
                (words.formIndex(before: &index))
                (words[index], remainder) = divisor.dividingFullWidth(HL(remainder, words[index]))
            }
        }
        
        return PVO(remainder, false)
    }
}
