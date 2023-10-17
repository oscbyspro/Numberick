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
    // MARK: Details x Numbers
    //=------------------------------------------------------------------------=
    
    /// An instance that is equal to `0`.
    @inlinable static var zero: Self { get }
    
    /// An instance that is equal to `1`.
    @inlinable static var one:  Self { get }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Comparisons
    //=------------------------------------------------------------------------=
 
    @inlinable func compared(to other: Self, at index: Int) -> Int
        
    @_disfavoredOverload @inlinable func compared(to other: Digit, at index: Int) -> Int
    
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
    
    @inlinable mutating func bitshiftLeft(major: Int, minor: Int)
    
    @inlinable func bitshiftedLeft(major: Int, minor: Int) -> Self
    
    @inlinable mutating func bitshiftLeft(major: Int)
    
    @inlinable func bitshiftedLeft(major: Int) -> Self
    
    @inlinable mutating func bitshiftRightSmart(by distance: Int)
    
    @inlinable func bitshiftedRightSmart(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftRight(by distance: Int)
    
    @inlinable func bitshiftedRight(by distance: Int) -> Self
    
    @inlinable mutating func bitshiftRight(major: Int, minor: Int)
    
    @inlinable func bitshiftedRight(major: Int, minor: Int) -> Self
    
    @inlinable mutating func bitshiftRight(major: Int)
    
    @inlinable func bitshiftedRight(major: Int) -> Self
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Update
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func updateZeroValue()
    
    @inlinable mutating func update(_ value: Digit)
}

//=----------------------------------------------------------------------------=
// MARK: + Details
//=----------------------------------------------------------------------------=

extension IntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A `description` of this type.
    ///
    /// ```
    /// ┌─────────────────────────── → ────────────┐
    /// │ type                       │ description │
    /// ├─────────────────────────── → ────────────┤
    /// │ NBKFlexibleWidth           │  "IntXL"    │
    /// │ NBKFlexibleWidth.Magnitude │ "UIntXL"    │
    /// └─────────────────────────── → ────────────┘
    /// ```
    ///
    @inlinable public static var description: String {
        Self.isSigned ? "IntXL" : "UIntXL"
    }
}
