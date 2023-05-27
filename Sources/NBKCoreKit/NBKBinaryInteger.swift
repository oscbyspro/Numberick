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

/// An integer type with a binary representation.
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
public protocol NBKBinaryInteger: BinaryInteger, Sendable where Magnitude: NBKUnsignedInteger, Words: Sendable {
    
    /// A machine word of some kind, or this type.
    associatedtype Digit: NBKBinaryInteger = Self where
    Digit.Digit == Digit, Digit.Magnitude == Magnitude.Digit
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given digit.
    ///
    /// ```
    /// ┌──────── → ────────── = ────────────┐
    /// │ digit   │ self       │ bit pattern │
    /// ├──────── → ────────── = ────────────┤
    /// │ Int( 0) │ Int256( 0) │ 0.......... │
    /// │ Int(-1) │ Int256(-1) │ 1.......... │
    /// └──────── → ────────── = ────────────┘
    /// ```
    ///
    @inlinable init(digit: Digit)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bits
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given bit.
    ///
    /// ```
    /// ┌────── → ────────── = ────────────┐
    /// │ bit   │ self       │ bit pattern │
    /// ├────── → ────────── = ────────────┤
    /// │ false │ Int256( 0) │ 0.......... │
    /// │ true  │ Int256( 1) │ 0.........1 │
    /// └────── → ────────── = ────────────┘
    /// ```
    ///
    /// - Note: This member has two's complement semantics.
    ///
    @inlinable init(bit: Bool)
    
    /// Returns the least significant bit (`LSB`).
    ///
    /// ```
    /// ┌─────────── = ─────────── → ──────┐
    /// │ self       │ bit pattern │ LSB   │
    /// ├─────────── = ─────────── → ──────┤
    /// │ Int256( 3) │ 0........11 │ true  │
    /// │ Int256( 2) │ 0........10 │ false │
    /// │ Int256( 1) │ 0.........1 │ true  │
    /// │ Int256( 0) │ 0.......... │ false │
    /// │ Int256(-1) │ 1.......... │ true  │
    /// │ Int256(-2) │ 1.........0 │ false │
    /// │ Int256(-3) │ 1........01 │ true  │
    /// │ Int256(-4) │ 1........11 │ false │
    /// └─────────── = ─────────── → ──────┘
    /// ```
    ///
    /// - Note: This member has two's complement semantics.
    ///
    @inlinable var leastSignificantBit: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    /// Returns whether this value is equal to zero.
    ///
    /// ```
    /// ┌─────────── = ─────────── → ───────┐
    /// │ self       │ bit pattern │ x == 0 │
    /// ├─────────── = ─────────── → ───────┤
    /// │ Int256( 3) │ 0........11 │ false │
    /// │ Int256( 2) │ 0........10 │ false │
    /// │ Int256( 1) │ 0.........1 │ false │
    /// │ Int256( 0) │ 0.......... │ true  │
    /// │ Int256(-1) │ 1.......... │ false │
    /// │ Int256(-2) │ 1.........0 │ false │
    /// │ Int256(-3) │ 1........01 │ false │
    /// │ Int256(-4) │ 1........00 │ false │
    /// └─────────── = ─────────── → ──────┘
    /// ```
    ///
    @inlinable var isZero: Bool { get }
    
    /// Returns whether this value is less than zero.
    ///
    /// ```
    /// ┌─────────── = ─────────── → ───────┐
    /// │ self       │ bit pattern │ x <  0 │
    /// ├─────────── = ─────────── → ───────┤
    /// │ Int256( 3) │ 0........11 │ false  │
    /// │ Int256( 2) │ 0........10 │ false  │
    /// │ Int256( 1) │ 0.........1 │ false  │
    /// │ Int256( 0) │ 0.......... │ false  │
    /// │ Int256(-1) │ 1.......... │ true   │
    /// │ Int256(-2) │ 1.........0 │ true   │
    /// │ Int256(-3) │ 1........01 │ true   │
    /// │ Int256(-4) │ 1........00 │ true   │
    /// └─────────── = ─────────── → ───────┘
    /// ```
    ///
    /// Semantically, it is equivalent to the following expression:
    ///
    /// ```swift
    /// leadingZeroBitCount == 0
    /// ```
    ///
    @inlinable var isLessThanZero: Bool { get }
    
