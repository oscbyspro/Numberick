//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

// TODO: consider a public NBKCoreKit/NBKFlexibleWidthInteger protocol
// TODO: consider a primary associated type similar to NBKCoreKit/NBKCoreInteger
//*============================================================================*
// MARK: * NBK x Flexible Width x Protocol
//*============================================================================*

public protocol IntXLOrUIntXL: NBKBinaryInteger, LosslessStringConvertible {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
 
    func compared(to other: Self, at index: Int) -> Int
    
    func compared(to other: Self.Digit) -> Int
    
    func compared(to other: Self.Digit, at index: Int) -> Int
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Numbers
    //=------------------------------------------------------------------------=
    
    init(digit: Self.Digit, at index: Int)
    
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
    // MARK: Details x Multiplication
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func multiply(by multiplicand: Self)
    
    @_disfavoredOverload @inlinable mutating func multiply(by multiplicand: Digit, adding addend: UInt)
    
    @inlinable func multiplied(by multiplicand: Self) -> Self
    
    @_disfavoredOverload @inlinable func multiplied(by multiplicand: Digit, adding addend: UInt) -> Self
    
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
}