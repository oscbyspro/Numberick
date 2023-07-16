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
        Self(words: x.storage.elements.map(~))
    }
    
    @inlinable public static func &=(lhs: inout Self, rhs: Self) {
        defer { Swift.assert(lhs.storage.isNormal) }
        //=--------------------------------------=
        if  lhs.storage.elements.endIndex > rhs.storage.elements.endIndex {
            lhs.storage.elements.removeSubrange(rhs.storage.elements.endIndex...)
        }
        //=--------------------------------------=
        for index in lhs.storage.elements.indices.reversed() {
            let word = lhs.storage.elements[index] & rhs.storage.elements[index]
            
            if  index == lhs.storage.elements.endIndex, word.isZero, index != lhs.storage.elements.startIndex {
                lhs.storage.elements.removeLast()
            }   else {
                lhs.storage.elements[index] = word
            }
        }
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs &= rhs; return lhs
    }
    
    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
        defer { Swift.assert(lhs.storage.isNormal) }
        //=--------------------------------------=
        lhs.storage.elements.reserveCapacity(rhs.storage.elements.count)
        //=--------------------------------------=
        for index in rhs.storage.elements.indices {
            let source = rhs.storage.elements[index]
            
            if  index < lhs.storage.elements.endIndex {
                lhs.storage.elements[index] |= source
            }   else {
                lhs.storage.elements.append(source as UInt)
            }
        }
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs |= rhs; return lhs
    }
    
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
        defer { lhs.storage.normalize() }
        //=--------------------------------------=
        lhs.storage.elements.reserveCapacity(rhs.storage.elements.count)
        //=--------------------------------------=
        for index in rhs.storage.elements.indices {
            let source = rhs.storage.elements[index]
            
            if  index < lhs.storage.elements.endIndex {
                lhs.storage.elements[index] ^= source
            }   else {
                lhs.storage.elements.append(source as UInt)
            }
        }
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs ^= rhs; return lhs
    }
}