    /// Returns whether this value is more than zero.
    ///
    /// ```
    /// ┌─────────── = ─────────── → ───────┐
    /// │ self       │ bit pattern │ x >  0 │
    /// ├─────────── = ─────────── → ───────┤
    /// │ Int256( 3) │ 0........11 │ true   │
    /// │ Int256( 2) │ 0........10 │ true   │
    /// │ Int256( 1) │ 0.........1 │ true   │
    /// │ Int256( 0) │ 0.......... │ false  │
    /// │ Int256(-1) │ 1.......... │ false  │
    /// │ Int256(-2) │ 1.........0 │ false  │
    /// │ Int256(-3) │ 1........01 │ false  │
    /// │ Int256(-4) │ 1........00 │ false  │
    /// └─────────── = ─────────── → ───────┘
    /// ```
    ///
    /// Semantically, it is equivalent to the following expression:
    ///
    /// ```swift
    /// 1 ..< bitWidth ~= leadingZeroBitCount
    /// ```
    ///
    @inlinable var isMoreThanZero: Bool { get }
    
    /// Returns whether this value is a power of `2`.
    ///
    /// ```
    /// ┌─────────── = ─────────── → ──────────┐
    /// │ self       │ bit pattern │ pow(2, x) │
    /// ├─────────── = ─────────── → ──────────┤
    /// │ Int256( 3) │ 0........11 │ false     │
    /// │ Int256( 2) │ 0........10 │ true      │
    /// │ Int256( 1) │ 0.........1 │ true      │
    /// │ Int256( 0) │ 0.......... │ false     │
    /// │ Int256(-1) │ 1.......... │ false     │
    /// │ Int256(-2) │ 1.........0 │ false     │
    /// │ Int256(-3) │ 1........01 │ false     │
    /// │ Int256(-4) │ 1........00 │ false     │
    /// └─────────── = ─────────── → ──────────┘
    /// ```
    ///
    /// Semantically, it is equivalent to the following expression:
    ///
    /// ```swift
    /// nonzeroBitCount == 1
    /// ```
    ///
    @inlinable var isPowerOf2: Bool { get }
    
    /// A three-way comparison that returns: `-1` (less), `0` (same), or `1` (more).
    ///
    /// ```
    /// ┌────────────┬─────────── → ────────┐
    /// │ self       │ other      │ signum  │
    /// ├────────────┼─────────── → ────────┤
    /// │ Int256( 1) │ Int256( 3) │ Int(-1) │ - less
    /// │ Int256( 2) │ Int256( 2) │ Int( 0) │ - same
    /// │ Int256( 3) │ Int256( 1) │ Int( 1) │ - more
    /// └────────────┴─────────── → ────────┘
    /// ```
    ///
    @inlinable func compared(to other: Self) -> Int
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    /// Forms the two's complement of `self`.
    ///
    /// ```
    /// ┌─────────── → ───────────┬──────────┐
    /// │ self       │ ~self + 1  │ overflow │
    /// ├─────────── → ───────────┼──────────┤
    /// │ Int256( 1) │ Int256(-1) │ false    │
    /// │ Int256( 0) │ Int256( 0) │ false    │
    /// │ Int256(-1) │ Int256( 1) │ false    │
    /// ├─────────── → ───────────┼──────────┤
    /// | Int256.min | Int256.min | true     |
    /// └─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @inlinable mutating func formTwosComplement()
    
