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
// MARK: * NBK x Flexible Width x Addition x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Self
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func add(_ other: Self, at index: inout Int, carrying overflow: inout Bool) {
        self.addWithoutGoingBeyond(other, at: &index, carrying: &overflow)
        self.add((), at: &index, carrying: &overflow)
    }
    
    @inlinable mutating func addWithoutGoingBeyond(_ other: Self, at index: inout Int, carrying overflow: inout Bool) {
        for otherIndex in other.elements.indices { // for-index-in >= for-element-in
            self.addWithoutGoingBeyond(other.elements[otherIndex], at: &index, carrying: &overflow)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x UInt
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func add(_ other: UInt, at index: inout Int, carrying overflow: inout Bool) {
        self.addWithoutGoingBeyond(other, at: &index, carrying: &overflow)
        self.add((), at: &index, carrying: &overflow)
    }
    
    @inlinable mutating func addWithoutGoingBeyond(_ other: UInt, at index: inout Int, carrying overflow: inout Bool) {
        var other = other as UInt
        
        if  overflow {
            overflow = other.addReportingOverflow(1 as UInt)
        }
        
        if !overflow {
            overflow = self.elements[index].addReportingOverflow(other)
        }

        self.elements.formIndex(after: &index)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Void
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func add(_ other: Void, at index: inout Int, carrying overflow: inout Bool) {
        while overflow && index < self.elements.endIndex {
            overflow = self.elements[index].addReportingOverflow(1 as UInt)
            self.elements.formIndex(after: &index)
        }
    }
}
