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
// MARK: * NBK x Flexible Width x Bits x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bit: Bool) {
        self.init(digit: Digit(bit: bit))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var bitWidth: Int {
        self.storage.count * UInt.bitWidth
    }
    
    @inlinable public var nonzeroBitCount: Int {
        self.storage.reduce(0) { $0 + $1.nonzeroBitCount }
    }
    
    @inlinable public var leadingZeroBitCount: Int {
        self.storage[self.storage.index(before: self.storage.endIndex)].leadingZeroBitCount
    }
    
    @inlinable public var trailingZeroBitCount: Int {
        var index = self.storage.startIndex
        var element = UInt.zero
        
        while index < self.storage.endIndex, element.isZero {
            element = self.storage[index]
            self.storage.formIndex(after: &index)
        }
        
        return (index - 1) * UInt.bitWidth + element.trailingZeroBitCount
    }
    
    @inlinable public var mostSignificantBit: Bool {
        self.storage[self.storage.index(before: self.storage.endIndex)].mostSignificantBit
    }
    
    @inlinable public var leastSignificantBit: Bool {
        self.storage[self.storage.startIndex].leastSignificantBit
    }
}
