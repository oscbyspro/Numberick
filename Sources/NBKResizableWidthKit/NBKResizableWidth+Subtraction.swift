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
// MARK: * NBK x Resizable Width x Subtraction x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func -=(lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func -(lhs: Self, rhs: Self) -> Self {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func subtractReportingOverflow(_ other: Self) -> Bool {
        fatalError("TODO")
    }
    
    @inlinable public func subtractingReportingOverflow(_ other: Self) -> PVO<Self> {
        fatalError("TODO")
    }
    
    @inlinable public mutating func subtract(_ other: Self, plus addend: Bool, at index: Int) -> Bool {
        var index = index, overflow = addend
        self.subtract(other, at: &index, borrowing: &overflow)
        return overflow as Bool
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func subtract(_ other: Self, at index: inout Int, borrowing overflow: inout Bool) {
        self.subtractWithoutGoingBeyond(other, at: &index, borrowing: &overflow)
        self.subtract((), at: &index, borrowing: &overflow)
    }
    
    @inlinable mutating func subtractWithoutGoingBeyond(_ other: Self, at index: inout Int, borrowing overflow: inout Bool) {
        for otherIndex in other.storage.indices { // for-index-in >= for-element-in
            self.subtractWithoutGoingBeyond(other.storage[otherIndex], at: &index, borrowing: &overflow)
        }
    }
}