    /// Returns the two's complement of `self`.
    ///
    /// ```
    /// ┌─────────── → ───────────┬──────────┐
    /// │ self       │ ~x + 1     │ overflow │
    /// ├─────────── → ───────────┼──────────┤
    /// │ Int256( 1) │ Int256(-1) │ false    │
    /// │ Int256( 0) │ Int256( 0) │ false    │
    /// │ Int256(-1) │ Int256( 1) │ false    │
    /// ├─────────── → ───────────┼──────────┤
    /// | Int256.min | Int256.min | true     |
    /// └─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @inlinable func twosComplement() -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    /// Forms the `sum` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ sum        │ overflow │
    /// ├────────────┼─────────── → ───────────┼──────────┤
    /// │ Int256( 1) │ Int256( 4) │ Int256( 5) │ false    │
    /// │ Int256( 2) │ Int256(-3) │ Int256(-1) │ false    │
    /// │ Int256(-3) │ Int256( 2) │ Int256(-1) │ false    │
    /// │ Int256(-4) │ Int256(-1) │ Int256(-5) │ false    │
    /// │────────────┤─────────── → ───────────┤──────────┤
    /// │ Int256.max │ Int256( 1) │ Int256.min │ true     │
    /// │ Int256.min │ Int256(-1) │ Int256.max │ true     │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static func +=(lhs: inout Self, rhs: Self)
    
    /// Forms the `sum` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ sum        │ overflow │
    /// ├────────────┼─────────── → ───────────┼──────────┤
    /// │ Int256( 1) │ Int(    4) │ Int256( 5) │ false    │
    /// │ Int256( 2) │ Int(   -3) │ Int256(-1) │ false    │
    /// │ Int256(-3) │ Int(    2) │ Int256(-1) │ false    │
    /// │ Int256(-4) │ Int(   -1) │ Int256(-5) │ false    │
    /// │────────────┤─────────── → ───────────┤──────────┤
    /// │ Int256.max │ Int(    1) │ Int256.min │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.max │ true     │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @_disfavoredOverload @inlinable static func +=(lhs: inout Self, rhs: Digit)
    
    /// Returns the `sum` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ sum        │ overflow │
    /// ├────────────┼─────────── → ───────────┼──────────┤
    /// │ Int256( 1) │ Int256( 4) │ Int256( 5) │ false    │
    /// │ Int256( 2) │ Int256(-3) │ Int256(-1) │ false    │
    /// │ Int256(-3) │ Int256( 2) │ Int256(-1) │ false    │
    /// │ Int256(-4) │ Int256(-1) │ Int256(-5) │ false    │
    /// │────────────┤─────────── → ───────────┤──────────┤
    /// │ Int256.max │ Int256( 1) │ Int256.min │ true     │
    /// │ Int256.min │ Int256(-1) │ Int256.max │ true     │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static func +(lhs: Self, rhs: Self) -> Self
    
    /// Returns the `sum` of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ sum        │ overflow │
    /// ├────────────┼─────────── → ───────────┼──────────┤
    /// │ Int256( 1) │ Int(    4) │ Int256( 5) │ false    │
    /// │ Int256( 2) │ Int(   -3) │ Int256(-1) │ false    │
    /// │ Int256(-3) │ Int(    2) │ Int256(-1) │ false    │
    /// │ Int256(-4) │ Int(   -1) │ Int256(-5) │ false    │
    /// │────────────┤─────────── → ───────────┤──────────┤
    /// │ Int256.max │ Int(    1) │ Int256.min │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.max │ true     │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @_disfavoredOverload @inlinable static func +(lhs: Self, rhs: Digit) -> Self
    
    /// Forms the `difference` of `lhs` rhs `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ difference │ overflow │
    /// ├────────────┼─────────── → ───────────┤──────────┤
    /// │ Int256( 1) │ Int256( 4) │ Int256(-3) │ false    │
    /// │ Int256( 2) │ Int256(-3) │ Int256( 5) │ false    │
    /// │ Int256(-3) │ Int256( 2) │ Int256(-5) │ false    │
    /// │ Int256(-4) │ Int256(-1) │ Int256(-3) │ false    │
    /// │────────────┤─────────── → ───────────┤──────────┤
    /// │ Int256.max │ Int256(-1) │ Int256.min │ true     │
    /// │ Int256.min │ Int256( 1) │ Int256.max │ true     │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static func -=(lhs: inout Self, rhs: Self)
    
