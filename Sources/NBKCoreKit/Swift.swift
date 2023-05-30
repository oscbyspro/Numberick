//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Binary Integer x Swift
//*============================================================================*

extension Swift.BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Text
    //=------------------------------------------------------------------------=
    
    /// Creates a `description` representing this value, in the given format.
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
    @inlinable public func description(radix: Int = 10, uppercase: Bool = false) -> String {
        String(self, radix: radix, uppercase: uppercase)
    }
}
