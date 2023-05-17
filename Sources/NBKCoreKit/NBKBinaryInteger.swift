//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
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
public protocol NBKBinaryInteger: NBKBigEndianTextable, NBKBitPatternConvertible,
BinaryInteger, Sendable where Magnitude: NBKUnsignedInteger, Words: Sendable {
    
    /// A machine word of some kind, or this type.
    associatedtype Digit: NBKBinaryInteger = Self where
    Digit.Digit == Digit, Digit.Magnitude == Magnitude.Digit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given digit.
    ///
    /// This conversion always succeeds and ensures optimal performance.
    ///
    @inlinable init(digit: Digit)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bits
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given bit.
    ///
    /// ```swift
    /// Int8(bit: false) // Int8(0)
    /// Int8(bit: true ) // Int8(1)
    /// ```
    ///
    @inlinable init(bit: Bool)
    
    /// Returns the most significant bit, in two's complement form.
    @inlinable var mostSignificantBit: Bool { get }
    
    /// Returns the least significant bit, in two's complement form.
    @inlinable var leastSignificantBit: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    /// Returns whether this value is equal to zero.
    @inlinable var isZero: Bool { get }
    
    /// Returns whether this value is less than zero.
    @inlinable var isLessThanZero: Bool { get }
    
    /// Returns whether this value is more than zero.
    @inlinable var isMoreThanZero: Bool { get }
    
    /// Returns whether this value is a power of `2`.
    @inlinable var isPowerOf2: Bool { get }
    
    /// Performs a [three-way comparison][3s] and returns: `0`, `1` or `-1`.
    ///
    /// It is semantically equivalent to the following expression:
    ///
    /// ```swift
    /// (self < other) ? -1 : (self == other) ? 0 : 1
    /// ```
    ///
    /// The return value can also be thought of as the ``signum()`` of the difference:
    ///
    /// ```swift
    /// (self - other).signum() // but without errors
    /// ```
    ///
    /// [3s]: https://en.wikipedia.org/wiki/Three-way_comparison
    ///
    @inlinable func compared(to other: Self) -> Int
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    /// Forms the two's complement of this value.
    @inlinable mutating func formTwosComplement()
    
    /// Returns the two's complement of this value.
    @inlinable func twosComplement() -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    /// Forms the sum of adding `rhs` to `lhs`.
    ///
    /// ```swift
    /// var a = Int(1); a += Int(2) // a = Int(3)
    /// var b = Int(2); b += Int(3) // b = Int(5)
    /// var c = Int(3); c += Int(4) // c = Int(7)
    /// var d = Int(4); d += Int(5) // d = Int(9)
    /// ```
    ///
    @inlinable static func +=(lhs: inout Self, rhs: Self)
    
    /// Forms the sum of adding `rhs` to `lhs`.
    ///
    /// ```swift
    /// var a = Int(1); a += Int(2) // a = Int(3)
    /// var b = Int(2); b += Int(3) // b = Int(5)
    /// var c = Int(3); c += Int(4) // c = Int(7)
    /// var d = Int(4); d += Int(5) // d = Int(9)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func +=(lhs: inout Self, rhs: Digit)
    
    /// Returns the sum of adding `rhs` to `lhs`.
    ///
    /// ```swift
    /// Int(1) + Int(2) // Int(3)
    /// Int(2) + Int(3) // Int(5)
    /// Int(3) + Int(4) // Int(7)
    /// Int(4) + Int(5) // Int(9)
    /// ```
    ///
    @inlinable static func +(lhs: Self, rhs: Self) -> Self
    
    /// Returns the sum of adding `rhs` to `lhs`.
    ///
    /// ```swift
    /// Int(1) + Int(2) // Int(3)
    /// Int(2) + Int(3) // Int(5)
    /// Int(3) + Int(4) // Int(7)
    /// Int(4) + Int(5) // Int(9)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func +(lhs: Self, rhs: Digit) -> Self
    
    /// Forms the difference of subtracting `rhs` from `lhs`.
    ///
    /// ```swift
    /// var a = Int(3); a -= Int(2) // a = Int(1)
    /// var b = Int(5); b -= Int(3) // b = Int(2)
    /// var c = Int(7); c -= Int(4) // c = Int(3)
    /// var d = Int(9); d -= Int(5) // d = Int(4)
    /// ```
    ///
    @inlinable static func -=(lhs: inout Self, rhs: Self)
    
    /// Forms the difference of subtracting `rhs` from `lhs`.
    ///
    /// ```swift
    /// var a = Int(3); a -= Int(2) // a = Int(1)
    /// var b = Int(5); b -= Int(3) // b = Int(2)
    /// var c = Int(7); c -= Int(4) // c = Int(3)
    /// var d = Int(9); d -= Int(5) // d = Int(4)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func -=(lhs: inout Self, rhs: Digit)
    
    /// Returns the difference of subtracting `rhs` from `lhs`.
    ///
    /// ```swift
    /// Int(3) - Int(2) // Int(1)
    /// Int(5) - Int(3) // Int(2)
    /// Int(7) - Int(4) // Int(3)
    /// Int(9) - Int(5) // Int(4)
    /// ```
    ///
    @inlinable static func -(lhs: Self, rhs: Self) -> Self
    
    /// Returns the difference of subtracting `rhs` from `lhs`.
    ///
    /// ```swift
    /// Int(3) - Int(2) // Int(1)
    /// Int(5) - Int(3) // Int(2)
    /// Int(7) - Int(4) // Int(3)
    /// Int(9) - Int(5) // Int(4)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func -(lhs: Self, rhs: Digit) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    /// Forms the product of multiplying `lhs` by `rhs`.
    ///
    /// ```swift
    /// var a = Int(1); a *= Int(2) // a = Int( 2)
    /// var b = Int(2); b *= Int(3) // b = Int( 6)
    /// var c = Int(3); c *= Int(4) // c = Int(12)
    /// var d = Int(4); d *= Int(5) // d = Int(20)
    /// ```
    ///
    @inlinable static func *=(lhs: inout Self, rhs: Self)
    
    /// Forms the product of multiplying `lhs` by `rhs`.
    ///
    /// ```swift
    /// var a = Int(1); a *= Int(2) // a = Int( 2)
    /// var b = Int(2); b *= Int(3) // b = Int( 6)
    /// var c = Int(3); c *= Int(4) // c = Int(12)
    /// var d = Int(4); d *= Int(5) // d = Int(20)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func *=(lhs: inout Self, rhs: Digit)
    
    /// Returns the product of multiplying `lhs` by `rhs`.
    ///
    /// ```swift
    /// Int(1) * Int(2) // Int( 2)
    /// Int(2) * Int(3) // Int( 6)
    /// Int(3) * Int(4) // Int(12)
    /// Int(4) * Int(5) // Int(20)
    /// ```
    ///
    @inlinable static func *(lhs: Self, rhs: Self) -> Self
    
    /// Returns the product of multiplying `lhs` by `rhs`.
    ///
    /// ```swift
    /// Int(1) * Int(2) // Int( 2)
    /// Int(2) * Int(3) // Int( 6)
    /// Int(3) * Int(4) // Int(12)
    /// Int(4) * Int(5) // Int(20)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func *(lhs: Self, rhs: Digit) -> Self
    
    // TODO: correct documentation of overflow semantics
    //=------------------------------------------------------------------------=
    // MARK: Details x Division
    //=------------------------------------------------------------------------=
    
    /// Forms the quotient of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// var a = Int( 7); a /= Int( 3) // a = Int( 2)
    /// var b = Int( 7); b /= Int(-3) // b = Int(-2)
    /// var c = Int(-7); c /= Int( 3) // c = Int(-2)
    /// var d = Int(-7); d /= Int(-3) // d = Int( 2)
    /// ```
    ///
    @inlinable static func /=(lhs: inout Self, rhs: Self)
    
    /// Forms the quotient of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// var a = Int( 7); a /= Int( 3) // a = Int( 2)
    /// var b = Int( 7); b /= Int(-3) // b = Int(-2)
    /// var c = Int(-7); c /= Int( 3) // c = Int(-2)
    /// var d = Int(-7); d /= Int(-3) // d = Int( 2)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func /=(lhs: inout Self, rhs: Digit)
    
    /// Returns the quotient of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// Int( 7) / Int( 3) // Int( 2)
    /// Int( 7) / Int(-3) // Int(-2)
    /// Int(-7) / Int( 3) // Int(-2)
    /// Int(-7) / Int(-3) // Int( 2)
    /// ```
    ///
    @inlinable static func /(lhs: Self, rhs: Self) -> Self
    
    /// Returns the quotient of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// Int( 7) / Int( 3) // Int( 2)
    /// Int( 7) / Int(-3) // Int(-2)
    /// Int(-7) / Int( 3) // Int(-2)
    /// Int(-7) / Int(-3) // Int( 2)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func /(lhs: Self, rhs: Digit) -> Self
    
    /// Forms the remainder of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// var a = Int( 7); a %= Int( 3) // a = Int( 1)
    /// var b = Int( 7); b %= Int(-3) // b = Int( 1)
    /// var c = Int(-7); c %= Int( 3) // c = Int(-1)
    /// var d = Int(-7); d %= Int(-3) // d = Int(-1)
    /// ```
    ///
    @inlinable static func %=(lhs: inout Self, rhs: Self)
    
    /// Forms the remainder of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// var a = Int( 7); a %= Int( 3) // a = Int( 1)
    /// var b = Int( 7); b %= Int(-3) // b = Int( 1)
    /// var c = Int(-7); c %= Int( 3) // c = Int(-1)
    /// var d = Int(-7); d %= Int(-3) // d = Int(-1)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func %=(lhs: inout Self, rhs: Digit)
    
    /// Returns the remainder of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// Int( 7) % Int( 3) // Int( 1)
    /// Int( 7) % Int(-3) // Int( 1)
    /// Int(-7) % Int( 3) // Int(-1)
    /// Int(-7) % Int(-3) // Int(-1)
    /// ```
    ///
    @inlinable static func %(lhs: Self, rhs: Self) -> Self
    
    /// Returns the remainder of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// Int( 7) % Int( 3) // Int( 1)
    /// Int( 7) % Int(-3) // Int( 1)
    /// Int(-7) % Int( 3) // Int(-1)
    /// Int(-7) % Int(-3) // Int(-1)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func %(lhs: Self, rhs: Digit) -> Digit
    
    /// Forms the quotient of this value divided by the given value, and returns an overflow indicator.
    /// In the case of overflow, the result is either truncated or, if undefined, this value.
    ///
    /// ```swift
    /// var a = Int8(-128); a.divideReportingOverflow(by:  3)) // a = Int8( -42); -> false
    /// var b = Int8(-128); b.divideReportingOverflow(by:  0)) // b = Int8(-128); -> true
    /// var c = Int8(-128); c.divideReportingOverflow(by: -1)) // c = Int8(-128); -> true
    /// ```
    ///
    @inlinable mutating func divideReportingOverflow(by divisor: Self) -> Bool
    
    /// Forms the quotient of this value divided by the given value, and returns an overflow indicator.
    /// In the case of overflow, the result is either truncated or, if undefined, this value.
    ///
    /// ```swift
    /// var a = Int8(-128); a.divideReportingOverflow(by:  3)) // a = Int8( -42); -> false
    /// var b = Int8(-128); b.divideReportingOverflow(by:  0)) // b = Int8(-128); -> true
    /// var c = Int8(-128); c.divideReportingOverflow(by: -1)) // c = Int8(-128); -> true
    /// ```
    ///
    @_disfavoredOverload @inlinable mutating func divideReportingOverflow(by divisor: Digit) -> Bool
    
    /// Returns the quotient of this value divided by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is either truncated or, if undefined, this value.
    ///
    /// ```swift
    /// Int8(-128).dividedReportingOverflow(by: Int8( 3)) // (partialValue: Int8( -42), overflow: false)
    /// Int8(-128).dividedReportingOverflow(by: Int8( 0)) // (partialValue: Int8(-128), overflow: true )
    /// Int8(-128).dividedReportingOverflow(by: Int8(-1)) // (partialValue: Int8(-128), overflow: true )
    /// ```
    ///
    @inlinable func dividedReportingOverflow(by divisor: Self) -> PVO<Self>
    
    /// Returns the quotient of this value divided by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is either truncated or, if undefined, this value.
    ///
    /// ```swift
    /// Int8(-128).dividedReportingOverflow(by: Int8( 3)) // (partialValue: Int8( -42), overflow: false)
    /// Int8(-128).dividedReportingOverflow(by: Int8( 0)) // (partialValue: Int8(-128), overflow: true )
    /// Int8(-128).dividedReportingOverflow(by: Int8(-1)) // (partialValue: Int8(-128), overflow: true )
    /// ```
    ///
    @_disfavoredOverload @inlinable func dividedReportingOverflow(by divisor: Digit) -> PVO<Self>
    
    /// Forms the remainder of this value divided by the given value, and returns an overflow indicator.
    /// In the case of overflow, the result is either the entire remainder or, if undefined, this value.
    ///
    /// ```swift
    /// var a = Int8(-128); a.formRemainderReportingOverflow(dividingBy:  3) // a = Int8(   2); -> false
    /// var b = Int8(-128); b.formRemainderReportingOverflow(dividingBy:  0) // b = Int8(-128); -> true
    /// var c = Int8(-128); c.formRemainderReportingOverflow(dividingBy: -1) // c = Int8(   0); -> true
    /// ```
    ///
    @inlinable mutating func formRemainderReportingOverflow(dividingBy divisor: Self) -> Bool
    
    /// Forms the remainder of this value divided by the given value, and returns an overflow indicator.
    /// In the case of overflow, the result is either the entire remainder or, if undefined, this value.
    ///
    /// ```swift
    /// var a = Int8(-128); a.formRemainderReportingOverflow(dividingBy:  3) // a = Int8(   2); -> false
    /// var b = Int8(-128); b.formRemainderReportingOverflow(dividingBy:  0) // b = Int8(-128); -> true
    /// var c = Int8(-128); c.formRemainderReportingOverflow(dividingBy: -1) // c = Int8(   0); -> true
    /// ```
    ///
    @_disfavoredOverload @inlinable mutating func formRemainderReportingOverflow(dividingBy divisor: Digit) -> Bool
    
    /// Returns the remainder of this value divided by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is either the entire remainder or, if undefined, this value.
    ///
    /// ```swift
    /// Int8(-128).remainderReportingOverflow(dividingBy:  3) // (partialValue: Int8(   2), overflow: false)
    /// Int8(-128).remainderReportingOverflow(dividingBy:  0) // (partialValue: Int8(-128), overflow: true )
    /// Int8(-128).remainderReportingOverflow(dividingBy: -1) // (partialValue: Int8(   0), overflow: true )
    /// ```
    ///
    @inlinable func remainderReportingOverflow(dividingBy divisor: Self) -> PVO<Self>
    
    /// Returns the remainder of this value divided by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is either the entire remainder or, if undefined, this value.
    ///
    /// ```swift
    /// Int8(-128).remainderReportingOverflow(dividingBy:  3) // (partialValue: Int8(   2), overflow: false)
    /// Int8(-128).remainderReportingOverflow(dividingBy:  0) // (partialValue: Int8(-128), overflow: true )
    /// Int8(-128).remainderReportingOverflow(dividingBy: -1) // (partialValue: Int8(   0), overflow: true )
    /// ```
    ///
    @_disfavoredOverload @inlinable func remainderReportingOverflow(dividingBy divisor: Digit) -> PVO<Digit>
    
    /// Returns the quotient and remainder of this value divided by the given value.
    ///
    /// ```swift
    /// Int8( 7).quotientAndRemainder(dividingBy: Int8( 3)) // (quotient: Int8( 2), remainder: Int8( 1))
    /// Int8( 7).quotientAndRemainder(dividingBy: Int8(-3)) // (quotient: Int8(-2), remainder: Int8( 1))
    /// Int8(-7).quotientAndRemainder(dividingBy: Int8( 3)) // (quotient: Int8(-2), remainder: Int8(-1))
    /// Int8(-7).quotientAndRemainder(dividingBy: Int8(-3)) // (quotient: Int8( 2), remainder: Int8(-1))
    /// ```
    ///
    @inlinable func quotientAndRemainder(dividingBy divisor: Self) -> QR<Self, Self>
    
    /// Returns the quotient and remainder of this value divided by the given value.
    ///
    /// ```swift
    /// Int8( 7).quotientAndRemainder(dividingBy: Int8( 3)) // (quotient: Int8( 2), remainder: Int8( 1))
    /// Int8( 7).quotientAndRemainder(dividingBy: Int8(-3)) // (quotient: Int8(-2), remainder: Int8( 1))
    /// Int8(-7).quotientAndRemainder(dividingBy: Int8( 3)) // (quotient: Int8(-2), remainder: Int8(-1))
    /// Int8(-7).quotientAndRemainder(dividingBy: Int8(-3)) // (quotient: Int8( 2), remainder: Int8(-1))
    /// ```
    ///
    @_disfavoredOverload @inlinable func quotientAndRemainder(dividingBy divisor: Digit) -> QR<Self, Digit>
    
    /// Returns the quotient and remainder of this value divided by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is either truncated or, if undefined, this value.
    ///
    /// ```swift
    /// let a = Int8(-128).quotientAndRemainderReportingOverflow(dividingBy: Int8( 3))
    /// a.partialValue.quotient  // Int8( -42)
    /// a.partialValue.remainder // Int8(   2)
    /// a.overflow               // false
    ///
    /// let b = Int8(-128).quotientAndRemainderReportingOverflow(dividingBy: Int8( 0))
    /// b.partialValue.quotient  // Int8(-128)
    /// b.partialValue.remainder // Int8(-128)
    /// b.overflow               // true
    ///
    /// let c = Int8(-128).quotientAndRemainderReportingOverflow(dividingBy: Int8(-1))
    /// c.partialValue.quotient  // Int8(-128)
    /// c.partialValue.remainder // Int8(   0)
    /// c.overflow               // true
    /// ```
    ///
    @inlinable func quotientAndRemainderReportingOverflow(dividingBy divisor: Self) -> PVO<QR<Self, Self>>
    
    /// Returns the quotient and remainder of this value divided by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is either truncated or, if undefined, this value.
    ///
    /// ```swift
    /// let a = Int8(-128).quotientAndRemainderReportingOverflow(dividingBy: Int8( 3))
    /// a.partialValue.quotient  // Int8( -42)
    /// a.partialValue.remainder // Int8(   2)
    /// a.overflow               // false
    ///
    /// let b = Int8(-128).quotientAndRemainderReportingOverflow(dividingBy: Int8( 0))
    /// b.partialValue.quotient  // Int8(-128)
    /// b.partialValue.remainder // Int8(-128)
    /// b.overflow               // true
    ///
    /// let c = Int8(-128).quotientAndRemainderReportingOverflow(dividingBy: Int8(-1))
    /// c.partialValue.quotient  // Int8(-128)
    /// c.partialValue.remainder // Int8(   0)
    /// c.overflow               // true
    /// ```
    ///
    @_disfavoredOverload @inlinable func quotientAndRemainderReportingOverflow(dividingBy divisor: Digit) -> PVO<QR<Self, Digit>>
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
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @_disfavoredOverload @inlinable public static func /=(lhs: inout Self, rhs: Digit) {
        let overflow: Bool = lhs.divideReportingOverflow(by: rhs)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @inlinable public static func /(lhs: Self, rhs: Self) -> Self {
        let pvo: PVO<Self> = lhs.dividedReportingOverflow(by: rhs)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as Self
    }
    
    @_disfavoredOverload @inlinable public static func /(lhs: Self, rhs: Digit) -> Self {
        let pvo: PVO<Self> = lhs.dividedReportingOverflow(by: rhs)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as Self
    }
    
    @inlinable public static func %=(lhs: inout Self, rhs: Self) {
        let overflow: Bool = lhs.formRemainderReportingOverflow(dividingBy: rhs)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @_disfavoredOverload @inlinable public static func %=(lhs: inout Self, rhs: Digit) {
        let overflow: Bool = lhs.formRemainderReportingOverflow(dividingBy: rhs)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @inlinable public static func %(lhs: Self, rhs: Self) -> Self {
        let pvo: PVO<Self> = lhs.remainderReportingOverflow(dividingBy: rhs)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as Self
    }
    
    @_disfavoredOverload @inlinable public static func %(lhs: Self, rhs: Digit) -> Digit {
        let pvo: PVO<Digit> = lhs.remainderReportingOverflow(dividingBy: rhs)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as Digit
    }
    
    @inlinable public func quotientAndRemainder(dividingBy divisor: Self) -> QR<Self, Self> {
        let qro: PVO<QR<Self, Self>> = self.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        precondition(!qro.overflow, NBK.callsiteOverflowInfo())
        return qro.partialValue as QR<Self, Self>
    }
    
    @_disfavoredOverload @inlinable public func quotientAndRemainder(dividingBy divisor: Digit) -> QR<Self, Digit> {
        let qro: PVO<QR<Self, Digit>> = self.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        precondition(!qro.overflow, NBK.callsiteOverflowInfo())
        return qro.partialValue as QR<Self, Digit>
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
    
    /// Returns a value with equal magnitude but opposite sign.
    ///
    /// ```swift
    /// -Int8( 1) // Int8(-1)
    /// -Int8( 0) // Int8( 0)
    /// -Int8(-1) // Int8( 1)
    /// ```
    ///
    @inlinable static prefix func -(x: Self) -> Self
    
    /// Forms a value with equal magnitude but opposite sign.
    ///
    /// ```swift
    /// var a = Int8( 1); a.negate() // a = Int8(-1)
    /// var b = Int8( 0); b.negate() // b = Int8( 0)
    /// var c = Int8(-1); c.negate() // c = Int8( 1)
    /// ```
    ///
    @inlinable mutating func negate()
    
    /// Returns a value with equal magnitude but opposite sign.
    ///
    /// ```swift
    /// Int8( 1).negated() // Int8(-1)
    /// Int8( 0).negated() // Int8( 0)
    /// Int8(-1).negated() // Int8( 1)
    /// ```
    ///
    @inlinable func negated() -> Self
    
    /// Forms a value with equal magnitude but opposite sign, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a: Int8(-127); a.negateReportingOverflow() // a = Int8( 127); -> false
    /// var b: Int8(-128); b.negateReportingOverflow() // b = Int8(-128); -> true
    /// ```
    ///
    @inlinable mutating func negateReportingOverflow() -> Bool
    
    /// Returns a value with equal magnitude but opposite sign, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int8(-127).negatedReportingOverflow() // -> (partialValue: Int8( 127), overflow: false)
    /// Int8(-128).negatedReportingOverflow() // -> (partialValue: Int8(-128), overflow: true )
    /// ```
    ///
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
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @inlinable public func negated() -> Self {
        let pvo: PVO<Self> = self.negatedReportingOverflow()
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
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
