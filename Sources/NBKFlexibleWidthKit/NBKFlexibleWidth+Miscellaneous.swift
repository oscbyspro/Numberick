//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKResizableWidthKit

//*============================================================================*
// MARK: * NBK x Flexible Width x Miscellaneous x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func assignZeroValue() {
        self.assign(UInt.zero)
    }
    
    @inlinable mutating func assign(_  value: UInt) {
        self.storage.normalize(assign: value)
        Swift.assert(self.storage.isNormal)
    }
}
