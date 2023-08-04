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
// MARK: * NBK x Resizable Width x Multiplication x Digit x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func multiply(by other: UInt, plus addend: UInt) -> UInt {
        var overflow = addend
        self.multiply(by: other, carrying: &overflow)
        return overflow as UInt
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=
    
extension NBKResizableWidth.Magnitude {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func multiply(by other: UInt, carrying overflow: inout UInt) {
        for index in self.storage.indices {
            var subproduct = self.storage[index].multipliedFullWidth(by: other)
            overflow = UInt(bit:   subproduct.low.addReportingOverflow(overflow)) &+ subproduct.high
            self.storage[index] = subproduct.low as UInt
        }
    }
}
