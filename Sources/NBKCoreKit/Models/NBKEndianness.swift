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

/// An enumeration of little and big endianness.
///
/// ### Static vs Dynamic
///
/// Some algorithms differ depending on endianness. Generic type parameterization
/// can express the difference, but dynamic solutions are often viable. This type
/// encurages the latter.
///
@frozen public enum NBKEndianness: Hashable, Sendable {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// A value representing a least-to-most-significant byte order.
    case little
    
    /// A value representing a most-to-least-significant byte order.
    case big
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Returns the current system's byte order.
    @inlinable public static var system: Self {
        #if _endian(little)
        return .little
        #elseif _endian(big)
        return .big
        #endif
    }
}
