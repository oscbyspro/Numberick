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
// MARK: * NBK x Flexible Width x IntXL
//*============================================================================*

/// A signed, flexible-width, binary integer.
@frozen public struct IntXL: IntXLOrUIntXL, NBKSignedInteger {
    
    public typealias Digit = Int
    
    @usableFromInline typealias Storage = ContiguousArray<UInt>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The integer's underlying storage.
    ///
    /// It must be normal and nonempty the start and end of each integer access.
    ///
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ storage: Storage) {
        self.storage = storage
        precondition(!self.storage.isEmpty)
        self.normalize()
    }
    
    @inlinable init(unchecked storage: Storage) {
        self.storage = storage
    }
    
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
        "IntXL"
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x UIntXL
//*============================================================================*

/// An unsigned, flexible-width, binary integer.
@frozen public struct UIntXL: IntXLOrUIntXL, NBKUnsignedInteger {
    
    public typealias Digit = UInt
    
    @usableFromInline typealias Storage = ContiguousArray<UInt>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The integer's underlying storage.
    ///
    /// It must be normal and nonempty the start and end of each integer access.
    ///
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ storage: Storage) {
        self.storage = storage
        precondition(!self.storage.isEmpty)
        self.normalize()
    }
    
    @inlinable init(unchecked storage: Storage) {
        self.storage = storage
    }
    
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
        "UIntXL"
    }
}

//*============================================================================*
// MARK: * NBK x IntXL or UIntXL
//*============================================================================*

public protocol IntXLOrUIntXL: NBKBinaryInteger, ExpressibleByStringLiteral where Magnitude == UIntXL { }
