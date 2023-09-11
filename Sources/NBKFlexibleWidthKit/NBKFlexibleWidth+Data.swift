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
// MARK: * NBK x Double Width x Data x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Private
    //=------------------------------------------------------------------------=
    
    /// Creates a new instance with unsafe access to its uninitialized memory.
    @inlinable static func uninitialized(count: Int, body: (inout NBK.UnsafeMutableWords) -> Void) -> Self {
        Self(elements: Elements(unsafeUninitializedCapacity: count) { body(&$0); $1 = count })
    }
}
