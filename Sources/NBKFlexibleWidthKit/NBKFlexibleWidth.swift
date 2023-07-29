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
@frozen public struct NBKFlexibleWidth: NBKSignedInteger, IntXLOrUIntXL {
    
    public typealias Digit = Int
    
    public typealias Sign  = NBK.Sign
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The sign of this value.
    public var sign: Sign
    
    /// The magnitude of this value.
    public var magnitude: Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(sign: Sign, magnitude: Magnitude) {
        self.sign = sign
        self.magnitude = magnitude
    }
    
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
        
        //*====================================================================*
        // MARK: * Storage
        //*====================================================================*
        
        /// A contiguous collection of machine words.
        ///
        /// - Note: It's methods have fixed-width semantics unless stated otherwise.
        ///
        @frozen @usableFromInline struct Storage: Hashable {
            
            @usableFromInline typealias Elements = Array<UInt>
            
            //=----------------------------------------------------------------=
            // MARK: State
            //=----------------------------------------------------------------=
            
            @usableFromInline var elements: Elements
            
            //=----------------------------------------------------------------=
            // MARK: Initializers
            //=----------------------------------------------------------------=
            
            @inlinable init(elements: Elements) { self.elements = elements }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Aliases
//*============================================================================*

/// A signed, flexible-width, integer.
public typealias IntXL = NBKFlexibleWidth

/// An unsigned, flexible-width, integer.
public typealias UIntXL = NBKFlexibleWidth.Magnitude
