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

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    // TODO: internal
    @inlinable public mutating func formInIntersection(of other: Self, each element: (UInt, UInt) -> UInt) {
        self .storage.withUnsafeMutableBufferPointer { lhs in
        other.storage.withUnsafeBufferPointer { rhs in
            let endIndex = Swift.min(lhs.endIndex, rhs.endIndex)
            let lhsIntersection = NBK.UnsafeMutableWords(rebasing: lhs.prefix(upTo:  endIndex))
            let rhsIntersection = /*---*/NBK.UnsafeWords(rebasing: rhs.prefix(upTo:  endIndex))
            NBK.merge(into: lhsIntersection, from: NBK.UnsafeWords(lhsIntersection), rhsIntersection, each: element)
        }}
    }
}
