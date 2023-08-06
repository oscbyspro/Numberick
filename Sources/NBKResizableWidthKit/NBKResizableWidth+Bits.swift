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
// MARK: * NBK x Resizable Width x Bits x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
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
        NBK.nonzeroBitCount(of: self.storage)
    }
    
    @inlinable public var leadingZeroBitCount: Int {
        NBK.leadingZeroBitCount(of: self.storage)
    }
    
    @inlinable public var trailingZeroBitCount: Int {
        NBK.trailingZeroBitCount(of: self.storage)
    }
    
    @inlinable public var mostSignificantBit: Bool {
        self.last.mostSignificantBit
    }
    
    @inlinable public var leastSignificantBit: Bool {
        self.first.leastSignificantBit
    }
}
