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
        lhs.add(rhs, at: 0 as Int)
    }
    
    @inlinable public static func +(lhs: Self, rhs: Self) -> Self {
        lhs.adding(rhs, at: 0 as Int)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func add(_ other: Self, at index: Int) {
        //=--------------------------------------=
        if  other.isZero { return }
        //=--------------------------------------=
        self.storage.resize(minCount: index + other.storage.elements.count)
        
        let overflow = self.storage.withUnsafeMutableBufferPointer(in: index...) { slice in
            other.storage.withUnsafeBufferPointer { other in
                NBK.SUISS.increment(&slice, by: other).overflow
            }
        }
        
        if  overflow {
            self.storage.append(1 as UInt)
        }
        
        Swift.assert(self.storage.isNormal)
    }
    
    @inlinable public func adding(_ other: Self, at index: Int) -> Self {
        var result = self
        result.add(other, at: index)
        return result as Self
    }
}
