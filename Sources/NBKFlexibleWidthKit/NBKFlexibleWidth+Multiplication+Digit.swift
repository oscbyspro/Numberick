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
// MARK: * NBK x Flexible Width x Multiplication x Digit x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func *=(lhs: inout Self, rhs: Int) {
        lhs.sign ^= Sign(rhs.isLessThanZero)
        lhs.magnitude *= rhs.magnitude as UInt
    }
    
    @_disfavoredOverload @inlinable public static func *(lhs: Self, rhs: Int) -> Self {
        Self(sign: lhs.sign ^ Sign(rhs.isLessThanZero), magnitude: lhs.magnitude * rhs.magnitude)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Multiplication x Digit x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func *=(lhs: inout Self, rhs: UInt) {
        lhs.multiply(by: rhs, add: UInt.zero)
    }
    
    @_disfavoredOverload @inlinable public static func *(lhs: Self, rhs: UInt) -> Self {
        lhs.multiplied(by: rhs, adding: UInt.zero)
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
        self.storage.reserveCapacity(self.storage.count + 1)
        let overflow = self.storage.multiply(by: multiplicand, add: addend)
        if !overflow.isZero {
            self.storage.append(overflow)
        }
    }
    
    @_disfavoredOverload @inlinable public func multiplied(by multiplicand: UInt, adding addend: UInt) -> Self {
        var result = self; result.multiply(by: multiplicand, add: addend); return result
    }
}
