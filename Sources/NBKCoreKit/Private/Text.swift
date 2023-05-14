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

extension StringProtocol {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the sign and radix, along with any remaining characters.
    ///
    /// ```swift
    /// "+0x???"._bigEndianTextComponents(radix: nil) // (sign: false,  radix: 16, body:    "???")
    /// "??????"._bigEndianTextComponents(radix: nil) // (sign: false,  radix: 10, body: "??????")
    /// "-0x???"._bigEndianTextComponents(radix:   2) // (sign: true, radix:  2, body:  "0x???")
    /// ```
    ///
    @inlinable public func _bigEndianTextComponents(radix: Int?) -> (sign: Bool, radix: Int, body: SubSequence) {
        var body  = self[...]
        let sign  = body._removeSignPrefix() ?? false
        let radix = radix ?? body._removeRadixLiteralPrefix() ?? 10
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
    /// var a = "+?"[...]; a._removeSignPrefix() // a = "?"; -> false
    /// var b = "-?"[...]; b._removeSignPrefix() // b = "?"; -> true
    /// var c = "??"[...]; c._removeSignPrefix() // nil
    /// ```
    ///
    @inlinable public mutating func _removeSignPrefix() -> Bool? {
        switch true {
        case hasPrefix("-"): removeFirst(); return true
        case hasPrefix("+"): removeFirst(); return false
        default: return nil }
    }
    
    /// Removes and returns a radix literal prefix, if it exists.
    ///
    /// ```swift
    /// var a = "0x?"[...]; a._removeRadixLiteralPrefix() // a = "?"; -> 16
    /// var b = "0o?"[...]; b._removeRadixLiteralPrefix() // b = "?"; -> 08
    /// var c = "0b?"[...]; c._removeRadixLiteralPrefix() // c = "?"; -> 02
    /// var d = "???"[...]; d._removeRadixLiteralPrefix() // nil
    /// ```
    ///
    @inlinable public mutating func _removeRadixLiteralPrefix() -> Int? {
        switch true {
        case hasPrefix("0x"): removeFirst(2); return 0x10
        case hasPrefix("0b"): removeFirst(2); return 0b10
        case hasPrefix("0o"): removeFirst(2); return 0o10
        default: return nil }
    }
}
