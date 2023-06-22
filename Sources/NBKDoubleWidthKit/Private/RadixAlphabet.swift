//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Radix Alphabet x Decoder x Any
//*============================================================================*

/// Decodes values in `0` to `36` from ASCII.
@frozen @usableFromInline struct AnyRadixAlphabetDecoder {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let x00x10: UInt8
    @usableFromInline let x10x36: UInt8
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(radix: Int) {
        precondition(2 ... 36 ~= radix, "radix must be in 2 through 36")
        //=--------------------------------------=
        let count = UInt8(truncatingIfNeeded: radix)
        let carry = count.subtractingReportingOverflow(10)
        if  carry.overflow {
            self.x00x10 = count
            self.x10x36 = 00000
        }   else {
            self.x00x10 = 00010
            self.x10x36 = carry.partialValue
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func decode(_ ascii: UInt8) -> UInt8? {
        var count: UInt8
        
        count = ascii &- UInt8(ascii: "0"); if count < self.x00x10 { return count       }
        count = ascii &- UInt8(ascii: "A"); if count < self.x10x36 { return count &+ 10 }
        count = ascii &- UInt8(ascii: "a"); if count < self.x10x36 { return count &+ 10 }
        
        return nil
    }
}

//*============================================================================*
// MARK: * NBK x Radix Alphabet x Encoder x Max
//*============================================================================*

/// Encodes values in `0` to `36` to ASCII.
@frozen @usableFromInline struct MaxRadixAlphabetEncoder {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let x00x10: UInt8
    @usableFromInline let x10x36: UInt8
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(uppercase: Bool) {
        self.x00x10 = UInt8(ascii: "0")
        self.x10x36 = UInt8(ascii: uppercase ? "A" : "a") &- 10
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable func encode(_ value: UInt8) -> UInt8? {
        if value < 10 { return value &+ self.x00x10 }
        if value < 36 { return value &+ self.x10x36 }
        return nil
    }
}
