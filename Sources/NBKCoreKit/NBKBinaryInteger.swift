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
/// ### Division By Zero
///
/// The result of division by zero mirrors the standard library, when possible.
/// Because the dividend may not fit in the remainder of single digit division,
/// the divisor is returned instead.
///
public protocol NBKBinaryInteger: BinaryInteger, Sendable where Magnitude: NBKUnsignedInteger, Words: Sendable {
    
    /// A machine word of some kind, or this type.
    associatedtype Digit: NBKBinaryInteger = Self where
    Digit.Digit == Digit, Digit.Magnitude == Magnitude.Digit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given digit.
    @inlinable init(digit: Digit)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bits
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given bit.
    ///
    /// ```swift
    /// Int256(bit: false) // Int256(0)
    /// Int256(bit: true ) // Int256(1)
    /// ```
    ///
    /// - Note: This member has two's complement semantics.
    ///
    @inlinable init(bit: Bool)
    
    /// Returns the least significant bit.
    ///
    /// - Note: This member has two's complement semantics.
    ///
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
    
    /// A three-way comparison that returns: `-1` (less), `0` (same), or `1` (more).
    ///
    /// ```swift
    /// Int256(1).compared(to: Int256(3)) // -1 (less)
    /// Int256(2).compared(to: Int256(2)) //  0 (same)
    /// Int256(3).compared(to: Int256(1)) //  1 (more)
    /// ```
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
    /// var a = Int256(1); a += Int256(2) // a = Int256(3)
    /// var b = Int256(2); b += Int256(3) // b = Int256(5)
    /// var c = Int256(3); c += Int256(4) // c = Int256(7)
    /// var d = Int256(4); d += Int256(5) // d = Int256(9)
    /// ```
    ///
    @inlinable static func +=(lhs: inout Self, rhs: Self)
    
    /// Forms the sum of adding `rhs` to `lhs`.
    ///
    /// ```swift
    /// var a = Int256(1); a += Int(2) // a = Int256(3)
    /// var b = Int256(2); b += Int(3) // b = Int256(5)
    /// var c = Int256(3); c += Int(4) // c = Int256(7)
    /// var d = Int256(4); d += Int(5) // d = Int256(9)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func +=(lhs: inout Self, rhs: Digit)
    
    /// Returns the sum of adding `rhs` to `lhs`.
    ///
    /// ```swift
    /// Int256(1) + Int256(2) // Int256(3)
    /// Int256(2) + Int256(3) // Int256(5)
    /// Int256(3) + Int256(4) // Int256(7)
    /// Int256(4) + Int256(5) // Int256(9)
    /// ```
    ///
    @inlinable static func +(lhs: Self, rhs: Self) -> Self
    
    /// Returns the sum of adding `rhs` to `lhs`.
    ///
    /// ```swift
    /// Int256(1) + Int(2) // Int256(3)
    /// Int256(2) + Int(3) // Int256(5)
    /// Int256(3) + Int(4) // Int256(7)
    /// Int256(4) + Int(5) // Int256(9)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func +(lhs: Self, rhs: Digit) -> Self
    
    /// Forms the difference of subtracting `rhs` from `lhs`.
    ///
    /// ```swift
    /// var a = Int256(3); a -= Int256(2) // a = Int256(1)
    /// var b = Int256(5); b -= Int256(3) // b = Int256(2)
    /// var c = Int256(7); c -= Int256(4) // c = Int256(3)
    /// var d = Int256(9); d -= Int256(5) // d = Int256(4)
    /// ```
    ///
    @inlinable static func -=(lhs: inout Self, rhs: Self)
    
    /// Forms the difference of subtracting `rhs` from `lhs`.
    ///
    /// ```swift
    /// var a = Int256(3); a -= Int(2) // a = Int256(1)
    /// var b = Int256(5); b -= Int(3) // b = Int256(2)
    /// var c = Int256(7); c -= Int(4) // c = Int256(3)
    /// var d = Int256(9); d -= Int(5) // d = Int256(4)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func -=(lhs: inout Self, rhs: Digit)
    
    /// Returns the difference of subtracting `rhs` from `lhs`.
    ///
    /// ```swift
    /// Int256(3) - Int256(2) // Int256(1)
    /// Int256(5) - Int256(3) // Int256(2)
    /// Int256(7) - Int256(4) // Int256(3)
    /// Int256(9) - Int256(5) // Int256(4)
    /// ```
    ///
    @inlinable static func -(lhs: Self, rhs: Self) -> Self
    
