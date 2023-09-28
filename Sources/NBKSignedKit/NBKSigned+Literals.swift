//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

//*============================================================================*
// MARK: * NBK x Signed x Literals
//*============================================================================*

extension NBKSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Integer Literal Type
    //=------------------------------------------------------------------------=
    
    @inlinable public init(integerLiteral source: Int) {
        self.init(source)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x String Literal Type
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given string literal.
    ///
    /// The string literal may contain a plus or minus sign (+ or -), followed by
    /// an optional radix indicator (0b, 0o or 0x), then one or more numeric digits
    /// (0-9) or letters (a-z or A-Z). If the string literal uses an invalid format,
    /// or its value cannot be represented, a runtime error may occur.
    ///
    /// ```
    /// ┌───────── → ─────────────┐
    /// │ literal  │ self         │
    /// ├───────── → ─────────────┤
    /// │    "123" │ Int256( 123) │
    /// │ "+0x123" │ Int256( 291) │
    /// │ "-0x123" │ Int256(-291) │
    /// │ "~OX123" │ error        │
    /// └───────── → ─────────────┘
    /// ```
    ///
    /// - Note: The decoding strategy is case insensitive.
    ///
    @inlinable public init(stringLiteral source: StaticString) {
        if  let value = Self(exactlyStringLiteral: source) { self = value } else {
            preconditionFailure("\(Self.self) cannot represent \(source)")
        }
    }
    
    @inlinable init?(exactlyStringLiteral source: StaticString) {
        let decoder = NBK.IntegerDescription.DecoderDecodingRadix()
        guard let components: SM<Magnitude> = decoder.decode(source) else { return nil }
        self.init(sign: components.sign, magnitude: components.magnitude)
    }
}
