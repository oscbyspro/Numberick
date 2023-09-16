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
        
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    /// An unsigned, flexible-width, binary integer.
    ///
    /// ### Logic
    ///
    /// - TODO: Comment on bitwise NOT, AND, OR, XOR semantics.
    ///
    @frozen public struct Magnitude: NBKUnsignedInteger, IntXLOrUIntXL {
        
        public typealias Digit = UInt
                
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var storage: Storage
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(storage: Storage) {
            self.storage = storage
            self.storage.normalize()
            Swift.assert(self.storage.isNormal)
        }
        
        @inlinable init(unchecked: Storage) {
            self.storage = unchecked
            Swift.assert(self.storage.isNormal)
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
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
        
        // #warning("check uses of elements, first!, last!, count, lastIndex")
        //*====================================================================*
        // MARK: * Storage
        //*====================================================================*
        
        /// An unsigned, resizable, collection of at least one word.
        ///
        /// Its operations have fixed-width semantics unless stated otherwise.
        /// 
        @frozen @usableFromInline struct Storage {
            
            @usableFromInline typealias Elements = ContiguousArray<UInt>
            
            //=----------------------------------------------------------------=
            // MARK: State
            //=----------------------------------------------------------------=
            
            @usableFromInline var elements: ContiguousArray<UInt>
            
            //=----------------------------------------------------------------=
            // MARK: Initializers
            //=----------------------------------------------------------------=
            
            @inlinable init(elements: Elements) {
                self.elements = elements
                precondition(!self.elements.isEmpty)
            }
            
            @inlinable init(unchecked elements: Elements) {
                self.elements = elements
                Swift.assert(!self.elements.isEmpty)
            }
            
            //=----------------------------------------------------------------=
            // MARK: Utilities
            //=----------------------------------------------------------------=
            
            @inlinable var isNormal: Bool {
                self.elements.count == 1 || !self.elements.last!.isZero
            }
        }
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
