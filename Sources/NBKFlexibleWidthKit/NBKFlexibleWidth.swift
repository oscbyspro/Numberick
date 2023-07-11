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

@frozen public struct NBKFlexibleWidth: Hashable {
    
    public typealias Digit = Int
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline var _signum: Int
    @usableFromInline var _magnitude: Magnitude
    
    //*========================================================================*
    // MARK: * Magnitude
    //*========================================================================*
    
    @frozen public struct Magnitude: NBKUnsignedInteger {
        
        public typealias Digit = UInt
                
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        @usableFromInline var storage: Storage
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(unchecked: Storage) {
            self.storage = unchecked
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
