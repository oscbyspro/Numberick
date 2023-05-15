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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @inlinable public func dividingFullWidth(_ dividend: HL<Self, Magnitude>) -> QR<Self, Self> {
        self.dividingFullWidthReportingOverflow(dividend).partialValue
    }
    
    @inlinable public func dividingFullWidth(_ dividend: DoubleWidth) -> QR<Self, Self> {
        self.dividingFullWidthReportingOverflow(dividend).partialValue
    }
    
    @inlinable public func dividingFullWidthReportingOverflow(_ dividend: HL<Self, Magnitude>) -> PVO<QR<Self, Self>> {
        self.dividingFullWidthReportingOverflow(DoubleWidth(dividend))
    }
    
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
    @_specialize(where Self == UInt128)
    @_specialize(where Self == UInt256)
    @_specialize(where Self == UInt512)
    @inlinable internal static func divide22(_ lhs: Self, by rhs: Self) -> PVO<QR<Self, Self>> {
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  rhs.isZero {
            return PVO(QR(lhs, lhs), true)
        }
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        let comparison: Int = lhs.compared(to: rhs)
        if  comparison <= 0 {
            return PVO(comparison.isZero ? QR(1, 0) : QR(0, lhs), false)
        }
        //=--------------------------------------=
        // division: 1 by 1
        //=--------------------------------------=
        if  lhs.high.isZero {
            let (x, a) = lhs.low.quotientAndRemainder(dividingBy: rhs.low)
            return PVO(QR(Self(0, x), Self(0, a)), false)
        }
        //=--------------------------------------=
        // division: 2 by 1
        //=--------------------------------------=
        if  rhs.high.isZero {
            let (x, a) = lhs.high.quotientAndRemainder(dividingBy: rhs.low)
            let (y, b) = a.isZero ? lhs.low.quotientAndRemainder(dividingBy: rhs.low) : rhs.low.dividingFullWidth(HL(a, lhs.low))
            return PVO(QR(Self(x, y), Self(0, b)), false)
        }
        //=--------------------------------------=
        // division: 2 by 2
        //=--------------------------------------=
        let shift: Int = rhs.leadingZeroBitCount
        let overshift: Int = Low.bitWidth &- shift
        assert(shift < Low.bitWidth)
        
        let lhs: Self = lhs._bitshiftedLeft(by: shift)
        let high: Low = lhs.high &>> overshift
        let rhs: Self = rhs._bitshiftedLeft(by: shift)
        assert(rhs.mostSignificantBit)

        let (x, a) = Self.divide32(unchecked: X3(high, lhs.high, lhs.low), by: rhs)
        return PVO(QR(Self(0, x), a._bitshiftedRight(by: shift)), false)
    }
    
    /// An adaptation of Fast Recursive Division by Christoph Burnikel and Joachim Ziegler.
    @_specialize(where Self == UInt128)
    @_specialize(where Self == UInt256)
    @_specialize(where Self == UInt512)
    @inlinable internal static func divide42(_ lhs: DoubleWidth, by rhs: Self) -> PVO<QR<Self, Self>> {
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  rhs.isZero {
            return PVO(QR(lhs.low, lhs.low), true)
        }
        //=--------------------------------------=
        // check whether the quotient fits
        //=--------------------------------------=
        let overflow: Bool = lhs.high >= rhs
        //=--------------------------------------=
        // division: 2 by 2
        //=--------------------------------------=
        if  lhs.high.isZero {
            return PVO(lhs.low.quotientAndRemainder(dividingBy: rhs), overflow)
        }
        //=--------------------------------------=
        // division: 3 by 2
        //=--------------------------------------=
        if  rhs.high.isZero {
            let (   a) = /*----*/   lhs.high.high % rhs.low
            let (   b) = a.isZero ? lhs.high.low  % rhs.low : rhs.low.dividingFullWidth((a, lhs.high.low)).remainder
            let (x, c) = b.isZero ? lhs.low .high.quotientAndRemainder(dividingBy: rhs.low) : rhs.low.dividingFullWidth(HL(b, lhs.low.high))
            let (y, d) = c.isZero ? lhs.low .low .quotientAndRemainder(dividingBy: rhs.low) : rhs.low.dividingFullWidth(HL(c, lhs.low.low ))
            return PVO(QR(Self(x, y), Self(0, d)), overflow)
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let shift: Int = rhs.leadingZeroBitCount
        let rhs =  rhs._bitshiftedLeft(by: shift)
        let lhs =  lhs._bitshiftedLeft(by: shift)
        //=--------------------------------------=
        // division: 3 by 2 (normalized)
        //=--------------------------------------=
        if  lhs.high.high.isZero, Self(lhs.high.low, lhs.low.high) < rhs {
            let (x, a) = Self.divide32(unchecked: X3(lhs.high.low, lhs.low.high, lhs.low.low), by: rhs)
            return PVO(QR(Self(0, x), a._bitshiftedRight(by: shift)), overflow)
        }
        //=--------------------------------------=
        // division: 4 by 2 (normalized)
        //=--------------------------------------=
        let (x, a) = Self.divide32(unchecked: X3(lhs.high.high, lhs.high.low, lhs.low.high), by: rhs)
        let (y, b) = Self.divide32(unchecked: X3(/*---*/a.high, /*---*/a.low, lhs.low.low ), by: rhs)
        return PVO(QR(Self(x, y), b._bitshiftedRight(by: shift)), overflow)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// An adaptation of Fast Recursive Division by Christoph Burnikel and Joachim Ziegler.
    @_specialize(where Self == UInt128)
    @_specialize(where Self == UInt256)
    @_specialize(where Self == UInt512)
    @inlinable internal static func divide32(unchecked lhs: X3<Low>, by rhs: Self) -> QR<Low, Self> {
        //=--------------------------------------=
        assert(rhs.mostSignificantBit)
        assert(Self(lhs.high, lhs.mid) < rhs)
        assert(Self(lhs.high, lhs.mid).leadingZeroBitCount <= Low.bitWidth)
        //=--------------------------------------=
        var quotient = lhs.high == rhs.high ? Low.max : rhs.high.dividingFullWidth(HL(lhs.high, lhs.mid)).quotient
        var approximation = Low.multiplying21(HL(rhs.high, rhs.low), by: quotient)
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
        var remainder = lhs as X3<Low>
        let _ = Low.decrement33(&remainder, by: approximation)
        return QR(quotient, Self(remainder.mid, remainder.low))
    }
}