    /// Returns the difference of subtracting `rhs` from `lhs`.
    ///
    /// ```swift
    /// Int256(3) - Int(2) // Int256(1)
    /// Int256(5) - Int(3) // Int256(2)
    /// Int256(7) - Int(4) // Int256(3)
    /// Int256(9) - Int(5) // Int256(4)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func -(lhs: Self, rhs: Digit) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    /// Forms the product of multiplying `lhs` by `rhs`.
    ///
    /// ```swift
    /// var a = Int256(1); a *= Int256(2) // a = Int256( 2)
    /// var b = Int256(2); b *= Int256(3) // b = Int256( 6)
    /// var c = Int256(3); c *= Int256(4) // c = Int256(12)
    /// var d = Int256(4); d *= Int256(5) // d = Int256(20)
    /// ```
    ///
    @inlinable static func *=(lhs: inout Self, rhs: Self)
    
    /// Forms the product of multiplying `lhs` by `rhs`.
    ///
    /// ```swift
    /// var a = Int256(1); a *= Int(2) // a = Int256( 2)
    /// var b = Int256(2); b *= Int(3) // b = Int256( 6)
    /// var c = Int256(3); c *= Int(4) // c = Int256(12)
    /// var d = Int256(4); d *= Int(5) // d = Int256(20)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func *=(lhs: inout Self, rhs: Digit)
    
    /// Returns the product of multiplying `lhs` by `rhs`.
    ///
    /// ```swift
    /// Int256(1) * Int256(2) // Int256( 2)
    /// Int256(2) * Int256(3) // Int256( 6)
    /// Int256(3) * Int256(4) // Int256(12)
    /// Int256(4) * Int256(5) // Int256(20)
    /// ```
    ///
    @inlinable static func *(lhs: Self, rhs: Self) -> Self
    
    /// Returns the product of multiplying `lhs` by `rhs`.
    ///
    /// ```swift
    /// Int256(1) * Int(2) // Int256( 2)
    /// Int256(2) * Int(3) // Int256( 6)
    /// Int256(3) * Int(4) // Int256(12)
    /// Int256(4) * Int(5) // Int256(20)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func *(lhs: Self, rhs: Digit) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Division
    //=------------------------------------------------------------------------=
    
    /// Forms the quotient of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// var a = Int256( 7); a /= Int256( 3) // a = Int256( 2)
    /// var b = Int256( 7); b /= Int256(-3) // b = Int256(-2)
    /// var c = Int256(-7); c /= Int256( 3) // c = Int256(-2)
    /// var d = Int256(-7); d /= Int256(-3) // d = Int256( 2)
    /// ```
    ///
    @inlinable static func /=(lhs: inout Self, rhs: Self)
    
    /// Forms the quotient of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// var a = Int256( 7); a /= Int( 3) // a = Int256( 2)
    /// var b = Int256( 7); b /= Int(-3) // b = Int256(-2)
    /// var c = Int256(-7); c /= Int( 3) // c = Int256(-2)
    /// var d = Int256(-7); d /= Int(-3) // d = Int256( 2)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func /=(lhs: inout Self, rhs: Digit)
    
    /// Returns the quotient of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// Int256( 7) / Int256( 3) // Int256( 2)
    /// Int256( 7) / Int256(-3) // Int256(-2)
    /// Int256(-7) / Int256( 3) // Int256(-2)
    /// Int256(-7) / Int256(-3) // Int256( 2)
    /// ```
    ///
    @inlinable static func /(lhs: Self, rhs: Self) -> Self
    
    /// Returns the quotient of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// Int256( 7) / Int( 3) // Int256( 2)
    /// Int256( 7) / Int(-3) // Int256(-2)
    /// Int256(-7) / Int( 3) // Int256(-2)
    /// Int256(-7) / Int(-3) // Int256( 2)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func /(lhs: Self, rhs: Digit) -> Self
    
    /// Forms the remainder of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// var a = Int256( 7); a %= Int256( 3) // a = Int256( 1)
    /// var b = Int256( 7); b %= Int256(-3) // b = Int256( 1)
    /// var c = Int256(-7); c %= Int256( 3) // c = Int256(-1)
    /// var d = Int256(-7); d %= Int256(-3) // d = Int256(-1)
    /// ```
    ///
    @inlinable static func %=(lhs: inout Self, rhs: Self)
    
    /// Forms the remainder of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// var a = Int256( 7); a %= Int( 3) // a = Int256( 1)
    /// var b = Int256( 7); b %= Int(-3) // b = Int256( 1)
    /// var c = Int256(-7); c %= Int( 3) // c = Int256(-1)
    /// var d = Int256(-7); d %= Int(-3) // d = Int256(-1)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func %=(lhs: inout Self, rhs: Digit)
    
