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
// MARK: * NBK x Flexible Width x Addition x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func +=(lhs: inout Self, rhs: Self) {
        lhs.add(rhs, at: Int.zero)
    }
    
    @inlinable public static func +(lhs: Self, rhs: Self) -> Self {
        lhs.adding(rhs, at: Int.zero)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func add(_ other: Self, at index: Int) {
        defer {
            Swift.assert(self.storage.isNormal)
        }
        //=--------------------------------------=
        if  other.isZero { return }
        //=--------------------------------------=
        self.storage.resize(minCount: index + other.storage.elements.count)
        
        var index    = index
        var overflow = false
        
        self.storage.addAsFixedWidth(other.storage, at: &index, carrying: &overflow)
        
        if  overflow {
            self.storage.elements.append(1 as UInt)
        }
    }
    
    @inlinable public func adding(_ other: Self, at index: Int) -> Self {
        var result = self
        result.add(other, at: index)
        return result as Self
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Addition x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func addAsFixedWidth(_ other: Self, at index: inout Int, carrying overflow: inout Bool) {
        self.addAsFixedWidthWithoutGoingBeyond(other, at: &index, carrying: &overflow)
        self.addAsFixedWidth(Void(), at: &index, carrying: &overflow)
    }
    
    @inlinable mutating func addAsFixedWidthWithoutGoingBeyond(_ other: Self, at index: inout Int, carrying overflow: inout Bool) {
        for otherIndex in other.elements.indices {
            var lhsWord = self .elements[index]
            let rhsWord = other.elements[otherIndex]
                        
            if !overflow {
                overflow = lhsWord.addReportingOverflow(rhsWord)
            }   else if    rhsWord != UInt.max {
                overflow = lhsWord.addReportingOverflow(rhsWord &+ 1)
            }
            
            self.elements[index] = lhsWord
            self.elements.formIndex(after: &index)
        }
    }
}