    /// Forms the `difference` of `lhs` rhs `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ difference │ overflow │
    /// ├────────────┼─────────── → ───────────┤──────────┤
    /// │ Int256( 1) │ Int(    4) │ Int256(-3) │ false    │
    /// │ Int256( 2) │ Int(   -3) │ Int256( 5) │ false    │
    /// │ Int256(-3) │ Int(    2) │ Int256(-5) │ false    │
    /// │ Int256(-4) │ Int(   -1) │ Int256(-3) │ false    │
    /// │────────────┤─────────── → ───────────┤──────────┤
    /// │ Int256.max │ Int(   -1) │ Int256.min │ true     │
    /// │ Int256.min │ Int(    1) │ Int256.max │ true     │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @_disfavoredOverload @inlinable static func -=(lhs: inout Self, rhs: Digit)
    
    /// Returns the `difference` of `lhs` rhs `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ difference │ overflow │
    /// ├────────────┼─────────── → ───────────┤──────────┤
    /// │ Int256( 1) │ Int256( 4) │ Int256(-3) │ false    │
    /// │ Int256( 2) │ Int256(-3) │ Int256( 5) │ false    │
    /// │ Int256(-3) │ Int256( 2) │ Int256(-5) │ false    │
    /// │ Int256(-4) │ Int256(-1) │ Int256(-3) │ false    │
    /// │────────────┤─────────── → ───────────┤──────────┤
    /// │ Int256.max │ Int256(-1) │ Int256.min │ true     │
    /// │ Int256.min │ Int256( 1) │ Int256.max │ true     │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static func -(lhs: Self, rhs: Self) -> Self
    
    /// Returns the `difference` of `lhs` rhs `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ lhs        │ rhs        │ difference │ overflow │
    /// ├────────────┼─────────── → ───────────┤──────────┤
    /// │ Int256( 1) │ Int(    4) │ Int256(-3) │ false    │
    /// │ Int256( 2) │ Int(   -3) │ Int256( 5) │ false    │
    /// │ Int256(-3) │ Int(    2) │ Int256(-5) │ false    │
    /// │ Int256(-4) │ Int(   -1) │ Int256(-3) │ false    │
    /// │────────────┤─────────── → ───────────┤──────────┤
    /// │ Int256.max │ Int(   -1) │ Int256.min │ true     │
    /// │ Int256.min │ Int(    1) │ Int256.max │ true     │
    /// └────────────┴─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @_disfavoredOverload @inlinable static func -(lhs: Self, rhs: Digit) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    /// Forms the `low` product of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ low        | high       │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 1) │ Int256( 4) │ Int256( 4) │ Int256( 0) │ false    │
    /// │ Int256( 2) │ Int256(-3) │ Int256(-6) │ Int256(-1) │ false    │
    /// │ Int256(-3) │ Int256( 2) │ Int256(-6) │ Int256(-1) │ false    │
    /// │ Int256(-4) │ Int256(-1) │ Int256( 4) │ Int256( 0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256.max │ Int256( 2) │ Int256(-2) │ Int256( 0) │ true     │
    /// │ Int256.min │ Int256( 2) │ Int256( 0) │ Int256(-1) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static func *=(lhs: inout Self, rhs: Self)
    
    /// Forms the `low` product of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ low        | high       │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 1) │ Int(    4) │ Int256( 4) │ Int(    0) │ false    │
    /// │ Int256( 2) │ Int(   -3) │ Int256(-6) │ Int(   -1) │ false    │
    /// │ Int256(-3) │ Int(    2) │ Int256(-6) │ Int(   -1) │ false    │
    /// │ Int256(-4) │ Int(   -1) │ Int256( 4) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256.max │ Int(    2) │ Int256(-2) │ Int(    0) │ true     │
    /// │ Int256.min │ Int(    2) │ Int256( 0) │ Int(   -1) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @_disfavoredOverload @inlinable static func *=(lhs: inout Self, rhs: Digit)
    