    /// Returns the remainder of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// Int256( 7) % Int256( 3) // Int256( 1)
    /// Int256( 7) % Int256(-3) // Int256( 1)
    /// Int256(-7) % Int256( 3) // Int256(-1)
    /// Int256(-7) % Int256(-3) // Int256(-1)
    /// ```
    ///
    @inlinable static func %(lhs: Self, rhs: Self) -> Self
    
    /// Returns the remainder of dividing `lhs` by `rhs`.
    ///
    /// ```swift
    /// Int256( 7) % Int( 3) // Int( 1)
    /// Int256( 7) % Int(-3) // Int( 1)
    /// Int256(-7) % Int( 3) // Int(-1)
    /// Int256(-7) % Int(-3) // Int(-1)
    /// ```
    ///
    @_disfavoredOverload @inlinable static func %(lhs: Self, rhs: Digit) -> Digit
    
    /// Forms the quotient of this value divided by the given value, and returns an overflow indicator.
    /// In the case of overflow, the result is either truncated or, if undefined, the dividend.
    ///
    /// ```swift
    /// var a = Int256( 7); a.divideReportingOverflow(by: Int256( 3)) // a = Int256( 2); -> false
    /// var b = Int256.min; b.divideReportingOverflow(by: Int256( 0)) // b = Int256.min; -> true
    /// var c = Int256.min; c.divideReportingOverflow(by: Int256(-1)) // c = Int256.min; -> true
    /// ```
    ///
    @inlinable mutating func divideReportingOverflow(by divisor: Self) -> Bool
    
    /// Forms the quotient of this value divided by the given value, and returns an overflow indicator.
    /// In the case of overflow, the result is either truncated or, if undefined, the dividend.
    ///
    /// ```swift
    /// var a = Int256( 7); a.divideReportingOverflow(by: Int( 3)) // a = Int256( 2); -> false
    /// var b = Int256.min; b.divideReportingOverflow(by: Int( 0)) // b = Int256.min; -> true
    /// var c = Int256.min; c.divideReportingOverflow(by: Int(-1)) // c = Int256.min; -> true
    /// ```
    ///
    @_disfavoredOverload @inlinable mutating func divideReportingOverflow(by divisor: Digit) -> Bool
    
    /// Returns the quotient of this value divided by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is either truncated or, if undefined, the dividend.
    ///
    /// ```swift
    /// Int256( 7).dividedReportingOverflow(by: Int256( 3)) // (partialValue: Int256( 2), overflow: false)
    /// Int256.min.dividedReportingOverflow(by: Int256( 0)) // (partialValue: Int256.min, overflow: true )
    /// Int256.min.dividedReportingOverflow(by: Int256(-1)) // (partialValue: Int256.min, overflow: true )
    /// ```
    ///
    @inlinable func dividedReportingOverflow(by divisor: Self) -> PVO<Self>
    
    /// Returns the quotient of this value divided by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is either truncated or, if undefined, the dividend.
    ///
    /// ```swift
    /// Int256( 7).dividedReportingOverflow(by: Int( 3)) // (partialValue: Int256( 2), overflow: false)
    /// Int256.min.dividedReportingOverflow(by: Int( 0)) // (partialValue: Int256.min, overflow: true )
    /// Int256.min.dividedReportingOverflow(by: Int(-1)) // (partialValue: Int256.min, overflow: true )
    /// ```
    ///
    @_disfavoredOverload @inlinable func dividedReportingOverflow(by divisor: Digit) -> PVO<Self>
    
    /// Forms the remainder of this value divided by the given value, and returns an overflow indicator.
    /// In the case of overflow, the result is either the entire remainder or, if undefined, the dividend.
    ///
    /// ```swift
    /// var a = Int256( 7); a.formRemainderReportingOverflow(dividingBy: Int256( 3)) // a = Int256( 1); -> false
    /// var b = Int256.min; b.formRemainderReportingOverflow(dividingBy: Int256( 0)) // b = Int256.min; -> true
    /// var c = Int256.min; c.formRemainderReportingOverflow(dividingBy: Int256(-1)) // c = Int256( 0); -> true
    /// ```
    ///
    @inlinable mutating func formRemainderReportingOverflow(dividingBy divisor: Self) -> Bool
    
    /// Forms the remainder of this value divided by the given value, and returns an overflow indicator.
    /// In the case of overflow, the result is either the entire remainder or, if undefined, the divisor.
    ///
    /// ```swift
    /// var a = Int256( 7); a.formRemainderReportingOverflow(dividingBy: Int( 3)) // a = Int256(1); -> false
    /// var b = Int256.min; b.formRemainderReportingOverflow(dividingBy: Int( 0)) // b = Int256(0); -> true
    /// var c = Int256.min; c.formRemainderReportingOverflow(dividingBy: Int(-1)) // c = Int256(0); -> true
    /// ```
    ///
    @_disfavoredOverload @inlinable mutating func formRemainderReportingOverflow(dividingBy divisor: Digit) -> Bool
    
