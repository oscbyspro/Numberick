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
        if other.isZero { return }
        //=--------------------------------------=
        self.storage.resize(minCount: other.storage.elements.count + index)
        
        var index    = index
        var overflow = false
                
        for var addend in other.storage.elements {
            overflow = addend.addReportingOverflow(UInt(bit: overflow))
            overflow = self.storage.elements[index].addReportingOverflow(addend) || overflow
            self.storage.elements.formIndex(after: &index)
        }
        
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
