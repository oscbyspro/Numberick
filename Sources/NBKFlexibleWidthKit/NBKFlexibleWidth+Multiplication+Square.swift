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
        Self.productBySquareLongAlgorithm(multiplying: self, adding: 0 as UInt)
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
    @inlinable static func productBySquareLongAlgorithm(multiplying base: Self, adding addend: UInt) -> Self {
        Self.uninitialized(count: 2 * base.count) { product in
            base.storage.withUnsafeBufferPointer  { base in
                //=--------------------------=
                // pointee: initialization
                //=--------------------------=
                product.initialize(repeating: 0 as UInt)
                //=--------------------------=
                var index:  Int = 000000
                var carry: UInt = addend
                //=--------------------------=
                var baseIndex = base.startIndex; while baseIndex < base.endIndex {
                    let multiplier = base[baseIndex]
                    let productIndex = 2 * baseIndex
                    base.formIndex(after: &baseIndex)
                    
                    index = productIndex + 1 // add non-diagonal products
                    
                    NBK.SUISS.incrementInIntersection(&product,
                    by: UnsafeBufferPointer(rebasing: base[baseIndex...]),
                    times: multiplier, plus: 00000, at: &index)
                    
                    index = productIndex // partially double non-diagonal products
                    
                    NBK.SUISS.multiply(&product, 
                    by:  000002,
                    add: &carry, at: &index, upTo: productIndex + 2)
                    
                    index = productIndex // add this iteration's diagonal product
                    
                    carry &+= UInt(bit: NBK.SUISS.incrementInIntersection(
                    &product, by: CollectionOfOne((multiplier)),
                    times: multiplier, plus: 00000, at: &index))
                }
            }
        }
    }
}
