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
/// Like `BinaryInteger`, it has un/signed [two's complement][2s] semantics.
///
/// ```
/// The two's complement representation of  0 is an infinite sequence of 0s.
/// The two's complement representation of -1 is an infinite sequence of 1s.
/// ```
///
/// [2s]: https://en.wikipedia.org/wiki/Two%27s_complement
///
public protocol NBKBinaryInteger: BinaryInteger, LosslessStringConvertible, Sendable
where Magnitude: NBKUnsignedInteger, Words: Sendable {
    
    /// A machine word of some kind, or this type.
    associatedtype Digit: NBKBinaryInteger = Self where
    Digit.Digit == Digit, Digit.Magnitude == Magnitude.Digit
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Numbers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given digit.
    ///
    /// ```
    /// ┌──────── → ─────────────────────────┐
    /// │ digit   │ self                     │
    /// ├──────── → ────────── = ────────────┤
    /// │ Int( 0) │ Int256( 0) │ 0.......... │
    /// │ Int(-1) │ Int256(-1) │ 1.......... │
    /// └──────── → ────────── = ────────────┘
    /// ```
    ///
    @inlinable init(digit: Digit)
    
    /// Tries to create a value equal to the given `sign` and `magnitude` pair.
    ///
    /// If the `sign` and `magnitude` pair is not representable, the result is nil.
    ///
    /// ```
    /// ┌───────┬───────────────────── → ───────────┐
    /// │ sign  │ magnitude            │ self       │
    /// │───────┤───────────────────── → ───────────┤
    /// │ plus  │ UInt256( 1)          │ Int256( 1) │
    /// │ minus │ UInt256( 1)          │ Int256(-1) │
    /// │───────┤───────────────────── → ───────────┤
    /// │ plus  │ Int256.max.magnitude │ Int256.max │
    /// │ minus │ Int256.min.magnitude │ Int256.min │
    /// │───────┤───────────────────── → ───────────┤
    /// │ plus  │ UInt256.max          │ nil        │
    /// │ minus │ UInt256.max          │ nil        │
    /// └───────┴───────────────────── → ───────────┘
    /// ```
    ///
    /// - Note: The `sign` and `magnitude` pair (minus, zero) is represented by zero.
    ///
    @inlinable init?(sign: FloatingPointSign, magnitude: Magnitude)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Words
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given collection of `words`.
    ///
    /// The `words` are interpreted as a binary integer with the same signedness.
    ///
    /// ```
    /// ┌─────────────────────────────────────────────── → ───────────┐
    /// │ words                                          │ self       │
    /// ├─────────────────────────────────────────────── → ───────────┤
    /// │ [UInt](                )                       │ Int256( 0) │
    /// │ [UInt](Int256(  ).words)                       │ Int256( 0) │
    /// │ [UInt](Int256.min.words)                       │ Int256.min │
    /// │ [UInt](Int256.max.words)                       │ Int256.max │
    /// ├─────────────────────────────────────────────── → ───────────┤
    /// | [UInt](repeating:  0, count: Int256.count + 1) │ Int256( 0) │
    /// | [UInt](repeating:  1, count: Int256.count + 1) │ nil        │
    /// | [UInt](repeating: ~0, count: Int256.count + 1) │ Int256(-1) │
    /// └─────────────────────────────────────────────── → ───────────┘
    /// ```
    ///
    /// - Note: This method returns zero when the given collection of `words` is empty.
    ///
    @inlinable init?(words: some RandomAccessCollection<UInt>)
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bits
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given bit.
    ///
    /// ```
    /// ┌────── → ─────────────────────────┐
    /// │ bit   │ self                     │
    /// ├────── → ────────── = ────────────┤
    /// │ false │ Int256( 0) │ 0.......... │
    /// │ true  │ Int256( 1) │ 0.........1 │
    /// └────── → ────────── = ────────────┘
    /// ```
    ///
    /// - Note: This member has un/signed two's complement semantics.
    ///
    @inlinable init(bit: Bool)
    
    /// The number of bits in its binary representation.
    ///
    /// - Note: This member is positive and nonzero.
    ///
    /// - Note: This member has un/signed two's complement semantics.
    ///
    @inlinable var bitWidth: Int { get }
    
    /// The number of bits equal to 1 in its binary representation.
    ///
    /// ```
    /// ┌───────────────────────── → ────────┐
    /// │ self                     │ n.z.b.c │
    /// ├─────────── = ─────────── → ────────┤
    /// │ Int256( 3) │ 0........11 │ 002     │
    /// │ Int256( 2) │ 0........10 │ 001     │
    /// │ Int256( 1) │ 0.........1 │ 001     │
    /// │ Int256( 0) │ 0.......... │ 000     │
    /// │ Int256(-1) │ 1.......... │ 256     │
    /// │ Int256(-2) │ 1.........0 │ 255     │
    /// │ Int256(-3) │ 1........01 │ 255     │
    /// │ Int256(-4) │ 1........00 │ 254     │
    /// └─────────── = ─────────── → ────────┘
    /// ```
    ///
    /// - Note: This member has un/signed two's complement semantics.
    ///
    /// ### Flexible Width Integers
    ///
    /// This value refers to the bits within the range of its bit width.
    ///
    @inlinable var nonzeroBitCount: Int { get }
    
    /// The number of leading zeros in its binary representation.
    ///
    /// ```
    /// ┌───────────────────────── → ────────┐
    /// │ self                     │ l.z.b.c │
    /// ├─────────── = ─────────── → ────────┤
    /// │ Int256( 3) │ 0........11 │ 254     │
    /// │ Int256( 2) │ 0........10 │ 254     │
    /// │ Int256( 1) │ 0.........1 │ 255     │
    /// │ Int256( 0) │ 0.......... │ 256     │
    /// │ Int256(-1) │ 1.......... │ 000     │
    /// │ Int256(-2) │ 1.........0 │ 000     │
    /// │ Int256(-3) │ 1........01 │ 000     │
    /// │ Int256(-4) │ 1........00 │ 000     │
    /// └─────────── = ─────────── → ────────┘
    /// ```
    ///
    /// - Note: This member has un/signed two's complement semantics.
    ///
    /// ### Flexible Width Integers
    ///
    /// This value refers to the bits within the range of its bit width.
    ///
    @inlinable var leadingZeroBitCount: Int { get }

    /// The number of trailing zeros in its binary representation.
    ///
    /// ```
    /// ┌───────────────────────── → ────────┐
    /// │ self                     │ t.z.b.c │
    /// ├─────────── = ─────────── → ────────┤
    /// │ Int256( 3) │ 0........11 │ 000     │
    /// │ Int256( 2) │ 0........10 │ 001     │
    /// │ Int256( 1) │ 0.........1 │ 000     │
    /// │ Int256( 0) │ 0.......... │ 256     │
    /// │ Int256(-1) │ 1.......... │ 000     │
    /// │ Int256(-2) │ 1.........0 │ 001     │
    /// │ Int256(-3) │ 1........01 │ 000     │
    /// │ Int256(-4) │ 1........00 │ 002     │
    /// └─────────── = ─────────── → ────────┘
    /// ```
    ///
    /// - Note: This member has un/signed two's complement semantics.
    ///
    /// ### Flexible Width Integers
    ///
    /// This value refers to the bits within the range of its bit width.
    ///
    @inlinable var trailingZeroBitCount: Int { get }
    
    /// Returns the most significant bit in its binary representation.
    ///
    /// ```
    /// ┌───────────────────────── → ──────┐
    /// │ self                     │ m.s.b │
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
    /// - Note: This member has un/signed two's complement semantics.
    ///
    /// ### Flexible Width Integers
    ///
    /// This value refers to the bits within the range of its bit width.
    ///
    @inlinable var mostSignificantBit: Bool { get }
    
    /// Returns the least significant bit in its binary representation.
    ///
    /// ```
    /// ┌───────────────────────── → ──────┐
    /// │ self                     │ l.s.b │
    /// ├─────────── = ─────────── → ──────┤
    /// │ Int256( 3) │ 0........11 │ true  │
    /// │ Int256( 2) │ 0........10 │ false │
    /// │ Int256( 1) │ 0.........1 │ true  │
    /// │ Int256( 0) │ 0.......... │ false │
    /// │ Int256(-1) │ 1.......... │ true  │
    /// │ Int256(-2) │ 1.........0 │ false │
    /// │ Int256(-3) │ 1........01 │ true  │
    /// │ Int256(-4) │ 1........00 │ false │
    /// └─────────── = ─────────── → ──────┘
    /// ```
    ///
    /// - Note: This member has un/signed two's complement semantics.
    ///
    /// ### Flexible Width Integers
    ///
    /// This value refers to the bits within the range of its bit width.
    ///
    @inlinable var leastSignificantBit: Bool { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
    
    /// Returns whether this value is equal to zero.
    ///
    /// ```
    /// ┌───────────────────────── → ───────┐
    /// │ self                     │ x == 0 │
    /// ├─────────── = ─────────── → ───────┤
    /// │ Int256( 3) │ 0........11 │ false  │
    /// │ Int256( 2) │ 0........10 │ false  │
    /// │ Int256( 1) │ 0.........1 │ false  │
    /// │ Int256( 0) │ 0.......... │ true   │
    /// │ Int256(-1) │ 1.......... │ false  │
    /// │ Int256(-2) │ 1.........0 │ false  │
    /// │ Int256(-3) │ 1........01 │ false  │
    /// │ Int256(-4) │ 1........00 │ false  │
    /// └─────────── = ─────────── → ───────┘
    /// ```
    ///
    @inlinable var isZero: Bool { get }
    
    /// Returns whether this value is less than zero.
    ///
    /// ```
    /// ┌───────────────────────── → ───────┐
    /// │ self                     │ x <  0 │
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
    @inlinable var isLessThanZero: Bool { get }
    
    /// Returns whether this value is more than zero.
    ///
    /// ```
    /// ┌───────────────────────── → ───────┐
    /// │ self                     │ x >  0 │
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
    @inlinable var isMoreThanZero: Bool { get }
    
    /// Returns whether this value is a power of two.
    ///
    /// ```
    /// ┌───────────────────────── → ──────────┐
    /// │ self                     │ pow(2, x) │
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
    @inlinable var isPowerOf2: Bool { get }
    
    /// A three-way comparison against zero.
    ///
    /// ```
    /// ┌─────────── → ────────┐
    /// │ self       │ signum  │
    /// ├─────────── → ────────┤
    /// │ Int256(-2) │ Int(-1) │ - less
    /// │ Int256( 0) │ Int( 0) │ - same
    /// │ Int256( 2) │ Int( 1) │ - more
    /// └─────────── → ────────┘
    /// ```
    ///
    @inlinable func signum() -> Int
    
    /// A three-way comparison against the given value.
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
    
    /// A three-way comparison against the given value.
    ///
    /// ```
    /// ┌────────────┬─────────── → ────────┐
    /// │ self       │ other      │ signum  │
    /// ├────────────┼─────────── → ────────┤
    /// │ Int256( 1) │ Int(    3) │ Int(-1) │ - less
    /// │ Int256( 2) │ Int(    2) │ Int( 0) │ - same
    /// │ Int256( 3) │ Int(    1) │ Int( 1) │ - more
    /// └────────────┴─────────── → ────────┘
    /// ```
    ///
    @_disfavoredOverload @inlinable func compared(to other: Digit) -> Int
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Complements
    //=------------------------------------------------------------------------=
    
    /// Forms the one's complement of `self`.
    ///
    /// ```
    /// ┌─────────── → ───────────────┐
    /// │ self       │ 1's complement │
    /// ├─────────── → ───────────────┤
    /// │ Int256( 1) │ Int256( 0)     │
    /// │ Int256( 0) │ Int256(-1)     │
    /// │ Int256(-1) │ Int256(-2)     │
    /// ├─────────── → ───────────────┤
    /// | Int256.max | Int256.min     |
    /// | Int256.min | Int256.max     |
    /// └─────────── → ───────────────┘
    /// ```
    ///
    /// ### Flexible Width Integers
    ///
    /// The transformation is performed with respect to the current bit width.
    /// The bit width may change depending on the value's normalization behavior.
    ///
    @inlinable mutating func formOnesComplement()

    /// Returns the one's complement of `self`.
    ///
    /// ```
    /// ┌─────────── → ───────────────┐
    /// │ self       │ 1's complement │
    /// ├─────────── → ───────────────┤
    /// │ Int256( 1) │ Int256( 0)     │
    /// │ Int256( 0) │ Int256(-1)     │
    /// │ Int256(-1) │ Int256(-2)     │
    /// ├─────────── → ───────────────┤
    /// | Int256.max | Int256.min     |
    /// | Int256.min | Int256.max     |
    /// └─────────── → ───────────────┘
    /// ```
    ///
    /// ### Flexible Width Integers
    ///
    /// The transformation is performed with respect to the current bit width.
    /// The bit width may change depending on the value's normalization behavior.
    ///
    @inlinable func onesComplement() -> Self
    
    /// Forms the two's complement of `self`.
    ///
    /// ```
    /// ┌─────────── → ───────────────┬──────────┐
    /// │ self       │ 2's complement │ overflow │
    /// ├─────────── → ───────────────┼──────────┤
    /// │ Int256( 1) │ Int256(-1)     │ false    │
    /// │ Int256( 0) │ Int256( 0)     │ false    │
    /// │ Int256(-1) │ Int256( 1)     │ false    │
    /// ├─────────── → ───────────────┼──────────┤
    /// | Int256.min | Int256.min     | true     |
    /// └─────────── → ───────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    /// ### Flexible Width Integers
    ///
    /// The transformation is performed with respect to the current bit width.
    /// The bit width may change depending on the value's normalization behavior.
    ///
    @inlinable mutating func formTwosComplement()
    
    /// Returns the two's complement of `self`.
    ///
    /// ```
    /// ┌─────────── → ───────────────┬──────────┐
    /// │ self       │ 2's complement │ overflow │
    /// ├─────────── → ───────────────┼──────────┤
    /// │ Int256( 1) │ Int256(-1)     │ false    │
    /// │ Int256( 0) │ Int256( 0)     │ false    │
    /// │ Int256(-1) │ Int256( 1)     │ false    │
    /// ├─────────── → ───────────────┼──────────┤
    /// | Int256.min | Int256.min     | true     |
    /// └─────────── → ───────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    @inlinable func twosComplement() -> Self
    
    /// Forms the two's complement of `self`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌─────────── → ───────────────┬──────────┐
    /// │ self       │ 2's complement │ overflow │
    /// ├─────────── → ───────────────┼──────────┤
    /// │ Int256( 1) │ Int256(-1)     │ false    │
    /// │ Int256( 0) │ Int256( 0)     │ false    │
    /// │ Int256(-1) │ Int256( 1)     │ false    │
    /// ├─────────── → ───────────────┼──────────┤
    /// | Int256.min | Int256.min     | true     |
    /// └─────────── → ───────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    /// ### Flexible Width Integers
    ///
    /// The transformation is performed with respect to the current bit width.
    /// The bit width may change depending on the value's normalization behavior.
    ///
    @inlinable mutating func formTwosComplementReportingOverflow() -> Bool
    
    /// Returns the two's complement of `self`, along with an `overflow` indicator.
    ///
    /// ```
    /// ┌─────────── → ───────────────┬──────────┐
    /// │ self       │ 2's complement │ overflow │
    /// ├─────────── → ───────────────┼──────────┤
    /// │ Int256( 1) │ Int256(-1)     │ false    │
    /// │ Int256( 0) │ Int256( 0)     │ false    │
    /// │ Int256(-1) │ Int256( 1)     │ false    │
    /// ├─────────── → ───────────────┼──────────┤
    /// | Int256.min | Int256.min     | true     |
    /// └─────────── → ───────────────┴──────────┘
    /// ```
    ///
    /// - Note: In the case of `overflow`, the result is truncated.
    ///
    /// ### Flexible Width Integers
    ///
    /// The transformation is performed with respect to the current bit width.
    /// The bit width may change depending on the value's normalization behavior.
    ///
    @inlinable func twosComplementReportingOverflow() -> PVO<Self>
    
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
    /// ### Flexible Width Integers
    ///
    /// The transformation is performed with respect to the current bit width.
    /// The bit width may change depending on the value's normalization behavior.
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
    /// ### Flexible Width Integers
    ///
    /// The transformation is performed with respect to the current bit width.
    /// The bit width may change depending on the value's normalization behavior.
    ///
    @inlinable func twosComplementSubsequence(_ carry: Bool) -> PVO<Self>
    
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
    
    /// Forms the `difference` of `lhs` and `rhs`.
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
    
    /// Forms the `difference` of `lhs` and `rhs`.
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
    
    /// Returns the `difference` of `lhs` and `rhs`.
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
    
    /// Returns the `difference` of `lhs` and `rhs`.
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
    /// │ lhs        │ rhs        │ high       │ low        │ overflow │
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
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static func *=(lhs: inout Self, rhs: Self)
    
    /// Forms the `low` product of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ high       │ low        │ overflow │
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
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @_disfavoredOverload @inlinable static func *=(lhs: inout Self, rhs: Digit)
    
    /// Returns the `low` product of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ high       │ low        │ overflow │
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
    /// - Note: In the case of `overflow`, a runtime error may occur.
    ///
    @inlinable static func *(lhs: Self, rhs: Self) -> Self
    
    /// Returns the `low` product of `lhs` and `rhs`.
    ///
    /// ```
    /// ┌────────────┬─────────── → ───────────┬────────────┬──────────┐
    /// │ lhs        │ rhs        │ high       │ low        │ overflow │
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
    /// - Note: In the case of `overflow`, the result is either truncated or, if undefined, `self`.
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
    
    /// Creates a new instance from the given `description`.
    ///
    /// The `description` may contain a plus or minus sign (+ or -), followed
    /// by one or more numeric digits (0-9). If the description uses an invalid
    /// format, or its value cannot be represented, the result is nil.
    ///
    /// ```
    /// ┌──────────── → ─────────────┐
    /// │ description │ self         │
    /// ├──────────── → ─────────────┤
    /// │  "123"      │ Int256( 123) │
    /// │ "+123"      │ Int256( 123) │
    /// │ "-123"      │ Int256(-123) │
    /// │ "~123"      │ nil          │
    /// └──────────── → ─────────────┘
    /// ```
    ///
    /// - Note: The decoding strategy is case insensitive.
    ///
    /// - Note: This member is required by `Swift.LosslessStringConvertible`.
    ///
    @inlinable init?(_ description: String)

    /// Creates a new instance from the given `description` and `radix`.
    ///
    /// The `description` may contain a plus or minus sign (+ or -), followed by one
    /// or more numeric digits (0-9) or letters (a-z or A-Z). If the description uses
    /// an invalid format, or its value cannot be represented, the result is nil.
    ///
    /// ```
    /// ┌─────────────┬────── → ─────────────┐
    /// │ description │ radix │ self         │
    /// ├─────────────┼────── → ─────────────┤
    /// │  "123"      │ 16    │ Int256( 291) │
    /// │ "+123"      │ 16    │ Int256( 291) │
    /// │ "-123"      │ 16    │ Int256(-291) │
    /// │ "~123"      │ 16    │ nil          │
    /// └─────────────┴────── → ─────────────┘
    /// ```
    ///
    /// - Note: The decoding strategy is case insensitive.
    ///
    @inlinable init?(_ description: some StringProtocol, radix: Int)
    
    /// A `description` of this value in base 10 ASCII.
    ///
    /// The description may contain a minus sign (-), followed by one
    /// or more numeric digits (0-9) or letters (a-z or A-Z). These represent
    /// the integer's sign and magnitude. Zero is always non-negative.
    ///
    /// ```
    /// ┌───────────── → ────────────┐
    /// │ self         │ description │
    /// ├───────────── → ────────────┤
    /// │ Int256( 123) │  "123"      │
    /// │ Int256(-123) │ "-123"      │
    /// └───────────── → ────────────┘
    /// ```
    ///
    /// - Note: This member is required by `Swift.CustomStringConvertible`.
    ///
    @inlinable var description: String { get }
    
    /// A `description` of this value in the given ASCII format.
    ///
    /// The description may contain a minus sign (-), followed by one
    /// or more numeric digits (0-9) or letters (a-z or A-Z). These represent
    /// the integer's sign and magnitude. Zero is always non-negative.
    ///
    /// ```
    /// ┌──────────────┬───────┬─────────── → ────────────┐
    /// │ self         │ radix │ uppercase  │ description │
    /// ├──────────────┼───────┼─────────── → ────────────┤
    /// │ Int256( 123) │ 12    │ true       │  "A3"       │
    /// │ Int256(-123) │ 16    │ false      │ "-7b"       │
    /// └──────────────┴───────┴─────────── → ────────────┘
    /// ```
    ///
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
    /// ┌───────────────────────── → ──────┐
    /// │ self                     │ odd   │
    /// ├─────────── = ─────────── → ──────┤
    /// │ Int256( 3) │ 0........11 │ true  │
    /// │ Int256( 2) │ 0........10 │ false │
    /// │ Int256( 1) │ 0.........1 │ true  │
    /// │ Int256( 0) │ 0.......... │ false │
    /// │ Int256(-1) │ 1.......... │ true  │
    /// │ Int256(-2) │ 1.........0 │ false │
    /// │ Int256(-3) │ 1........01 │ true  │
    /// │ Int256(-4) │ 1........00 │ false │
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
    /// ┌───────────────────────── → ──────┐
    /// │ self                     │ even  │
    /// ├─────────── = ─────────── → ──────┤
    /// │ Int256( 3) │ 0........11 │ false │
    /// │ Int256( 2) │ 0........10 │ true  │
    /// │ Int256( 1) │ 0.........1 │ false │
    /// │ Int256( 0) │ 0.......... │ true  │
    /// │ Int256(-1) │ 1.......... │ false │
    /// │ Int256(-2) │ 1.........0 │ true  │
    /// │ Int256(-3) │ 1........01 │ false │
    /// │ Int256(-4) │ 1........00 │ true  │
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
    // MARK: Details x Complements
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formTwosComplement() {
        _ = self.formTwosComplementReportingOverflow()
    }
    
    @inlinable public func twosComplement() -> Self {
        self.twosComplementReportingOverflow().partialValue
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
        return qro.partialValue as  QR<Self, Self>
    }
    
    @inlinable public func quotientAndRemainder(dividingBy other: Self) -> QR<Self, Self> where Self == Digit {
        let qro: PVO<QR<Self, Self>> = self.quotientAndRemainderReportingOverflow(dividingBy: other)
        precondition(!qro.overflow, NBK.callsiteOverflowInfo())
        return qro.partialValue as  QR<Self, Self>
    }
    
    @_disfavoredOverload @inlinable public func quotientAndRemainder(dividingBy other: Digit) -> QR<Self, Digit> {
        let qro: PVO<QR<Self, Digit>> = self.quotientAndRemainderReportingOverflow(dividingBy: other)
        precondition(!qro.overflow, NBK.callsiteOverflowInfo())
        return qro.partialValue as  QR<Self, Digit>
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Text
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ description: String) {
        self.init(description, radix: 10)
    }
    
    @inlinable public var description: String {
        self.description(radix: 10, uppercase: false)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Details x Text
//=----------------------------------------------------------------------------=

extension String {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a string representing the given value, in the given format.
    ///
    /// ```
    /// ┌──────────────┬───────┬─────────── → ────────────┐
    /// │ integer      │ radix │ uppercase  │ self        │
    /// ├──────────────┼───────┼─────────── → ────────────┤
    /// │ Int256( 123) │ 12    │ true       │  "A3"       │
    /// │ Int256(-123) │ 16    │ false      │ "-7b"       │
    /// └──────────────┴───────┴─────────── → ────────────┘
    /// ```
    ///
    @inlinable public init(_ source: some NBKBinaryInteger, radix: Int = 10, uppercase: Bool = false) {
        self = source.description(radix: radix, uppercase: uppercase)
    }
}
