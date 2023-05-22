//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Any Radix Alphabet x Decoder
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
        if  digit >= UInt8(ascii: "0") && digit < self.numericalUpperBound {
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
