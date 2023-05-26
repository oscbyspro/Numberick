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
    
    /// Returns the sign, along with all remaining characters.
    ///
    /// ```
    /// │ input  │     output      │
    /// ├────────┼────────┬────────┤
    /// │ ascii  │  sign  │  body  │
    /// ├────────┼────────┼────────┤
    /// │ "+123" │ .plus  │  "123" │
    /// │ "+123" │ .minus │  "123" │
    /// │ "~123" │ .plus  │ "~123" │
    /// ```
    ///
    @inlinable public static func unsafeIntegerTextComponents(utf8: UnsafeBufferPointer<UInt8>)
    -> (sign: FloatingPointSign, body: UnsafeBufferPointer<UInt8>) {
        var utf8 = utf8[...]
        let sign = utf8.removeSignPrefix() ??   .plus
        let body = UnsafeBufferPointer(rebasing: utf8)
        return (sign, body)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + SubSequence
//=----------------------------------------------------------------------------=

extension UnsafeBufferPointer<UInt8>.SubSequence {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Removes and returns a sign prefix, if it exists.
    ///
    /// ```
    /// │ input  │     output      │
    /// ├────────┼────────┬────────┤
    /// │ ascii  │  sign  │  self  │
    /// ├────────┼────────┼────────┤
    /// │ "+123" │ .plus  │  "123" │
    /// │ "+123" │ .minus │  "123" │
    /// │ "~123" │ .plus  │ "~123" │
    /// ```
    ///
    @inlinable mutating func removeSignPrefix() -> FloatingPointSign? {
        guard !self.isEmpty else { return nil }
        //=--------------------------------------=
        var slice = self[...] as SubSequence
        //=--------------------------------------=
        switch slice.removeFirst() {
        case UInt8(ascii: "+"): self = slice; return .plus
        case UInt8(ascii: "-"): self = slice; return .minus
        default:   return nil }
    }
}
