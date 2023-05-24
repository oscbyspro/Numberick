//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Core Integer
//*============================================================================*

/// A fixed-width, binary, integer.
///
/// Only the following types in the standard library may conform to this protocol:
///
/// - `Int`
/// - `Int8`
/// - `Int16`
/// - `Int32`
/// - `Int64`
///
/// - `UInt`
/// - `UInt8`
/// - `UInt16`
/// - `UInt32`
/// - `UInt64`
///
public protocol NBKCoreInteger<Magnitude>: NBKFixedWidthInteger where
BitPattern == Magnitude, Digit == Self, Magnitude: NBKCoreInteger { }

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NBKCoreInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bits
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bit: Bool) {
        self = bit ?  (1 as Self) : (0 as Self)
    }
    
    @inlinable public init(repeating bit: Bool) {
        self = bit ? ~(0 as Self) : (0 as Self)
    }
    
    @inlinable public var mostSignificantBit: Bool {
        self & ((1 as Self) &<< (Self.bitWidth &- 1)) != (0 as Self)
    }
    
    @inlinable public var leastSignificantBit: Bool {
        self & ((1 as Self)) != (0 as Self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public var isFull: Bool {
        self == ~(0 as Self)
    }
    
    @inlinable public var isZero: Bool {
        self ==  (0 as Self)
    }
    
    @inlinable public var isLessThanZero: Bool {
        Self.isSigned && self < (0 as Self)
    }
    
    @inlinable public var isMoreThanZero: Bool {
        self > (0 as Self)
    }
    
    @inlinable public func compared(to other: Self) -> Int {
        self < other ? -1 : self == other ? 0 : 1
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Complements
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: BitPattern) {
        self = Swift.unsafeBitCast(bitPattern, to: Self.self)
    }
    
    @inlinable public var bitPattern: BitPattern {
        Swift.unsafeBitCast(self, to: BitPattern.self)
    }
    
    @inlinable public mutating func formTwosComplement() {
        self = self.twosComplement()
    }
    
    @inlinable public func twosComplement() -> Self {
        ~self &+ (1 as Self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition, Subtraction, Multiplication, Division
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func addReportingOverflow(_ amount: Self) -> Bool {
        let pvo: PVO<Self> = self.addingReportingOverflow(amount)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @inlinable public mutating func subtractReportingOverflow(_ amount: Self) -> Bool {
        let pvo: PVO<Self> = self.subtractingReportingOverflow(amount)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @inlinable public mutating func multiplyReportingOverflow(by amount: Self) -> Bool {
        let pvo: PVO<Self> = self.multipliedReportingOverflow(by: amount)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @inlinable public mutating func multiplyFullWidth(by amount: Self) -> Self {
        let product: HL<Self, Magnitude> = self.multipliedFullWidth(by: amount)
        self = Self(bitPattern: product.low)
        return product.high as Self
    }
    
    @inlinable public mutating func divideReportingOverflow(by amount: Self) -> Bool {
        let pvo: PVO<Self> = self.dividedReportingOverflow(by: amount)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @inlinable public mutating func formRemainderReportingOverflow(dividingBy amount: Self) -> Bool {
        let pvo: PVO<Self> = self.remainderReportingOverflow(dividingBy: amount)
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @inlinable public func quotientAndRemainder(dividingBy divisor: Self) -> QR<Self, Self> {
        let qro: PVO<QR<Self, Self>> = self.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        precondition(!qro.overflow, NBK.callsiteOverflowInfo())
        return qro.partialValue as QR<Self, Self>
    }
    
    @inlinable public func quotientAndRemainderReportingOverflow(dividingBy divisor: Self) -> PVO<QR<Self, Self>> {
        let quotient:  PVO<Self> = self.dividedReportingOverflow(by: divisor)
        let remainder: PVO<Self> = self.remainderReportingOverflow(dividingBy: divisor)
        assert(quotient.overflow == remainder.overflow)
        return PVO(QR(quotient.partialValue, remainder.partialValue), quotient.overflow)
    }
    
    @inlinable public func dividingFullWidthReportingOverflow(_ dividend: HL<Self, Magnitude>) -> PVO<QR<Self, Self>> {
        //=--------------------------------------=
        if  self.isZero {
            return PVO(QR(Self(bitPattern: dividend.low), Self(bitPattern: dividend.low)), true)
        }
        //=--------------------------------------=
        let lhsIsLessThanZero: Bool = dividend.high.isLessThanZero
        let rhsIsLessThanZero: Bool = /*-----*/self.isLessThanZero
        let minus: Bool  = (lhsIsLessThanZero != rhsIsLessThanZero)
        //=--------------------------------------=
        var lhsMagnitude = HL(Magnitude(bitPattern: dividend.high), dividend.low)
        if  lhsIsLessThanZero {
            var carry: Bool
            (lhsMagnitude.low,  carry) = (~lhsMagnitude.low ).addingReportingOverflow(1 as Magnitude)
            (lhsMagnitude.high, carry) = (~lhsMagnitude.high).addingReportingOverflow(Magnitude(bit: carry))
        }
        
        let rhsMagnitude = self.magnitude as Magnitude
        //=--------------------------------------=
        var qro = PVO(rhsMagnitude.dividingFullWidth(lhsMagnitude), lhsMagnitude.high >= rhsMagnitude)
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
// MARK: + Details x Signed
//=----------------------------------------------------------------------------=

extension NBKCoreInteger where Self: NBKSignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func negateReportingOverflow() -> Bool {
        let pvo: PVO<Self> = self.negatedReportingOverflow()
        self = pvo.partialValue
        return pvo.overflow as Bool
    }
    
    @inlinable public func negatedReportingOverflow() -> PVO<Self> {
        PVO(self.twosComplement(), self == Self.min)
    }
}

//*============================================================================*
// MARK: * NBK x Core Integer x Swift
//*============================================================================*

extension Int: NBKCoreInteger, NBKSignedInteger {    
    public typealias BitPattern = Magnitude
}

extension Int8: NBKCoreInteger, NBKSignedInteger {
    public typealias BitPattern = Magnitude
}

extension Int16: NBKCoreInteger, NBKSignedInteger {
    public typealias BitPattern = Magnitude
}

extension Int32: NBKCoreInteger, NBKSignedInteger {
    public typealias BitPattern = Magnitude
}

extension Int64: NBKCoreInteger, NBKSignedInteger {
    public typealias BitPattern = Magnitude
}

extension UInt: NBKCoreInteger, NBKUnsignedInteger {
    public typealias BitPattern = Magnitude
}

extension UInt8: NBKCoreInteger, NBKUnsignedInteger {
    public typealias BitPattern = Magnitude
}

extension UInt16: NBKCoreInteger, NBKUnsignedInteger {
    public typealias BitPattern = Magnitude
}

extension UInt32: NBKCoreInteger, NBKUnsignedInteger {
    public typealias BitPattern = Magnitude
}

extension UInt64: NBKCoreInteger, NBKUnsignedInteger {
    public typealias BitPattern = Magnitude
}
