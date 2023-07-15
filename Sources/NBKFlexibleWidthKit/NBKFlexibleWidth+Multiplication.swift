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
// MARK: * NBK x Flexible Width x Multiplication x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *=(lhs: inout Self, rhs: Self) {
        lhs.multiply(by: rhs)
    }
    
    @inlinable public static func *(lhs: Self, rhs: Self) -> Self {
        lhs.multiplied(by: rhs)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Private
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func multiply(by other: Self) {
        self = self.multiplied(by: other)
    }
    
    @inlinable func multiplied(by other: Self) -> Self {
        //=--------------------------------------=
        let capacity: Int = self.storage.elements.count + other.storage.elements.count
        var product = Storage(repeating: UInt(), count: capacity)
        //=--------------------------------------=
        for lhsIndex in self.storage.elements.indices {
            var carry = UInt.zero
            
            for rhsIndex in other.storage.elements.indices {
                var subproduct = self.storage.elements[lhsIndex].multipliedFullWidth(by: other.storage.elements[rhsIndex])
                
                carry   = UInt(bit: subproduct.low.addReportingOverflow(carry))
                carry &+= UInt(bit: product.elements[lhsIndex + rhsIndex].addReportingOverflow(subproduct.low))
                carry &+= subproduct.high
            }
            
            product.elements[lhsIndex + other.storage.elements.endIndex] = carry
        }
        //=--------------------------------------=
        product.normalize()
        return Self(unchecked: product)
    }
}
