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
// MARK: * NBK x Flexible Width x Multiplication x Digit x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func *=(lhs: inout Self, rhs: Int) {
        lhs.multiply(by: rhs, adding: UInt.zero)
    }
    
    @_disfavoredOverload @inlinable public static func *(lhs: Self, rhs: Int) -> Self {
        lhs.multiplied(by: rhs, adding: UInt.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func multiply(by multiplicand: Int, adding addend: UInt) {
        self.sign = self.sign ^ Sign(multiplicand.isLessThanZero)
        return self.magnitude.multiply(by: multiplicand.magnitude, adding: addend)
    }
    
    @_disfavoredOverload @inlinable public func multiplied(by multiplicand: Int, adding addend: UInt) -> Self {
        let sign = self.sign ^ Sign(multiplicand.isLessThanZero)
        let magnitude = self.magnitude.multiplied(by: multiplicand.magnitude, adding: addend)
        return Self(sign: sign, magnitude: magnitude)
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
        lhs.multiply(by: rhs, adding: UInt.zero)
    }
    
    @_disfavoredOverload @inlinable public static func *(lhs: Self, rhs: UInt) -> Self {
        lhs.multiplied(by: rhs, adding: UInt.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func multiply(by multiplicand: UInt, adding addend: UInt) {
        defer {
            Swift.assert(self.storage.isNormal)
        }
        //=--------------------------------------=
        if  multiplicand.isZero {
            return self.update(addend)
        }
        //=--------------------------------------=
        self.storage.reserveCapacity(self.storage.count + 1)
        let overflow = self.storage.multiply(by: multiplicand, plus: addend)
        if !overflow.isZero {
            self.storage.append(overflow)
        }
    }
    
    @_disfavoredOverload @inlinable public func multiplied(by multiplicand: UInt, adding addend: UInt) -> Self {
        var result = self; result.multiply(by: multiplicand, adding: addend); return result
    }
}
