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
    
    @inlinable public init?(_ description: String) {
        self.init(description, radix: 10)
    }
    
    // TODO: decoder needs a sign and magnitude option
    @inlinable public init?(_ description: some StringProtocol, radix: Int) {
        let components = NBK.IntegerDescription.makeSignBody(from: description.utf8)
        let body = description[components.body.startIndex ..< components.body.endIndex]
        guard let magnitude = Magnitude(body, radix: radix) else { return nil }
        self.init(sign: components.sign,  magnitude: magnitude)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encoding
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        self.description(radix: 10, uppercase: false)
    }
    
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
