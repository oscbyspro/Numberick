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
        lhs.multiply(by: rhs, add: 0 as UInt)
    }
    
    @_disfavoredOverload @inlinable public static func *(lhs: Self, rhs: UInt) -> Self {
        lhs.multiplied(by: rhs, adding: 0 as UInt)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func multiply(by multiplicand: UInt, add addend: UInt) {
        defer {
            Swift.assert(self.storage.isNormal)
        }
        //=--------------------------------------=
        if  multiplicand.isZero {
            return self.update(addend)
        }
        //=--------------------------------------=
        self.storage.reserveCapacity(self.storage.elements.count + 1)
        let overflow = self.storage.multiply(by: multiplicand, add: addend)
        if !overflow.isZero {
            self.storage.append(overflow)
        }
    }
    
    @_disfavoredOverload @inlinable public func multiplied(by multiplicand: UInt, adding addend: UInt) -> Self {
        var result = self; result.multiply(by: multiplicand, add: addend); return result
    }
}

//*============================================================================*
// MARK: * NBK x Resizable Width x Multiplication x Digit x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable mutating func multiply(by other: UInt, add addend: UInt) -> UInt {
        NBK.multiplyFullWidthLenientUnsignedInteger(&self.elements, by: other, add: addend)
    }
}
