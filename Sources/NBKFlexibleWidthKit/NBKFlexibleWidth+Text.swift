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
    // MARK: Details x Decode
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
    /// - Note: This member is required by `Swift.LosslessStringConvertible`.
    ///
    @inlinable public init?(_ description: String) {
        self.init(description, radix: 10)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Encode
    //=------------------------------------------------------------------------=
    
    /// The `description` of this value.
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
    
    /// The `description` of this type.
    ///
    /// ```
    /// ┌───────────── → ────────────┐
    /// │ self         │ description │
    /// ├───────────── → ────────────┤
    /// │  Int256.self │  "Int256"   │
    /// │ UInt512.self │ "UInt512"   │
    /// └───────────── → ────────────┘
    /// ```
    ///
    @inlinable public static var description: String {
        "UIntXL"
    }
}