    /// Returns the remainder of this value divided by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is either the entire remainder or, if undefined, the dividend.
    ///
    /// ```swift
    /// Int( 7).remainderReportingOverflow(dividingBy: Int( 3)) // (partialValue: Int( 1), overflow: false)
    /// Int.min.remainderReportingOverflow(dividingBy: Int( 0)) // (partialValue: Int.min, overflow: true )
    /// Int.min.remainderReportingOverflow(dividingBy: Int(-1)) // (partialValue: Int( 0), overflow: true )
    /// ```
    ///
    @inlinable func remainderReportingOverflow(dividingBy divisor: Self) -> PVO<Self>
    
    /// Returns the remainder of this value divided by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is either the entire remainder or, if undefined, the divisor.
    ///
    /// ```swift
    /// Int256( 7).remainderReportingOverflow(dividingBy: Int( 3)) // (partialValue: Int(1), overflow: false)
    /// Int256.min.remainderReportingOverflow(dividingBy: Int( 0)) // (partialValue: Int(0), overflow: true )
    /// Int256.min.remainderReportingOverflow(dividingBy: Int(-1)) // (partialValue: Int(0), overflow: true )
    /// ```
    ///
    @_disfavoredOverload @inlinable func remainderReportingOverflow(dividingBy divisor: Digit) -> PVO<Digit>
    
    /// Returns the quotient and remainder of this value divided by the given value.
    ///
    /// ```swift
    /// Int256( 7).quotientAndRemainder(dividingBy: Int256( 3)) // (quotient: Int256( 2), remainder: Int256( 1))
    /// Int256( 7).quotientAndRemainder(dividingBy: Int256(-3)) // (quotient: Int256(-2), remainder: Int256( 1))
    /// Int256(-7).quotientAndRemainder(dividingBy: Int256( 3)) // (quotient: Int256(-2), remainder: Int256(-1))
    /// Int256(-7).quotientAndRemainder(dividingBy: Int256(-3)) // (quotient: Int256( 2), remainder: Int256(-1))
    /// ```
    ///
    @inlinable func quotientAndRemainder(dividingBy divisor: Self) -> QR<Self, Self>
    
    /// Returns the quotient and remainder of this value divided by the given value.
    ///
    /// ```swift
    /// Int256( 7).quotientAndRemainder(dividingBy: Int( 3)) // (quotient: Int256( 2), remainder: Int( 1))
    /// Int256( 7).quotientAndRemainder(dividingBy: Int(-3)) // (quotient: Int256(-2), remainder: Int( 1))
    /// Int256(-7).quotientAndRemainder(dividingBy: Int( 3)) // (quotient: Int256(-2), remainder: Int(-1))
    /// Int256(-7).quotientAndRemainder(dividingBy: Int(-3)) // (quotient: Int256( 2), remainder: Int(-1))
    /// ```
    ///
    @_disfavoredOverload @inlinable func quotientAndRemainder(dividingBy divisor: Digit) -> QR<Self, Digit>
    
    /// Returns the quotient and remainder of this value divided by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is either truncated or, if undefined, the dividend and dividend.
    ///
    /// ```swift
    /// let a = Int256(-7).quotientAndRemainderReportingOverflow(dividingBy: Int256( 3))
    /// a.partialValue.quotient  // Int256( 2) == Int256(-7).dividedReportingOverflow(by: Int256( 3)).partialValue
    /// a.partialValue.remainder // Int256(-1) == Int256(-7).remainderReportingOverflow(dividingBy: Int256( 3)).partialValue
    /// a.overflow               // false
    ///
    /// let b = Int256.min.quotientAndRemainderReportingOverflow(dividingBy: Int256( 0))
    /// b.partialValue.quotient  // Int256.min == Int256.min.dividedReportingOverflow(by: Int256( 0)).partialValue
    /// b.partialValue.remainder // Int256.min == Int256.min.remainderReportingOverflow(dividingBy: Int256( 0)).partialValue
    /// b.overflow               // true
    ///
    /// let c = Int256.min.quotientAndRemainderReportingOverflow(dividingBy: Int256(-1))
    /// c.partialValue.quotient  // Int256.min == Int256.min.dividedReportingOverflow(by: Int256(-1)).partialValue
    /// c.partialValue.remainder // Int256( 0) == Int256.min.remainderReportingOverflow(dividingBy: Int256(-1)).partialValue
    /// c.overflow               // true
    /// ```
    ///
    @inlinable func quotientAndRemainderReportingOverflow(dividingBy divisor: Self) -> PVO<QR<Self, Self>>
    
