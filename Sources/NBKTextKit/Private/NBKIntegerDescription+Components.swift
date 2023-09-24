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
// MARK: * NBK x Integer Description x Components x Unsafe
//*============================================================================*

@frozen @usableFromInline struct NBKIntegerDescriptionComponents<UTF8> where UTF8: Collection<UInt8> {
    
    @usableFromInline typealias Sign = FloatingPointSign
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let sign: Sign
    @usableFromInline let radix: Int
    @usableFromInline let body: UTF8.SubSequence
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance from the given `text`.
    ///
    /// ```
    /// ┌───────── → ──────┬───────┬──────────┐
    /// │     text │ sign  │ radix │     body │
    /// ├───────── → ──────┼───────┼──────────┤
    /// │    "123" │ plus  │ 010   │    "123" │
    /// │ "+0b123" │ plus  │ 002   │    "123" │
    /// │ "-0x123" │ minus │ 016   │    "123" │
    /// ├───────── → ──────┼───────┼──────────┤
    /// │ "~Ox123" │ plus  │ 010   │ "~Ox123" │
    /// │ "~0X123" │ plus  │ 010   │ "~0X123" │
    /// └───────── → ──────┴───────┴──────────┘
    /// ```
    ///
    /// - Note: Integers without sign are interpreted as positive.
    ///
    /// - Note: Integers without radix are interpreted as base 10.
    ///
    @inlinable init(text: UTF8)  {
        var  body  = text[...] as UTF8.SubSequence
        self.sign  = Self.removeLeadingSign (utf8: &body) ?? Sign.plus
        self.radix = Self.removeLeadingRadix(utf8: &body) ?? 10 as Int
        self.body  = body
    }
    
    /// Creates a new instance from the given `text` and `radix`.
    ///
    /// ```
    /// ┌─────── → ──────┬────────┐
    /// │   text │ sign  │   body │
    /// ├─────── → ──────┼────────┤
    /// │ "+123" │ plus  │  "123" │
    /// │ "-123" │ minus │  "123" │
    /// │ "~123" │ nil   │ "~123" │
    /// └─────── → ──────┴────────┘
    /// ```
    ///
    /// - Note: Integers without sign are interpreted as positive.
    ///
    @inlinable init(text: UTF8, radix: Int) {
        precondition(2 <= radix && radix <= 36)
        var  body  = text[...] as UTF8.SubSequence
        self.sign  = NBK.removeLeadingSign(utf8: &body) ?? Sign.plus
        self.radix = radix
        self.body  = body
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
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
    @inlinable public static func removeLeadingSign(utf8: inout UTF8.SubSequence) -> Sign? {
        switch utf8.first {
        case UInt8(ascii: "+"): utf8.removeFirst(); return Sign.plus
        case UInt8(ascii: "-"): utf8.removeFirst(); return Sign.minus
        default: return nil  }
    }
    
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
    /// │ "Ox123" │ nil   │ "Ox123" │
    /// │ "0X123" │ nil   │ "0X123" │
    /// └──────── → ──────┴─────────┘
    /// ```
    ///
    @inlinable public static func removeLeadingRadix(utf8: inout UTF8.SubSequence) -> Int? {
        var radix: Int?
        
        var index = utf8.startIndex
        if  index < utf8.endIndex, utf8[index] == UInt8(ascii: "0") {
            utf8.formIndex(after: &index)
            
            switch utf8[index] {
            case UInt8(ascii: "x"): radix = 0x10; utf8 = utf8[utf8.index(after: index)...]
            case UInt8(ascii: "b"): radix = 0b10; utf8 = utf8[utf8.index(after: index)...]
            case UInt8(ascii: "o"): radix = 0o10; utf8 = utf8[utf8.index(after: index)...]
            default: break }
        }
        
        return radix as Int?
    }
}
