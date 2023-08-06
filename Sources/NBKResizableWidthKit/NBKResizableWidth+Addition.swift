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
// MARK: * NBK x Resizable Width x Addition x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +=(lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func +(lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func add(_ other: Self, plus addend: Bool, at index: Int) -> Bool {
        var index = index, overflow = addend
        self.add(other, at: &index, carrying: &overflow)
        return overflow as Bool
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Self
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func add(_ other: Self, at index: inout Int, carrying overflow: inout Bool) {
        self.addWithoutGoingBeyond(other, at: &index, carrying: &overflow)
        self.add((), at: &index, carrying: &overflow)
    }
    
    @inlinable mutating func addWithoutGoingBeyond(_ other: Self, at index: inout Int, carrying overflow: inout Bool) {
        for otherIndex in other.storage.indices { // for-index-in >= for-element-in
            self.addWithoutGoingBeyond(other.storage[otherIndex], at: &index, carrying: &overflow)
        }
    }
}
