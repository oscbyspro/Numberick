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
// MARK: * NBK x Flexible Width x Logic x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
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
        fatalError("TODO")
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs &= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x OR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs |= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x XOR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
        fatalError("TODO")
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs ^= rhs; return lhs
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Logic x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
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
        lhs.storage.downsizeThenFormInIntersection(with: rhs.storage, each: &)
        lhs.storage.normalize()
        Swift.assert(lhs.storage.isNormal)
    }
    
    @inlinable public static func &(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs &= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x OR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func |=(lhs: inout Self, rhs: Self) {
        lhs.storage.upsizeThenFormInIntersection(with: rhs.storage, each: |)
        Swift.assert(lhs.storage.isNormal)
    }
    
    @inlinable public static func |(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs |= rhs; return lhs
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x XOR
    //=------------------------------------------------------------------------=
    
    @inlinable public static func ^=(lhs: inout Self, rhs: Self) {
        lhs.storage.upsizeThenFormInIntersection(with: rhs.storage, each: ^)
        lhs.storage.normalize()
        Swift.assert(lhs.storage.isNormal)
    }
    
    @inlinable public static func ^(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs ^= rhs; return lhs
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Logic x Unsigned x Storage
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func upsizeThenFormInIntersection(with other: Self, each element: (UInt, UInt) -> UInt) {
        self.resize(minCount: other.elements.count)
        self.withUnsafeMutableBufferPointer { lhs in
            other.withUnsafeBufferPointer {   rhs in
                for index in rhs.indices  {
                    lhs[index] = element(lhs[index], rhs[index])
                }
            }
        }
    }
    
    @inlinable mutating func downsizeThenFormInIntersection(with other: Self, each element: (UInt, UInt) -> UInt) {
        self.resize(maxCount: other.elements.count)
        self.withUnsafeMutableBufferPointer { lhs in
            other.withUnsafeBufferPointer {   rhs in
                for index in lhs.indices  {
                    lhs[index] = element(lhs[index], rhs[index])
                }
            }
        }
    }
}
