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
// MARK: * NBK x Flexible Width x Update
//*============================================================================*

extension PrivateIntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func updateZeroValue() {
        self.update(0 as Digit)
    }
    
    @inlinable public mutating func update(_  value: Digit) {
        Self.normalize(&self.storage, update: value)
    }
}
