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
public protocol NBKFixedWidthInteger: NBKBinaryInteger, NBKBitPatternConvertible, FixedWidthInteger where
Digit: NBKFixedWidthInteger, Magnitude: NBKFixedWidthInteger, Magnitude.BitPattern == BitPattern {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bits
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance repeating the given bit.
    ///
    /// ```
    /// ┌────── → ────────── = ────────────┐
    /// │ bit   │ self       │ bit pattern │
    /// ├────── → ────────── = ────────────┤
    /// │ false │ Int256( 0) │ 0.......... │
    /// │ true  │ Int256(-1) │ 1.......... │
    /// └────── → ────────── = ────────────┘
    /// ```
    ///
    /// - Note: This member has two's complement semantics.
    ///
    @inlinable init(repeating bit: Bool)
    
    /// Returns the most significant bit (`MSB`).
    ///
    /// ```
    /// ┌─────────── = ─────────── → ──────┐
    /// │ self       │ bit pattern │ MSB   │
    /// ├─────────── = ─────────── → ──────┤
    /// │ Int256( 3) │ 0........11 │ false │
    /// │ Int256( 2) │ 0........10 │ false │
    /// │ Int256( 1) │ 0.........1 │ false │
    /// │ Int256( 0) │ 0.......... │ false │
    /// │ Int256(-1) │ 1.......... │ true  │
    /// │ Int256(-2) │ 1.........0 │ true  │
    /// │ Int256(-3) │ 1........01 │ true  │
    /// │ Int256(-4) │ 1........00 │ true  │
    /// └─────────── = ─────────── → ──────┘
    /// ```
    ///
    /// - Note: This member has two's complement semantics.
    ///
    @inlinable var mostSignificantBit: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    /// Returns whether all of its bits are set.
    ///
    /// It can be viewed as the bitwise inverse of ``isZero``.
    ///
    /// ```
    /// ┌─────────── = ─────────── → ──────┐
    /// │ self       │ bit pattern │ full  │
    /// ├─────────── = ─────────── → ──────┤
    /// │ Int256( 3) │ 0........11 │ false │
    /// │ Int256( 2) │ 0........10 │ false │
    /// │ Int256( 1) │ 0.........1 │ false │
    /// │ Int256( 0) │ 0.......... │ false │
    /// │ Int256(-1) │ 1.......... │ true  │
    /// │ Int256(-2) │ 1.........0 │ false │
    /// │ Int256(-3) │ 1........01 │ false │
    /// │ Int256(-4) │ 1........00 │ false │
    /// └─────────── = ─────────── → ──────┘
    /// ```
    ///
    /// - Note: This member has two's complement semantics.
    ///
    @inlinable var isFull: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Complements
    //=------------------------------------------------------------------------=
    
    /// Forms the two's complement subsequence of `self` and `carry`, and returns an `overflow` indicator.
    ///
    /// The subsequence is equal to the two's complement when the `carry` bit is set:
    ///
    /// ```swift
    /// formTwosComplementSubsequence(true ) // two's complement
    /// formTwosComplementSubsequence(false) // one's complement
    /// ```
    ///
    /// The following example shows a two's complement formation of a composite integer:
    ///
    /// ```swift
    /// var carry = true
    /// carry = low .formTwosComplementSubsequence(carry)
    /// carry = high.formTwosComplementSubsequence(carry)
    /// ```
    ///
    @inlinable mutating func formTwosComplementSubsequence(_ carry: Bool) -> Bool
    
    /// Returns the two's complement subsequence of `self` and `carry`, along with an `overflow` indicator.
    ///
    /// The subsequence is equal to the two's complement when the `carry` bit is set:
    ///
    /// ```swift
    /// twosComplementSubsequence(true ) // two's complement
    /// twosComplementSubsequence(false) // one's complement
    /// ```
    ///
    /// The following example shows a two's complement formation of a composite integer:
    ///
    /// ```swift
    /// var carry = true
    /// (low,  carry) = low .twosComplementSubsequence(carry)
    /// (high, carry) = high.twosComplementSubsequence(carry)
    /// ```
    ///
    @inlinable func twosComplementSubsequence(_ carry: Bool) -> PVO<Self>
    
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
    /// │ self       │ other      │ low        | high       │ overflow │
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
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @inlinable mutating func multiplyReportingOverflow(by other: Self) -> Bool
    
    /// Forms the `low` product of `self` and `other`, and returns an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ low        | high       │ overflow │
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
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @_disfavoredOverload @inlinable mutating func multiplyReportingOverflow(by other: Digit) -> Bool
    
    /// Returns the `low` product of `self` and `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ low        | high       │ overflow │
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
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @inlinable func multipliedReportingOverflow(by other: Self) -> PVO<Self>
    
    /// Returns the `low` product of `self` and `other`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ low        | high       │ overflow │
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
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @_disfavoredOverload @inlinable func multipliedReportingOverflow(by other: Digit) -> PVO<Self>
    
    /// Forms the `low` product of `self` and `other`, and returns the `high`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ low        | high       │ overflow │
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
    @inlinable mutating func multiplyFullWidth(by other: Self) -> Self
    
    /// Forms the `low` product of `self` and `other`, and returns the `high`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ low        | high       │ overflow │
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
    @_disfavoredOverload @inlinable mutating func multiplyFullWidth(by other: Digit) -> Digit
    
    /// Returns the `low` and `high` product of `self` and `other`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ low        | high       │ overflow │
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
    @inlinable func multipliedFullWidth(by other: Self) -> HL<Self, Magnitude>
    
    /// Returns the `low` and `high` product of `self` and `other`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ self       │ other      │ low        | high       │ overflow │
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
    
    @inlinable public var isFull: Bool {
        self == (~0 as Self)
    }
    
    @inlinable public var isZero: Bool {
        self == ( 0 as Self)
    }
    
    @inlinable public var isLessThanZero: Bool {
        Self.isSigned && self < (0 as Self)
    }
    
    @inlinable public var isMoreThanZero: Bool {
        self > (0 as Self)
    }
    
    @inlinable public var isPowerOf2: Bool {
        self.nonzeroBitCount == 1
    }
    
    @inlinable public func compared(to other: Self) -> Int {
        (self < other) ? -1 : (self == other) ? 0 : 1
    }
    
    /// Returns whether `self` matches the repeating `bit` pattern.
    ///
    /// ```
    /// ┌─────────── = ────────────┬────── → ──────┐
    /// │ self       │ bit pattern │ bit   │ match │
    /// ├─────────── = ────────────┼────── → ──────┤
    /// │ Int256( 1) │ 0.........1 │ true  │ false │
    /// │ Int256( 0) │ 0.......... │ true  │ false │
    /// │ Int256(-1) │ 1.......... │ true  │ true  │
    /// │ Int256(-2) │ 1.........0 │ true  │ false │
    /// ├─────────── = ────────────┼────── → ──────┤
    /// │ Int256( 1) │ 0.........1 │ false │ false │
    /// │ Int256( 0) │ 0.......... │ false │ true  │
    /// │ Int256(-1) │ 1.......... │ false │ false │
    /// │ Int256(-2) │ 1.........0 │ false │ false │
    /// └─────────── = ────────────┴────── → ──────┘
    /// ```
    ///
    /// - Note: This member has two's complement semantics.
    ///
    @inlinable public func matches(repeating bit: Bool) -> Bool {
        bit ? self.isFull : self.isZero
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Complements
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formTwosComplement() {
        _ = self.formTwosComplementSubsequence(true)
    }
    
    @inlinable public func twosComplement() -> Self {
        self.twosComplementSubsequence(true).partialValue
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
