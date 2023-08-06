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
    
    @_disfavoredOverload @inlinable public static func -=(lhs: inout Self, rhs: UInt) {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public static func -(lhs: Self, rhs: UInt) -> Self {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func subtractReportingOverflow(_ other: UInt) -> Bool {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public func subtractingReportingOverflow(_ other: UInt) -> PVO<Self> {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public mutating func subtract(_ other: UInt, plus addend: Bool, at index: Int) -> Bool {
        var index = index, overflow = addend
        self.subtract(other, at: &index, borrowing: &overflow)
        return overflow as Bool
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Multiplication By UInt
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func subtract(_ other: Self, times multiplicand: UInt, plus addend: UInt, at index: Int) -> Bool {
        var index    = index
        var overflow = false
        var last = addend as UInt
        
        for otherIndex in other.storage.indices {
            var subproduct = other.storage[otherIndex].multipliedFullWidth(by: multiplicand)
            last = UInt(bit: subproduct.low.addReportingOverflow(last)) &+ subproduct.high
            self.subtractWithoutGoingBeyond(subproduct.low, at: &index, borrowing: &overflow)
        }
        
        return self.subtract(last, plus: overflow, at: index)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
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
            overflow = self.storage[index].subtractReportingOverflow(other)
        }
        
        self.storage.formIndex(after: &index)
    }
}
