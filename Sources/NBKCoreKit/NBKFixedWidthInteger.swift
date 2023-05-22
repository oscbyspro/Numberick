//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Fixed Width Integer
//*============================================================================*

/// A fixed-width, binary, integer.
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
public protocol NBKFixedWidthInteger: NBKBinaryInteger, NBKBitPatternConvertible, FixedWidthInteger where
Digit: NBKFixedWidthInteger, Magnitude: NBKFixedWidthInteger, Magnitude.BitPattern == BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bits
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance repeating the given bit, in two's complement form.
    ///
    /// ```swift
    /// Int256(repeating: false) // Int256( 0)
    /// Int256(repeating: true ) // Int256(-1)
    /// ```
    ///
    @inlinable init(repeating bit: Bool)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    /// Returns whether all of its bits are set, in two's complement form.
    ///
    /// The return value can be viewed as the bitwise inverse of ``isZero``.
    ///
    /// ```swift
    /// Int256( 0).isFull // false
    /// Int256( 1).isFull // false
    /// Int256(-1).isFull // true
    /// ```
    ///
    @inlinable var isFull: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    /// Forms the sum of adding the given value to this value, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a: Int256(32); a.addReportingOverflow(Int256(1)) // a = Int256(33); -> false
    /// var b: Int256.max; b.addReportingOverflow(Int256(1)) // b = Int256.min; -> true
    /// ```
    ///
    @inlinable mutating func addReportingOverflow(_ amount: Self) -> Bool
    
    /// Forms the sum of adding the given value to this value, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a: Int256(32); a.addReportingOverflow(Int(1)) // a = Int256(33); -> false
    /// var b: Int256.max; b.addReportingOverflow(Int(1)) // b = Int256.min; -> true
    /// ```
    ///
    @_disfavoredOverload @inlinable mutating func addReportingOverflow(_ amount: Digit) -> Bool
    
    /// Returns the sum of adding the given value to this value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int256(32).addingReportingOverflow(Int256(1)) // (partialValue: Int256(33), overflow: false)
    /// Int256.max.addingReportingOverflow(Int256(1)) // (partialValue: Int256.min, overflow: true )
    /// ```
    ///
    @inlinable func addingReportingOverflow(_ amount: Self) -> PVO<Self>
    
    /// Returns the sum of adding the given value to this value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int256(32).addingReportingOverflow(Int(1)) // (partialValue: Int256(33), overflow: false)
    /// Int256.max.addingReportingOverflow(Int(1)) // (partialValue: Int256.min, overflow: true )
    /// ```
    ///
    @_disfavoredOverload @inlinable func addingReportingOverflow(_ amount: Digit) -> PVO<Self>
    
    /// Forms the difference of subtracting the given value from this value, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a: Int256(33); a.subtractReportingOverflow(Int256(1)) // a = Int256(32); -> false
    /// var b: Int256.min; b.subtractReportingOverflow(Int256(1)) // b = Int256.max; -> true
    /// ```
    ///
    @inlinable mutating func subtractReportingOverflow(_ amount: Self) -> Bool
    
    /// Forms the difference of subtracting the given value from this value, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a: Int256(33); a.subtractReportingOverflow(Int(1)) // a = Int256(32); -> false
    /// var b: Int256.min; b.subtractReportingOverflow(Int(1)) // b = Int256.max; -> true
    /// ```
    ///
    @_disfavoredOverload @inlinable mutating func subtractReportingOverflow(_ amount: Digit) -> Bool
    
    /// Returns the difference of subtracting the given value from this value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int256(33).subtractingReportingOverflow(Int256(1)) // (partialValue: Int256(32), overflow: false)
    /// Int256.min.subtractingReportingOverflow(Int256(1)) // (partialValue: Int256.max, overflow: true )
    /// ```
    ///
    @inlinable func subtractingReportingOverflow(_ amount: Self) -> PVO<Self>
    
    /// Returns the difference of subtracting the given value from this value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int256(33).subtractingReportingOverflow(Int(1)) // (partialValue: Int256(32), overflow: false)
    /// Int256.min.subtractingReportingOverflow(Int(1)) // (partialValue: Int256.max, overflow: true )
    /// ```
    ///
    @_disfavoredOverload @inlinable func subtractingReportingOverflow(_ amount: Digit) -> PVO<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    /// Forms the product of multiplying this value by the given value, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a = Int256(11); a.multiplyReportingOverflow(by: Int256(4)) // a = Int256(44); -> false
    /// var b = Int256.max; b.multiplyReportingOverflow(by: Int256(4)) // b = Int256(-4); -> true
    /// ```
    ///
    @inlinable mutating func multiplyReportingOverflow(by amount: Self) -> Bool
    
    /// Forms the product of multiplying this value by the given value, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a = Int256(11); a.multiplyReportingOverflow(by: Int(4)) // a = Int256(44); -> false
    /// var b = Int256.max; b.multiplyReportingOverflow(by: Int(4)) // b = Int256(-4); -> true
    /// ```
    ///
    @_disfavoredOverload @inlinable mutating func multiplyReportingOverflow(by amount: Digit) -> Bool
    
    /// Returns the product of multiplying this value by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int256(11).multipliedReportingOverflow(by: Int256(4)) // (partialValue: Int256(44), overflow: false)
    /// Int256.max.multipliedReportingOverflow(by: Int256(4)) // (partialValue: Int256(-4), overflow: true )
    /// ```
    ///
    @inlinable func multipliedReportingOverflow(by amount: Self) -> PVO<Self>
    
    /// Returns the product of multiplying this value by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int256(11).multipliedReportingOverflow(by: Int(4)) // (partialValue: Int256(44), overflow: false)
    /// Int256.max.multipliedReportingOverflow(by: Int(4)) // (partialValue: Int256(-4), overflow: true )
    /// ```
    ///
    @_disfavoredOverload @inlinable func multipliedReportingOverflow(by amount: Digit) -> PVO<Self>
    
    /// Forms the low part of multiplying this value by the given value, and returns the high.
    ///
    /// ```swift
    /// var a = Int256(11); a.multiplyFullWidth(by: Int256(4)) // a = Int256(44); -> Int256(0)
    /// var b = Int256.max; b.multiplyFullWidth(by: Int256(4)) // b = Int256(-4); -> Int256(1)
    /// ```
    ///
    @inlinable mutating func multiplyFullWidth(by amount: Self) -> Self
    
    /// Forms the low part of multiplying this value by the given value, and returns the high.
    ///
    /// ```swift
    /// var a = Int256(11); a.multiplyFullWidth(by: Int(4)) // a = Int256(44); -> Int(0)
    /// var b = Int256.max; b.multiplyFullWidth(by: Int(4)) // b = Int256(-4); -> Int(1)
    /// ```
    ///
    @_disfavoredOverload @inlinable mutating func multiplyFullWidth(by amount: Digit) -> Digit
    
    /// Returns the low and high part of multiplying this value by the given value.
    ///
    /// ```swift
    /// Int256(11).multipliedFullWidth(by: Int256(4)) // (high: Int256(0), low:  UInt256(44))
    /// Int256.max.multipliedFullWidth(by: Int256(4)) // (high: Int256(1), low: ~UInt256( 3))
    /// ```
    ///
    @inlinable func multipliedFullWidth(by amount: Self) -> HL<Self, Magnitude>
    
    /// Returns the low and high part of multiplying this value by the given value.
    ///
    /// ```swift
    /// Int256(11).multipliedFullWidth(by: Int(4)) // (high: Int(0), low:  UInt256(44))
    /// Int256.max.multipliedFullWidth(by: Int(4)) // (high: Int(1), low: ~UInt256( 3))
    /// ```
    ///
    @_disfavoredOverload @inlinable func multipliedFullWidth(by amount: Digit) -> HL<Digit, Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Division
    //=------------------------------------------------------------------------=
    
    /// Returns a the quotient and remainder of dividing the given value by this value.
    ///
    /// The resulting quotient must be representable within the bounds of the type. If
    /// the quotient is too large to represent in the type, a runtime error may occur.
    ///
    /// ```swift
    /// let (dividend) = (high: Int256.max / 2, low: UInt256.max / 2)
    /// let (quotient, remainder) =  (Int256.max).dividingFullWidth(dividend)
    /// //  (quotient, remainder) == (Int256.max, Int256.max - 1)
    /// ````
    ///
    @inlinable func dividingFullWidth(_ dividend: HL<Self, Magnitude>) -> QR<Self, Self>
    
    /// Returns the quotient and remainder of this value divided by the given value,
    /// along with an overflow indicator. In the case of overflow, the result is either
    /// truncated or, if undefined, the dividend and dividend.
    ///
    /// ```swift
    /// let ((dividend)) = (high: Int256.max / 2, low: UInt256.max / 2)
    /// let ((quotient, remainder), overflow) =  ((Int256.max)).dividingFullWidthReportingOverflow(dividend)
    /// //  ((quotient, remainder), overflow) == ((Int256.max, Int256.max - 1), false)
    /// ````
    ///
    /// ```swift
    /// let (dividend) = (high: Int256.max / 2, low: UInt256.max / 2 + 1)
    /// let ((quotient, remainder), overflow) =  ((Int256.max)).dividingFullWidthReportingOverflow(dividend)
    /// //  ((quotient, remainder), overflow) == ((Int256.max, Int256.max - 1), true)
    /// ````
    ///
    /// ```swift
    /// let (dividend) = (high: Int256.max / 2, low: UInt256.max / 2 + 1)
    /// let ((quotient, remainder), overflow) =  ((Int256( 0))).dividingFullWidthReportingOverflow(dividend)
    /// //  ((quotient, remainder), overflow) == ((Int256.max / 2, Int256.max / 2), true)
    /// ````
    ///
    @inlinable func dividingFullWidthReportingOverflow(_ dividend: HL<Self, Magnitude>) -> PVO<QR<Self, Self>>
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NBKFixedWidthInteger {
        
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable public var isFull: Bool {
        self.nonzeroBitCount == self.bitWidth
    }
    
    @inlinable public var isPowerOf2: Bool {
        self.nonzeroBitCount == 1
    }
    
    /// Returns whether this value matches the given bit pattern, in two's complement form.
    ///
    /// ```swift
    /// Int256( 0).matches(repeating: true ) // false
    /// Int256( 1).matches(repeating: true ) // false
    /// Int256(-1).matches(repeating: true ) // true
    ///
    /// Int256( 0).matches(repeating: false) // true
    /// Int256( 1).matches(repeating: false) // false
    /// Int256(-1).matches(repeating: false) // false
    /// ```
    ///
    @inlinable public func matches(repeating bit: Bool) -> Bool {
        bit ? self.isFull : self.isZero
    }

    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +=(lhs: inout Self, rhs: Self) {
        let overflow: Bool = lhs.addReportingOverflow(rhs)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @_disfavoredOverload @inlinable public static func +=(lhs: inout Self, rhs: Digit) {
        let overflow: Bool = lhs.addReportingOverflow(rhs)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @inlinable public static func +(lhs: Self, rhs: Self) -> Self {
        let pvo: PVO<Self> = lhs.addingReportingOverflow(rhs)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as Self
    }
    
    @_disfavoredOverload @inlinable public static func +(lhs: Self, rhs: Digit) -> Self {
        let pvo: PVO<Self> = lhs.addingReportingOverflow(rhs)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as Self
    }
    
    @inlinable public static func &+=(lhs: inout Self, rhs: Self) {
        _ = lhs.addReportingOverflow(rhs)
    }
    
    @_disfavoredOverload @inlinable public static func &+=(lhs: inout Self, rhs: Digit) {
        _ = lhs.addReportingOverflow(rhs)
    }
    
    @inlinable public static func &+(lhs: Self, rhs: Self) -> Self {
        lhs.addingReportingOverflow(rhs).partialValue
    }
    
    @_disfavoredOverload @inlinable public static func &+(lhs: Self, rhs: Digit) -> Self {
        lhs.addingReportingOverflow(rhs).partialValue
    }
    
    @inlinable public static func -=(lhs: inout Self, rhs: Self) {
        let overflow: Bool = lhs.subtractReportingOverflow(rhs)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @_disfavoredOverload @inlinable public static func -=(lhs: inout Self, rhs: Digit) {
        let overflow: Bool = lhs.subtractReportingOverflow(rhs)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @inlinable public static func -(lhs: Self, rhs: Self) -> Self {
        let pvo: PVO<Self> = lhs.subtractingReportingOverflow(rhs)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as Self
    }
    
    @_disfavoredOverload @inlinable public static func -(lhs: Self, rhs: Digit) -> Self {
        let pvo: PVO<Self> = lhs.subtractingReportingOverflow(rhs)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as Self
    }
    
    @inlinable public static func &-=(lhs: inout Self, rhs: Self) {
        _ = lhs.subtractReportingOverflow(rhs)
    }
    
    @_disfavoredOverload @inlinable public static func &-=(lhs: inout Self, rhs: Digit) {
        _ = lhs.subtractReportingOverflow(rhs)
    }
    
    @inlinable public static func &-(lhs: Self, rhs: Self) -> Self {
        lhs.subtractingReportingOverflow(rhs).partialValue
    }
    
    @_disfavoredOverload @inlinable public static func &-(lhs: Self, rhs: Digit) -> Self {
        lhs.subtractingReportingOverflow(rhs).partialValue
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *=(lhs: inout Self, rhs: Self) {
        let overflow: Bool = lhs.multiplyReportingOverflow(by: rhs)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @_disfavoredOverload @inlinable public static func *=(lhs: inout Self, rhs: Digit) {
        let overflow: Bool = lhs.multiplyReportingOverflow(by: rhs)
        precondition(!overflow, NBK.callsiteOverflowInfo())
    }
    
    @inlinable public static func *(lhs: Self, rhs: Self) -> Self {
        let pvo: PVO<Self> = lhs.multipliedReportingOverflow(by: rhs)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as Self
    }
    
    @_disfavoredOverload @inlinable public static func *(lhs: Self, rhs: Digit) -> Self {
        let pvo: PVO<Self> = lhs.multipliedReportingOverflow(by: rhs)
        precondition(!pvo.overflow, NBK.callsiteOverflowInfo())
        return pvo.partialValue as Self
    }
    
    @inlinable public static func &*=(lhs: inout Self, rhs: Self) {
        _ = lhs.multiplyReportingOverflow(by: rhs)
    }
    
    @_disfavoredOverload @inlinable public static func &*=(lhs: inout Self, rhs: Digit) {
        _ = lhs.multiplyReportingOverflow(by: rhs)
    }
    
    @inlinable public static func &*(lhs: Self, rhs: Self) -> Self {
        lhs.multipliedReportingOverflow(by: rhs).partialValue
    }
    
    @_disfavoredOverload @inlinable public static func &*(lhs: Self, rhs: Digit) -> Self {
        lhs.multipliedReportingOverflow(by: rhs).partialValue
    }
}
