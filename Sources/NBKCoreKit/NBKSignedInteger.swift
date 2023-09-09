//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Signed Integer
//*============================================================================*

/// A signed, binary, integer.
///
/// ### Two's Complement
///
/// Like `BinaryInteger`, it has [two's complement][2s] semantics.
///
/// ```
/// The two's complement representation of  0 is an infinite sequence of 0s.
/// The two's complement representation of -1 is an infinite sequence of 1s.
/// ```
///
/// [2s]: https://en.wikipedia.org/wiki/Two%27s_complement
///
public protocol NBKSignedInteger: NBKBinaryInteger, SignedInteger where Digit: NBKSignedInteger {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the additive inverse of `number`.
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
    
    /// Forms the additive inverse of `self`.
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
    
    /// Returns the additive inverse of `self`.
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
    
    /// Forms the additive inverse of `self`, and returns an `overflow` indicator.
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
    
    /// Returns the additive inverse of `self`, along with an `overflow` indicator.
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
