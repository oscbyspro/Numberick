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
public protocol NBKFixedWidthInteger: NBKBinaryInteger, FixedWidthInteger where
Digit: NBKFixedWidthInteger, Magnitude: NBKFixedWidthInteger, Magnitude.BitPattern == BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bits
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance repeating the given bit, in two's complement form.
    ///
    /// ```swift
    /// Int8(repeating: false) // Int8( 0)
    /// Int8(repeating: true ) // Int8(-1)
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
    /// UInt8(0b00000000).isFull // false
    /// UInt8(0b00001111).isFull // false
    /// UInt8(0b11111111).isFull // true
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
    /// var a: Int8(126); a.addReportingOverflow(Int8(1)) // a = Int8( 127); -> false
    /// var b: Int8(127); b.addReportingOverflow(Int8(1)) // b = Int8(-128); -> true
    /// ```
    ///
    @inlinable mutating func addReportingOverflow(_ amount: Self) -> Bool
    
    /// Forms the sum of adding the given value to this value, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a: Int8(126); a.addReportingOverflow(Int8(1)) // a = Int8( 127); -> false
    /// var b: Int8(127); b.addReportingOverflow(Int8(1)) // b = Int8(-128); -> true
    /// ```
    ///
    @_disfavoredOverload @inlinable mutating func addReportingOverflow(_ amount: Digit) -> Bool
    
    /// Returns the sum of adding the given value to this value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int8(32).addingReportingOverflow(Int8(1)) // (partialValue: Int8(33), overflow: false)
    /// Int8.max.addingReportingOverflow(Int8(1)) // (partialValue: Int8.min, overflow: true )
    /// ```
    ///
    @inlinable func addingReportingOverflow(_ amount: Self) -> PVO<Self>
    
    /// Returns the sum of adding the given value to this value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int8(32).addingReportingOverflow(Int8(1)) // (partialValue: Int8(33), overflow: false)
    /// Int8.max.addingReportingOverflow(Int8(1)) // (partialValue: Int8.min, overflow: true )
    /// ```
    ///
    @_disfavoredOverload @inlinable func addingReportingOverflow(_ amount: Digit) -> PVO<Self>
    
    /// Forms the difference of subtracting the given value from this value, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a: Int8(-127); a.subtractReportingOverflow(1) // a = -128; -> false
    /// var b: Int8(-128); b.subtractReportingOverflow(1) // b =  127; -> true
    /// ```
    ///
    @inlinable mutating func subtractReportingOverflow(_ amount: Self) -> Bool
    
    /// Forms the difference of subtracting the given value from this value, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a: Int8(-127); a.subtractReportingOverflow(1) // a = -128; -> false
    /// var b: Int8(-128); b.subtractReportingOverflow(1) // b =  127; -> true
    /// ```
    ///
    @_disfavoredOverload @inlinable mutating func subtractReportingOverflow(_ amount: Digit) -> Bool
    
    /// Returns the difference of subtracting the given value from this value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int8(33).subtractingReportingOverflow(Int8(1)) // (partialValue: Int8(32), overflow: false)
    /// Int8.min.subtractingReportingOverflow(Int8(1)) // (partialValue: Int8.max, overflow: true )
    /// ```
    ///
    @inlinable func subtractingReportingOverflow(_ amount: Self) -> PVO<Self>
    
    /// Returns the difference of subtracting the given value from this value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int8(33).subtractingReportingOverflow(Int8(1)) // (partialValue: Int8(32), overflow: false)
    /// Int8.min.subtractingReportingOverflow(Int8(1)) // (partialValue: Int8.max, overflow: true )
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
    /// var a = Int8(11); a.multiplyReportingOverflow(by: Int8(4)) // a = Int8(44); -> false
    /// var b = Int8.max; b.multiplyReportingOverflow(by: Int8(4)) // b = Int8(-4); -> true
    /// ```
    ///
    @inlinable mutating func multiplyReportingOverflow(by amount: Self) -> Bool
    
    /// Forms the product of multiplying this value by the given value, and returns an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// var a = Int8(11); a.multiplyReportingOverflow(by: Int8(4)) // a = Int8(44); -> false
    /// var b = Int8.max; b.multiplyReportingOverflow(by: Int8(4)) // b = Int8(-4); -> true
    /// ```
    ///
    @_disfavoredOverload @inlinable mutating func multiplyReportingOverflow(by amount: Digit) -> Bool
    
    /// Returns the product of multiplying this value by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int8(11).multipliedReportingOverflow(by: Int8(4)) // (partialValue: Int8(44), overflow: false)
    /// Int8.max.multipliedReportingOverflow(by: Int8(4)) // (partialValue: Int8(-4), overflow: true )
    /// ```
    ///
    @inlinable func multipliedReportingOverflow(by amount: Self) -> PVO<Self>
    
    /// Returns the product of multiplying this value by the given value, along with an overflow indicator.
    /// In the case of overflow, the result is truncated.
    ///
    /// ```swift
    /// Int8(11).multipliedReportingOverflow(by: Int8(4)) // (partialValue: Int8(44), overflow: false)
    /// Int8.max.multipliedReportingOverflow(by: Int8(4)) // (partialValue: Int8(-4), overflow: true )
    /// ```
    ///
    @_disfavoredOverload @inlinable func multipliedReportingOverflow(by amount: Digit) -> PVO<Self>
    
    /// Forms the low part of multiplying this value by the given value, and returns the high.
    ///
    /// ```swift
    /// var a = Int8(11); a.multiplyFullWidth(by: Int8(4)) // a = Int8(44); -> Int8(0)
    /// var b = Int8.max; b.multiplyFullWidth(by: Int8(4)) // b = Int8(-4); -> Int8(1)
    /// ```
    ///
    @inlinable mutating func multiplyFullWidth(by amount: Self) -> Self
    
    /// Forms the low part of multiplying this value by the given value, and returns the high.
    ///
    /// ```swift
    /// var a = Int8(11); a.multiplyFullWidth(by: Int8(4)) // a = Int8(44); -> Int8(0)
    /// var b = Int8.max; b.multiplyFullWidth(by: Int8(4)) // b = Int8(-4); -> Int8(1)
    /// ```
    ///
    @_disfavoredOverload @inlinable mutating func multiplyFullWidth(by amount: Digit) -> Digit
    
    /// Returns the low and high part of multiplying this value by the given value.
    ///
    /// ```swift
    /// Int8(11).multipliedFullWidth(by: Int8(4)) // (high: Int8(0), low:  UInt8(44))
    /// Int8.max.multipliedFullWidth(by: Int8(4)) // (high: Int8(1), low: ~UInt8( 3))
    /// ```
    ///
    @inlinable func multipliedFullWidth(by amount: Self) -> HL<Self, Magnitude>
    
    /// Returns the low and high part of multiplying this value by the given value.
    ///
    /// ```swift
    /// Int8(11).multipliedFullWidth(by: Int8(4)) // (high: Int8(0), low:  UInt8(44))
    /// Int8.max.multipliedFullWidth(by: Int8(4)) // (high: Int8(1), low: ~UInt8( 3))
    /// ```
    ///
    @_disfavoredOverload @inlinable func multipliedFullWidth(by amount: Digit) -> HL<Digit, Magnitude>
    
    // TODO: documentation
    //=------------------------------------------------------------------------=
    // MARK: Details x Division
    //=------------------------------------------------------------------------=
    
    @inlinable func dividingFullWidth(_ dividend: HL<Self, Magnitude>) -> QR<Self, Self>
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
    /// UInt8(0b00000000).matches(repeating: true ) // false
    /// UInt8(0b00000000).matches(repeating: false) // true
    ///
    /// UInt8(0b00001111).matches(repeating: true ) // false
    /// UInt8(0b00001111).matches(repeating: false) // false
    ///
    /// UInt8(0b11111111).matches(repeating: true ) // true
    /// UInt8(0b11111111).matches(repeating: false) // false
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
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Text
    //=------------------------------------------------------------------------=
    
    @inlinable public static func decodeBigEndianText(_ text: some StringProtocol, radix: Int?) -> Self? {
        let (sign, radix, body) = NBK.bigEndianTextComponents(text, radix: radix)
        guard  let magnitude =  Magnitude(body, radix: radix) else { return nil }
        return Self(sign: sign, magnitude: magnitude)
    }
    
    @inlinable public static func encodeBigEndianText(_ source: Self, radix: Int, uppercase: Bool) -> String {
        String(source, radix: radix, uppercase: uppercase)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Sign & Magnitude
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given integer, if it is representable.
    ///
    /// If the value passed as source is not representable, the result is nil.
    ///
    @inlinable public init?(sign: Bool, magnitude: Magnitude) {
        let isLessThanZero: Bool = sign && !magnitude.isZero
        self.init(bitPattern: isLessThanZero ? magnitude.twosComplement() : magnitude)
        guard self.isLessThanZero == isLessThanZero else { return nil }
    }
}
