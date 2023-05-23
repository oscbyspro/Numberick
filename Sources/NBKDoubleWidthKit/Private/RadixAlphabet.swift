//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Radix Alphabet x Any x Decoder
//*============================================================================*

@frozen @usableFromInline struct AnyRadixAlphabetDecoder {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let numericalUpperBound: UInt8
    @usableFromInline let uppercaseUpperBound: UInt8
    @usableFromInline let lowercaseUpperBound: UInt8
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(radix: Int) {
        precondition(radix >= 2 && radix <= 36)
        
        if  radix <= 10 {
            numericalUpperBound = UInt8(ascii: "0") &+ UInt8(truncatingIfNeeded: radix)
            uppercaseUpperBound = UInt8(ascii: "A")
            lowercaseUpperBound = UInt8(ascii: "a")
        }   else {
            numericalUpperBound = UInt8(ascii: "0") &+ 10
            uppercaseUpperBound = UInt8(ascii: "A") &+ UInt8(truncatingIfNeeded: radix &- 10)
            lowercaseUpperBound = UInt8(ascii: "a") &+ UInt8(truncatingIfNeeded: radix &- 10)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable func decode(_ digit: UInt8) -> UInt8? {
        if  /*---*/ digit >= UInt8(ascii: "0") && digit < self.numericalUpperBound {
            return  digit &- UInt8(ascii: "0")
        }   else if digit >= UInt8(ascii: "A") && digit < self.uppercaseUpperBound {
            return  digit &- UInt8(ascii: "A") &+ 10
        }   else if digit >= UInt8(ascii: "a") && digit < self.lowercaseUpperBound {
            return  digit &- UInt8(ascii: "a") &+ 10
        }   else {
            return nil
        }
    }
}

//*============================================================================*
// MARK: * NBK x Radix Alphabet x Max x Encoder
//*============================================================================*

/// Maps values from `0` through `36` to ASCII.
///
/// ```swift
/// let map =  MaxRadixAlphabetEncoder(uppercase: true)
/// map[00] // UInt8(ascii: "0")
/// map[20] // UInt8(ascii: "K")
/// ```
///
@frozen @usableFromInline struct MaxRadixAlphabetEncoder {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let map00To10: UInt8
    @usableFromInline let map10To37: UInt8
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(uppercase: Bool) {
        self.map00To10 = UInt8(ascii: "0")
        self.map10To37 = UInt8(ascii: uppercase ? "A" : "a") &- 10
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
