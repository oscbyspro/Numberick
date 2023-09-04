//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Chunked Int
//*============================================================================*

/// A sequence that chunks elements of an un/signed source.
///
/// ```swift
/// for word in NBKChunkedInt(source, isSigned: false, count: nil, as: UInt.self) { ... }
/// for byte in NBKChunkedInt(source, isSigned: false, count: nil, as: Int8.self) { ... }
/// ```
///
/// ### Binary Integer Order
///
/// This sequence is ordered like a binary integer, meaning it merges and splits
/// its elements from least significant to most. You can reorder it by reversing
/// the input, the output, or both.
///
@frozen public struct NBKChunkedInt<Base, Element>: RandomAccessCollection where
Element: NBKCoreInteger, Base: RandomAccessCollection, Base.Element: NBKCoreInteger {
    
    public typealias Base = Base
    
    @frozen @usableFromInline enum Major { }
    
    @frozen @usableFromInline enum Minor { }
    
    @frozen @usableFromInline enum Equal { }
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    @usableFromInline let base: Base
    @usableFromInline let sign: Element
    public let count: Int
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Creates a sequence of the given type from an un/signed source.
    ///
    /// - Parameters:
    ///   - base: The base sequence viewed through this sequence.
    ///   - isSigned: The signedness of the base sequence.
    ///   - count: An optionally chosen number of elements to view.
    ///   - element: The type of element produced by this sequence.
    ///
    @inlinable public init(_ base: Base, isSigned: Bool = false, count: Int? = nil, as element: Element.Type = Element.self) {
        self.base  = base
        self.sign  = Self.Element(repeating: isSigned && self.base.last?.mostSignificantBit == true)
        self.count = count ?? Self.count(of: self.base)
        
        precondition(self.count >= 0 as Int)
        Swift.assert(Self.Element.bitWidth.isPowerOf2)
        Swift.assert(Base.Element.bitWidth.isPowerOf2)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Accessors
    //=------------------------------------------------------------------------=
    
    /// Returns the element at the given index.
    ///
    /// The elements are ordered from least significant to most, with infinite sign extension.
    ///
    @inlinable public subscript(index: Int) -> Element {
        if  Self.Element.bitWidth > Base.Element.bitWidth {
            return Major.element(index, base: self.base, sign: self.sign)
        }   else if Self.Element.bitWidth < Base.Element.bitWidth {
            return Minor.element(index, base: self.base, sign: self.sign)
        }   else {
            return Equal.element(index, base: self.base, sign: self.sign)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func count(of base: Base) -> Int {
        if  Self.Element.bitWidth > Base.Element.bitWidth {
            return Major.count(of:  base)
        }   else if Self.Element.bitWidth < Base.Element.bitWidth {
            return Minor.count(of:  base)
        }   else {
            return Equal.count(of:  base)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Major
//=----------------------------------------------------------------------------=

extension NBKChunkedInt.Major {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static var ratio: Int {
        Element.bitWidth / Base.Element.bitWidth
    }
    
    @inlinable static func count(of base: Base) -> Int {
        let division = base.count.quotientAndRemainder(dividingBy: self.ratio)
        return division.quotient + Int(bit: !division.remainder.isZero)
    }
    
    @inlinable static func element(_ index: Int, base: Base, sign: Element) -> Element {
        var shift = 0 as Int
        var major = 0 as Element
        let minor = index as Int * self.ratio
        
        if  minor < base.count {
            var   baseIndex = base.index(base.startIndex, offsetBy: minor)
            while baseIndex < base.endIndex, shift < Element.bitWidth {
                major |= Element(truncatingIfNeeded: Base.Element.Magnitude(bitPattern: base[baseIndex])) &<< shift
                shift += Base.Element.bitWidth
                base.formIndex(after: &baseIndex)
            }
        }
        
        return shift >= Element.bitWidth ? major : major | sign &<< shift
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Minor
//=----------------------------------------------------------------------------=

extension NBKChunkedInt.Minor {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static var ratio: Int {
        Base.Element.bitWidth / Element.bitWidth
    }
    
    @inlinable static func count(of base: Base) -> Int {
        base.count *  self.ratio
    }
    
    @inlinable static func element(_ index: Int, base: Base, sign: Element) -> Element {
        precondition(index >= 0 as Int, NBK.callsiteOutOfBoundsInfo())
        let  (quotient, remainder) = index.quotientAndRemainder(dividingBy: self.ratio)
        guard quotient < base.count else { return sign }
        let major = base[base.index(base.startIndex,  offsetBy: quotient)]
        return Element(truncatingIfNeeded: major &>> (remainder * Element.bitWidth))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Equal
//=----------------------------------------------------------------------------=

extension NBKChunkedInt.Equal {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable static func count(of base: Base) -> Int {
        base.count
    }
    
    @inlinable static func element(_ index: Int, base: Base, sign: Element) -> Element {
        guard  index < base.count else { return  sign }
        return NBK.initOrBitCast(truncating: base[base.index(base.startIndex, offsetBy: index)])
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

extension NBKChunkedInt {
    
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
        0 as Int ..< self.count
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
