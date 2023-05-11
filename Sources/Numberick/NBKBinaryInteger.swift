//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Binary Integer
//*============================================================================*

/// A binary integer.
///
/// ### Two's Complement
///
/// Like `BinaryInteger`, it has [two's complement][2s] semantics.
///
/// - The two's complement representation of `+0` is an infinite sequence of `0s`.
/// - The two's complement representation of `-1` is an infinite sequence of `1s`.
///
/// [2s]: https://en.wikipedia.org/wiki/Two%27s_complement
///
public protocol NBKBinaryInteger: NBKBitPatternConvertible, BinaryInteger, Sendable where
Magnitude: NBKUnsignedInteger, Words: Sendable {
    
    /// A machine word of some kind, or this type.
    associatedtype Digit: NBKBinaryInteger = Self where
    Digit.Digit == Digit, Digit.Magnitude == Magnitude.Digit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(digit: Digit)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bits
    //=------------------------------------------------------------------------=
    
    @inlinable init(bit: Bool)
    
    @inlinable var mostSignificantBit: Bool { get }
    
    @inlinable var leastSignificantBit: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable var isZero: Bool { get }
    
    @inlinable var isLessThanZero: Bool { get }
    
    @inlinable var isMoreThanZero: Bool { get }
    
    @inlinable var isPowerOf2: Bool { get }
    
    @inlinable func compared(to other: Self) -> Int
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func formTwosComplement()
    
    @inlinable func twosComplement() -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable static func +=(lhs: inout Self, rhs: Self)
    
    @inlinable static func +(lhs: Self, rhs: Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable static func -=(lhs: inout Self, rhs: Self)
    
    @inlinable static func -(lhs: Self, rhs: Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable static func *=(lhs: inout Self, rhs: Self)
    
    @inlinable static func *(lhs: Self, rhs: Self) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Division
    //=------------------------------------------------------------------------=
    
    @inlinable static func /=(lhs: inout Self, rhs: Self)
    
    @inlinable static func /(lhs: Self, rhs: Self) -> Self
    
    @inlinable static func %=(lhs: inout Self, rhs: Self)
    
    @inlinable static func %(lhs: Self, rhs: Self) -> Self
    
    @inlinable mutating func divideReportingOverflow(by divisor: Self) -> Bool
    
    @inlinable func dividedReportingOverflow(by divisor: Self) -> PVO<Self>
    
    @inlinable mutating func formRemainderReportingOverflow(dividingBy divisor: Self) -> Bool
    
    @inlinable func remainderReportingOverflow(dividingBy divisor: Self) -> PVO<Self>
    
    @inlinable func quotientAndRemainder(dividingBy divisor: Self) -> QR<Self, Self>
    
    @inlinable func quotientAndRemainderReportingOverflow(dividingBy divisor: Self) -> PVO<QR<Self, Self>>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NBKBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(digit: Digit) where Digit == Self {
        self = digit
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public var isOdd: Bool {
        self.leastSignificantBit
    }
    
    @inlinable public var isEven: Bool {
        self.leastSignificantBit == false
    }
    
    @inlinable public var isLessThanZero: Bool {
        Self.isSigned && self.mostSignificantBit
    }
    
    @inlinable public var isMoreThanZero: Bool {
        !self.isLessThanZero && !self.isZero
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Division
    //=------------------------------------------------------------------------=
    
    @inlinable public static func /=(lhs: inout Self, rhs: Self) {
        let overflow: Bool = lhs.divideReportingOverflow(by: rhs)
        precondition(!overflow, "overflow in /=")
    }
    
    @inlinable public static func /(lhs: Self, rhs: Self) -> Self {
        let pvo: PVO<Self> = lhs.dividedReportingOverflow(by: rhs)
        precondition(!pvo.overflow, "overflow in /")
        return pvo.partialValue as Self
    }
    
    @inlinable public static func %=(lhs: inout Self, rhs: Self) {
        let overflow: Bool = lhs.formRemainderReportingOverflow(dividingBy: rhs)
        precondition(!overflow, "overflow in %=")
    }
    
    @inlinable public static func %(lhs: Self, rhs: Self) -> Self {
        let pvo: PVO<Self> = lhs.remainderReportingOverflow(dividingBy: rhs)
        precondition(!pvo.overflow, "overflow in %")
        return pvo.partialValue as Self
    }
    
    @inlinable public func quotientAndRemainder(dividingBy divisor: Self) -> QR<Self, Self> {
        let qro: PVO<QR<Self, Self>> = self.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        precondition(!qro.overflow, "overflow in division")
        return qro.partialValue as QR<Self, Self>
    }
}

//*============================================================================*
// MARK: * NBK x Binary Integer x Signed
//*============================================================================*

/// A signed, binary, integer.
///
/// ### Two's Complement
///
/// Like `BinaryInteger`, it has [two's complement][2s] semantics.
///
/// - The two's complement representation of `+0` is an infinite sequence of `0s`.
/// - The two's complement representation of `-1` is an infinite sequence of `1s`.
///
/// [2s]: https://en.wikipedia.org/wiki/Two%27s_complement
///
public protocol NBKSignedInteger: NBKBinaryInteger, SignedInteger where Digit: NBKSignedInteger {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable static prefix func -(x: Self) -> Self
    
    @inlinable mutating func negate()
    
    @inlinable func negated() -> Self
    
    @inlinable mutating func negateReportingOverflow() -> Bool
    
    @inlinable func negatedReportingOverflow() -> PVO<Self>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NBKSignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func -(x: Self) -> Self {
        x.negated()
    }
    
    @inlinable public mutating func negate() {
        let overflow: Bool = self.negateReportingOverflow()
        precondition(!overflow, "overflow in negation")
    }
    
    @inlinable public func negated() -> Self {
        let pvo: PVO<Self> = self.negatedReportingOverflow()
        precondition(!pvo.overflow, "overflow in negation")
        return pvo.partialValue as Self
    }
}

//*============================================================================*
// MARK: * NBK x Binary Integer x Unsigned
//*============================================================================*

/// An unsigned, binary, integer.
///
/// ### Two's Complement
///
/// Like `BinaryInteger`, it has [two's complement][2s] semantics.
///
/// - The two's complement representation of `+0` is an infinite sequence of `0s`.
/// - The two's complement representation of `-1` is an infinite sequence of `1s`.
///
/// [2s]: https://en.wikipedia.org/wiki/Two%27s_complement
///
public protocol NBKUnsignedInteger: NBKBinaryInteger, UnsignedInteger where Digit: NBKUnsignedInteger, Magnitude == Self { }
