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
    
    public typealias SubSequence = Slice<Self>
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    /// The base collection that is viewed through this instance.
    ///
    /// - Note: The base collection must be private if one of its indices is stored.
    ///
    @usableFromInline var body: Base
    
    /// The bit-mask used to change the offset based on the current direction.
    ///
    /// It is equal to zero when front-to-back, and minus one otherwise.
    ///
    @usableFromInline var mask: Self.Index
    
    /// The base index to be offset.
    ///
    /// It is the base's start index when front-to-back, and its end index otherwise.
    ///
    @usableFromInline var head: Base.Index
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a view presenting the collection's elements in a dynamic order.
    ///
    /// - Parameters:
    ///   - base: The collection viewed through this instance.
    ///   - reversed: A value indicating whether the direction should be reversed.
    ///
    @inlinable public init(_ other: Self, reversed: Bool = false) {
        self.init(other.base, reversed: other.isFrontToBack == reversed)
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
        self.body = base
        self.mask = Int .zero
        self.head = self.body.startIndex
        if reversed { self.reverse() }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// The base collection that is viewed through this instance.
    @inlinable public var base: Base {
        self.body as Base
    }
    
    /// Returns whether the base collection's elements are presented front-to-back.
    @inlinable public var isFrontToBack: Bool {
        self.mask == ( 0) as Int
    }
    
    /// Returns the base collection, if its elements matches this collection.
    @inlinable public var asFrontToBack: Base? {
        self.isFrontToBack ? self.base : nil
    }
    
    /// Returns whether the base collection's elements are presented back-to-front.
    @inlinable public var isBackToFront: Bool {
        self.mask == (-1) as Int
    }
    
    /// Returns the base collection but reversed, if its elements matches this collection.
    @inlinable public var asBackToFront: ReversedCollection<Base>? {
        self.isBackToFront ? self.base.reversed() : nil
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms this collection but reversed.
    ///
    /// - Complexity: O(1).
    ///
    @inlinable public mutating func reverse() {
        self.head =  self.baseIndex(self.endIndex)
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
    
    /// Returns the base collection's corresponding subscript index.
    ///
    /// - Parameter index: `self.startIndex <= index < self.endIndex`
    ///
    @inlinable func baseSubscriptIndex(_ index: Int) -> Base.Index {
        assert(self.startIndex <= index && index <  self.endIndex)
        return self.base.index(self.head, offsetBy: self.mask ^ index)
    }
    
    /// Returns the base collection's corresponding index.
    ///
    /// - Parameter index: `self.startIndex <= index <= self.endIndex`
    ///
    @inlinable func baseIndex(_ index: Int) -> Base.Index {
        assert(self.startIndex <= index && index <= self.endIndex)
        return self.base.index(self.head, offsetBy: self.mask ^ index - self.mask)
    }
    
    /// Returns the base collection's corresponding indices.
    ///
    /// - Parameter index: `self.startIndex <= index <= self.endIndex`
    ///
    @inlinable func baseIndices(_ indices: Range<Int>) -> Range<Base.Index> {
        assert(self.startIndex <= indices.lowerBound && indices.upperBound <= self.endIndex)

        var lowerBound = self.baseIndex(indices.lowerBound)
        var upperBound = self.baseIndex(indices.upperBound)
        
        if  self.isBackToFront {
            Swift.swap(&lowerBound, &upperBound)
        }
        
        return Range(uncheckedBounds:(lowerBound, upperBound))
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
    
    @inlinable public subscript(index: Int) -> Element {
        _read { yield self.base[self.baseSubscriptIndex(index)] }
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
// MARK: + Mutable Collection
//=----------------------------------------------------------------------------=

extension NBKTwinHeaded: MutableCollection where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public subscript(index: Int) -> Element {
        _read   { yield  self.body[self.baseSubscriptIndex(index)] }
        _modify { yield &self.body[self.baseSubscriptIndex(index)] }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension NBKTwinHeaded {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a collection with the same data and direction as the given subsequence.
    @inlinable public init<T>(rebasing subsequence: SubSequence) where Base == UnsafeBufferPointer<T> {
        let subindices = Range(uncheckedBounds:(subsequence.startIndex, subsequence.endIndex))
        let base = Base(rebasing: subsequence.base.base[subsequence.base.baseIndices(subindices)])
        self.init(base, reversed: subsequence.base.isBackToFront)
    }
    
    /// Creates a collection with the same data and direction as the given subsequence.
    @inlinable public init<T>(rebasing subsequence: SubSequence) where Base == UnsafeMutableBufferPointer<T> {
        let subindices = Range(uncheckedBounds:(subsequence.startIndex, subsequence.endIndex))
        let base = Base(rebasing: subsequence.base.base[subsequence.base.baseIndices(subindices)])
        self.init(base, reversed: subsequence.base.isBackToFront)
    }
}
