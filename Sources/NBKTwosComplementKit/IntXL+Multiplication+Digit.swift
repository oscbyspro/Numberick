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
// MARK: * NBK x Flexible Width x Multiplication x Digit x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func *=(lhs: inout Self, rhs: Digit) {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public static func *(lhs: Self, rhs: Digit) -> Self {
        fatalError("TODO")
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Multiplication x Digit x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func *=(lhs: inout Self, rhs: Digit) {
        lhs.multiply(by: rhs, add: 0 as Digit)
    }
    
    @_disfavoredOverload @inlinable public static func *(lhs: Self, rhs: Digit) -> Self {
        lhs.multiplied(by: rhs, adding: 0 as Digit)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func multiply(by multiplicand: Digit, add addend: Digit) {
        defer {
            Swift.assert(Self.isNormal(self.storage))
        }
        //=--------------------------------------=
        if  multiplicand.isZero {
            return self.update(addend)
        }
        //=--------------------------------------=
        self.storage.reserveCapacity(self.storage.elements.count + 1)
        let overflow = self.storage.multiplyAsUnsigned(by: multiplicand, add: addend)
        if !overflow.isZero {
            self.storage.append(overflow)
        }
    }
    
    @_disfavoredOverload @inlinable public func multiplied(by multiplicand: Digit, adding addend: Digit) -> Self {
        var result = self
        result.multiply(by: multiplicand, add: addend)
        return result as Self
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Multiplication x Digit x Storage
//*============================================================================*

extension StorageXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable mutating func multiplyAsUnsigned(by other: UInt, add addend: UInt) -> UInt {
        NBK.multiplyFullWidthLenientUnsignedInteger(&self.elements, by: other, add: addend)
    }
}
