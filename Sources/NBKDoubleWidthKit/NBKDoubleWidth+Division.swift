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
        typealias T = PVO<QR<Self, Self>>
        //=--------------------------------------=
        let lhsIsLessThanZero: Bool =    self.isLessThanZero
        let rhsIsLessThanZero: Bool = divisor.isLessThanZero
        //=--------------------------------------=
        var qro = unsafeBitCast(Magnitude._divide22(self.magnitude, by: divisor.magnitude), to: T.self)
        //=--------------------------------------=
        if  qro.overflow {
            return qro as T
        }
        
        if  lhsIsLessThanZero != rhsIsLessThanZero {
            qro.partialValue.quotient.formTwosComplement()
        }
        
        if  lhsIsLessThanZero && rhsIsLessThanZero && qro.partialValue.quotient.mostSignificantBit {
            return T(qro.partialValue, true)
        }

        if  lhsIsLessThanZero {
            qro.partialValue.remainder.formTwosComplement()
        }
        //=--------------------------------------=
        return qro as T
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    @inlinable public func dividingFullWidth(_ dividend: HL<Self, Magnitude>) -> QR<Self, Self> {
        self.dividingFullWidthReportingOverflow(dividend).partialValue
    }
    
    @inlinable public func _dividingFullWidth(_ dividend: DoubleWidth) -> QR<Self, Self> {
        self.dividingFullWidthReportingOverflow(dividend).partialValue
    }
    
    @inlinable public func dividingFullWidthReportingOverflow(_ dividend: HL<Self, Magnitude>) -> PVO<QR<Self, Self>> {
        self.dividingFullWidthReportingOverflow(DoubleWidth(dividend))
    }
    
    @inlinable public func dividingFullWidthReportingOverflow(_ dividend: DoubleWidth) -> PVO<QR<Self, Self>> {
        typealias T = PVO<QR<Self, Self>>
        //=--------------------------------------=
        let lhsIsLessThanZero: Bool = dividend.isLessThanZero
        let rhsIsLessThanZero: Bool = /**/self.isLessThanZero
        //=--------------------------------------=
        var qro = unsafeBitCast(Magnitude._divide42(dividend.magnitude, by: self.magnitude), to: T.self)
        //=--------------------------------------=
        if  qro.overflow {
            return qro as T
        }
        
        if  lhsIsLessThanZero != rhsIsLessThanZero {
            qro.partialValue.quotient.formTwosComplement()
        }
        
        if  lhsIsLessThanZero {
            qro.partialValue.remainder.formTwosComplement()
        }
        
        return qro as T
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Unsigned
//=----------------------------------------------------------------------------=

extension NBKDoubleWidth where High == High.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable internal static func _divide22(_ lhs: Self, by rhs: Self) -> PVO<QR<Self, Self>> {
        //=--------------------------------------=
        // Divisor Is Zero
        //=--------------------------------------=
        if  rhs.isZero {
            return PVO(QR(lhs, lhs), true)
        }
        //=--------------------------------------=
        // Divisor Is Greater Than Or Equal
        //=--------------------------------------=
        let comparison: Int = lhs.compared(to: rhs)
        if  comparison <= 0 {
            return PVO(comparison.isZero ? QR(1, 0) : QR(0, lhs), false)
        }
        //=--------------------------------------=
        // Division: 1 x 1
        //=--------------------------------------=
        if  lhs.high.isZero {
            assert(rhs.high.isZero)
            let (yyy, bbb) = lhs.low.quotientAndRemainder(dividingBy: rhs.low )
            return PVO(QR(Self(000, yyy), Self(000, bbb)), false)
        }
        //=--------------------------------------=
        // Division: 2 x 1
        //=--------------------------------------=
        if  rhs.high.isZero {
            assert(lhs.high.isZero == false)
            let (xxx, aaa) = lhs.high.quotientAndRemainder(dividingBy: rhs.low)
            let (yyy, bbb) = aaa.isZero ? lhs.low.quotientAndRemainder(dividingBy: rhs.low) : rhs.low.dividingFullWidth((aaa, lhs.low))
            return PVO(QR(Self(xxx, yyy), Self(000, bbb)), false)
        }
        //=--------------------------------------=
        // Division: 2 x 2
        //=--------------------------------------=
        assert(lhs.high.isZero == false)
        assert(rhs.high.isZero == false)
        //=--------------------------------------=
        let shift: Int = rhs.leadingZeroBitCount
        assert(shift < Low.bitWidth)
        
        let rhs = rhs._bitshiftedLeft(by: shift) as Self
        let lhs = DoubleWidth(0, lhs)._bitshiftedLeft(by: shift)
        assert(lhs.high.high.isZero)
        
        let (xxx, aaa) = Self._divide32((lhs.high.low, lhs.low.high, lhs.low.low), by: rhs)
        return PVO(QR(Self(0, xxx), aaa._bitshiftedRight(by: shift)), false)
    }
    
    @inlinable internal static func _divide32(_ lhs: (high: Low, mid: Low, low: Low), by rhs: Self) -> QR<Low, Self> {
        //=--------------------------------------=
        assert(rhs.mostSignificantBit)
        assert(Self(lhs.high, lhs.mid) < rhs)
        assert(Self(lhs.high, lhs.mid).leadingZeroBitCount <= Low.bitWidth)
        //=--------------------------------------=
        var quotient = (lhs.high == rhs.high) ? Low.max : rhs.high.dividingFullWidth((lhs.high, lhs.mid)).quotient
        //=--------------------------------------=
        var xxx = quotient.multipliedFullWidth(by: rhs.low )
        var yyy = quotient.multipliedFullWidth(by: rhs.high)
        yyy.low &+= UInt(bit: xxx.high.addReportingOverflow(yyy.low))
        var product = DoubleWidth(Self(0, yyy.high), Self(xxx))
        //=--------------------------------------=
        // Decrement If Overestimated
        //=--------------------------------------=
        var remainder = DoubleWidth(Self(0, lhs.high), Self(lhs.mid, lhs.low))
        
        while remainder < product {
            quotient &-= (1 as UInt)
            let o = product.low.subtractReportingOverflow(rhs)
            if  o { product.high &-= (1 as UInt) }
        }
        
        remainder &-= product
        //=--------------------------------------=
        return QR(quotient, remainder.low)
    }
    
    @inlinable internal static func _divide42(_ lhs: DoubleWidth, by rhs: Self) -> PVO<QR<Self, Self>> {
        //=--------------------------------------=
        // Divisor Is Zero
        //=--------------------------------------=
        if  rhs.isZero {
            return PVO(QR(lhs.low, lhs.low), true)
        }
        //=--------------------------------------=
        // Check Whether The Quotient Fits
        //=--------------------------------------=
        let overflow: Bool = lhs.high >= rhs
        //=--------------------------------------=
        // Division: 2 x 2
        //=--------------------------------------=
        if  lhs.high.isZero {
            return PVO(lhs.low.quotientAndRemainder(dividingBy: rhs), overflow)
        }
        //=--------------------------------------=
        // Division: 3 x 2
        //=--------------------------------------=
        if  rhs.high.isZero {
            let (ppp) = lhs.high.high % rhs.low
            let (qqq) = ppp.isZero ? lhs.high.low % rhs.low : rhs.low.dividingFullWidth((ppp, lhs.high.low)).remainder
            let (xxx, aaa) = qqq.isZero ? lhs.low.high.quotientAndRemainder(dividingBy: rhs.low) : rhs.low.dividingFullWidth((qqq, lhs.low.high))
            let (yyy, bbb) = aaa.isZero ? lhs.low.low .quotientAndRemainder(dividingBy: rhs.low) : rhs.low.dividingFullWidth((aaa, lhs.low.low ))
            return PVO(QR(Self(xxx, yyy), Self(0, bbb)), overflow)
        }
        //=--------------------------------------=
        // Normalization
        //=--------------------------------------=
        let shift: Int = rhs.leadingZeroBitCount
        let rhs =  rhs._bitshiftedLeft(by: shift)
        let lhs =  lhs._bitshiftedLeft(by: shift)
        //=--------------------------------------=
        // Division: 3 x 2 (Normalized)
        //=--------------------------------------=
        if  lhs.high.high.isZero && Self(lhs.high.low, lhs.low.high) < rhs {
            let (aaa, bbb) = Self._divide32((lhs.high.low, lhs.low.high, lhs.low.low), by: rhs)
            return PVO(QR(Self(0, aaa), bbb._bitshiftedRight(by: shift)), overflow)
        }
        //=--------------------------------------=
        // Division: 4 x 2 (Normalized)
        //=--------------------------------------=
        let (xxx, aaa) = Self._divide32((lhs.high.high, lhs.high.low, lhs.low.high), by: rhs)
        let (yyy, bbb) = Self._divide32((/*-*/aaa.high, /*-*/aaa.low, lhs.low.low ), by: rhs)
        return PVO(QR(Self(xxx, yyy), bbb._bitshiftedRight(by: shift)), overflow)
    }
}
