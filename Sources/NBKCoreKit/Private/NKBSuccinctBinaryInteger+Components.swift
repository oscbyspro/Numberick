//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Succinct Binary Integer x Components
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Pointers
//=----------------------------------------------------------------------------=

extension NBK.SuccinctBinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the `sign` bit, along with the `body` of significant elements.
    ///
    /// ```
    /// ┌─────────────── → ───────────────┬───────┐
    /// │ source         │ body           │ sign  │
    /// ├─────────────── → ───────────────┼───────┤
    /// │  0,  0,  0,  0 │                │ false │
    /// │  1,  2,  0,  0 │  1,  2         │ false │
    /// │ ~1, ~2, ~0, ~0 │ ~1, ~2         │ true  │
    /// │ ~0, ~0, ~0, ~0 │                │ true  │
    /// ├─────────────── → ───────────────┼───────┤
    /// │                │                │ error │
    /// └─────────────── → ───────────────┴───────┘
    /// ```
    ///
    /// ### Development
    ///
    /// `@inline(always)` is required for `NBKFlexibleWidth` performance reasons.
    ///
    @inline(__always) @inlinable public static func components<T>(
    fromStrictSignedInteger source: Base) -> Components where Base == UnsafeBufferPointer<T> {
        let sign = source.last!.mostSignificantBit
        let bits = UInt(repeating: sign)
        let body = Base(rebasing: NBK.dropLast(from: source, while:{ $0 == bits }))
        return Components(body: body, sign: sign)
    }
    
    /// Returns the `sign` bit, along with the `body` of significant elements.
    ///
    /// ```
    /// ┌─────────────── → ───────────────┬───────┐
    /// │ source         │ body           │ sign  │
    /// ├─────────────── → ───────────────┼───────┤
    /// │  0,  0,  0,  0 │                │ false │
    /// │  1,  2,  0,  0 │  1,  2         │ false │
    /// │ ~1, ~2, ~0, ~0 │ ~1, ~2, ~0, ~0 │ false │
    /// │ ~0, ~0, ~0, ~0 │ ~0, ~0, ~0, ~0 │ false │
    /// ├─────────────── → ───────────────┼───────┤
    /// │                │                │ false │
    /// └─────────────── → ───────────────┴───────┘
    /// ```
    ///
    /// ### Development
    ///
    /// `@inline(always)` is required for `NBKFlexibleWidth` performance reasons.
    ///
    @inline(__always) @inlinable public static func components<T>(
    fromStrictUnsignedIntegerSubSequence source: Base) -> Components where Base == UnsafeBufferPointer<T> {
        Components(body: Base(rebasing: NBK.dropLast(from: source, while:{ $0.isZero })), sign: false)
    }
}

