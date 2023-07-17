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
// MARK: * NBK x Flexible Width x Miscellaneous x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func assignZeroValue() {
        self.storage.elements.removeAll(keepingCapacity: true)
    }
    
    @inlinable mutating func assign(_ other: UInt) {
        self.storage.elements.removeAll(keepingCapacity: true)
        guard !other.isZero else { return }
        self.storage.elements.append(other)
    }
}
