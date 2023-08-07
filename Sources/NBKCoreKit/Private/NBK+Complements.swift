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
    // MARK: Details x Succinct Binary Integer
    //=------------------------------------------------------------------------=
    
    /// Returns a `sign` bit, along with a `body` of significant words.
    @inlinable public static func succinctSignedInteger(_ source: NBK.UnsafeWords) -> (body: NBK.UnsafeWords, sign: Bool) {
        let sign = source.last!.mostSignificantBit
        let bits = UInt(repeating: sign)
        let body = NBK.UnsafeWords(rebasing: NBK.dropLast(from: source, while:{ $0 == bits }))
        return (body: body, sign: sign)
    }
    
    /// Returns a `sign` bit, along with a `body` of significant words.
    @inlinable public static func succinctUnsignedInteger(_ source: NBK.UnsafeWords) -> (body: NBK.UnsafeWords, sign: Void) {
        return (body: NBK.UnsafeWords(rebasing: NBK.dropLast(from: source, while:{ $0.isZero })), sign: Void())
    }
}
