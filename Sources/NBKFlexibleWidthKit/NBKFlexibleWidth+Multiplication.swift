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
// MARK: * NBK x Flexible Width x Multiplication x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
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
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func multiply(by multiplicand: Self) {
        self = self.multiplied(by: multiplicand)
    }
    
    @inlinable public func multiplied(by multiplicand: Self) -> Self {
        fatalError("TODO")
    }
}

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
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func multiply(by multiplicand: Self) {
        self = self.multiplied(by: multiplicand)
    }
    
    @inlinable public func multiplied(by multiplicand: Self) -> Self {
        Self(storage: self.storage.multipliedFullWidth(by: multiplicand.storage))
    }
}
