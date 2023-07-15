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
// MARK: * NBK x Flexible Width x Multiplication x Digit x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func *=(lhs: inout Self, rhs: UInt) {
        lhs.multiply(by: rhs)
    }
    
    @_disfavoredOverload @inlinable public static func *(lhs: Self, rhs: UInt) -> Self {
        var lhs = lhs; lhs *= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Private
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable mutating func multiply(by other: UInt) {
        defer { Swift.assert(self.storage.isNormal) }
        //=--------------------------------------=
        if  other.isZero {
            return self = Self.zero
        }
        //=--------------------------------------=
        self.storage.elements.reserveCapacity(self.storage.elements.count + 1)
        //=--------------------------------------=
        var carry = UInt.zero
        
        for index in self.storage.elements.indices {
            var subproduct = self.storage.elements[index].multipliedFullWidth(by: other)
            subproduct.high &+= UInt(bit:  subproduct.low.addReportingOverflow(carry))
            (carry, self.storage.elements[index]) = subproduct as HL<UInt, UInt>
        }
        
        if !carry.isZero {
            self.storage.elements.append(carry)
        }
    }
    
    @_disfavoredOverload @inlinable func multiplied(by other: UInt) -> Self {
        var result = self; result.multiply(by: other); return result as Self
    }
}
