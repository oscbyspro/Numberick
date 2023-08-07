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
// MARK: * NBK x Resizable Width x Miscellaneous x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func updateZeroValue() {
        self.update(repeating: false)
    }
    
    @inlinable public mutating func update(repeating bit: Bool) {
        self.update(repeating: UInt(repeating: bit))
    }
    
    @inlinable public mutating func update(repeating word: UInt) {
        self.withContiguousMutableStorage({ $0.update(repeating: word) })
    }
}
