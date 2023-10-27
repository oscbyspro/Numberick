//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Collection
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Drop
    //=------------------------------------------------------------------------=
    
    /// Drops elements that satisfy the predicate from the end of the given `collection`.
    @_transparent public static func dropLast<T: BidirectionalCollection>(
    from collection: T, while predicate: (T.Element) -> Bool) -> T.SubSequence {
        var newEndIndex = collection.endIndex
        
        backwards: while newEndIndex > collection.startIndex {
            let newLastIndex = collection.index(before: newEndIndex)
            guard predicate(collection[newLastIndex]) else { break }
            newEndIndex = newLastIndex
        }
        
        return collection.prefix(upTo: newEndIndex)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Remove Count
    //=------------------------------------------------------------------------=
    
    /// Removes `count` prefixing elements from the given `collection`.
    @inlinable public static func removePrefix<T: RandomAccessCollection>(
    from collection: inout T, count: Int) -> T where T == T.SubSequence {
        let index  = collection.index(collection.startIndex, offsetBy: count)
        let prefix = collection.prefix(upTo: index)
        collection = collection.suffix(from: index)
        return prefix as T
    }
    
    /// Removes `count` suffixing elements from the given `collection`.
    @inlinable public static func removeSuffix<T: RandomAccessCollection>(
    from collection: inout T, count: Int) -> T where T == T.SubSequence {
        let index  = collection.index(collection.endIndex, offsetBy: count.negated())
        let suffix = collection.suffix(from: index)
        collection = collection.prefix(upTo: index)
        return suffix as T
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Remove Max Length
    //=------------------------------------------------------------------------=
    
    /// Removes up to `maxLength` prefixing elements from the given `collection`.
    @inlinable public static func removePrefix<T: RandomAccessCollection>(
    from collection: inout T, maxLength: Int) -> T where T == T.SubSequence {
        let prefix = collection.prefix(maxLength)
        collection = collection.suffix(from: prefix.endIndex)
        return prefix as T
    }
    
    /// Removes up to `maxLength` suffixing elements from the given `collection`.
    @inlinable public static func removeSuffix<T: RandomAccessCollection>(
    from collection: inout T, maxLength: Int) -> T where T == T.SubSequence {
        let suffix = collection.suffix(maxLength)
        collection = collection.prefix(upTo: suffix.startIndex)
        return suffix as T
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Array Index
    //=------------------------------------------------------------------------=
    
    /// Returns the array-like result of `index(_:offsetBy:limitedBy:)`.
    @inlinable public static func arrayIndex(
    _   index: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
        let distanceLimit = limit - index
        
        guard distance >= 0 as Int
        ? distance <= distanceLimit || distanceLimit < 0 as Int
        : distance >= distanceLimit || distanceLimit > 0 as Int
        else { return nil }
        
        return index + distance as Int
    }
}
