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
/// ### Binary Integer Order
///
/// This sequence is ordered like a binary integer, meaning it merges and splits
/// its components from least significant to most. You can reorder it by reversing
/// the input, the output, or both.
///
@frozen public struct NBKMajorInteger<Base, Element>:  RandomAccessCollection where
Element: NBKCoreInteger, Base: RandomAccessCollection, Base.Element: NBKCoreInteger {
    
    @inlinable static var ratio: Int { Self.Element.bitWidth / Base.Element.bitWidth }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Base
    @usableFromInline let sign: Element
        
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    // TODO: documentation
    @inlinable public init(_ minorLimbs: Base, isSigned: Bool = false, as majorLimb: Element.Type = Element.self) {
        //=--------------------------------------=
        Swift.assert(Self.Element.bitWidth.isPowerOf2) // core
        Swift.assert(Base.Element.bitWidth.isPowerOf2) // core
        precondition(Self.Element.bitWidth >= Base.Element.bitWidth)
        //=--------------------------------------=
        self.base = minorLimbs
        let  bit  = isSigned && self.base.last?.mostSignificantBit == true
        self.sign = Self.Element(repeating: bit)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    @inlinable public var count: Int {
        let division = base.count.quotientAndRemainder(dividingBy: Self.ratio)
        return division.quotient + Int(bit: !division.remainder.isZero)
    }
    
    @inlinable public subscript(index: Int) -> Element {
        var shift = 0 as Int
        var major = 0 as Self.Element
        //=--------------------------------------=
        var   baseIndex = self.base.index(self.base.startIndex, offsetBy: index * Self.ratio)
        while baseIndex < self.base.endIndex && shift < Self.Element.bitWidth {
            major |= Self.Element(truncatingIfNeeded: Base.Element.Magnitude(bitPattern: self.base[baseIndex])) &<< shift
            shift += Base.Element.bitWidth as Int
            self.base.formIndex(after: &baseIndex)
        }
        //=--------------------------------------=
        if  shift <  Self.Element.bitWidth { major |= self.sign &<< shift }
        //=--------------------------------------=
        return major
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
