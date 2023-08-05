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
// MARK: * NBK x Collection
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Drop
    //=------------------------------------------------------------------------=
    
    /// Drops elements that the satisfy the predicate from the end of the given `collection`.
    @_transparent @usableFromInline static func dropLast<T>(
    from collection: T, while predicate: (T.Element) -> Bool)
    -> T.SubSequence where T: BidirectionalCollection {
        var newEndIndex = collection.endIndex
        
        backwards: while newEndIndex > collection.startIndex {
            let newLastIndex = collection.index(before: newEndIndex)
            guard predicate(collection[newLastIndex]) else { break }
            newEndIndex = newLastIndex
        }
        
        return collection.prefix(upTo: newEndIndex)
    }
}
