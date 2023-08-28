//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Twin Headed
//*============================================================================*

/// A collection that iterates forwards or backwards in a dynamic but branchless way.
@frozen public struct NBKTwinHeaded<Base>: RandomAccessCollection where Base: RandomAccessCollection {
    
    public typealias Base = Base
    
    public typealias Index = Int
    
    public typealias Indices = Range<Int>
    
    public typealias Element = Base.Element
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    public var base: Base
    @usableFromInline var mask: Self.Index
    @usableFromInline var edge: Base.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a view presenting the collection's elements in a dynamic order.
    ///
    /// - Parameters:
    ///   - base: The collection viewed through this instance.
    ///   - reversed: A value indicating whether the direction should be reversed.
    ///
    @inlinable public init(_ other: Self, reversed:  Bool =  false) {
        self.init(other.base, reversed: other.mask.isZero == reversed)
    }
    
    /// Creates a view presenting the collection's elements in a dynamic order.
    ///
    /// - Parameters:
    ///   - base: The collection viewed through this instance.
    ///   - reversed: A value indicating whether the direction should be reversed.
    ///
    @inlinable public init(_ other: ReversedCollection<Base>, reversed: Bool = false) {
        self.init(other.reversed(), reversed: !reversed)
    }
    
    /// Creates a view presenting the collection's elements in a dynamic order.
    ///
    /// - Parameters:
    ///   - base: The collection viewed through this instance.
    ///   - reversed: A value indicating whether the direction should be reversed.
    ///
    @_disfavoredOverload @inlinable public init(_ base: Base, reversed: Bool = false) {
        self.base = base
        self.mask = Int.zero
        self.edge = self.base.startIndex
        if reversed { self.reverse() }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms this collection but reversed.
    ///
    /// - Complexity: O(1).
    ///
    @inlinable public mutating func reverse() {
        self.edge =  self.base.index(self.edge, offsetBy: self.mask ^ self.count - self.mask)
        self.mask = ~self.mask
    }
    
    /// Returns this collection but reversed.
    ///
    /// - Complexity: O(1).
    ///
    @inlinable public func reversed() -> Self {
        var result = self; result.reverse(); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    /// Returns the corresponding index in the base collection.
    ///
    /// - Parameter index: `self.startIndex <= index < self.endIndex`
    ///
    @inlinable func baseSubscriptIndex(_ index: Int) -> Base.Index {
        assert(self.startIndex <= index && index <  self.endIndex)
        return self.base.index(self.edge, offsetBy: self.mask ^ index)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension NBKTwinHeaded {
    
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
        self.count
    }
    
    @inlinable public var indices: Range<Int> {
        Range(uncheckedBounds:(self.startIndex, self.endIndex))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors x Element
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(index: Int) -> Element {
        _read   { yield  self.base[self.baseSubscriptIndex(index)] }
    }
    
    @inlinable public subscript(index: Int) -> Element where Base: MutableCollection {
        _read   { yield  self.base[self.baseSubscriptIndex(index)] }
        _modify { yield &self.base[self.baseSubscriptIndex(index)] }
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
    
    // TODO: NBK.arrayIndex(_:offsetBy:limitedBy:)
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
// MARK: + Conditional Conformances
//=----------------------------------------------------------------------------=

extension NBKTwinHeaded: MutableCollection where Base: MutableCollection { }
