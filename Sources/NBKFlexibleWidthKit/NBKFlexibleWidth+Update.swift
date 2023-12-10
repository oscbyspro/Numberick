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
// MARK: * NBK x Flexible Width x Update x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func update(_ value: Self) {
        self.storage.elements.replaceSubrange(self.storage.elements.indices, with: value.storage.elements)
    }
    
    @inlinable public mutating func update(_ value: Digit) {
        self.storage.elements.replaceSubrange(self.storage.elements.indices, with: CollectionOfOne(value))
    }
}