    /// Returns the `low` product of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ low        | high       │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 1) │ Int256( 4) │ Int256( 4) │ Int256( 0) │ false    │
    /// │ Int256( 2) │ Int256(-3) │ Int256(-6) │ Int256(-1) │ false    │
    /// │ Int256(-3) │ Int256( 2) │ Int256(-6) │ Int256(-1) │ false    │
    /// │ Int256(-4) │ Int256(-1) │ Int256( 4) │ Int256( 0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256.max │ Int256( 2) │ Int256(-2) │ Int256( 0) │ true     │
    /// │ Int256.min │ Int256( 2) │ Int256( 0) │ Int256(-1) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static func *(lhs: Self, rhs: Self) -> Self
    
    /// Returns the `low` product of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ low        | high       │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 1) │ Int(    4) │ Int256( 4) │ Int(    0) │ false    │
    /// │ Int256( 2) │ Int(   -3) │ Int256(-6) │ Int(   -1) │ false    │
    /// │ Int256(-3) │ Int(    2) │ Int256(-6) │ Int(   -1) │ false    │
    /// │ Int256(-4) │ Int(   -1) │ Int256( 4) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256.max │ Int(    2) │ Int256(-2) │ Int(    0) │ true     │
    /// │ Int256.min │ Int(    2) │ Int256( 0) │ Int(   -1) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @_disfavoredOverload @inlinable static func *(lhs: Self, rhs: Digit) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Division
    //=------------------------------------------------------------------------=
    
    /// Forms the `quotient` of dividing `lhs` by `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │ Int256( 7) │ Int256(-3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256( 3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256(-3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 0) │ Int256( 7) │ Int256( 7) │ true     │
    /// │ Int256.min │ Int256(-1) │ Int256.min │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static func /=(lhs: inout Self, rhs: Self)
    
    /// Forms the `quotient` of dividing `lhs` by `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    3) │ Int256( 2) │ Int(    0) │ false    │
    /// │ Int256( 7) │ Int(   -3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(    3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(   -3) │ Int256( 2) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    0) │ Int256( 7) │ Int(    7) │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.min │ Int(    0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @_disfavoredOverload @inlinable static func /=(lhs: inout Self, rhs: Digit)
    
    /// Returns the `quotient` of dividing `lhs` by `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │ Int256( 7) │ Int256(-3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256( 3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256(-3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 0) │ Int256( 7) │ Int256( 7) │ true     │
    /// │ Int256.min │ Int256(-1) │ Int256.min │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static func /(lhs: Self, rhs: Self) -> Self
    
    /// Returns the `quotient` of dividing `lhs` by `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    3) │ Int256( 2) │ Int(    0) │ false    │
    /// │ Int256( 7) │ Int(   -3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(    3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(   -3) │ Int256( 2) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    0) │ Int256( 7) │ Int(    7) │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.min │ Int(    0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @_disfavoredOverload @inlinable static func /(lhs: Self, rhs: Digit) -> Self
    
    /// Forms the `remainder` of dividing `lhs` by `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │ Int256( 7) │ Int256(-3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256( 3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256(-3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 0) │ Int256( 7) │ Int256( 7) │ true     │
    /// │ Int256.min │ Int256(-1) │ Int256.min │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static func %=(lhs: inout Self, rhs: Self)
    
    /// Forms the `remainder` of dividing `lhs` by `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    3) │ Int256( 2) │ Int(    0) │ false    │
    /// │ Int256( 7) │ Int(   -3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(    3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(   -3) │ Int256( 2) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    0) │ Int256( 7) │ Int(    7) │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.min │ Int(    0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @_disfavoredOverload @inlinable static func %=(lhs: inout Self, rhs: Digit)
    
    /// Returns the `remainder` of dividing `lhs` by `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │ Int256( 7) │ Int256(-3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256( 3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256(-3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 0) │ Int256( 7) │ Int256( 7) │ true     │
    /// │ Int256.min │ Int256(-1) │ Int256.min │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static func %(lhs: Self, rhs: Self) -> Self
    
