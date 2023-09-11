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
        lhs.sign ^= rhs.sign
        lhs.magnitude *= rhs.magnitude as Magnitude
    }
    
    @inlinable public static func *(lhs: Self, rhs: Self) -> Self {
        Self(sign: lhs.sign ^ Sign(rhs.isLessThanZero), magnitude: lhs.magnitude * rhs.magnitude)
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
        lhs = lhs * rhs
    }
    
    @inlinable public static func *(lhs: Self, rhs: Self) -> Self {
        Self(storage: lhs.storage.multipliedFullWidth(by: rhs.storage))
    }
}

//*============================================================================*
// MARK: * NBK x Resizable Width x Multiplication x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable func multipliedFullWidth(by multiplicand: Self) -> Self {
        self.multipliedFullWidthByNaiveMethod(by: multiplicand, adding: UInt.zero)
    }
    
    @inlinable func multipliedFullWidthByNaiveMethod(by multiplicand: Self, adding addend: UInt) -> Self {
        Self.uninitialized(count: self.elements.count + multiplicand.elements.count) { product in
            //=----------------------------------=
            // de/init: pointee is trivial
            //=----------------------------------=
            product.update(repeating: UInt.zero)
            //=----------------------------------=
            var overflow =  addend as UInt
            for lhsIndex in self.elements.indices {
                let outer = self.elements[lhsIndex]
                
                for rhsIndex in multiplicand.elements.indices {
                    let inner = multiplicand.elements[rhsIndex]
                    var subproduct = outer.multipliedFullWidth(by: inner)
                    
                    overflow   = UInt(bit: subproduct.low.addReportingOverflow(overflow))
                    overflow &+= UInt(bit: product[lhsIndex + rhsIndex].addReportingOverflow(subproduct.low))
                    overflow &+= subproduct.high
                }
                
                product[lhsIndex + multiplicand.elements.count] = overflow
                overflow = UInt.zero
            }
        }
    }
}
