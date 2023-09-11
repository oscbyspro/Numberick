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
// MARK: * NBK x Resizable Width x Logic x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x NOT
    //=------------------------------------------------------------------------=
    
    @inlinable public static prefix func ~(x: Self) -> Self {
        x.onesComplement()
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x AND
    //=------------------------------------------------------------------------=
    
    @inlinable public static func &=(lhs: inout Self, rhs: Self) {
        lhs.upsizeThenFormInIntersection(of: rhs, each: &)
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs &= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x OR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
        lhs.upsizeThenFormInIntersection(of: rhs, each: |)
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs |= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x XOR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
        lhs.upsizeThenFormInIntersection(of: rhs, each: ^)
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs ^= rhs; return lhs
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func upsizeThenFormInIntersection(of other: Self, each element: (UInt, UInt) -> UInt) {
        self.resize(minCount: other.storage.count)
        self.withContiguousMutableStorage { lhs in
            other.withContiguousStorage   { rhs in
                for index in rhs.indices  {
                    lhs[index] = element(lhs[index], rhs[index])
                }
            }
        }
    }
        
    @inlinable public mutating func downsizeThenFormInIntersection(of other: Self, each element: (UInt, UInt) -> UInt) {
        self.resize(maxCount: other.storage.count)
        self.withContiguousMutableStorage { lhs in
            other.withContiguousStorage   { rhs in
                for index in lhs.indices  {
                    lhs[index] = element(lhs[index], rhs[index])
                }
            }
        }
    }
}
