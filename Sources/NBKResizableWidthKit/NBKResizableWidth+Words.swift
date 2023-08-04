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
// MARK: * NBK x Resizable Width x Words x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    @inlinable public init(words: some RandomAccessCollection<UInt>) {
        self.init(storage: Storage(words))
    }
    
    @inlinable public init(repeating word: UInt, count: Int) {
        self.init(storage: Storage(repeating: word, count: count))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        self.storage.count
    }
    
    @inlinable public var words: Self {
        _read { yield self }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection x Indices
//=----------------------------------------------------------------------------=

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: Int {
        self.storage.startIndex
    }
    
    @inlinable public var lastIndex: Int {
        self.storage.index(before: self.storage.endIndex)
    }
    
    @inlinable public var endIndex: Int {
        self.storage.endIndex
    }
    
    @inlinable public var indices: Range<Int> {
        self.storage.indices
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func distance(from start: Int, to end: Int) -> Int {
        end - start
    }
    
    @inlinable public func index(after index: Int) -> Int {
        index +  1
    }
    
    @inlinable public func formIndex(after index: inout Int) {
        index += 1
    }
    
    @inlinable public func index(before index: Int) -> Int {
        index -  1
    }
    
    @inlinable public func formIndex(before index: inout Int) {
        index -= 1
    }
    
    @inlinable public func index(_ index: Int, offsetBy distance: Int) -> Int {
        index + distance
    }
    
    @inlinable public func index(_ index: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
        let distanceLimit: Int = self.distance(from: index, to: limit)
        
        guard distance >= 0
        ? distance <= distanceLimit || distanceLimit < 0
        : distance >= distanceLimit || distanceLimit > 0
        else { return nil }
        
        return self.index(index, offsetBy: distance) as Int
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection x Elements
//=----------------------------------------------------------------------------=

extension NBKResizableWidth.Magnitude {
    
    /// The least significant word.
    ///
    /// - Note: This member is required by `Swift.BinaryInteger`.
    ///
    @inlinable public var _lowWord: UInt {
        self.first
    }
    
    /// The least significant word.
    @inlinable public var first: UInt {
        _read   { yield  self[self.startIndex] }
        _modify { yield &self[self.startIndex] }
    }
    
    /// The most significant word.
    @inlinable public var last: UInt {
        _read   { yield  self[self.lastIndex] }
        _modify { yield &self[self.lastIndex] }
    }
    
    /// The most significant word, reinterpreted as a ``Digit``.
    @inlinable public var tail: Digit {
        _read   { yield  self[self.lastIndex] }
        _modify { yield &self[self.lastIndex] }
    }
    
    /// Accesses the word at the given index, from least significant to most.
    @inlinable public subscript(_ index: Int) -> UInt {
        _read   { yield  self.storage[index] }
        _modify { yield &self.storage[index] }
    }
}
