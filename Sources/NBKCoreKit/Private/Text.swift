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
    
    /// Returns the sign and radix, along with any remaining characters.
    ///
    /// ```swift
    /// NBK.bigEndianTextComponents("+0x???", radix: nil) // (sign: plus,  radix: 16, body:    "???")
    /// NBK.bigEndianTextComponents("??????", radix: nil) // (sign: plus,  radix: 10, body: "??????")
    /// NBK.bigEndianTextComponents("-0x???", radix:   2) // (sign: minus, radix:  2, body:  "0x???")
    /// ```
    ///
    @inlinable public static func bigEndianTextComponents<T>(_ text: T, radix: Int?)
    -> (sign: FloatingPointSign, radix: Int, body: T.SubSequence) where T: StringProtocol {
        var body  = text[...]
        let sign  = body.removeSignPrefix() ?? .plus
        let radix = radix ?? body.removeRadixLiteralPrefix() ?? 10
        return (sign: sign, radix: radix, body: body)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + SubSequence
//=----------------------------------------------------------------------------=

extension StringProtocol where Self == SubSequence {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Removes and returns a sign prefix, if it exists.
    ///
    /// ```swift
    /// var a = "+?"[...]; a.removeSignPrefix() // a = "?"; -> plus
    /// var b = "-?"[...]; b.removeSignPrefix() // b = "?"; -> minus
    /// var c = "??"[...]; c.removeSignPrefix() // nil
    /// ```
    ///
    @inlinable internal mutating func removeSignPrefix() -> FloatingPointSign? {
        switch true {
        case hasPrefix("-"): removeFirst(); return .minus
        case hasPrefix("+"): removeFirst(); return .plus
        default: return nil }
    }
    
    /// Removes and returns a radix literal prefix, if it exists.
    ///
    /// ```swift
    /// var a = "0x?"[...]; a.removeRadixLiteralPrefix() // a = "?"; -> 16
    /// var b = "0o?"[...]; b.removeRadixLiteralPrefix() // b = "?"; -> 08
    /// var c = "0b?"[...]; c.removeRadixLiteralPrefix() // c = "?"; -> 02
    /// var d = "???"[...]; d.removeRadixLiteralPrefix() // nil
    /// ```
    ///
    @inlinable internal mutating func removeRadixLiteralPrefix() -> Int? {
        switch true {
        case hasPrefix("0x"): removeFirst(2); return 0x10
        case hasPrefix("0b"): removeFirst(2); return 0b10
        case hasPrefix("0o"): removeFirst(2); return 0o10
        default: return nil }
    }
}
