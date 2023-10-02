//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Integer Description x Components
//*============================================================================*

extension NBK.IntegerDescription {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns an `UTF-8` encoded integer's `sign` and `body`.
    ///
    /// ```
    /// ┌──────────── → ──────┬────────┐
    /// │ description │ sign  │   body │
    /// ├──────────── → ──────┼────────┤
    /// │      "+123" │ plus  │  "123" │
    /// │      "-123" │ minus │  "123" │
    /// ├──────────── → ──────┼────────┤
    /// │      "~123" │ plus  │ "~123" │
    /// └──────────── → ──────┴────────┘
    /// ```
    ///
    /// - Note: Integers without sign are interpreted as positive.
    ///
    @inlinable public static func makeSignBody<UTF8>(from description: UTF8)
    -> (sign: NBK.Sign, body: UTF8.SubSequence) where UTF8: Collection<UInt8> {
        var body = description[...] as UTF8.SubSequence
        let sign = self.removeLeadingSign(from: &body) ?? NBK.Sign.plus
        return (sign: sign, body: body)
    }
    
    /// Returns an `UTF-8` encoded integer's `sign`, `radix`, and `body`.
    ///
    /// ```
    /// ┌──────────── → ──────┬───────┬──────────┐
    /// │ description │ sign  │ radix │   body   │
    /// ├──────────── → ──────┼───────┼──────────┤
    /// │       "123" │ plus  │ 010   │    "123" │
    /// │    "+0b123" │ plus  │ 002   │    "123" │
    /// │    "-0x123" │ minus │ 016   │    "123" │
    /// ├──────────── → ──────┼───────┼──────────┤
    /// │    "~Ox123" │ plus  │ 010   │ "~Ox123" │
    /// │    "~0X123" │ plus  │ 010   │ "~0X123" │
    /// └──────────── → ──────┴───────┴──────────┘
    /// ```
    ///
    /// - Note: Integers without sign are interpreted as positive.
    ///
    /// - Note: Integers without radix are interpreted as base 10.
    ///
    @inlinable public static func makeSignRadixBody<UTF8>(from description: UTF8)
    -> (sign: NBK.Sign, radix: Int, body: UTF8.SubSequence) where UTF8: Collection<UInt8> {
        var body  = description[...] as UTF8.SubSequence
        let sign  = self.removeLeadingSign (from: &body) ?? NBK.Sign.plus
        let radix = self.removeLeadingRadix(from: &body) ?? 10 as Int
        return (sign:  sign, radix:  radix, body:  body)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Removes and returns an `UTF-8` encoded `sign` prefix, if it exists.
    ///
    /// ```
    /// ┌──────────── → ──────┬────────┐
    /// │ description │ sign  │   body │
    /// ├──────────── → ──────┼────────┤
    /// │      "+123" │ plus  │  "123" │
    /// │      "-123" │ minus │  "123" │
    /// │      "~123" │ nil   │ "~123" │
    /// └──────────── → ──────┴────────┘
    /// ```
    ///
    @inlinable public static func removeLeadingSign<UTF8>(from description: inout UTF8)
    ->  NBK.Sign? where UTF8: Collection<UInt8>, UTF8 == UTF8.SubSequence {
        switch description.first {
        case UInt8(ascii: "+"): description.removeFirst(); return NBK.Sign.plus
        case UInt8(ascii: "-"): description.removeFirst(); return NBK.Sign.minus
        default: return nil  }
    }
    
    /// Removes and returns an `UTF-8` encoded `radix` prefix, if it exists.
    ///
    /// ```
    /// ┌──────────── → ──────┬─────────┐
    /// │ description │ radix │    body │
    /// ├──────────── → ──────┼─────────┤
    /// │     "0b123" │ 002   │   "123" │
    /// │     "0o123" │ 008   │   "123" │
    /// │     "0x123" │ 016   │   "123" │
    /// ├──────────── → ──────┼─────────┤
    /// │     "Ox123" │ nil   │ "Ox123" │
    /// │     "0X123" │ nil   │ "0X123" │
    /// └──────────── → ──────┴─────────┘
    /// ```
    ///
    @inlinable public static func removeLeadingRadix<UTF8>(from description: inout UTF8)
    ->  Int? where UTF8: Collection<UInt8>, UTF8 == UTF8.SubSequence {
        var radix:  Int?
        var index = description.startIndex
        if  index < description.endIndex, description[index] == UInt8(ascii: "0") {
            description.formIndex(after: &index)
            if  index < description.endIndex {
                switch  description[index] {
                case UInt8(ascii: "x"): radix = 0x10; description = description[description.index(after: index)...]
                case UInt8(ascii: "b"): radix = 0b10; description = description[description.index(after: index)...]
                case UInt8(ascii: "o"): radix = 0o10; description = description[description.index(after: index)...]
                default: break }
            }
        }

        return radix as Int?
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Performs an action with a temporary allocation that contains a minus sign or is empty.
    @inlinable public static func withUnsafeTemporarySignPrefix<T>(
    minus: Bool, perform: (NBK.UnsafeUTF8) -> T) -> T {
        Swift.withUnsafeTemporaryAllocation(of: UInt8.self, capacity: 1 as Int) { buffer in
            //=----------------------------------=
            // pointee: initialization
            //=----------------------------------=
            buffer.baseAddress!.initialize(to: UInt8(ascii: "-"))
            //=----------------------------------=
            // pointee: deferred deinitialization
            //=----------------------------------=
            defer {
                buffer.baseAddress!.deinitialize(count: 1 as Int)
            }
            //=----------------------------------=
            return perform(UnsafeBufferPointer(start: buffer.baseAddress!, count: Int(bit: minus)))
        }
    }
}
