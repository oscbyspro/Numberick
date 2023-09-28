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
// MARK: * NBK x Flexible Width x Text x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Decoding
    //=------------------------------------------------------------------------=
    
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
    @inlinable public init?(_ description: some StringProtocol, radix: Int) {
        let decoder = NBK.IntegerDescription.Decoder(radix: radix)
        if let value: Self = decoder.decode(description) { self = value } else { return nil }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encoding
    //=------------------------------------------------------------------------=
    
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
    @inlinable public func description(radix: Int, uppercase: Bool) -> String {
        let encoder = NBK.IntegerDescription.Encoder(radix: radix, uppercase: uppercase)
        return encoder.encode(self) as String
    }
}
