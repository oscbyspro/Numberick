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
        lhs.multiply(by: rhs, adding: UInt.zero)
    }
    
    @_disfavoredOverload @inlinable public static func *(lhs: Self, rhs: UInt) -> Self {
        lhs.multiplied(by: rhs, adding: UInt.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable mutating func multiply(by multiplicand: UInt, adding addend: UInt) {
        defer {
            Swift.assert(self.storage.isNormal)
        }
        //=--------------------------------------=
        if  multiplicand.isZero {
            return self.assign(addend)
        }
        //=--------------------------------------=
        self.storage.reserve(minCount: self.storage.elements.count + 1)
        
        var overflow = addend as UInt
        
        self.storage.multiply(by: multiplicand, carrying: &overflow)
        
        if !overflow.isZero {
            self.storage.elements.append(overflow)
        }
    }
    
    @_disfavoredOverload @inlinable func multiplied(by multiplicand: UInt, adding addend: UInt) -> Self {
        var result = self; result.multiply(by: multiplicand, adding: addend); return result
    }
}
