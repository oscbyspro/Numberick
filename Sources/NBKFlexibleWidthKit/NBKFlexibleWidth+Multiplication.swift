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
    
    @usableFromInline static let productByKaratsubaAlgorithmThreshold: Int = 40
    
    @usableFromInline static let productBySquareKaratsubaAlgorithmThreshold: Int = 40
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable public static func *(lhs: Self, rhs: Self) -> Self {
        if  lhs.count < Self.productByKaratsubaAlgorithmThreshold ||
            rhs.count < Self.productByKaratsubaAlgorithmThreshold {
            return self.productByLongAlgorithm(multiplying: lhs, by: rhs, adding: UInt.zero)
        }   else {
            return self.productByKaratsubaAlgorithm(multiplying: lhs, by: rhs)
        }
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Square
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func square() {
        self = self.squared()
    }
    
    @inlinable public func squared() -> Self {
        if  self.count < Self.productBySquareKaratsubaAlgorithmThreshold {
            return Self.productBySquareLongAlgorithm(multiplying: self, adding: UInt.zero)
        }   else {
            return Self.productBySquareKaratsubaAlgorithm(multiplying: self)
        }
    }
}
