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
// MARK: * NBK x Flexible Width x Addition x Digit x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func +=(lhs: inout Self, rhs: UInt) {
        lhs.add(rhs, at: 0 as Int)
    }
    
    @_disfavoredOverload @inlinable public static func +(lhs: Self, rhs: UInt) -> Self {
        lhs.adding(rhs, at: 0 as Int)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Index
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func add(_ other: UInt, at index: Int) {
        //=--------------------------------------=
        if  other.isZero { return }
        //=--------------------------------------=
        self.storage.resize(minCount: index + 1)
        
        let overflow = self.storage.withUnsafeMutableBufferPointer(in: index...) {
            NBK.SUISS.increment(&$0, by: other).overflow
        }
        
        if  overflow {
            self.storage.append(1 as UInt)
        }
        
        Swift.assert(self.storage.isNormal)
    }
    
    @_disfavoredOverload @inlinable public func adding(_ other: UInt, at index: Int) -> Self {
        var result = self
        result.add(other, at: index)
        return result as Self
    }
}
