//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

//*============================================================================*
// MARK: * NBK x Flexible Width x Bits
//*============================================================================*

extension PrivateIntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bit: Bool) {
        self.init(digit: Digit(bit: bit))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public var bitWidth: Int {
        self.storage.elements.count * UInt.bitWidth
    }
    
    @inlinable public var nonzeroBitCount: Int {
        self.withUnsafeBufferPointer(NBK.nonzeroBitCount(of:))
    }
    
    @inlinable public var leadingZeroBitCount: Int {
        self.storage.last.leadingZeroBitCount
    }
    
    @inlinable public var trailingZeroBitCount: Int {
        self.withUnsafeBufferPointer(NBK.trailingZeroBitCount(of:))
    }
    
    @inlinable public var mostSignificantBit: Bool {
        self.storage.last.mostSignificantBit
    }
    
    @inlinable public var leastSignificantBit: Bool {
        self.storage.first.leastSignificantBit
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    @inlinable func leadingBitCount(_ bit: Bool) -> Int {
        var last = self.storage.last
        if  bit {
            last.formOnesComplement()
        }
        
        return last.leadingZeroBitCount
    }
}