    /// Returns the quotient and remainder of this value divided by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is either truncated or, if undefined, the dividend and divisor.
    ///
    /// ```swift
    /// let a = Int256(-7).quotientAndRemainderReportingOverflow(dividingBy: Int256( 3))
    /// a.partialValue.quotient  // Int256( 2) == Int256(-7).dividedReportingOverflow(by: Int( 3)).partialValue
    /// a.partialValue.remainder // Int(   -1) == Int256(-7).remainderReportingOverflow(dividingBy: Int( 3)).partialValue
    /// a.overflow               // false
    ///
    /// let b = Int256.min.quotientAndRemainderReportingOverflow(dividingBy: Int256( 0))
    /// b.partialValue.quotient  // Int256.min == Int256.min.dividedReportingOverflow(by: Int( 0)).partialValue
    /// b.partialValue.remainder // Int(    0) == Int256.min.remainderReportingOverflow(dividingBy: Int( 0)).partialValue
    /// b.overflow               // true
    ///
    /// let c = Int256.min.quotientAndRemainderReportingOverflow(dividingBy: Int256(-1))
    /// c.partialValue.quotient  // Int256.min == Int256.min.dividedReportingOverflow(by: Int(-1)).partialValue
    /// c.partialValue.remainder // Int(    0) == Int256.min.remainderReportingOverflow(dividingBy: Int(-1)).partialValue
    /// c.overflow               // true
    /// ```
    ///
    @_disfavoredOverload @inlinable func quotientAndRemainderReportingOverflow(dividingBy divisor: Digit) -> PVO<QR<Self, Digit>>
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Text
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given string and radix.
    @inlinable init?(_ description: some StringProtocol, radix: Int)
    
    /// Creates a string representing this value, in the given format.
    @inlinable func description(radix: Int, uppercase: Bool) -> String
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
    
    /// Returns whether this value is odd.
    ///
    /// Semantically, it is equivalent to the following expression:
    ///
    /// ```swift
    /// self.leastSignificantBit == true
    /// ```
    ///
    @inlinable public var isOdd: Bool {
        self.leastSignificantBit
    }
    
    /// Returns whether this value is even.
    ///
    /// Semantically, it is equivalent to the following expression:
    ///
    /// ```swift
    /// self.leastSignificantBit == false
    /// ```
    ///
    @inlinable public var isEven: Bool {
        !self.leastSignificantBit
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

//=----------------------------------------------------------------------------=
// MARK: + Details x Text x String
//=----------------------------------------------------------------------------=

extension String {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a string representing the given value, in the given format.
    @inlinable public init(_ integer: some NBKBinaryInteger, radix: Int = 10, uppercase: Bool = false) {
        self = integer.description(radix: radix, uppercase: uppercase)
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
    /// -Int256( 1) // Int256(-1)
    /// -Int256( 0) // Int256( 0)
    /// -Int256(-1) // Int256( 1)
    /// ```
    ///
    @inlinable static prefix func -(x: Self) -> Self
    
    /// Forms a value with equal magnitude but opposite sign.
    ///
    /// ```swift
    /// var a = Int256( 1); a.negate() // a = Int256(-1)
    /// var b = Int256( 0); b.negate() // b = Int256( 0)
    /// var c = Int256(-1); c.negate() // c = Int256( 1)
    /// ```
    ///
    @inlinable mutating func negate()
    
    /// Returns a value with equal magnitude but opposite sign.
    ///
    /// ```swift
    /// Int256( 1).negated() // Int256(-1)
    /// Int256( 0).negated() // Int256( 0)
    /// Int256(-1).negated() // Int256( 1)
    /// ```
    ///
    @inlinable func negated() -> Self
    
    /// Forms a value with equal magnitude but opposite sign, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a: Int256.min + 1; a.negateReportingOverflow() // a = Int256.max; -> false
    /// var b: Int256.min + 0; b.negateReportingOverflow() // b = Int256.min; -> true
    /// ```
    ///
    @inlinable mutating func negateReportingOverflow() -> Bool
    
    /// Returns a value with equal magnitude but opposite sign, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// (Int256.min + 1).negatedReportingOverflow() // -> (partialValue: Int256.max, overflow: false)
    /// (Int256.min + 0).negatedReportingOverflow() // -> (partialValue: Int256.min, overflow: true )
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
