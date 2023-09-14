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
// MARK: * NBK x Flexible Width x Multiplication x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable public static func *(lhs: Self, rhs: Self) -> Self {
        let lhsIsLessThanZero: Bool = lhs.isLessThanZero
        let rhsIsLessThanZero: Bool = rhs.isLessThanZero
        var minus = lhsIsLessThanZero != rhsIsLessThanZero
        //=--------------------------------------=
        var product = lhs.magnitude * rhs.magnitude
        //=--------------------------------------=
        if  minus {
            minus = product.storage.formTwosComplementSubsequence(minus)
        }
        //=--------------------------------------=
        return Self(normalizing: Storage(bitPattern: product.storage))
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Multiplication x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func *=(lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }
    
    @inlinable public static func *(lhs: Self, rhs: Self) -> Self {
        Self(normalizing: lhs.storage.multipliedFullWidth(by: rhs.storage))
    }
}

//*============================================================================*
// MARK: * NBK x Resizable Width x Multiplication x UIntXL x Storage
//*============================================================================*

extension UIntXL.Storage {
    
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
            product.initialize(repeating: UInt.zero)
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
