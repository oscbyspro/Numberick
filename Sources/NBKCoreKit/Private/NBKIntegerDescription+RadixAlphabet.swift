//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Integer Description x Radix Alphabet
//*============================================================================*

extension NBK.IntegerDescription {
    
    //*========================================================================*
    // MARK: * Any Decoder
    //*========================================================================*
    
    /// Decodes values in `0` to `36` from ASCII.
    @frozen public struct AnyRadixAlphabetDecoder {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let x00x10: UInt8
        @usableFromInline let x10x36: UInt8
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(radix: Int) {
            precondition(2 ... 36 ~= radix)
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
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func decode(_ ascii: UInt8) -> UInt8? {
            var index: UInt8
            
            index = ascii &- UInt8(ascii: "0"); if index < self.x00x10 { return index }
            index = ascii &- UInt8(ascii: "A"); if index < self.x10x36 { return index &+ 10 }
            index = ascii &- UInt8(ascii: "a"); if index < self.x10x36 { return index &+ 10 }
            
            return nil
        }
    }
    
    //*========================================================================*
    // MARK: * Max Encoder
    //*========================================================================*
    
    /// Encodes values in `0` to `36` to ASCII.
    @frozen public struct MaxRadixAlphabetEncoder {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline let x00x10: UInt8
        @usableFromInline let x10x36: UInt8
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable public init(uppercase: Bool) {
            self.x00x10 = UInt8(ascii: "0")
            self.x10x36 = UInt8(ascii: uppercase ? "A" : "a") &- 10
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public func encode(_ value: UInt8) -> UInt8? {
            if value < 10 { return value &+ self.x00x10 }
            if value < 36 { return value &+ self.x10x36 }
            return nil
        }
    }
}
