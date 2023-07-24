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
// MARK: * NBK x Flexible Width x Multiplication x Digit x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Self
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
                
                (product[lhsIndex + multiplicand.elements.count], overflow) = (overflow, UInt.zero)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x UInt
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func multiply(by other: UInt, plus addend: UInt) -> UInt {
        var overflow = addend
        self.multiply(by: other, carrying: &overflow)
        return overflow as UInt
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=
    
extension NBKFlexibleWidth.Magnitude.Storage {

    //=------------------------------------------------------------------------=
    // MARK: Transformations x UInt
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func multiply(by other: UInt, carrying overflow: inout UInt) {
        for index in self.elements.indices {
            var subproduct = self.elements[index].multipliedFullWidth(by: other)
            overflow = UInt(bit:   subproduct.low.addReportingOverflow(overflow)) &+ subproduct.high
            self.elements[index] = subproduct.low as UInt
        }
    }
}
