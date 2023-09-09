//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Limbs x Succinct
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the `sign` bit, along with the `body` of significant limbs.
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
    @_transparent public static func makeSuccinctSignedInteger(fromStrictSignedInteger source: UnsafeWords) -> UnsafeSuccinctWords {
        let sign = source.last!.mostSignificantBit
        let bits = UInt(repeating: sign)
        let body = UnsafeWords(rebasing: NBK.dropLast(from: source, while:{ $0 == bits }))
        return (body:  body, sign: sign)
    }
    
    /// Returns the `sign` bit, along with the `body` of significant limbs.
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
    /// - Note: This operation interprets empty collections as zero.
    ///
    @_transparent public static func makeSuccinctUnsignedInteger(fromLenientUnsignedInteger source: UnsafeWords) -> UnsafeSuccinctWords {
        return (body: UnsafeWords(rebasing: NBK.dropLast(from: source, while:{ $0.isZero })), sign: false)
    }
}
