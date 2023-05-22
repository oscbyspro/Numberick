//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

// TODO: write documentation
//*============================================================================*
// MARK: * NBK x Text
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the sign and radix, along with any remaining characters.
    @inlinable public static func components(ascii: UnsafeBufferPointer<UInt8>, radix: Int?)
    -> (sign:  FloatingPointSign, radix: Int, body: UnsafeBufferPointer<UInt8>) {
        var ascii = ascii[...]
        let sign  = ascii.removeSignPrefix() ?? .plus
        let radix = radix ?? ascii.removeRadixLiteralPrefix() ?? 10
        let body  = UnsafeBufferPointer(rebasing: ascii)
        return (sign, radix, body)
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
    @inlinable internal mutating func removeSignPrefix() -> FloatingPointSign? {
        guard self.count >= 1 else { return nil }
        //=--------------------------------------=
        var index = self.startIndex
        //=--------------------------------------=
        switch self[self.startIndex] {
        case UInt8(ascii: "-"):
            self.formIndex(after: &index)
            self = self[index...]
            return FloatingPointSign.minus
        case UInt8(ascii: "+"):
            self.formIndex(after: &index)
            self = self[index...]
            return FloatingPointSign.plus
        default: return nil }
    }
    
    /// Removes and returns a radix literal prefix, if it exists.
    @inlinable internal mutating func removeRadixLiteralPrefix() -> Int? {
        guard self.count >= 2 else { return nil }
        //=--------------------------------------=
        var index = self.startIndex
        //=--------------------------------------=
        guard self[index] == UInt8(ascii: "0") else { return nil }
        self.formIndex(after: &index)
        //=--------------------------------------=
        switch self[index] {
        case UInt8(ascii: "x"):
            self.formIndex(after: &index)
            self = self[index...]
            return 0x10
        case UInt8(ascii: "b"):
            self.formIndex(after: &index)
            self = self[index...]
            return 0b10
        case UInt8(ascii: "o"):
            self.formIndex(after: &index)
            self = self[index...]
            return 0o10
        default: return nil }
    }
}
