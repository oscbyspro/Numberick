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
    // MARK: Transformations x Overflow
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
    
    @_specialize(where Self == UInt128) @_specialize(where Self == Int128)
    @_specialize(where Self == UInt256) @_specialize(where Self == Int256)
    @_specialize(where Self == UInt512) @_specialize(where Self == Int512)
    @inlinable public func quotientAndRemainderReportingOverflow(dividingBy other: Self) -> PVO<QR<Self, Self>> {
        let lhsIsLessThanZero: Bool = self .isLessThanZero
        let rhsIsLessThanZero: Bool = other.isLessThanZero
        let minus = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var qro = NBK.bitCast(Magnitude.divide2222(self.magnitude, by: other.magnitude)) as PVO<QR<Self, Self>>
        //=--------------------------------------=
        if  minus {
            qro.partialValue.quotient.formTwosComplement()
        }

        if  lhsIsLessThanZero {
            qro.partialValue.remainder.formTwosComplement()
        }
        
        if  lhsIsLessThanZero && rhsIsLessThanZero && qro.partialValue.quotient.isLessThanZero {
            qro.overflow = true
        }
        //=--------------------------------------=
        return qro as PVO<QR<Self, Self>>
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @inlinable public func dividingFullWidth(_ other: HL<Self, Magnitude>) -> QR<Self, Self> {
        self.dividingFullWidth(NBKDoubleWidth<Self>(descending: other))
    }

    @inlinable public func dividingFullWidth(_ other: NBKDoubleWidth<Self>) -> QR<Self, Self> {
        let pvo: PVO<QR<Self, Self>> = self.dividingFullWidthReportingOverflow(other)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as  QR<Self, Self>
    }

    @inlinable public func dividingFullWidthReportingOverflow(_ other: HL<Self, Magnitude>) -> PVO<QR<Self, Self>> {
        self.dividingFullWidthReportingOverflow(NBKDoubleWidth<Self>(descending: other))
    }
    
    @_specialize(where Self == UInt128) @_specialize(where Self == Int128)
    @_specialize(where Self == UInt256) @_specialize(where Self == Int256)
    @_specialize(where Self == UInt512) @_specialize(where Self == Int512)
    @inlinable public func dividingFullWidthReportingOverflow(_ other: NBKDoubleWidth<Self>) -> PVO<QR<Self, Self>> {
        let lhsIsLessThanZero: Bool = other.isLessThanZero
        let rhsIsLessThanZero: Bool = self .isLessThanZero
        let minus = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var qro = NBK.bitCast(Magnitude.divide4222(other.magnitude, by: self.magnitude)) as PVO<QR<Self, Self>>
        //=--------------------------------------=
        if  minus {
            qro.partialValue.quotient.formTwosComplement()
        }
        
        if  lhsIsLessThanZero {
            qro.partialValue.remainder.formTwosComplement()
        }
        
        if  minus != qro.partialValue.quotient.isLessThanZero {
            qro.overflow = qro.overflow || !(minus && qro.partialValue.quotient.isZero)
        }
        //=--------------------------------------=
        return qro as PVO<QR<Self, Self>>
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 2222
    //=------------------------------------------------------------------------=
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func divide2222(_ lhs: Self, by rhs: Self) -> PVO<QR<Self, Self>> {
        let shift = NBK.ZeroOrMore(unchecked: rhs.leadingZeroBitCount as Int)
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  UInt(bitPattern: shift.value) == UInt(bitPattern: Self.bitWidth) {
            return PVO(QR(lhs,lhs), true)
        }
        //=--------------------------------------=
        return PVO(Self.divide2222Unchecked(lhs, by: rhs, shift: shift), false)
    }
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func divide2222Unchecked(_ lhs: Self, by rhs: Self, shift: NBK.ZeroOrMore<Int>) -> QR<Self, Self> {
        assert(rhs.isZero == false, "must not divide by zero")
        assert(rhs.leadingZeroBitCount == shift.value, "save shift distance")
        //=--------------------------------------=
        // divisor is greater than or equal
        //=--------------------------------------=
        let comparison: Int = rhs.compared(to: lhs)
        if  comparison >= 0 {
            return comparison.isZero ? QR(1, 0) : QR(0, lhs)
        }
        //=--------------------------------------=
        // division: 1111
        //=--------------------------------------=
        if  lhs.high.isZero {
            assert(rhs.high.isZero, "divisors greater than or equal should go fast path")
            let (quotient, remainder) = lhs.low.quotientAndRemainder(dividingBy: rhs.low)
            return QR(Self(low: quotient), Self(low: remainder))
        }
        //=--------------------------------------=
        // division: 2121
        //=--------------------------------------=
        if  UInt(bitPattern: shift.value) >= UInt(bitPattern: High.bitWidth) {
            let (quotient, remainder) = Self.divide2121(lhs, by: rhs.low)
            return QR(quotient, Self(low: remainder))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let major = NBK .quotient(of: shift, dividingBy: NBK.PowerOf2(bitWidth: UInt.self))
        let minor = NBK.remainder(of: shift, dividingBy: NBK.PowerOf2(bitWidth: UInt.self))
        
        let top = shift.value.isZero ? High.zero : lhs.high &>> (High.bitWidth &- shift.value)
        let lhs = lhs.bitshiftedLeft(major: major, minor: minor) as Self
        let rhs = rhs.bitshiftedLeft(major: major, minor: minor) as Self
        //=--------------------------------------=
        // division: 3212 (normalized)
        //=--------------------------------------=
        let (quotient, remainder) = Self.divide3212MSBUnchecked(NBK.Wide3(top, lhs.high, lhs.low), by: rhs)
        return QR(Self(low: quotient), remainder.bitshiftedRight(major: major, minor: minor))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x 4222
    //=------------------------------------------------------------------------=
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func divide4222(_ lhs: NBKDoubleWidth<Self>, by rhs: Self) -> PVO<QR<Self, Self>> {
        let shift = NBK.ZeroOrMore(unchecked: rhs.leadingZeroBitCount as Int)
        //=--------------------------------------=
        // divisor is zero
        //=--------------------------------------=
        if  UInt(bitPattern: shift.value) == UInt(bitPattern: Self.bitWidth) {
            return PVO(QR(lhs.low, lhs.low), true)
        }
        //=--------------------------------------=
        // quotient does not fit in two halves
        //=--------------------------------------=
        if  rhs <= lhs.high {
            let high = Self.divide2222Unchecked(lhs.high,  by: rhs, shift: shift)
            let truncated = NBKDoubleWidth<Self>(high:     high.remainder, low: lhs.low)
            return PVO(Self.divide4222Unchecked(truncated, by: rhs, shift: shift), true)
        }
        //=--------------------------------------=
        return PVO(Self.divide4222Unchecked(lhs, by: rhs, shift: shift), false)
    }
    
    /// An adaptation of "Fast Recursive Division" by Christoph Burnikel and Joachim Ziegler.
    @inlinable static func divide4222Unchecked(_ lhs: NBKDoubleWidth<Self>, by rhs: Self, shift: NBK.ZeroOrMore<Int>) -> QR<Self, Self> {
        assert(rhs.isZero == false, "must not divide by zero")
        assert(rhs.leadingZeroBitCount == shift.value, "save shift distance")
        assert(rhs > lhs.high, "quotient must fit in two halves")
        //=--------------------------------------=
        // division: 2222
        //=--------------------------------------=
        if  lhs.high.isZero {
            return Self.divide2222Unchecked(lhs.low, by: rhs, shift: shift)
        }
        //=--------------------------------------=
        // division: 3121
        //=--------------------------------------=
        if  UInt(bitPattern: shift.value) >= UInt(bitPattern: High.bitWidth) {
            assert(lhs.high.high.isZero,  "quotient must fit in two halves") // because  lhs.high < rhs && rhs.high == 0
            let (quotient, remainder) = Self.divide3121Unchecked(NBK.Wide3(lhs.high.low, lhs.low.high, lhs.low.low), by: rhs.low)
            return QR(quotient, Self(low: remainder))
        }
        //=--------------------------------------=
        // normalization
        //=--------------------------------------=
        let major = NBK .quotient(of: shift, dividingBy: NBK.PowerOf2(bitWidth: UInt.self))
        let minor = NBK.remainder(of: shift, dividingBy: NBK.PowerOf2(bitWidth: UInt.self))
        
        let lhs = lhs.bitshiftedLeft(major: major, minor: minor) as NBKDoubleWidth<Self>
        let rhs = rhs.bitshiftedLeft(major: major, minor: minor) as Self
        //=--------------------------------------=
        // division: 3212 (normalized)
        //=--------------------------------------=
        if  lhs.high.high.isZero, rhs > Self(high: lhs.high.low, low: lhs.low.high) {
            let (quotient, remainder) = Self.divide3212MSBUnchecked(NBK.Wide3(lhs.high.low, lhs.low.high, lhs.low.low), by: rhs)
            return QR(Self(low: quotient), remainder.bitshiftedRight(major: major, minor: minor))
        }
        //=--------------------------------------=
        // division: 4222 (normalized)
        //=--------------------------------------=
        let (quotient, remainder) = Self.divide4222MSBUnchecked(lhs, by: rhs)
        return QR(quotient, remainder.bitshiftedRight(major: major, minor: minor))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Special
    //=------------------------------------------------------------------------=
    
    @inlinable static func divide2121(_ lhs: Self, by rhs: High) -> QR<Self, High> {
        let (x, a) = lhs.high.quotientAndRemainder(dividingBy: rhs)
        let (y, b) = a.isZero ? lhs.low.quotientAndRemainder(dividingBy: rhs) : rhs.dividingFullWidth(HL(a, lhs.low))
        return QR(Self(high: x, low: y), b)
    }
    
    @inlinable static func divide3121Unchecked(_ lhs: NBK.Wide3<High>, by rhs: High) -> QR<Self, High> {
        assert(rhs > lhs.high, "quotient must fit in two halves")
        let (x, a) = rhs.dividingFullWidth(HL(lhs.high, lhs.mid))
        let (y, b) = a.isZero ? lhs.low.quotientAndRemainder(dividingBy: rhs) : rhs.dividingFullWidth(HL(a, lhs.low))
        return QR(Self(high: x, low: y), b)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Special x Normalized
    //=------------------------------------------------------------------------=
    
    /// Divides 3 halves by 2 normalized halves, assuming the quotient fits in 1 half.
    @inlinable static func divide3212MSBUnchecked(_ lhs: NBK.Wide3<High>, by rhs: Self) -> QR<High, Self> {
        var remainder = lhs as NBK.Wide3<High>
        let quotient  = NBK.TupleInteger.divide3212MSBUnchecked(&remainder, by: rhs.descending)
        return QR(quotient, Self(high: remainder.mid, low: remainder.low))
    }
    
    /// Divides 4 halves by 2 normalized halves, assuming the quotient fits in 2 halves.
    @inlinable static func divide4222MSBUnchecked(_ lhs: NBKDoubleWidth<Self>, by rhs: Self) -> QR<Self, Self> {
        let (x, a) =  Self.divide3212MSBUnchecked(NBK.Wide3(lhs.high.high, lhs.high.low, lhs.low.high), by: rhs)
        let (y, b) =  Self.divide3212MSBUnchecked(NBK.Wide3(/*---*/a.high, /*---*/a.low, lhs.low.low ), by: rhs)
        return QR(Self(high: x, low: y), b)
    }
}
