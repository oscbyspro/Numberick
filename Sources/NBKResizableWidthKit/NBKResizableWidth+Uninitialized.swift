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
// MARK: * NBK x Resizable Width x Uninitialized x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    // TODO: measure (inout Self) -> Void
    @inlinable public static func uninitialized(count: Int, body: (inout NBK.UnsafeMutableWords) -> Void) -> Self {
        Self(storage: Storage(unsafeUninitializedCapacity: count) { body(&$0); $1 = count })
    }
}
