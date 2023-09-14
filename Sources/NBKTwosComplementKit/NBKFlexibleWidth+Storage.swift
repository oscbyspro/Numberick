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
// MARK: * NBK x Flexible Width x Storage x IntXL
//*============================================================================*

extension IntXL {
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*

    /// IntXL's and UIntXL's underlying storage.
    ///
    /// It has fixed-width semantics unless stated otherwise.
    ///
    @frozen @usableFromInline struct Storage: PrivateIntXLOrUIntXLStorage {
        
        @usableFromInline typealias Digit = IntXL.Digit
        
        @usableFromInline typealias Elements = NBKFlexibleWidth.Elements
                
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// A collection of unsigned integers.
        ///
        /// It must be `nonempty` at the start and end of each access.
        ///
        @usableFromInline var elements: Elements
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ elements: Elements) {
            self.elements = elements
            precondition(!self.elements.isEmpty)
        }
        
        @inlinable init(unchecked elements: Elements) {
            self.elements = elements
            Swift.assert(!self.elements.isEmpty)
        }
        
        @inlinable init(nonemptying elements: Elements) {
            self.elements = elements
            if  self.elements.isEmpty {
                self.elements.append(0)
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Details x Bit Pattern
        //=--------------------------------------------------------------------=
        
        @inlinable init(bitPattern: UIntXL.Storage) {
            self.init(unchecked: bitPattern.elements)
        }
        
        @inlinable var bitPattern: UIntXL.Storage {
            UIntXL.Storage(unchecked: self.elements)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Storage x UIntXL
//*============================================================================*

extension UIntXL {
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*

    /// IntXL's and UIntXL's underlying storage.
    ///
    /// It has fixed-width semantics unless stated otherwise.
    ///
    @frozen @usableFromInline struct Storage: PrivateIntXLOrUIntXLStorage {
        
        @usableFromInline typealias Digit = UIntXL.Digit
                
        @usableFromInline typealias Elements = NBKFlexibleWidth.Elements
                
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// A collection of unsigned integers.
        ///
        /// It must be `nonempty` at the start and end of each access.
        ///
        @usableFromInline var elements: Elements
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ elements: Elements) {
            self.elements = elements
            precondition(!self.elements.isEmpty)
        }
        
        @inlinable init(unchecked elements: Elements) {
            self.elements = elements
            Swift.assert(!self.elements.isEmpty)
        }
        
        @inlinable init(nonemptying elements: Elements) {
            self.elements = elements
            if  self.elements.isEmpty {
                self.elements.append(0)
            }
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Details x Bit Pattern
        //=--------------------------------------------------------------------=
        
        @inlinable init(bitPattern: UIntXL.Storage) {
            self = bitPattern
        }
        
        @inlinable var bitPattern: UIntXL.Storage {
            self
        }
    }
}
