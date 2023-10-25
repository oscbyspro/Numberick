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
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable public static func *(lhs: Self, rhs: Self) -> Self {
        Self.productByLongAlgorithm(multiplying: lhs, by: rhs, adding: 0 as UInt)        
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Long Multiplication
    //=------------------------------------------------------------------------=
    
    /// Returns the product of `multiplicand` and `multiplier` plus `addend` by performing long multiplication.
    @inlinable static func productByLongAlgorithm(multiplying multiplicand: Self, by multiplier: Self, adding addend: UInt) -> Self {
        Self.uninitialized(count: multiplicand.count + multiplier.count) { pro in
            multiplicand.storage.withUnsafeBufferPointer   { lhs in
                multiplier.storage.withUnsafeBufferPointer { rhs in
                    var pointer = pro.baseAddress!
                    //=--------------------------=
                    // pointee: initialization 1
                    //=--------------------------=
                    var carry: UInt = addend
                    let first: UInt = rhs.first!
                    
                    for element in lhs {
                        var wide = element.multipliedFullWidth(by: first) as NBK.Wide2<UInt>
                        carry = UInt(bit: wide.low.addReportingOverflow(carry)) &+ wide.high
                        pointer.initialize(to: wide.low) // done, pointee has no prior value
                        pointer = pointer.successor()
                    }
                    
                    pointer.initialize(to: carry)
                    pointer = pointer.successor()
                    Swift.assert(pro.baseAddress!.distance(to: pointer) == lhs.count + 1)
                    //=--------------------------=
                    // pointee: initialization 2
                    //=--------------------------=
                    for var index in 1 ..< rhs.count {
                        pointer.initialize(to: 00000)
                        pointer = pointer.successor()
                        NBK.SUISS.incrementInIntersection(&pro, by: lhs, times: rhs[index], plus: 00000, at: &index)
                    }
                    
                    Swift.assert(pro.baseAddress!.distance(to: pointer) == pro.count)
                }
            }
        }
    }
}
