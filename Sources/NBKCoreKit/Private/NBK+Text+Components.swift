//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Text x Components
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Removes and returns an `UTF-8` encoded `sign` prefix, if it exists.
    ///
    /// ```
    /// ┌─────── → ──────┬────────┐
    /// │ body   │ sign  │   body │
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
    
    #warning("tests")
    /// Removes and returns an `UTF-8` encoded `radix` prefix, if it exists.
    ///
    /// ```
    /// ┌──────── → ──────┬─────────┐
    /// │ body    │ radix │    body │
    /// ├──────── → ──────┼─────────┤
    /// │ "0b123" │ 002   │   "123" │
    /// │ "0o123" │ 008   │   "123" │
    /// │ "0x123" │ 016   │   "123" │
    /// ├──────── → ──────┼─────────┤
    /// │ "1x123" │ nil   │ "1x123" │
    /// │ "0X123" │ nil   │ "0X123" │
    /// └──────── → ──────┴─────────┘
    /// ```
    ///
    @inlinable public static func removeRadixPrefix<T>(utf8: inout T) -> Int? where T: Collection<UInt8>, T == T.SubSequence {
        var radix: Int?
        
        var index = utf8.startIndex
        if  index < utf8.endIndex, utf8[index] == UInt8(ascii: "0") {
            utf8.formIndex(after: &index)
            
            switch utf8[index] {
            case UInt8(ascii: "x"): radix = 0x10; utf8 = utf8[utf8.index(after: index)...]
            case UInt8(ascii: "o"): radix = 0o10; utf8 = utf8[utf8.index(after: index)...]
            case UInt8(ascii: "b"): radix = 0b10; utf8 = utf8[utf8.index(after: index)...]
            default: break }
        }
        
        return radix as Int?
    }
    
    /// Returns an `UTF-8` encoded integer's `sign` and `body`.
    ///
    /// ```
    /// ┌─────── → ──────┬────────┐
    /// │ body   │ sign  │   body │
    /// ├─────── → ──────┼────────┤
    /// │ "+123" │ plus  │  "123" │
    /// │ "-123" │ minus │  "123" │
    /// │ "~123" │ plus  │ "~123" │
    /// └─────── → ──────┴────────┘
    /// ```
    ///
    /// - Note: Integers without sign are interpreted as positive.
    ///
    @inlinable public static func makeIntegerComponents<T>(utf8: T) -> (sign: Sign, body: T.SubSequence) where T: Collection<UInt8> {
        var body = utf8[...] as T.SubSequence
        let sign = NBK.removeSignPrefix(utf8: &body) ?? Sign.plus
        return (sign: sign, body: body)
    }
}
