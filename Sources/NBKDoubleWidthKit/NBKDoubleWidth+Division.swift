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

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @_specialize(where Self == UInt128) @_specialize(where Self == Int128)
    @_specialize(where Self == UInt256) @_specialize(where Self == Int256)
    @_specialize(where Self == UInt512) @_specialize(where Self == Int512)
    @inlinable public func quotientAndRemainderReportingOverflow(dividingBy divisor: Self) -> PVO<QR<Self, Self>> {
        let lhsIsLessThanZero: Bool =    self.isLessThanZero
        let rhsIsLessThanZero: Bool = divisor.isLessThanZero
        //=--------------------------------------=
        var qro = Magnitude.divide22(self.magnitude, by: divisor.magnitude) as PVO<QR<Magnitude, Magnitude>>
        //=--------------------------------------=
        if  lhsIsLessThanZero != rhsIsLessThanZero {
            qro.partialValue.quotient.formTwosComplement()
        }

        if  lhsIsLessThanZero {
            qro.partialValue.remainder.formTwosComplement()
        }

        if  lhsIsLessThanZero, rhsIsLessThanZero, qro.partialValue.quotient.mostSignificantBit {
            qro.overflow = true
        }
        //=--------------------------------------=
        return PVO(QR(Self(bitPattern: qro.partialValue.quotient), Self(bitPattern: qro.partialValue.remainder)), qro.overflow)
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=

    @inlinable public func dividingFullWidth(_ dividend: HL<Self, Magnitude>) -> QR<Self, Self> {
        self.dividingFullWidth(DoubleWidth(descending: dividend))
    }

    @inlinable public func dividingFullWidth(_ dividend: DoubleWidth) -> QR<Self, Self> {
        let pvo: PVO<QR<Self, Self>> = self.dividingFullWidthReportingOverflow(dividend)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as  QR<Self, Self>
    }

    @inlinable public func dividingFullWidthReportingOverflow(_ dividend: HL<Self, Magnitude>) -> PVO<QR<Self, Self>> {
        self.dividingFullWidthReportingOverflow(DoubleWidth(descending: dividend))
    }
    
    @_specialize(where Self == UInt128) @_specialize(where Self == Int128)
    @_specialize(where Self == UInt256) @_specialize(where Self == Int256)
    @_specialize(where Self == UInt512) @_specialize(where Self == Int512)
    @inlinable public func dividingFullWidthReportingOverflow(_ dividend: DoubleWidth) -> PVO<QR<Self, Self>> {
        let lhsIsLessThanZero: Bool = dividend.isLessThanZero
        let rhsIsLessThanZero: Bool = /**/self.isLessThanZero
        let minus: Bool = (lhsIsLessThanZero != rhsIsLessThanZero)
        //=--------------------------------------=
        var qro = Magnitude.divide42(dividend.magnitude, by: self.magnitude) as PVO<QR<Magnitude, Magnitude>>
        //=--------------------------------------=
        if  minus {
            qro.partialValue.quotient.formTwosComplement()
        }
        
        if  lhsIsLessThanZero {
            qro.partialValue.remainder.formTwosComplement()
        }
        
        if  Self.isSigned, qro.partialValue.quotient.mostSignificantBit != minus {
            qro.overflow = minus ? (qro.overflow || !qro.partialValue.quotient.isZero) : true
        }
        //=--------------------------------------=
        return PVO(QR(Self(bitPattern: qro.partialValue.quotient), Self(bitPattern: qro.partialValue.remainder)), qro.overflow)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// An adaptation of Fast Recursive Division by Christoph Burnikel and Joachim Ziegler.
    @inlinable internal static func divide22(_ lhs: Self, by rhs: Self) -> PVO<QR<Self, Self>> {
        let shift: Int = rhs.leadingZeroBitCount
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  UInt(bitPattern: shift) == UInt(bitPattern: Self.bitWidth) {
            return PVO(QR(lhs, lhs), true)
        }
        //=--------------------------------------=
        return PVO(Self.divide22Unchecked(lhs, by: rhs, shift: shift), false)
    }

    /// An adaptation of Fast Recursive Division by Christoph Burnikel and Joachim Ziegler.
    @inlinable internal static func divide22Unchecked(_ lhs: Self, by rhs: Self, shift: Int) -> QR<Self, Self> {
        assert(rhs.isMoreThanZero, "must not divide by zero")
        assert(rhs.leadingZeroBitCount == shift, "save shift amount")
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        let comparison: Int = rhs.compared(to: lhs)
        if  comparison >= 0 {
            return comparison.isZero ? QR(1, Self.zero) : QR(Self.zero, lhs)
        }
        //=--------------------------------------=
        // division: 1 by 1
        //=--------------------------------------=
        let lhsIs0X = lhs.high.isZero as Bool
        if  lhsIs0X {
            assert(rhs.high.isZero, "divisors greater than or equal should go fast path")
            let (quotient, remainder) = lhs.low.quotientAndRemainder(dividingBy: rhs.low)
            return QR(Self(descending: HL(High.zero, quotient)), Self(descending: HL(High.zero, remainder)))
        }
        //=--------------------------------------=
        // division: 2 by 1
        //=--------------------------------------=
        let rhsIs0X = UInt(bitPattern: shift) >= UInt(bitPattern: High.bitWidth)
        if  rhsIs0X {
            let (quotient, remainder) = Self.divide21(lhs, by: rhs.low)
            return QR(quotient, Self(descending: HL(High.zero, remainder)))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let (words,  bits) = shift.dividedByBitWidth()
        let (high) = shift.isZero ? Low.zero : lhs.high &>> (Low.bitWidth &- shift)
        let (lhs ) = lhs.bitshiftedLeftUnchecked(words: words, bits: bits) as Self
        let (rhs ) = rhs.bitshiftedLeftUnchecked(words: words, bits: bits) as Self
        //=--------------------------------------=
        // division: 3 by 2 (normalized)
        //=--------------------------------------=
        let (quotient, remainder) = Self.divide32Normalized(Wide3(high, lhs.high, lhs.low), by: rhs)
        return QR(Self(descending: HL(High.zero, quotient)), remainder.bitshiftedRightUnchecked(words: words, bits: bits))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// An adaptation of Fast Recursive Division by Christoph Burnikel and Joachim Ziegler.
    @inlinable internal static func divide42(_ lhs: DoubleWidth, by rhs: Self) -> PVO<QR<Self, Self>> {
        let shift: Int = rhs.leadingZeroBitCount
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  UInt(bitPattern: shift) == UInt(bitPattern: Self.bitWidth) {
            return PVO(QR(lhs.low, lhs.low), true)
        }
        //=--------------------------------------=
        // quotient will not fit in two halves
        //=--------------------------------------=
        if  rhs <= lhs.high {
            let high = Self.divide22Unchecked(lhs.high,  by: rhs, shift: shift)
            let truncated = DoubleWidth(descending: HL(high.remainder, lhs.low))
            return PVO(Self.divide42Unchecked(truncated, by: rhs, shift: shift), true)
        }
        //=--------------------------------------=
        return PVO(Self.divide42Unchecked(lhs, by: rhs, shift: shift), false)
    }
    
    @inlinable internal static func divide42Unchecked(_ lhs: DoubleWidth, by rhs: Self, shift: Int) -> QR<Self, Self> {
        assert(rhs > lhs.high, "quotient must fit in two halves")
        assert(rhs.isMoreThanZero, "must not divide by zero")
        assert(rhs.leadingZeroBitCount == shift, "save shift amount")
        //=--------------------------------------=
        let lhsIs0XXX = lhs.high.high.isZero as Bool
        let lhsIs00XX = lhsIs0XXX && lhs.high.low.isZero as Bool
        //=--------------------------------------=
        // division: 2 by 2
        //=--------------------------------------=
        if  lhsIs00XX {
            return Self.divide22Unchecked(lhs.low, by: rhs, shift: shift)
        }
        //=--------------------------------------=
        // division: 3 by 1
        //=--------------------------------------=
        let rhsIs0X = UInt(bitPattern: shift) >= UInt(bitPattern: High.bitWidth)
        if  rhsIs0X {
            assert(lhsIs0XXX,  "quotient must fit in two halves")
            let (quotient, remainder) = Self.divide31Unchecked(Wide3(lhs.high.low, lhs.low.high, lhs.low.low), by: rhs.low)
            return QR(quotient, Self(descending: HL(High.zero, remainder)))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let (words, bits) = shift.dividedByBitWidth()
        let (lhs) = lhs.bitshiftedLeftUnchecked(words: words, bits: bits) as DoubleWidth
        let (rhs) = rhs.bitshiftedLeftUnchecked(words: words, bits: bits) as Self
        //=--------------------------------------=
        // division: 3 by 2 (normalized)
        //=--------------------------------------=
        if  lhsIs0XXX, Self(descending: HL(lhs.high.low, lhs.low.high)) < rhs {
            let (quotient, remainder) = Self.divide32Normalized(Wide3(lhs.high.low, lhs.low.high, lhs.low.low), by: rhs)
            return QR(Self(descending: HL(High.zero, quotient)), remainder.bitshiftedRightUnchecked(words: words, bits: bits))
        }
        //=--------------------------------------=
        // division: 4 by 2 (normalized)
        //=--------------------------------------=
        let (quotient, remainder) = Self.divide42Normalized(lhs, by: rhs)
        return QR(quotient, remainder.bitshiftedRightUnchecked(words: words, bits: bits))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable internal static func divide21(_ lhs: Self, by rhs: Low) -> QR<Self, Low> {
        let (x, a) = lhs.high.quotientAndRemainder(dividingBy: rhs)
        let (y, b) = a.isZero ? lhs.low.quotientAndRemainder(dividingBy: rhs) : rhs.dividingFullWidth(HL(a, lhs.low))
        return QR(Self(descending: HL(x, y)), b)
    }
    
    @inlinable internal static func divide31Unchecked(_ lhs: Wide3<Low>, by rhs: Low) -> QR<Self, Low> {
        assert(lhs.high < rhs, "quotient must fit in two halves")
        //=--------------------------------------=
        let (x, b) = rhs.dividingFullWidth(HL(lhs.high, lhs.mid))
        let (y, c) = b.isZero ? lhs.low.quotientAndRemainder(dividingBy: rhs) : rhs.dividingFullWidth(HL(b, lhs.low))
        return QR(Self(descending: HL(x, y)), c)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Normalized
    //=------------------------------------------------------------------------=

    /// Divides 3 halves by 2 normalized halves, where the quotient fits in one half.
    ///
    /// ### Approximation Adjustment
    ///
    /// The approximation needs at most two adjustments, but the while loop is faster.
    ///
    @inlinable internal static func divide32Normalized(_ lhs: Wide3<Low>, by rhs: Self) -> QR<Low, Self> {
        assert(rhs.mostSignificantBit, "divisor must be normalized")
        assert(rhs > Self(descending: HL(lhs.high, lhs.mid)), "quotient must fit in one half")
        //=--------------------------------------=
        var quotient: Low = (lhs.high == rhs.high) ? Low.max : rhs.high.dividingFullWidth(HL(lhs.high, lhs.mid)).quotient
        var approximation: Wide3<Low> =  Low.multiplying21(HL(rhs.high, rhs.low), by: quotient)
        //=--------------------------------------=
        // decrement if overestimated (max twice)
        //=--------------------------------------=
        while Low.compare33(lhs, to: approximation)  == -1 {
            _ = quotient.subtractReportingOverflow(1 as UInt)
            _ = Low.decrement32(&approximation, by: HL(rhs.high, rhs.low))
        }
        //=--------------------------------------=
        var remainder = lhs as Wide3<Low>
        let _  = Low.decrement33(&remainder, by: approximation)
        return QR(quotient, Self(descending: HL(remainder.mid, remainder.low)))
    }

    /// Divides 4 halves by 2 normalized halves, where the quotient fits in two halves.
    @inlinable internal static func divide42Normalized(_ lhs: DoubleWidth, by rhs: Self) -> QR<Self, Self> {
        let (x, a) = Self.divide32Normalized(Wide3(lhs.high.high, lhs.high.low, lhs.low.high), by: rhs)
        let (y, b) = Self.divide32Normalized(Wide3(/*---*/a.high, /*---*/a.low, lhs.low.low ), by: rhs)
        return QR(Self(descending: HL(x, y)), b)
    }
}
