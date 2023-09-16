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
// MARK: * NBK x Flexible Width x IntXL or UIntXL
//*============================================================================*

public protocol IntXLOrUIntXL: NBKBinaryInteger, ExpressibleByStringLiteral where Magnitude == UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
 
    func compared(to other: Self,  at index: Int) -> Int
        
    func compared(to other: Digit, at index: Int) -> Int
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Addition
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func add(_ other: Self, at index: Int)
    
    @_disfavoredOverload @inlinable mutating func add(_ other: Digit, at index: Int)

    @inlinable func adding(_ other: Self, at index: Int) -> Self
    
    @_disfavoredOverload @inlinable func adding(_ other: Digit, at index: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Subtraction
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func subtract(_ other: Self, at index: Int)
    
    @_disfavoredOverload @inlinable mutating func subtract(_ other: Digit, at index: Int)

    @inlinable func subtracting(_ other: Self, at index: Int) -> Self
    
    @_disfavoredOverload @inlinable func subtracting(_ other: Digit, at index: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Shifts
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func bitshiftLeftSmart(by distance: Int)
    
    @inlinable func bitshiftedLeftSmart(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftLeft(by distance: Int)
    
    @inlinable func bitshiftedLeft(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftLeft(words: Int, bits: Int)
    
    @inlinable func bitshiftedLeft(words: Int, bits: Int) -> Self
    
    @inlinable mutating func bitshiftLeft(words: Int)
    
    @inlinable func bitshiftedLeft(words: Int) -> Self
    
    @inlinable mutating func bitshiftRightSmart(by distance: Int)
    
    @inlinable func bitshiftedRightSmart(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftRight(by distance: Int)
    
    @inlinable func bitshiftedRight(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftRight(words: Int, bits: Int)
    
    @inlinable func bitshiftedRight(words: Int, bits: Int) -> Self
    
    @inlinable mutating func bitshiftRight(words: Int)
    
    @inlinable func bitshiftedRight(words: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Update
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func updateZeroValue()
    
    @inlinable mutating func update(_ value: Digit)
}
