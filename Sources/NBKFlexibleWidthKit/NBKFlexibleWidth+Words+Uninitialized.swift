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
// MARK: * NBK x Double Width x Words x Uninitialized x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with unsafe access to its uninitialized memory.
    ///
    /// The `init` is responsible for initializing the words given to it.
    ///
    @inlinable public static func uninitialized(
    count: Int, init: (inout UnsafeMutableBufferPointer<UInt>) -> Void) -> Self {
        Self(normalizing: Storage.uninitialized(count: count, init: `init`))
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Words x Uninitialized x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Private
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with unsafe access to its uninitialized memory.
    ///
    /// The `init` is responsible for initializing the words given to it.
    ///
    @inlinable static func uninitialized(
    count: Int, init: (inout UnsafeMutableBufferPointer<UInt>) -> Void) -> Self {
        Self(Elements(unsafeUninitializedCapacity: count) { `init`(&$0); $1 = $0.count })
    }
}
