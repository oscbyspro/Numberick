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
// MARK: * NBK x Flexible Width x Multiplication x Square x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func square() {
        self = self.squared()
    }
    
    @inlinable public func squared() -> Self {
        Self.productBySquareLongAlgorithm(multiplying: self)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Long Multiplication
    //=------------------------------------------------------------------------=
    
    /// Returns the square product of `base` by performing long multiplication.
    ///
    /// - Note: It is up to `2x` faster than long multiplication with arbitrary inputs.
    ///
    @inlinable static func productBySquareLongAlgorithm(multiplying base: Self) -> Self {
        Self.uninitialized(count: 2 * base.count) { product in
            base.storage.withUnsafeBufferPointer  { base in
                //=--------------------------=
                // pointee: initialization
                //=--------------------------=
                product.initialize(repeating: 0 as UInt)
                //=--------------------------=
                var carry0: Bool = false // for multiplication by 02
                var carry1: Bool = false // for addition of diagonal
                
                for baseIndex in base.indices {
                    let multiplier = base[baseIndex]
                    let productIndex = 2 * baseIndex
                    
                    NBK.SUISS.incrementInIntersection(
                    &product[(productIndex + 1)...],  // add non-diagonal elements
                    by: UnsafeBufferPointer(rebasing: base[(baseIndex + 1)...]), times: multiplier)
                    
                    carry0 = NBK.SUISS.incrementInIntersection(
                    &product[(productIndex)...], //   partially double non-diagonal elements
                    by: UnsafeBufferPointer(rebasing: product[(productIndex) ..< (productIndex + 2)]), plus: carry0).overflow
                    
                    carry1 = NBK.SUISS.incrementInIntersection(
                    &product[(productIndex)...], //  add the diagonal element
                    by: CollectionOfOne(multiplier), times: multiplier, plus: UInt(bit: carry1)).overflow
                }
            }
        }
    }
}
