//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Major Or Minor Integer
//*============================================================================*

/// A sequence that merges or splits elements of an un/signed integer sequence.
///
/// ```swift
/// for word in NBKMajorOrMinorInteger(source, isSigned: false, count: nil, as: UInt.self) { ... }
/// for byte in NBKMajorOrMinorInteger(source, isSigned: false, count: nil, as: Int8.self) { ... }
/// ```
///
/// ### Binary Integer Order
///
/// This sequence is ordered like a binary integer, meaning it merges and splits
/// its elements from least significant to most. You can reorder it by reversing
/// the input, the output, or both.
///
@frozen public struct NBKMajorOrMinorInteger<Base, Element>: RandomAccessCollection where
Element: NBKCoreInteger, Base: RandomAccessCollection, Base.Element: NBKCoreInteger {
    
    public typealias Base = Base
    
    public typealias Major = NBKMajorInteger<Base, Element>
    
    public typealias Minor = NBKMinorInteger<Base, Element>
    
    @frozen @usableFromInline enum Storage { case major(Major), minor(Minor) }
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a sequence of the given type from an un/signed source.
    ///
    /// - Parameters:
    ///   - base: The base sequence viewed through this model.
    ///   - isSigned: A value indicating whether the base sequence is signed.
    ///   - count: A value used to extend or truncate the base sequence.
    ///   - element: The type of element produced by this model.
    ///
    @inlinable public init(_ base: Base, isSigned: Bool = false, count: Int? = nil, as element: Element.Type = Element.self) {
        switch Self.Element.bitWidth > Base.Element.bitWidth {
        case  true: self.storage = .major(Major(base, isSigned: isSigned, count: count))
        case false: self.storage = .minor(Minor(base, isSigned: isSigned, count: count)) }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        switch storage {
        case let .major(base): return base.count
        case let .minor(base): return base.count }
    }
    
    /// Returns the element at the given index.
    ///
    /// Its elements are ordered from least significant to most, with infinite sign extension.
    ///
    @inlinable public subscript(index: Int) -> Element {
        switch storage {
        case let .major(base): return base[index]
        case let .minor(base): return base[index] }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension NBKMajorOrMinorInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var startIndex: Int {
        0 as Int
    }
    
    @inlinable public var endIndex: Int {
        self.count
    }
    
    @inlinable public var indices: Range<Int> {
        Range(uncheckedBounds:(0 as Int, self.count))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public func distance(from start: Int, to end: Int) -> Int {
        end - start
    }
    
    @inlinable public func index(after index: Int) -> Int {
        index +  1 as Int
    }
    
    @inlinable public func formIndex(after index: inout Int) {
        index += 1 as Int
    }
    
    @inlinable public func index(before index: Int) -> Int {
        index -  1 as Int
    }
    
    @inlinable public func formIndex(before index: inout Int) {
        index -= 1 as Int
    }
    
    @inlinable public func index(_ index: Int, offsetBy distance: Int) -> Int {
        index + distance
    }
    
    @inlinable public func index(_ index: Int, offsetBy distance: Int, limitedBy limit: Int) -> Int? {
        NBK.arrayIndex(index, offsetBy: distance, limitedBy: limit)
    }
}
