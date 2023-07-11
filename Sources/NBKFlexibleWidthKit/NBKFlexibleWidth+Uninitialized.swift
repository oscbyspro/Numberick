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
// MARK: * NBK x Flexible Width x Uninitialized x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers x Private
    //=------------------------------------------------------------------------=
    
    @inlinable static func uninitialized(count: Int, body: (NBK.UnsafeMutableWords) -> Void) -> Self {
        let storage = Array(unsafeUninitializedCapacity: count) {
            storage, endIndex in
            body(NBK.UnsafeMutableWords(rebasing: storage.prefix(upTo: count)))
            endIndex = count as Int
        }
        
        return Self(unchecked: storage)
    }
}
