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
        self.storage.elements.count * UInt.bitWidth
    }
    
    @inlinable public var nonzeroBitCount: Int {
        self.storage.elements.withUnsafeBufferPointer(NBK.nonzeroBitCount(of:))
    }
    
    @inlinable public var leadingZeroBitCount: Int {
        self.storage.elements.withUnsafeBufferPointer(NBK.leadingZeroBitCount(of:))
    }
    
    @inlinable public var trailingZeroBitCount: Int {
        self.storage.elements.withUnsafeBufferPointer(NBK.trailingZeroBitCount(of:))
    }
    
    @inlinable public var mostSignificantBit: Bool {
        self.storage.elements.last!.mostSignificantBit
    }
    
    @inlinable public var leastSignificantBit: Bool {
        self.storage.elements.first!.leastSignificantBit
    }
}
