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
        self.withUnsafeBufferPointer(NBK.SBISS.nonzeroBitCount(of:))
    }
    
    @inlinable public var leadingZeroBitCount: Int {
        self.withUnsafeBufferPointer(NBK.SBISS.leadingZeroBitCount(of:))
    }
    
    @inlinable public var trailingZeroBitCount: Int {
        self.withUnsafeBufferPointer(NBK.SBISS.trailingZeroBitCount(of:))
    }
    
    @inlinable public var mostSignificantBit: Bool {
        self.last.mostSignificantBit
    }
    
    @inlinable public var leastSignificantBit: Bool {
        self.first.leastSignificantBit
    }
}
