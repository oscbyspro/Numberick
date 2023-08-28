//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Endianness
//*============================================================================*

/// An enumeration of big and little endianness.
///
/// ### Static vs Dynamic
///
/// Some algorithms differ depending on endianness. Generic type parameterization
/// can express the difference, but dynamic solutions are often viable. This type
/// encurages the latter.
///
@frozen public enum NBKEndianness: Hashable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// A value representing big endianness.
    case big
    
    /// A value representing little endianness.
    case little
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns the endianness of the current system.
    @inlinable public static var system: Self {
        #if _endian(big)
        return .big
        #else
        return .little
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    /// Returns the opposite endianness.
    @inlinable public static prefix func !(operand: Self) -> Self {
        switch operand { case .big: return .little; case .little: return .big }
    }
}
