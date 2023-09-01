//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Minor Integer
//*============================================================================*

/// A sequence that splits components of an un/signed integer sequence.
///
/// ### Binary Integer Order
///
/// This sequence is ordered like a binary integer, meaning it merges and splits
/// its components from least significant to most. You can reorder it by reversing
/// the input, the output, or both.
///
@frozen public struct NBKMinorInteger<Base, Element>: RandomAccessCollection where
Element: NBKCoreInteger, Base: RandomAccessCollection, Base.Element: NBKCoreInteger {
    
    @inlinable static var ratio: Int { Base.Element.bitWidth / Self.Element.bitWidth }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Base
    @usableFromInline let sign: Self.Element
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    // TODO: documentation
    @inlinable public init(_ majorLimbs: Base, isSigned: Bool, as minorLimb: Element.Type = Element.self) {
        //=--------------------------------------=
        Swift.assert(Base.Element.bitWidth.isPowerOf2) // core
        Swift.assert(Self.Element.bitWidth.isPowerOf2) // core
        precondition(Base.Element.bitWidth >= Self.Element.bitWidth)
        //=--------------------------------------=
        self.base = majorLimbs
        let  bit  = isSigned && self.base.last?.mostSignificantBit == true
        self.sign = Self.Element(repeating: bit)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        Self.ratio * self.base.count
    }
    
    @inlinable public subscript(index: Int) -> Element {
        guard index < self.count else { return self.sign }
        let indices = index.quotientAndRemainder(dividingBy: Self.ratio)
        let major = self.base[self.base.index(self.base.startIndex, offsetBy: indices.quotient)]
        return Element(truncatingIfNeeded: major &>> (indices.remainder * Element.bitWidth))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension NBKMinorInteger {
    
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