    /// Returns the `remainder` of dividing `lhs` by `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    3) │ Int256( 2) │ Int(    0) │ false    │
    /// │ Int256( 7) │ Int(   -3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(    3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(   -3) │ Int256( 2) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    0) │ Int256( 7) │ Int(    7) │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.min │ Int(    0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @_disfavoredOverload @inlinable static func %(lhs: Self, rhs: Digit) -> Digit
    
    /// Returns the `quotient` and `remainder` of dividing `self` by `other`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │ Int256( 7) │ Int256(-3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256( 3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256(-3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 0) │ Int256( 7) │ Int256( 7) │ true     │
    /// │ Int256.min │ Int256(-1) │ Int256.min │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable func quotientAndRemainder(dividingBy other: Self) -> QR<Self, Self>
    
    /// Returns the `quotient` and `remainder` of dividing `self` by `other`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    3) │ Int256( 2) │ Int(    0) │ false    │
    /// │ Int256( 7) │ Int(   -3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(    3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(   -3) │ Int256( 2) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    0) │ Int256( 7) │ Int(    7) │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.min │ Int(    0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @_disfavoredOverload @inlinable func quotientAndRemainder(dividingBy other: Digit) -> QR<Self, Digit>
    
    /// Forms the `quotient` of dividing `self` by `other`, and returns an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │ Int256( 7) │ Int256(-3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256( 3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256(-3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 0) │ Int256( 7) │ Int256( 7) │ true     │
    /// │ Int256.min │ Int256(-1) │ Int256.min │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is either truncated or, if undefined, `self`.
    ///
    @inlinable mutating func divideReportingOverflow(by other: Self) -> Bool
    
    /// Forms the `quotient` of dividing `self` by `other`, and returns an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    3) │ Int256( 2) │ Int(    0) │ false    │
    /// │ Int256( 7) │ Int(   -3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(    3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(   -3) │ Int256( 2) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    0) │ Int256( 7) │ Int(    7) │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.min │ Int(    0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is either truncated or, if undefined, `self`.
    ///
    @_disfavoredOverload @inlinable mutating func divideReportingOverflow(by other: Digit) -> Bool
    
    /// Returns the `quotient` of dividing `self` by `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │ Int256( 7) │ Int256(-3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256( 3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256(-3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 0) │ Int256( 7) │ Int256( 7) │ true     │
    /// │ Int256.min │ Int256(-1) │ Int256.min │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is either truncated or, if undefined, `self`.
    ///
    @inlinable func dividedReportingOverflow(by other: Self) -> PVO<Self>
    
    /// Returns the `quotient` of dividing `self` by `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    3) │ Int256( 2) │ Int(    0) │ false    │
    /// │ Int256( 7) │ Int(   -3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(    3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(   -3) │ Int256( 2) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    0) │ Int256( 7) │ Int(    7) │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.min │ Int(    0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is either truncated or, if undefined, `self`.
    ///
    @_disfavoredOverload @inlinable func dividedReportingOverflow(by other: Digit) -> PVO<Self>
    
    /// Forms the `remainder` of dividing `self` by `other`, and returns an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │ Int256( 7) │ Int256(-3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256( 3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256(-3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 0) │ Int256( 7) │ Int256( 7) │ true     │
    /// │ Int256.min │ Int256(-1) │ Int256.min │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is either the entire remainder or, if undefined, `self`.
    ///
    @inlinable mutating func formRemainderReportingOverflow(dividingBy other: Self) -> Bool
    
    /// Forms the `remainder` of dividing `self` by `other`, and returns an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    3) │ Int256( 2) │ Int(    0) │ false    │
    /// │ Int256( 7) │ Int(   -3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(    3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(   -3) │ Int256( 2) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    0) │ Int256( 7) │ Int(    7) │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.min │ Int(    0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is either the entire remainder or, if undefined, `self`.
    ///
    @_disfavoredOverload @inlinable mutating func formRemainderReportingOverflow(dividingBy other: Digit) -> Bool
    
