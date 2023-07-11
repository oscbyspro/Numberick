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
        defer { Swift.assert(self.isNormal) }
        //=--------------------------------------=
        if other.isZero { return }
        //=--------------------------------------=
        self.resize(minCount: other.storage.count + index)
        
        var index = index
        var carry = false
                
        for var addend in other.storage {
            carry = addend.addReportingOverflow(UInt(bit: carry))
            carry = self.storage[index].addReportingOverflow(addend) || carry
            self.storage.formIndex(after: &index)
        }
        
        if  carry {
            self.storage.append(1 as UInt)
        }
    }
    
    @inlinable public func adding(_ other: Self, at index: Int) -> Self {
        var result = self
        result.add(other, at: index)
        return result as Self
    }
}
