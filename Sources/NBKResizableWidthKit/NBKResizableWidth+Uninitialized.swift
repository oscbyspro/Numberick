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
    @inlinable public static func uninitialized(count: Int, body: (NBK.UnsafeMutableWords) -> Void) -> Self {
        let storage = Storage(unsafeUninitializedCapacity: count) {
            storage,  endIndex in
            body(NBK.UnsafeMutableWords(rebasing: storage.prefix(upTo: count)))
            endIndex = count as Int
        }
        
        return Self(storage: storage)
    }
}
