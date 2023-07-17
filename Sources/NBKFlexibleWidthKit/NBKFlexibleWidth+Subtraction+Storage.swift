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
// MARK: * NBK x Flexible Width x Subtraction x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Self
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func subtract(_ other: Self, at index: inout Int, borrowing overflow: inout Bool) {
        self.subtractWithoutGoingBeyond(other, at: &index, borrowing: &overflow)
        self.subtract((), at: &index, borrowing: &overflow)
    }
    
    @inlinable mutating func subtractWithoutGoingBeyond(_ other: Self, at index: inout Int, borrowing overflow: inout Bool) {
        for otherIndex in other.elements.indices { // for-index-in >= for-element-in
            self.subtractWithoutGoingBeyond(other.elements[otherIndex], at: &index, borrowing: &overflow)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x UInt
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func subtract(_ other: UInt, at index: inout Int, borrowing overflow: inout Bool) {
        self.subtractWithoutGoingBeyond(other, at: &index, borrowing: &overflow)
        self.subtract((), at: &index, borrowing: &overflow)
    }
    
    @inlinable mutating func subtractWithoutGoingBeyond(_ other: UInt, at index: inout Int, borrowing overflow: inout Bool) {
        var other = other as UInt
        
        if  overflow {
            overflow = other.addReportingOverflow(1 as UInt)
        }
        
        if !overflow {
            overflow = self.elements[index].subtractReportingOverflow(other)
        }
        
        self.elements.formIndex(after: &index)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Void
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func subtract(_ other: Void, at index: inout Int, borrowing overflow: inout Bool) {
        while overflow && index < self.elements.endIndex {
            overflow = self.elements[index].subtractReportingOverflow(1 as UInt)
            self.elements.formIndex(after: &index)
        }
    }
}
