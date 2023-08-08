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
// MARK: * NBK x Resizable Width
//*============================================================================*

/// A signed, resizable-width, binary integer of at least one word.
@frozen public struct NBKResizableWidth {
    
    public typealias Digit = Int
    
    public typealias Words = Self
    
    @usableFromInline typealias Storage = ContiguousArray<UInt>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(storage: Storage) {
        self.storage = storage
        precondition(self.isOK, Self.callsiteInvariantsInfo())
    }
    
    @inlinable init(unchecked storage: Storage) {
        self.storage = storage
        Swift.assert(self.isOK, Self.callsiteInvariantsInfo())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Invariants
    //=------------------------------------------------------------------------=
    
    /// Returns whether its invariants are kept.
    @inlinable var isOK: Bool {
        !self.storage.isEmpty
    }
    
    /// Returns a description of the invariants that must be kept.
    @inlinable static func callsiteInvariantsInfo() -> String {
        "\(Self.description) must contain at least one word"
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// A `description` of this type.
    ///
    /// ```
    /// ┌──────────────────────────── → ────────────┐
    /// │ type                        │ description │
    /// ├──────────────────────────── → ────────────┤
    /// │ NBKResizableWidth           │  "IntXR"    │
    /// │ NBKResizableWidth.Magnitude │ "UIntXR"    │
    /// └──────────────────────────── → ────────────┘
    /// ```
    ///
    @inlinable public static var description: String {
        "IntXR"
    }
    
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    /// An unsigned, resizable-width, binary integer of at least one word.
    @frozen public struct Magnitude: NBKUnsignedInteger, IntXROrUIntXR {
                
        public typealias Digit = UInt
        
        public typealias Words = Self
        
        @usableFromInline typealias Storage = NBKResizableWidth.Storage
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var storage: Storage
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(storage: Storage) {
            self.storage = storage
            precondition(self.isOK, Self.callsiteInvariantsInfo())
        }
        
        @inlinable init(unchecked storage: Storage) {
            self.storage = storage
            Swift.assert(self.isOK, Self.callsiteInvariantsInfo())
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Invariants
        //=--------------------------------------------------------------------=
        
        /// Returns whether its invariants are kept.
        @inlinable var isOK: Bool {
            !self.storage.isEmpty
        }
        
        /// Returns a description of the invariants that must be kept.
        @inlinable static func callsiteInvariantsInfo() -> String {
            "\(Self.description) must contain at least one word"
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        /// A `description` of this type.
        ///
        /// ```
        /// ┌──────────────────────────── → ────────────┐
        /// │ type                        │ description │
        /// ├──────────────────────────── → ────────────┤
        /// │ NBKResizableWidth           │  "IntXR"    │
        /// │ NBKResizableWidth.Magnitude │ "UIntXR"    │
        /// └──────────────────────────── → ────────────┘
        /// ```
        ///
        @inlinable public static var description: String {
            "UIntXR"
        }
    }
}

//*============================================================================*
// MARK: * NBK x Resizable Width x Aliases
//*============================================================================*

/// A signed, resizable-width, binary integer of at least one word.
public typealias IntXR = NBKResizableWidth

/// An unsigned, resizable-width, binary integer of at least one word.
public typealias UIntXR = NBKResizableWidth.Magnitude
