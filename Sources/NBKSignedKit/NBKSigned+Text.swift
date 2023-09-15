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
    // MARK: Details x Decode
    //=------------------------------------------------------------------------=
    
    @inlinable public init?(_ description: String) {
        self.init(description, radix: 10)
    }
    
    @inlinable public init?(_ description: some StringProtocol, radix: Int) {
        let components = NBK.makeIntegerComponents(utf8: description.utf8)
        let body = description[components.body.startIndex ..< components.body.endIndex]
        guard let magnitude = Magnitude(body, radix: radix) else { return nil }
        self.init(sign: components.sign,  magnitude: magnitude)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encode
    //=------------------------------------------------------------------------=
    
    @inlinable public var description: String {
        self.description(radix: 10, uppercase: false)
    }
    
    @inlinable public func description(radix: Int = 10, uppercase: Bool = false) -> String {
        let minus  = self.sign == Sign.minus
        let digits = self.magnitude.description(radix: radix, uppercase: uppercase)
        return minus ? "-" + digits : digits
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
