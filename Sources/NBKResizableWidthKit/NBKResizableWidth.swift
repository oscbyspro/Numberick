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
    
    @usableFromInline typealias Storage = Array<UInt>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable init(storage: Storage) {
        self.storage = storage
        precondition(!self.storage.isEmpty, "\(Self.description) must contain at least one word")
    }
    
    @inlinable init(unchecked storage: Storage) {
        self.storage = storage
        Swift.assert(!self.storage.isEmpty, "\(Self.description) must contain at least one word")
    }
    
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    /// An unsigned, resizable-width, binary integer of at least one word.
    @frozen public struct Magnitude: MutableCollection, RandomAccessCollection, Sendable {
                
        public typealias Digit = UInt
        
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
            precondition(!self.storage.isEmpty, "\(Self.description) must contain at least one word")
        }
        
        @inlinable init(unchecked storage: Storage) {
            self.storage = storage
            Swift.assert(!self.storage.isEmpty, "\(Self.description) must contain at least one word")
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
