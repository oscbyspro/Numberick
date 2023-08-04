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
    // MARK: Transformations x Self
    //=------------------------------------------------------------------------=
    
    @inlinable public func multipliedFullWidth(by multiplicand: Self) -> Self {
        self.multipliedFullWidthByNaiveMethod(by: multiplicand, adding: UInt.zero)
    }
    
    @inlinable public func multipliedFullWidthByNaiveMethod(by multiplicand: Self, adding addend: UInt) -> Self {
        Self.uninitialized(count: self.storage.count + multiplicand.storage.count) { product in
            //=----------------------------------=
            // de/init: pointee is trivial
            //=----------------------------------=
            product.update(repeating: UInt.zero)
            //=----------------------------------=
            var overflow =  addend as UInt
            for lhsIndex in self.storage.indices {
                let outer = self.storage[lhsIndex]
                
                for rhsIndex in multiplicand.storage.indices {
                    let inner = multiplicand.storage[rhsIndex]
                    var subproduct = outer.multipliedFullWidth(by: inner)
                    
                    overflow   = UInt(bit: subproduct.low.addReportingOverflow(overflow))
                    overflow &+= UInt(bit: product[lhsIndex + rhsIndex].addReportingOverflow(subproduct.low))
                    overflow &+= subproduct.high
                }
                
                product[lhsIndex + multiplicand.storage.count] = overflow
                overflow = UInt.zero
            }
        }
    }
}
