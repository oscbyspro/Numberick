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
// MARK: * NBK x Flexible Width x Logic x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(x: Self) -> Self {
        Self(words: x.storage.map(~))
    }
    
    @inlinable public static func &=(lhs: inout Self, rhs: Self) {
        defer { Swift.assert(lhs.isNormal) }
        //=--------------------------------------=
        if  lhs.storage.endIndex > rhs.storage.endIndex {
            lhs.storage.removeSubrange(rhs.storage.endIndex...)
        }
        //=--------------------------------------=
        for index in lhs.storage.indices.reversed() {
            let word = lhs.storage[index] & rhs.storage[index]
            
            if  index == lhs.storage.endIndex, word.isZero, index != lhs.storage.startIndex {
                lhs.storage.removeLast()
            }   else {
                lhs.storage[index] = word
            }
        }
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs &= rhs; return lhs
    }
    
    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
        defer { Swift.assert(lhs.isNormal) }
        //=--------------------------------------=
        lhs.storage.reserveCapacity(rhs.storage.count)
        //=--------------------------------------=
        for index in rhs.storage.indices {
            let source = rhs.storage[index]
            
            if  index < lhs.storage.endIndex {
                lhs.storage[index] |= source
            }   else {
                lhs.storage.append(source as UInt)
            }
        }
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs |= rhs; return lhs
    }
    
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
        defer { lhs.normalize() }
        //=--------------------------------------=
        lhs.storage.reserveCapacity(rhs.storage.count)
        //=--------------------------------------=
        for index in rhs.storage.indices {
            let source = rhs.storage[index]
            
            if  index < lhs.storage.endIndex {
                lhs.storage[index] ^= source
            }   else {
                lhs.storage.append(source as UInt)
            }
        }
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs ^= rhs; return lhs
    }
}
