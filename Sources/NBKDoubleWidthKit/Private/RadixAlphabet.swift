//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Radix Alphabet x Max
//*============================================================================*

/// Maps values from `0` through `36` to ASCII.
///
/// ```swift
/// let map =  MaxRadixAlphabet(uppercase: true)
/// map[00] // UInt8(ascii: "0")
/// map[20] // UInt8(ascii: "K")
/// map[40] // crash
/// ```
///
@frozen @usableFromInline struct MaxRadixAlphabet {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let map00To10: UInt8
    @usableFromInline let map10To37: UInt8
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(uppercase: Bool) {
        self.map00To10 = 48
        self.map10To37 = uppercase ? 55 : 87
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable subscript(_ value: UInt8) -> UInt8 {
        precondition(value < 37, "digit is not in alphabet")
        return self[unchecked: value]
    }
    
    @inlinable subscript(unchecked value: UInt8) -> UInt8 {
        Swift.assert(value < 37, "digit is not in alphabet")
        let offset = value < 10 ? self.map00To10 : self.map10To37
        return value &+  offset
    }
}