    /// Returns the `remainder` of dividing `self` by `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │ Int256( 7) │ Int256(-3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256( 3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256(-3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 0) │ Int256( 7) │ Int256( 7) │ true     │
    /// │ Int256.min │ Int256(-1) │ Int256.min │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is either truncated or, if undefined, `self` and `self`.
    ///
    @inlinable func remainderReportingOverflow(dividingBy other: Self) -> PVO<Self>
    
    /// Returns the `remainder` of dividing `self` by `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    3) │ Int256( 2) │ Int(    0) │ false    │
    /// │ Int256( 7) │ Int(   -3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(    3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(   -3) │ Int256( 2) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    0) │ Int256( 7) │ Int(    7) │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.min │ Int(    0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is either truncated or, if undefined, `self`.
    ///
    @_disfavoredOverload @inlinable func remainderReportingOverflow(dividingBy other: Digit) -> PVO<Digit>
    
    /// Returns the `quotient` and `remainder` of dividing `self` by `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │ Int256( 7) │ Int256(-3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256( 3) │ Int256(-2) │ Int256(-1) │ false    │
    /// │ Int256(-7) │ Int256(-3) │ Int256( 2) │ Int256( 0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int256( 0) │ Int256( 7) │ Int256( 7) │ true     │
    /// │ Int256.min │ Int256(-1) │ Int256.min │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is either truncated or, if undefined, `self` and `self`.
    ///
    @inlinable func quotientAndRemainderReportingOverflow(dividingBy other: Self) -> PVO<QR<Self, Self>>
    
    /// Returns the `quotient` and `remainder` of dividing `self` by `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ quotient   | remainder  │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    3) │ Int256( 2) │ Int(    0) │ false    │
    /// │ Int256( 7) │ Int(   -3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(    3) │ Int256(-2) │ Int(   -1) │ false    │
    /// │ Int256(-7) │ Int(   -3) │ Int256( 2) │ Int(    0) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 7) │ Int(    0) │ Int256( 7) │ Int(    7) │ true     │
    /// │ Int256.min │ Int(   -1) │ Int256.min │ Int(    0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is either truncated or, if undefined, `self` and `self`.
    ///
    @_disfavoredOverload @inlinable func quotientAndRemainderReportingOverflow(dividingBy other: Digit) -> PVO<QR<Self, Digit>>
    
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
    /// ```
    /// ┌─────────── = ─────────── → ──────┐
    /// │ self       │ bit pattern │ odd   │
    /// ├─────────── = ─────────── → ──────┤
    /// │ Int256( 3) │ 0........11 │ true  │
    /// │ Int256( 2) │ 0........10 │ false │
    /// │ Int256( 1) │ 0.........1 │ true  │
    /// │ Int256( 0) │ 0.......... │ false │
    /// │ Int256(-1) │ 1.......... │ true  │
    /// │ Int256(-2) │ 1.........0 │ false │
    /// │ Int256(-3) │ 1........01 │ true  │
    /// │ Int256(-4) │ 1........11 │ false │
    /// └─────────── = ─────────── → ──────┘
    /// ```
    ///
    /// Semantically, it is equivalent to the following expression:
    ///
    /// ```swift
    /// leastSignificantBit == true
    /// ```
    ///
    @inlinable public var isOdd: Bool {
        self.leastSignificantBit
    }
    
    /// Returns whether this value is even.
    ///
    /// ```
    /// ┌─────────── = ─────────── → ──────┐
    /// │ self       │ bit pattern │ even  │
    /// ├─────────── = ─────────── → ──────┤
    /// │ Int256( 3) │ 0........11 │ false │
    /// │ Int256( 2) │ 0........10 │ true  │
    /// │ Int256( 1) │ 0.........1 │ false │
    /// │ Int256( 0) │ 0.......... │ true  │
    /// │ Int256(-1) │ 1.......... │ false │
    /// │ Int256(-2) │ 1.........0 │ true  │
    /// │ Int256(-3) │ 1........01 │ false │
    /// │ Int256(-4) │ 1........11 │ true  │
    /// └─────────── = ─────────── → ──────┘
    /// ```
    ///
    /// Semantically, it is equivalent to the following expression:
    ///
    /// ```swift
    /// leastSignificantBit == false
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
    
