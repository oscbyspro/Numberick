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
        var qro = Magnitude.divide22(self.magnitude, by: divisor.magnitude)
        //=--------------------------------------=
        if  lhsIsLessThanZero != rhsIsLessThanZero {
            qro.partialValue.quotient.formTwosComplement()
        }

        if  lhsIsLessThanZero {
            qro.partialValue.remainder.formTwosComplement()
        }

        if  lhsIsLessThanZero && rhsIsLessThanZero && qro.partialValue.quotient.mostSignificantBit {
            qro.overflow = true
        }
        //=--------------------------------------=
        return PVO(QR(Self(bitPattern: qro.partialValue.quotient), Self(bitPattern: qro.partialValue.remainder)), qro.overflow)
    }

    // TODO: consider removing duplicates
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=

    @inlinable public func dividingFullWidth(_ dividend: HL<Self, Magnitude>) -> QR<Self, Self> {
        self.dividingFullWidth(DoubleWidth(descending: dividend))
    }

    @inlinable public func dividingFullWidth(_ dividend: DoubleWidth) -> QR<Self, Self> {
        self.dividingFullWidthReportingOverflow(dividend).partialValue
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
        //=--------------------------------------=
        var qro = Magnitude.divide42(dividend.magnitude, by: self.magnitude)
        //=--------------------------------------=
        if  lhsIsLessThanZero != rhsIsLessThanZero {
            qro.partialValue.quotient.formTwosComplement()
        }

        if  lhsIsLessThanZero {
            qro.partialValue.remainder.formTwosComplement()
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
        assert(shift <  Self.bitWidth, "must not divide by zero")
        assert(shift == rhs.leadingZeroBitCount, "the shift amount should be cached")
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        let comparison: Int = lhs.compared(to: rhs)
        if  comparison <= 0 {
            return comparison.isZero ? QR(1, 0) : QR(0, lhs)
        }
        //=--------------------------------------=
        // division: 1 by 1
        //=--------------------------------------=
        if  lhs.high.isZero {
            let (quotient, remainder) = lhs.low.quotientAndRemainder(dividingBy: rhs.low)
            return QR(Self(descending: HL(0, quotient)), Self(descending: HL(0, remainder)))
        }
        //=--------------------------------------=
        // division: 2 by 1
        //=--------------------------------------=
        if  UInt(bitPattern: shift) >= UInt(bitPattern: High.bitWidth) {
            let (quotient, remainder) = Self.divide21(lhs, by: rhs.low)
            return QR(quotient, Self(descending: HL(0, remainder)))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let (words, bits) = shift.dividedByBitWidth()
        assert(shift < Low.bitWidth)

        let high = shift.isZero ? Low.zero : lhs.high &>> (Low.bitWidth &- shift)
        let lhs: Self = lhs._bitshiftedLeft(words: words, bits: bits)
        let rhs: Self = rhs._bitshiftedLeft(words: words, bits: bits)
        assert(rhs.mostSignificantBit)
        //=--------------------------------------=
        // division: 3 by 2 (normalized)
        //=--------------------------------------=
        let (quotient, remainder) = Self.divide32Normalized(Wide3(high, lhs.high, lhs.low), by: rhs)
        return QR(Self(descending: HL(0, quotient)), remainder._bitshiftedRight(words: words, bits: bits))
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
        if  lhs.high >= rhs {
            let remainder = Self.divide22(lhs.high, by: rhs).partialValue.remainder
            let truncated = DoubleWidth(descending: HL(remainder, lhs.low))
            return PVO(Self.divide42Unchecked(truncated, by: rhs, shift: shift), true)
        }
        //=--------------------------------------=
        return PVO(Self.divide42Unchecked(lhs, by: rhs, shift: shift), false)
    }

    @inlinable internal static func divide42Unchecked(_ lhs: DoubleWidth, by rhs: Self, shift: Int) -> QR<Self, Self> {
        assert(lhs.high < rhs, "quotient must fit in two halves")
        assert(shift <  Self.bitWidth, "must not divide by zero")
        assert(shift == rhs.leadingZeroBitCount, "the shift amount should be cached")
        //=--------------------------------------=
        var zeros: Int = lhs.high.leadingZeroBitCount
        //=--------------------------------------=
        // division: 2 by 2
        //=--------------------------------------=
        if  UInt(bitPattern: zeros) >= UInt(bitPattern: Self.bitWidth) {
            return Self.divide22Unchecked(lhs.low, by: rhs, shift: shift)
        }
        //=--------------------------------------=
        // division: 4 by 1
        //=--------------------------------------=
        if  UInt(bitPattern: shift) >= UInt(bitPattern: High.bitWidth) {
            let (quotient, remainder) = Self.divide41(lhs, by: rhs.low)
            return QR(quotient, Self(descending: HL(0, remainder)))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let (words, bits) = shift.dividedByBitWidth()
        assert(shift < Low.bitWidth)

        zeros &-= shift
        let lhs = lhs._bitshiftedLeft(words: words, bits: bits) as DoubleWidth
        let rhs = rhs._bitshiftedLeft(words: words, bits: bits) as Self
        assert(rhs.mostSignificantBit)
        assert(lhs.leadingZeroBitCount == zeros)
        //=--------------------------------------=
        // division: 3 by 2 (normalized)
        //=--------------------------------------=
        if  UInt(bitPattern: zeros) >= UInt(bitPattern: High.bitWidth), Self(descending: HL(lhs.high.low, lhs.low.high)) < rhs {
            let (quotient, remainder) = Self.divide32Normalized(Wide3(lhs.high.low, lhs.low.high, lhs.low.low), by: rhs)
            return QR(Self(descending: HL(0, quotient)), remainder._bitshiftedRight(words: words, bits: bits))
        }
        //=--------------------------------------=
        // division: 4 by 2 (normalized)
        //=--------------------------------------=
        let (quotient, remainder) = Self.divide42Normalized(lhs, by: rhs)
        return QR(quotient, remainder._bitshiftedRight(words: words, bits: bits))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    @inlinable internal static func divide21(_ lhs: Self, by rhs: Low) -> QR<Self, Low> {
        let (x, a) = lhs.high.quotientAndRemainder(dividingBy: rhs)
        let (y, b) = a.isZero ? lhs.low.quotientAndRemainder(dividingBy: rhs) : rhs.dividingFullWidth(HL(a, lhs.low))
        return QR(Self(descending: HL(x, y)), b)
    }

    @inlinable internal static func divide41(_ lhs: DoubleWidth, by rhs: Low) -> QR<Self, Low> {
        let (   a) = /*------*/ lhs.high.high % rhs
        let (   b) = a.isZero ? lhs.high.low  % rhs : rhs.dividingFullWidth((a, lhs.high.low)).remainder
        let (x, c) = b.isZero ? lhs.low .high.quotientAndRemainder(dividingBy: rhs) : rhs.dividingFullWidth(HL(b, lhs.low.high))
        let (y, d) = c.isZero ? lhs.low .low .quotientAndRemainder(dividingBy: rhs) : rhs.dividingFullWidth(HL(c, lhs.low.low ))
        return QR(Self(descending: HL(x, y)), d)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Normalized
    //=------------------------------------------------------------------------=

    // TODO: code coverage (2nd decrement)
    // TODO: code coverage (lhs.high == rhs.high)
    @inlinable internal static func divide32Normalized(_ lhs: Wide3<Low>, by rhs: Self) -> QR<Low, Self> {
        assert(rhs.mostSignificantBit, "the divisor must be normalized")
        assert(Self(descending: HL(lhs.high, lhs.mid)) < rhs, "the quotient must fit in one half")
        //=--------------------------------------=
        var quotient = lhs.high == rhs.high ? Low.max : rhs.high.dividingFullWidth(HL(lhs.high, lhs.mid)).quotient
        var approximation = Low.multiplying21(HL(rhs.high, rhs.low), by: quotient) as Wide3<Low>
        //=--------------------------------------=
        // decrement if overestimated
        //=--------------------------------------=
        if  Low.compare33(lhs, to: approximation) == -1 {
            _ = quotient.subtractReportingOverflow(1 as UInt)
            _ = Low.decrement32(&approximation, by: HL(rhs.high, rhs.low))

            if  Low.compare33(lhs, to: approximation) == -1 {
                _ = quotient.subtractReportingOverflow(1 as UInt)
                _ = Low.decrement32(&approximation, by: HL(rhs.high, rhs.low))
            }
        }
        //=--------------------------------------=
        var remainder = lhs as Wide3<Low>
        let _  = Low.decrement33(&remainder, by: approximation)
        return QR(quotient, Self(descending: HL(remainder.mid, remainder.low)))
    }

    @inlinable internal static func divide42Normalized(_ lhs: DoubleWidth, by rhs: Self) -> QR<Self, Self> {
        let (x, a) = Self.divide32Normalized(Wide3(lhs.high.high, lhs.high.low, lhs.low.high), by: rhs)
        let (y, b) = Self.divide32Normalized(Wide3(/*---*/a.high, /*---*/a.low, lhs.low.low ), by: rhs)
        return QR(Self(descending: HL(x, y)), b)
    }
}
