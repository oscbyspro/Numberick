//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Complements
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Binary Integer Limbs x Succinct
    //=------------------------------------------------------------------------=
    
    /// Returns the `sign` bit, along with the `body` of significant limbs.
    ///
    /// ```
    /// ┌─────────────── → ───────────────┬──────┐
    /// │ source         │ body           │ sign │
    /// ├─────────────── → ───────────────┼──────┤
    /// │  0,  0,  0,  0 │                │ 0    │
    /// │  1,  2,  0,  0 │  1,  2         │ 0    │
    /// │ ~1, ~2, ~0, ~0 │ ~1, ~2         │ 1    │
    /// │ ~0, ~0, ~0, ~0 │                │ 1    │
    /// └─────────────── → ───────────────┴──────┘
    /// ```
    ///
    @_transparent public static func makeSuccinctSignedIntegerLimbs(_ source: NBK.UnsafeWords) -> (body: NBK.UnsafeWords, sign: Bool) {
        let sign = source.last!.mostSignificantBit
        let bits = UInt(repeating: sign)
        let body = NBK.UnsafeWords(rebasing: NBK.dropLast(from: source, while:{ $0 == bits }))
        return (body: body, sign: sign)
    }
    
    /// Returns the `sign` bit, along with the `body` of significant limbs.
    ///
    /// ```
    /// ┌─────────────── → ───────────────┬──────┐
    /// │ source         │ body           │ sign │
    /// ├─────────────── → ───────────────┼──────┤
    /// │  0,  0,  0,  0 │                │ 0    │
    /// │  1,  2,  0,  0 │  1,  2         │ 0    │
    /// │ ~1, ~2, ~0, ~0 │ ~1, ~2, ~0, ~0 │ 0    │
    /// │ ~0, ~0, ~0, ~0 │ ~0, ~0, ~0, ~0 │ 0    │
    /// └─────────────── → ───────────────┴──────┘
    /// ```
    ///
    @_transparent public static func makeSuccinctUnsignedInteger(_ source: NBK.UnsafeWords) -> (body: NBK.UnsafeWords, sign: Void) {
        return (body: NBK.UnsafeWords(rebasing: NBK.dropLast(from: source, while:{ $0.isZero })), sign: Void())
    }
}