    @inlinable public func quotientAndRemainder(dividingBy other: Self) -> QR<Self, Self> {
        let qro: PVO<QR<Self, Self>> = self.quotientAndRemainderReportingOverflow(dividingBy: other)
        precondition(!qro.overflow, NBK.callsiteOverflowInfo())
        return qro.partialValue as QR<Self, Self>
    }
    
    @_disfavoredOverload @inlinable public func quotientAndRemainder(dividingBy other: Digit) -> QR<Self, Digit> {
        let qro: PVO<QR<Self, Digit>> = self.quotientAndRemainderReportingOverflow(dividingBy: other)
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
    
    /// Returns the negative of `number`.
    ///
    /// ```
    /// ┌─────────── → ───────────┬──────────┐
    /// │ number     │ -number    │ overflow │
    /// ├─────────── → ───────────┼──────────┤
    /// │ Int256( 1) │ Int256(-1) │ false    │
    /// │ Int256( 0) │ Int256( 0) │ false    │
    /// │ Int256(-1) │ Int256( 1) │ false    │
    /// ├─────────── → ───────────┼──────────┤
    /// | Int256.min | Int256.min | true     |
    /// └─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static prefix func -(number: Self) -> Self
    
    /// Forms the negative of `self`.
    ///
    /// ```
    /// ┌─────────── → ───────────┬──────────┐
    /// │ self       │ -self      │ overflow │
    /// ├─────────── → ───────────┼──────────┤
    /// │ Int256( 1) │ Int256(-1) │ false    │
    /// │ Int256( 0) │ Int256( 0) │ false    │
    /// │ Int256(-1) │ Int256( 1) │ false    │
    /// ├─────────── → ───────────┼──────────┤
    /// | Int256.min | Int256.min | true     |
    /// └─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable mutating func negate()
    
    /// Returns the negative of `self`.
    ///
    /// ```
    /// ┌─────────── → ───────────┬──────────┐
    /// │ self       │ -self      │ overflow │
    /// ├─────────── → ───────────┼──────────┤
    /// │ Int256( 1) │ Int256(-1) │ false    │
    /// │ Int256( 0) │ Int256( 0) │ false    │
    /// │ Int256(-1) │ Int256( 1) │ false    │
    /// ├─────────── → ───────────┼──────────┤
    /// | Int256.min | Int256.min | true     |
    /// └─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable func negated() -> Self
    
    /// Forms the negative of `self`, and returns an `overflow` indicator.
    ///
    /// ```
    /// ┌─────────── → ───────────┬──────────┐
    /// │ self       │ -self      │ overflow │
    /// ├─────────── → ───────────┼──────────┤
    /// │ Int256( 1) │ Int256(-1) │ false    │
    /// │ Int256( 0) │ Int256( 0) │ false    │
    /// │ Int256(-1) │ Int256( 1) │ false    │
    /// ├─────────── → ───────────┼──────────┤
    /// | Int256.min | Int256.min | true     |
    /// └─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @inlinable mutating func negateReportingOverflow() -> Bool
    
    /// Returns the negative of `self`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌─────────── → ───────────┬──────────┐
    /// │ self       │ -self      │ overflow │
    /// ├─────────── → ───────────┼──────────┤
    /// │ Int256( 1) │ Int256(-1) │ false    │
    /// │ Int256( 0) │ Int256( 0) │ false    │
    /// │ Int256(-1) │ Int256( 1) │ false    │
    /// ├─────────── → ───────────┼──────────┤
    /// | Int256.min | Int256.min | true     |
    /// └─────────── → ───────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated.
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
