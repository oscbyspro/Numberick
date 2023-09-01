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

/// A sequence that merges or splits components of an un/signed integer sequence.
///
/// ### Binary Integer Order
///
/// This sequence is ordered like a binary integer, meaning it merges and splits
/// its components from least significant to most. You can reorder it by reversing
/// the input, the output, or both.
///
@frozen public struct NBKMajorOrMinorInteger<Base, Element>: RandomAccessCollection where
Element: NBKCoreInteger, Base: RandomAccessCollection, Base.Element: NBKCoreInteger {
    
    public typealias Base = Base
    
    public typealias MajorLimbs = NBKMajorInteger<Base, Element>
    
    public typealias MinorLimbs = NBKMinorInteger<Base, Element>
        
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let storage: Storage
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a sequence of the given type, from an un/signed source.
    @inlinable public init(_ source: Base, isSigned: Bool = false, as limb: Element.Type = Element.self) {
        if  Element.bitWidth > Base.Element.bitWidth {
            self.storage = .majorLimbs(MajorLimbs(source, isSigned: isSigned))
        }   else {
            self.storage = .minorLimbs(MinorLimbs(source, isSigned: isSigned))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        switch storage {
        case let .majorLimbs(limbs): return limbs.count
        case let .minorLimbs(limbs): return limbs.count }
    }
    
    @inlinable public subscript(index: Int) -> Element {
        switch storage {
        case let .majorLimbs(limbs): return limbs[index]
        case let .minorLimbs(limbs): return limbs[index] }
    }
    
    //*========================================================================*
    // MARK: * Storage
    //*========================================================================*
    
    @frozen @usableFromInline enum Storage {
        case majorLimbs(MajorLimbs)
        case minorLimbs(MinorLimbs)
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
