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
// MARK: * NBK x Flexible Width x Addition x Digit
//*============================================================================*

extension IntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func +=(lhs: inout Self, rhs: Digit) {
        lhs.add(rhs, at: Int.zero)
    }
    
    @_disfavoredOverload @inlinable public static func +(lhs: Self, rhs: Digit) -> Self {
        lhs.adding(rhs, at: Int.zero)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Addition x Digit x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func add(_ other: Int, at index: Int) {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public func adding(_ other: Int, at index: Int) -> Self {
        var result = self
        result.add(other, at: index)
        return result as Self
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Addition x Digit x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public mutating func add(_ other: UInt, at index: Int) {
        fatalError("TODO")
    }
    
    @_disfavoredOverload @inlinable public func adding(_ other: UInt, at index: Int) -> Self {
        var result = self
        result.add(other, at: index)
        return result as Self
    }
}
