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
// MARK: * NBK x Flexible Width
//*============================================================================*

/// A signed, flexible-width, binary integer.
@frozen public struct NBKFlexibleWidth: PrivateIntXLOrUIntXL, NBKSignedInteger {
    
    public typealias Digit = Int
    
    public typealias Words = ContiguousArray<UInt>
    
    @usableFromInline typealias Elements = ContiguousArray<UInt>
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The integer's underlying storage.
    ///
    /// It must be `normal` and `nonempty` at the start and end of each access.
    ///
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(_ storage: Storage) {
        self.storage = storage
        precondition(self.storage.isNormal)
    }
    
    @inlinable init(unchecked storage: Storage) {
        self.storage = storage
        Swift.assert(self.storage.isNormal)
    }
    
    @inlinable init(normalizing storage: Storage) {
        self.storage = storage
        self.storage.normalize()
    }
    
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    /// An unsigned, flexible-width, binary integer.
    @frozen public struct Magnitude: PrivateIntXLOrUIntXL, NBKUnsignedInteger {
        
        public typealias Digit = UInt
        
        public typealias Words = NBKFlexibleWidth.Words
        
        @usableFromInline typealias Elements = NBKFlexibleWidth.Elements
                        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// The integer's underlying storage.
        ///
        /// It must be `normal` and `nonempty` at the start and end of each access.
        ///
        @usableFromInline var storage: Storage
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ storage: Storage) {
            self.storage = storage
            precondition(self.storage.isNormal)
        }
        
        @inlinable init(unchecked storage: Storage) {
            self.storage = storage
            Swift.assert(self.storage.isNormal)
        }
        
        @inlinable init(normalizing storage: Storage) {
            self.storage = storage
            self.storage.normalize()
        }
    }
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
        self.isSigned ? "IntXL" : "UIntXL"
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Aliases
//*============================================================================*

/// A signed, flexible-width, integer.
public typealias IntXL = NBKFlexibleWidth

/// An unsigned, flexible-width, integer.
public typealias UIntXL = NBKFlexibleWidth.Magnitude
