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
    
    /// Returns an `UTF-8` encoded integer's `sign` and `body`.
    ///
    /// ```
    /// ┌─────── → ──────┬────────┐
    /// │ utf8   │ sign  │  body  │
    /// ├─────── → ──────┼────────┤
    /// │ "+123" │ plus  │  "123" │
    /// │ "-123" │ minus │  "123" │
    /// │ "~123" │ plus  │ "~123" │
    /// └─────── → ──────┴────────┘
    /// ```
    ///
    @inlinable public static func integerComponents<T>(utf8: T) -> (sign: Sign, body: T.SubSequence) where T: Collection<UInt8> {
        var body = utf8[...] as T.SubSequence
        let sign = NBK.removeSignPrefix(utf8: &body) ?? Sign.plus
        return (sign: sign, body: body)
    }
    
    /// Removes and returns an `UTF-8` encoded `sign` prefix, if it exists.
    ///
    /// ```
    /// ┌─────── → ──────┬────────┐
    /// │ self   │ sign  │  self  │
    /// ├─────── → ──────┼────────┤
    /// │ "+123" │ plus  │  "123" │
    /// │ "-123" │ minus │  "123" │
    /// │ "~123" │ nil   │ "~123" │
    /// └─────── → ──────┴────────┘
    /// ```
    ///
    @inlinable public static func removeSignPrefix<T>(utf8: inout T) -> Sign? where T: Collection<UInt8>, T == T.SubSequence {
        switch utf8.first {
        case UInt8(ascii: "+"): utf8.removeFirst(); return Sign.plus
        case UInt8(ascii: "-"): utf8.removeFirst(); return Sign.minus
        default: return nil  }
    }
}
