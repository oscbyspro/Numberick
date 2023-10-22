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
///
/// This name reserves a spot for a signed 2's-complement-in-memory integer.
///
/// - Note: You can use `NBKSigned<UIntXL>` until `IntXL` becomes available.
///
@frozen public struct NBKFlexibleWidth {
    
    @usableFromInline typealias Elements = ContiguousArray<UInt>
    
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    /// An unsigned, flexible-width, binary integer.
    @frozen public struct Magnitude: NBKUnsignedInteger, IntXLOrUIntXL {
        
        public typealias Digit = UInt
        
        public typealias Words = ContiguousArray<UInt> // TODO: make opaque
        
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
        
        @inlinable init(normalizing storage: Storage) {
            self.storage = storage
            self.storage.normalize()
        }
        
        @inlinable init(unchecked storage: Storage) {
            self.storage = storage
            Swift.assert(self.storage.isNormal)
        }
        
        //*====================================================================*
        // MARK: * Storage
        //*====================================================================*
        
        /// An unsigned, resizable, collection of at least one word.
        ///
        /// Its operations have fixed-width semantics unless stated otherwise.
        /// 
        @frozen @usableFromInline struct Storage {
            
            @usableFromInline typealias Elements = NBKFlexibleWidth.Elements
            
            //=----------------------------------------------------------------=
            // MARK: State
            //=----------------------------------------------------------------=
            
            /// A collection of unsigned integers.
            ///
            /// It must be `nonempty` at the start and end of each access.
            ///
            @usableFromInline var elements: Elements
            
            //=----------------------------------------------------------------=
            // MARK: Initializers
            //=----------------------------------------------------------------=
            
            @inlinable init(_ elements: Elements) {
                self.elements = elements
                precondition(!self.elements.isEmpty)
            }
            
            @inlinable init(nonemptying elements: Elements) {
                self.elements = elements
                if  self.elements.isEmpty {
                    self.elements.append(0)
                }
            }
            
            @inlinable init(unchecked elements: Elements) {
                self.elements = elements
                Swift.assert(!self.elements.isEmpty)
            }
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
        Self.isSigned ? "IntXL" : "UIntXL"
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Aliases
//*============================================================================*

/// A signed, flexible-width, integer.
///
/// This name reserves a spot for a signed 2's-complement-in-memory integer.
///
/// - Note: You can use `NBKSigned<UIntXL>` until `IntXL` becomes available.
///
public typealias IntXL = NBKFlexibleWidth

/// An unsigned, flexible-width, integer.
public typealias UIntXL = NBKFlexibleWidth.Magnitude
