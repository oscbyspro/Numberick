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
/// ```swift
/// let value = Int256.uninitialized { words in
///     for index in words.indices {
///         words.base.initializeElement(at: words.baseIndex(index), to: UInt.zero)
///     }
/// }
/// ```
///
@frozen public struct NBKLittleEndianOrdered<Base>: RandomAccessCollection where Base: RandomAccessCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The collection wrapped by this instance.
    public var base: Base
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a view presenting the collection's elements in an endianness-dependent order.
    @inlinable public init(_ base: Base) {
        self.base = base
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        self.base.count
    }
    
    @inlinable public var startIndex: Int {
        Int.zero
    }
    
    @inlinable public var endIndex: Int {
        self.base.count
    }
    
    @inlinable public var indices: Range<Int> {
        Range(uncheckedBounds:(self.startIndex, self.endIndex))
    }
    
    @inlinable public subscript(index: Int) -> Base.Element {
        _read   { yield  self.base[self.baseIndex(index)] }
    }
    
    @inlinable public subscript(index: Int) -> Base.Element where Base: MutableCollection {
        _read   { yield  self.base[self.baseIndex(index)] }
        _modify { yield &self.base[self.baseIndex(index)] }
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
    
    /// Returns the corresponding base index, assuming it exists.
    ///
    /// - Note: This operation is unchecked.
    ///
    /// - Parameter index: `self.startIndex <= index < self.endIndex`
    ///
    @inlinable public func baseIndex(_ index: Int) -> Base.Index {
        #if _endian(big)
        return self.base.index(self.base.endIndex,   offsetBy: ~index)
        #else
        return self.base.index(self.base.startIndex, offsetBy:  index)
        #endif
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Conditional Conformances
//=----------------------------------------------------------------------------=

extension NBKLittleEndianOrdered: MutableCollection where Base: MutableCollection { }
