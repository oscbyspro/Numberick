//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Fixed-Width Integer
//*============================================================================*

/// An integer type with a fixed bit width for every instance.
///
/// ### Two's Complement
///
/// Like `BinaryInteger`, it has un/signed [two's complement][2s] semantics.
///
/// ```
/// The two's complement representation of  0 is an infinite sequence of 0s.
/// The two's complement representation of -1 is an infinite sequence of 1s.
/// ```
///
/// [2s]: https://en.wikipedia.org/wiki/Two%27s_complement
///
public protocol NBKFixedWidthInteger: FixedWidthInteger, NBKBinaryInteger, NBKBitPatternConvertible where
Digit: NBKFixedWidthInteger, Magnitude: NBKFixedWidthInteger, Magnitude.BitPattern == BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bits
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance repeating the given bit.
    ///
    /// ```
    /// ┌────── → ─────────────────────────┐
    /// │ bit   │ self                     │
    /// ├────── → ────────── = ────────────┤
    /// │ false │ Int256( 0) │ 0.......... │
    /// │ true  │ Int256(-1) │ 1.......... │
    /// └────── → ────────── = ────────────┘
    /// ```
    ///
    /// - Note: This member has un/signed two's complement semantics.
    ///
    @inlinable init(repeating bit: Bool)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    /// Forms the `sum` of `self` and `other`, and returns an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ self       │ other      │ sum        │ overflow │
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
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @inlinable mutating func addReportingOverflow(_ other: Self) -> Bool
    
    /// Forms the `sum` of `self` and `other`, and returns an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ self       │ other      │ sum        │ overflow │
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
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @_disfavoredOverload @inlinable mutating func addReportingOverflow(_ other: Digit) -> Bool
    
    /// Returns the `sum` of `self` and `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ self       │ other      │ sum        │ overflow │
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
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @inlinable func addingReportingOverflow(_ other: Self) -> PVO<Self>
    
    /// Returns the `sum` of `self` and `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ self       │ other      │ sum        │ overflow │
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
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @_disfavoredOverload @inlinable func addingReportingOverflow(_ other: Digit) -> PVO<Self>
    
    /// Forms the `difference` of `self` and `other`, and returns an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ self       │ other      │ difference │ overflow │
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
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @inlinable mutating func subtractReportingOverflow(_ other: Self) -> Bool
    
    /// Forms the `difference` of `self` and `other`, and returns an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ self       │ other      │ difference │ overflow │
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
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @_disfavoredOverload @inlinable mutating func subtractReportingOverflow(_ other: Digit) -> Bool
    
    /// Returns the `difference` of `self` and `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ self       │ other      │ difference │ overflow │
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
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @inlinable func subtractingReportingOverflow(_ other: Self) -> PVO<Self>
    
    /// Returns the `difference` of `self` and `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬──────────┐
    /// │ self       │ other      │ difference │ overflow │
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
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @_disfavoredOverload @inlinable func subtractingReportingOverflow(_ other: Digit) -> PVO<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    /// Forms the `low` product of `self` and `other`, and returns an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ high       │ low        │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 1) │ Int256( 4) │ Int256( 0) │ Int256( 4) │ false    │
    /// │ Int256( 2) │ Int256(-3) │ Int256(-1) │ Int256(-6) │ false    │
    /// │ Int256(-3) │ Int256( 2) │ Int256(-1) │ Int256(-6) │ false    │
    /// │ Int256(-4) │ Int256(-1) │ Int256( 0) │ Int256( 4) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256.max │ Int256( 2) │ Int256( 0) │ Int256(-2) │ true     │
    /// │ Int256.min │ Int256( 2) │ Int256(-1) │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @inlinable mutating func multiplyReportingOverflow(by other: Self) -> Bool
    
    /// Forms the `low` product of `self` and `other`, and returns an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ high       │ low        │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 1) │ Int(    4) │ Int(    0) │ Int256( 4) │ false    │
    /// │ Int256( 2) │ Int(   -3) │ Int(   -1) │ Int256(-6) │ false    │
    /// │ Int256(-3) │ Int(    2) │ Int(   -1) │ Int256(-6) │ false    │
    /// │ Int256(-4) │ Int(   -1) │ Int(    0) │ Int256( 4) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256.max │ Int(    2) │ Int(    0) │ Int256(-2) │ true     │
    /// │ Int256.min │ Int(    2) │ Int(   -1) │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @_disfavoredOverload @inlinable mutating func multiplyReportingOverflow(by other: Digit) -> Bool
    
    /// Returns the `low` product of `self` and `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ high       │ low        │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 1) │ Int256( 4) │ Int256( 0) │ Int256( 4) │ false    │
    /// │ Int256( 2) │ Int256(-3) │ Int256(-1) │ Int256(-6) │ false    │
    /// │ Int256(-3) │ Int256( 2) │ Int256(-1) │ Int256(-6) │ false    │
    /// │ Int256(-4) │ Int256(-1) │ Int256( 0) │ Int256( 4) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256.max │ Int256( 2) │ Int256( 0) │ Int256(-2) │ true     │
    /// │ Int256.min │ Int256( 2) │ Int256(-1) │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @inlinable func multipliedReportingOverflow(by other: Self) -> PVO<Self>
    
    /// Returns the `low` product of `self` and `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ high       │ low        │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 1) │ Int(    4) │ Int(    0) │ Int256( 4) │ false    │
    /// │ Int256( 2) │ Int(   -3) │ Int(   -1) │ Int256(-6) │ false    │
    /// │ Int256(-3) │ Int(    2) │ Int(   -1) │ Int256(-6) │ false    │
    /// │ Int256(-4) │ Int(   -1) │ Int(    0) │ Int256( 4) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256.max │ Int(    2) │ Int(    0) │ Int256(-2) │ true     │
    /// │ Int256.min │ Int(    2) │ Int(   -1) │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @_disfavoredOverload @inlinable func multipliedReportingOverflow(by other: Digit) -> PVO<Self>
    
    /// Forms the `low` product of `self` and `other`, and returns the `high`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ high       │ low        │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 1) │ Int256( 4) │ Int256( 0) │ Int256( 4) │ false    │
    /// │ Int256( 2) │ Int256(-3) │ Int256(-1) │ Int256(-6) │ false    │
    /// │ Int256(-3) │ Int256( 2) │ Int256(-1) │ Int256(-6) │ false    │
    /// │ Int256(-4) │ Int256(-1) │ Int256( 0) │ Int256( 4) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256.max │ Int256( 2) │ Int256( 0) │ Int256(-2) │ true     │
    /// │ Int256.min │ Int256( 2) │ Int256(-1) │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: The `high` and `low` product contain the entire `overflow` from `low` to `high`.
    ///
    @inlinable mutating func multiplyFullWidth(by other: Self) -> Self
    
    /// Forms the `low` product of `self` and `other`, and returns the `high`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ high       │ low        │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 1) │ Int(    4) │ Int(    0) │ Int256( 4) │ false    │
    /// │ Int256( 2) │ Int(   -3) │ Int(   -1) │ Int256(-6) │ false    │
    /// │ Int256(-3) │ Int(    2) │ Int(   -1) │ Int256(-6) │ false    │
    /// │ Int256(-4) │ Int(   -1) │ Int(    0) │ Int256( 4) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256.max │ Int(    2) │ Int(    0) │ Int256(-2) │ true     │
    /// │ Int256.min │ Int(    2) │ Int(   -1) │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: The `high` and `low` product contain the entire `overflow` from `low` to `high`.
    ///
    @_disfavoredOverload @inlinable mutating func multiplyFullWidth(by other: Digit) -> Digit
    
    /// Returns the `high` and `low` product of `self` and `other`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ high       │ low        │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 1) │ Int256( 4) │ Int256( 0) │ Int256( 4) │ false    │
    /// │ Int256( 2) │ Int256(-3) │ Int256(-1) │ Int256(-6) │ false    │
    /// │ Int256(-3) │ Int256( 2) │ Int256(-1) │ Int256(-6) │ false    │
    /// │ Int256(-4) │ Int256(-1) │ Int256( 0) │ Int256( 4) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256.max │ Int256( 2) │ Int256( 0) │ Int256(-2) │ true     │
    /// │ Int256.min │ Int256( 2) │ Int256(-1) │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: The `high` and `low` product contain the entire `overflow` from `low` to `high`.
    ///
    @inlinable func multipliedFullWidth(by other: Self) -> HL<Self, Magnitude>
    
    /// Returns the `high` and `low` product of `self` and `other`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ high       │ low        │ overflow │
    /// ├────────────┼─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256( 1) │ Int(    4) │ Int(    0) │ Int256( 4) │ false    │
    /// │ Int256( 2) │ Int(   -3) │ Int(   -1) │ Int256(-6) │ false    │
    /// │ Int256(-3) │ Int(    2) │ Int(   -1) │ Int256(-6) │ false    │
    /// │ Int256(-4) │ Int(   -1) │ Int(    0) │ Int256( 4) │ false    │
    /// │────────────┤─────────── → ───────────┤────────────┤──────────┤
    /// │ Int256.max │ Int(    2) │ Int(    0) │ Int256(-2) │ true     │
    /// │ Int256.min │ Int(    2) │ Int(   -1) │ Int256( 0) │ true     │
    /// └────────────┴─────────── → ───────────┴────────────┴──────────┘
    /// ```
    ///
    /// - Note: The `high` and `low` product contain the entire `overflow` from `low` to `high`.
    ///
    @_disfavoredOverload @inlinable func multipliedFullWidth(by other: Digit) -> HL<Digit, Magnitude>
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Division
    //=------------------------------------------------------------------------=
    
    /// Returns the `quotient` and `remainder` of dividing `other` by `self`.
    ///
    /// ```
    /// ┌────────────┬──────────────────────────────────────── → ───────────┬────────────────┬──────────┐
    /// │ self       │ other                                   │ quotient   | remainder      │ overflow │
    /// ├────────────┼──────────────────────────────────────── → ───────────┤────────────────┤──────────┤
    /// │ Int256.max │ Int256( 1),         UInt256( 2)         │ Int256( 2) │ Int256( 4)     │ false    │
    /// │ Int256.min │ Int256( 1),         UInt256( 2)         │ Int256(-2) │ Int256( 2)     │ false    │
    /// │ Int256.max │ Int256.max / 2 + 0, UInt256.max / 2 + 0 │ Int256.max │ Int256.max - 1 │ false    │
    /// │ Int256.min │ Int256.max / 2 + 1, UInt256.max / 2 + 0 │ Int256.min │ Int256.max - 1 │ false    │
    /// │────────────┤──────────────────────────────────────── → ───────────┤────────────────┤──────────┤
    /// │ Int256( 0) │ Int256( 1),         UInt256( 2)         │ Int256( 2) │ Int256( 2)     │ true     │
    /// │ Int256.max │ Int256.max / 2 + 0, UInt256.max / 2 + 1 │ Int256.min │ Int256( 0)     │ true     │
    /// │ Int256.min │ Int256.max / 2 + 1, UInt256.max / 2 + 1 │ Int256.max │ Int256( 0)     │ true     │
    /// └────────────┴──────────────────────────────────────── → ───────────┴────────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable func dividingFullWidth(_ other: HL<Self, Magnitude>) -> QR<Self, Self>
    
    /// Returns the `quotient` and `remainder` of dividing `other` by `self`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬──────────────────────────────────────── → ───────────┬────────────────┬──────────┐
    /// │ self       │ other                                   │ quotient   | remainder      │ overflow │
    /// ├────────────┼──────────────────────────────────────── → ───────────┤────────────────┤──────────┤
    /// │ Int256.max │ Int256( 1),         UInt256( 2)         │ Int256( 2) │ Int256( 4)     │ false    │
    /// │ Int256.min │ Int256( 1),         UInt256( 2)         │ Int256( 2) │ Int256( 4)     │ false    │
    /// │ Int256.max │ Int256.max / 2 + 0, UInt256.max / 2 + 0 │ Int256.max │ Int256.max - 1 │ false    │
    /// │ Int256.min │ Int256.max / 2 + 1, UInt256.max / 2 + 0 │ Int256.min │ Int256.max - 1 │ false    │
    /// │────────────┤──────────────────────────────────────── → ───────────┤────────────────┤──────────┤
    /// │ Int256( 0) │ Int256( 1),         UInt256( 2)         │ Int256( 2) │ Int256( 2)     │ true     │
    /// │ Int256.max │ Int256.max / 2 + 0, UInt256.max / 2 + 1 │ Int256.min │ Int256( 0)     │ true     │
    /// │ Int256.min │ Int256.max / 2 + 1, UInt256.max / 2 + 1 │ Int256.max │ Int256( 0)     │ true     │
    /// └────────────┴──────────────────────────────────────── → ───────────┴────────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated or, if undefined, `other` and `other`.
    ///
    @inlinable func dividingFullWidthReportingOverflow(_ other: HL<Self, Magnitude>) -> PVO<QR<Self, Self>>
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Shifts
    //=------------------------------------------------------------------------=
    
    /// Performs a left shift.
    ///
    /// ```
    /// ┌────────────┬───────── → ───────────┐
    /// │ self       │ distance │ self       │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256( 1) │ Int(255) │ Int256.min │
    /// │ Int256.min │ Int(  1) │ Int256( 0) │
    /// └────────────┴───────── → ───────────┘
    /// ```
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable mutating func bitShiftLeft(by distance: Int)
    
    /// Performs a left shift.
    ///
    /// ```
    /// ┌────────────┬───────── → ───────────┐
    /// │ self       │ distance │ self       │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256( 1) │ Int(255) │ Int256.min │
    /// │ Int256.min │ Int(  1) │ Int256( 0) │
    /// └────────────┴───────── → ───────────┘
    /// ```
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable func bitShiftedLeft(by distance: Int) -> Self
    
    /// Performs an un/signed right shift.
    ///
    /// ```
    /// ┌────────────┬───────── → ───────────┐
    /// │ self       │ distance │ self       │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256.min │ Int(255) │ Int256(-1) │
    /// │ Int256(-1) │ Int(  1) │ Int256(-1) │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256.max │ Int(254) │ Int256( 1) │
    /// │ Int256( 1) │ Int(  1) │ Int256( 0) │
    /// └────────────┴───────── → ───────────┘
    /// ```
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable mutating func bitShiftRight(by distance: Int)
    
    /// Performs an un/signed right shift.
    ///
    /// ```
    /// ┌────────────┬───────── → ───────────┐
    /// │ self       │ distance │ self       │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256.min │ Int(255) │ Int256(-1) │
    /// │ Int256(-1) │ Int(  1) │ Int256(-1) │
    /// ├────────────┼───────── → ───────────┤
    /// │ Int256.max │ Int(254) │ Int256( 1) │
    /// │ Int256( 1) │ Int(  1) │ Int256( 0) │
    /// └────────────┴───────── → ───────────┘
    /// ```
    ///
    /// - Parameters:
    ///   - distance: `0 <= distance < Self.bitWidth`
    ///
    @inlinable func bitShiftedRight(by distance: Int) -> Self
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension NBKFixedWidthInteger {
    
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
    
    @inlinable public var isZero: Bool {
        self == (0 as Self)
    }
    
    @inlinable public var isLessThanZero: Bool {
        Self.isSigned && self < (0 as Self)
    }
    
    @inlinable public var isMoreThanZero: Bool {
        self > (0 as Self)
    }
    
    @inlinable public var isPowerOf2: Bool {
        !self.isLessThanZero && self.nonzeroBitCount == 1
    }
    
    @inlinable public func compared(to other: Self) -> Int {
        (self < other) ? -1 : (self == other) ? 0 : 1
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
    // MARK: Details x Shifts
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func bitShiftLeft(by distance: Int) {
        precondition(0 ..< self.bitWidth ~= distance, NBK.callsiteOutOfBoundsInfo())
        self &<<= distance
    }
    
    @inlinable public func bitShiftedLeft(by distance: Int) -> Self {
        precondition(0 ..< self.bitWidth ~= distance, NBK.callsiteOutOfBoundsInfo())
        return self &<< distance
    }
    
    @inlinable public mutating func bitShiftRight(by distance: Int) {
        precondition(0 ..< self.bitWidth ~= distance, NBK.callsiteOutOfBoundsInfo())
        self &>>= distance
    }
    
    @inlinable public func bitShiftedRight(by distance: Int) -> Self {
        precondition(0 ..< self.bitWidth ~= distance, NBK.callsiteOutOfBoundsInfo())
        return self &>> distance
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Text
    //=------------------------------------------------------------------------=
    // required because Swift.FixedWidthInteger does not refine NBKBinaryInteger
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ description: String) {
        self.init(description, radix: 10)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details x Signed
//=----------------------------------------------------------------------------=

extension NBKFixedWidthInteger where Self: NBKSignedInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func negateReportingOverflow() -> Bool {
        self.formTwosComplementSubsequence(true)
    }

    @inlinable public func negatedReportingOverflow() -> PVO<Self> {
        self.twosComplementSubsequence(true)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details x Sign & Magnitude
//=----------------------------------------------------------------------------=

extension NBKFixedWidthInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Numbers
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(magnitude: Magnitude) {
        self.init(bitPattern: magnitude)
        guard !self.isLessThanZero else { return nil }
    }
    
    @inlinable public init?(sign: FloatingPointSign, magnitude: Magnitude) {
        var bitPattern = magnitude as Magnitude
        var isLessThanZero = (sign == FloatingPointSign.minus)
        if  isLessThanZero {
            isLessThanZero = !bitPattern.formTwosComplementReportingOverflow()
        }
        
        self.init(bitPattern: bitPattern)
        guard self.isLessThanZero == isLessThanZero else { return nil }
    }
}
