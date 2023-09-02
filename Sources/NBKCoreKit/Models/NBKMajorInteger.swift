//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Major Integer
//*============================================================================*

/// A sequence that merges components of an un/signed integer sequence.
///
/// ```swift
/// for word in NBKMajorInteger(source, isSigned: false, count: nil, as: UInt.self) { ... }
/// ```
///
/// ### Binary Integer Order
///
/// This sequence is ordered like a binary integer, meaning it merges and splits
/// its components from least significant to most. You can reorder it by reversing
/// the input, the output, or both.
///
@frozen public struct NBKMajorInteger<Base, Element>:  RandomAccessCollection where
Element: NBKCoreInteger, Base: RandomAccessCollection, Base.Element: NBKCoreInteger {
    
    public typealias Base = Base
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Base
    @usableFromInline let sign: Element
    public let count: Int
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a sequence of the given type, from an un/signed source.
    @inlinable public init(_ base: Base, isSigned: Bool = false, count: Int? = nil, as element: Element.Type = Element.self) {
        //=--------------------------------------=
        Swift.assert(Self.Element.bitWidth.isPowerOf2)
        Swift.assert(Base.Element.bitWidth.isPowerOf2)
        precondition(Self.Element.bitWidth >= Base.Element.bitWidth)
        //=--------------------------------------=
        self.base  = base
        self.sign  = Self.Element(repeating: isSigned && self.base.last?.mostSignificantBit == true)
        self.count = count ?? Self.count(of: self.base)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// Returns the element at the given index.
    ///
    /// Its elements are ordered from least significant to most, with infinite sign extension.
    ///
    @inlinable public subscript(index: Int) -> Element {
        precondition(index >= 0 as Int, NBK.callsiteOutOfBoundsInfo())
        //=--------------------------------------=
        var major = 0 as Element
        var shift = 0 as Int
        
        if  var   baseIndex = self.baseIndex(index) {
            while baseIndex < self.base.endIndex, shift < Self.Element.bitWidth {
                major |= Self.Element(truncatingIfNeeded: Base.Element.Magnitude(bitPattern: self.base[baseIndex])) &<< shift
                shift += Base.Element.bitWidth
                self.base.formIndex(after: &baseIndex)
            }
        }
        
        return shift >= Self.Element.bitWidth ? major : major | self.sign &<< shift
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities x Private
    //=------------------------------------------------------------------------=
    
    @inlinable func baseIndex(_ index: Int) -> Base.Index? {
        let    position = Self.ratio * index
        guard  position < self.base.count else { return nil }
        return self.base.index(self.base.startIndex, offsetBy: position)
    }
    
    @inlinable static var ratio: Int {
        Self.Element.bitWidth / Base.Element.bitWidth
    }
    
    @inlinable static func count(of base: Base) -> Int {
        let division = base.count.quotientAndRemainder(dividingBy: Self.ratio)
        return division.quotient + Int(bit: !division.remainder.isZero)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension NBKMajorInteger {
    
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
