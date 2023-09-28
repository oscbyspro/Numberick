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
// MARK: * NBK x Signed x Text
//*============================================================================*

extension NBKSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Decoding
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
    @inlinable public init?(_ description: String) {
        self.init(description, radix: 10)
    }
    
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
        //  TODO: decoder needs a sign and magnitude option
        let components = NBK.IntegerDescription.makeSignBody(from: description.utf8)
        let body = description[components.body.startIndex ..< components.body.endIndex]
        guard let magnitude = Magnitude(body, radix: radix) else { return nil }
        self.init(sign: components.sign,  magnitude: magnitude)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encoding
    //=------------------------------------------------------------------------=
    
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
    @inlinable public var description: String {
        self.description(radix: 10, uppercase: false)
    }
    
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
        return encoder.encode(sign: self.sign, magnitude: self.magnitude.words) as String
    }
}

//=----------------------------------------------------------------------------=
// MARK: + String
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
    @inlinable public init<T>(_ value: NBKSigned<T>, radix: Int = 10, uppercase: Bool = false) {
        self = value.description(radix: radix, uppercase: uppercase)
    }
}
