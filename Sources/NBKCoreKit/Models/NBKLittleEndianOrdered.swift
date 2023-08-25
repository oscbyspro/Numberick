//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Little Endian Ordered
//*============================================================================*

/// A collection that iterates forwards or backwards depending on the platform.
///
/// It iterates front-to-back on little-endian platforms, and back-to-front otherwise.
///
@frozen public struct NBKLittleEndianOrdered<Base>: BidirectionalCollection where Base: BidirectionalCollection {
    
    #if _endian(big)
    @usableFromInline typealias Storage = ReversedCollection<Base>
    #else
    @usableFromInline typealias Storage = Base
    #endif
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// A collection based on the platform's endianness.
    ///
    /// ```
    /// BE: base.reversed() (back-to-front)
    /// LE: base            (front-to-back)
    /// ```
    ///
    @usableFromInline let storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(_ base: Base) {
        #if _endian(big)
        self.storage = base.reversed()
        #else
        self.storage = base
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var base: Base {
        #if _endian(big)
        return self.storage.reversed() // from >= Swift 4.2
        #else
        return self.storage
        #endif
    }
    
    @inlinable public var count: Int {
        self.storage.count
    }
    
    @inlinable public var startIndex: Index {
        Index(self.storage.startIndex)
    }
    
    @inlinable public var endIndex: Index {
        Index(self.storage.endIndex)
    }
    
    @inlinable public subscript(index: Index) -> Base.Element {
        _read { yield self.storage[index.storageIndex] }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func distance(from start: Index, to end: Index) -> Int {
        self.storage.distance(from: start.storageIndex, to: end.storageIndex)
    }
    
    @inlinable public func index(after  index: Index) -> Index {
        Index(self.storage.index(after: index.storageIndex))
    }
    
    @inlinable public func formIndex(after index: inout Index) {
        self.storage.formIndex(after: &index.storageIndex)
    }
    
    @inlinable public func index(before  index: Index) -> Index {
        Index(self.storage.index(before: index.storageIndex))
    }
    
    @inlinable public func formIndex(before index: inout Index) {
        self.storage.formIndex(before: &index.storageIndex)
    }
    
    @inlinable public func index(_ index: Index, offsetBy distance: Int) -> Index {
        Index(self.storage.index(index.storageIndex, offsetBy: distance))
    }
    
    @inlinable public func index(_ index: Index, offsetBy distance: Int, limitedBy limit: Index) -> Index? {
        self.storage.index(index.storageIndex, offsetBy: distance, limitedBy: limit.storageIndex).map(Index.init)
    }
    
    @inlinable public func baseSubscriptIndex(at index: Index) -> Base.Index {
        #if _endian(big)
        return self.storage.index(after: index.storageIndex).base
        #else
        return index.storageIndex
        #endif
    }
    
    @inlinable public func makeIterator() -> some IteratorProtocol<Base.Element> {
        self.storage.makeIterator()
    }
    
    //*========================================================================*
    // MARK: * Index
    //*========================================================================*
    
    @frozen public struct Index: Comparable {
        
        //=--------------------------------------------------------------------=
        // MARK: State
        //=--------------------------------------------------------------------=
        
        /// An index based on the platform's endianness.
        ///
        /// ```
        /// BE: base.endIndex ..< base.startIndex (back-to-front)
        /// LE: base.startIndex ..< base.endIndex (front-to-back)
        /// ```
        ///
        @usableFromInline var storageIndex: Storage.Index
        
        //=--------------------------------------------------------------------=
        // MARK: Initializers
        //=--------------------------------------------------------------------=
        
        @inlinable init(_ storageIndex: Storage.Index) {
            self.storageIndex = storageIndex
        }
        
        //=--------------------------------------------------------------------=
        // MARK: Utilities
        //=--------------------------------------------------------------------=
        
        @inlinable public static func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.storageIndex == rhs.storageIndex
        }
        
        @inlinable public static func < (lhs: Self, rhs: Self) -> Bool {
            lhs.storageIndex <  rhs.storageIndex
        }
        
        /// Returns the subscript index of the corresponding collection, assuming it exists.
        ///
        /// - Note: This operation is unchecked.
        ///
        @inlinable public func baseSubscriptIndex<T: Strideable>() -> Base.Index where Base.Indices == Range<T> {
            #if _endian(big)
            return self.storageIndex.base.advanced(by: -1)
            #else
            return self.storageIndex
            #endif
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conditional Conformances
//=----------------------------------------------------------------------------=

extension NBKLittleEndianOrdered.Index: Hashable         where Base.Index: Hashable         { }
extension NBKLittleEndianOrdered: RandomAccessCollection where Base: RandomAccessCollection { }
