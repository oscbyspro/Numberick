//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Text
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the integer's sign, along with all other code points.
    ///
    /// ```
    /// ┌─────── → ───────┬────────┐
    /// │ utf8   │  sign  │  body  │
    /// ├─────── → ───────┼────────┤
    /// │ "+123" │ .plus  │  "123" │
    /// │ "-123" │ .minus │  "123" │
    /// │ "~123" │ .plus  │ "~123" │
    /// └─────── → ───────┴────────┘
    /// ```
    ///
    @inlinable public static func unsafeIntegerComponents(utf8: UnsafeUTF8) -> (sign: Sign, body: UnsafeUTF8) {
        var utf8 = utf8[...] as UnsafeUTF8.SubSequence
        let sign = NBK.removeSignPrefix(utf8: &utf8) ?? Sign.plus
        let body = UnsafeUTF8(rebasing: utf8)
        return (sign: sign, body: body)
    }
    
    /// Removes and returns an `UTF-8` encoded sign prefix, if it exists.
    ///
    /// ```
    /// ┌─────── → ───────┬────────┐
    /// │ utf8   │  sign  │  utf8  │
    /// ├─────── → ───────┼────────┤
    /// │ "+123" │ .plus  │  "123" │
    /// │ "-123" │ .minus │  "123" │
    /// │ "~123" │  nil   │ "~123" │
    /// └─────── → ───────┴────────┘
    /// ```
    ///
    @inlinable public static func removeSignPrefix(utf8: inout UnsafeUTF8.SubSequence) -> Sign? {
        switch utf8.first {
        case UInt8(ascii: "+"): utf8.removeFirst(); return Sign.plus
        case UInt8(ascii: "-"): utf8.removeFirst(); return Sign.minus
        default: return nil  }
    }
}
