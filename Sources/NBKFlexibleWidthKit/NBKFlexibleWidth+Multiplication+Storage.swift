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
// MARK: * NBK x Flexible Width x Multiplication x Digit x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x UInt
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func multiply(by other: UInt, carrying overflow: inout UInt) {
        for index in self.elements.indices {
            var subproduct  = self.elements[index].multipliedFullWidth(by: other)
            subproduct.high &+= UInt(bit: subproduct.low.addReportingOverflow(overflow))
            (overflow, self.elements[index]) = subproduct as HL<UInt, UInt>
        }
    }
}
