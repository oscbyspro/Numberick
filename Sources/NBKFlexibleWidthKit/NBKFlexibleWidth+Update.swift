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
// MARK: * NBK x Flexible Width x Miscellaneous x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func updateZeroValue() {
        self.sign = Sign.plus
        self.magnitude.updateZeroValue()
    }
    
    @inlinable public mutating func update(_ value: Digit) {
        self.sign = Sign(value.isLessThanZero)
        self.magnitude.update(value.magnitude)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Miscellaneous x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func updateZeroValue() {
        self.update(UInt.zero)
    }
    
    @inlinable public mutating func update(_ value: Digit) {
        self.storage.normalize(update: value)
    }
}
