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
    
    @inlinable init(repeating bit: Bool)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    @inlinable var isFull: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func addReportingOverflow(_ amount: Self) -> Bool
    
    @_disfavoredOverload @inlinable mutating func addReportingOverflow(_ amount: Digit) -> Bool
    
    @inlinable func addingReportingOverflow(_ amount: Self) -> PVO<Self>
    
    @_disfavoredOverload @inlinable func addingReportingOverflow(_ amount: Digit) -> PVO<Self>
    
    @inlinable mutating func subtractReportingOverflow(_ amount: Self) -> Bool
    
    @_disfavoredOverload @inlinable mutating func subtractReportingOverflow(_ amount: Digit) -> Bool
    
    @inlinable func subtractingReportingOverflow(_ amount: Self) -> PVO<Self>
    
    @_disfavoredOverload @inlinable func subtractingReportingOverflow(_ amount: Digit) -> PVO<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func multiplyReportingOverflow(by amount: Self) -> Bool
    
    @_disfavoredOverload @inlinable mutating func multiplyReportingOverflow(by amount: Digit) -> Bool
    
    @inlinable func multipliedReportingOverflow(by amount: Self) -> PVO<Self>
    
    @_disfavoredOverload @inlinable func multipliedReportingOverflow(by amount: Digit) -> PVO<Self>
    
    @inlinable mutating func multiplyFullWidth(by amount: Self) -> Self
    
    @_disfavoredOverload @inlinable mutating func multiplyFullWidth(by amount: Digit) -> Digit
    
    @inlinable func multipliedFullWidth(by amount: Self) -> HL<Self, Magnitude>
    
    @_disfavoredOverload @inlinable func multipliedFullWidth(by amount: Digit) -> HL<Digit, Magnitude>
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
    
    @inlinable public func matches(repeating bit: Bool) -> Bool {
        bit ? self.isFull : self.isZero
    }

    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +=(lhs: inout Self, rhs: Self) {
        let overflow: Bool = lhs.addReportingOverflow(rhs)
        precondition(!overflow, "overflow in +=")
    }
    
    @_disfavoredOverload @inlinable public static func +=(lhs: inout Self, rhs: Digit) {
        let overflow: Bool = lhs.addReportingOverflow(rhs)
        precondition(!overflow, "overflow in +=")
    }
    
    @inlinable public static func +(lhs: Self, rhs: Self) -> Self {
        let pvo: PVO<Self> = lhs.addingReportingOverflow(rhs)
        precondition(!pvo.overflow, "overflow in +")
        return pvo.partialValue as Self
    }
    
    @_disfavoredOverload @inlinable public static func +(lhs: Self, rhs: Digit) -> Self {
        let pvo: PVO<Self> = lhs.addingReportingOverflow(rhs)
        precondition(!pvo.overflow, "overflow in +")
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
        precondition(!overflow, "overflow in -=")
    }
    
    @_disfavoredOverload @inlinable public static func -=(lhs: inout Self, rhs: Digit) {
        let overflow: Bool = lhs.subtractReportingOverflow(rhs)
        precondition(!overflow, "overflow in -=")
    }
    
    @inlinable public static func -(lhs: Self, rhs: Self) -> Self {
        let pvo: PVO<Self> = lhs.subtractingReportingOverflow(rhs)
        precondition(!pvo.overflow, "overflow in -")
        return pvo.partialValue as Self
    }
    
    @_disfavoredOverload @inlinable public static func -(lhs: Self, rhs: Digit) -> Self {
        let pvo: PVO<Self> = lhs.subtractingReportingOverflow(rhs)
        precondition(!pvo.overflow, "overflow in -")
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
        precondition(!overflow, "overflow in *=")
    }
    
    @_disfavoredOverload @inlinable public static func *=(lhs: inout Self, rhs: Digit) {
        let overflow: Bool = lhs.multiplyReportingOverflow(by: rhs)
        precondition(!overflow, "overflow in *=")
    }
    
    @inlinable public static func *(lhs: Self, rhs: Self) -> Self {
        let pvo: PVO<Self> = lhs.multipliedReportingOverflow(by: rhs)
        precondition(!pvo.overflow, "overflow in *")
        return pvo.partialValue as Self
    }
    
    @_disfavoredOverload @inlinable public static func *(lhs: Self, rhs: Digit) -> Self {
        let pvo: PVO<Self> = lhs.multipliedReportingOverflow(by: rhs)
        precondition(!pvo.overflow, "overflow in *")
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
