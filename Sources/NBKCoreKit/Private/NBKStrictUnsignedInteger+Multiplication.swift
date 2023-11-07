//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Multiplication x Sub Sequence
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Digit + Digit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Multiplies `base` by `multiplier` then adds `digit`.
    ///
    /// - Returns: The `low` product is formed in `base` and the `high` product is returned in one element.
    ///
    @inlinable public static func multiply(
    _   base: inout Base, by multiplier: Base.Element, add digit: Base.Element) -> Base.Element {
        //=--------------------------------------=
        var carry: Base.Element = digit
        var index: Base.Index = base.startIndex
        //=--------------------------------------=
        self.multiply(&base, by: multiplier, add: &carry, from: &index, to: base.endIndex)
        //=--------------------------------------=
        return carry as Base.Element
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Multiplies `base` by `multiplier` then adds `digit` from `index` to `limit`.
    ///
    /// - Returns: The `low` product is formed in `base[index..<limit]` and the `high` product is formed in `digit`.
    ///
    @inlinable public static func multiply(
    _   base: inout Base, by multiplier: Base.Element, add digit: inout Base.Element, from index: inout Base.Index, to limit: Base.Index) {
        //=--------------------------------------=
        Swift.assert(index >= base.startIndex)
        Swift.assert(index <= limit)
        Swift.assert(limit <= base.endIndex  )
        //=--------------------------------------=
        forwards: while index < limit {
            var wide = base[index].multipliedFullWidth(by: multiplier)
            wide.high &+= Base.Element(bit: wide.low.addReportingOverflow(digit))
            (digit, base[index]) = (wide)
            base.formIndex(after: &index)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + where Base is Unsafe Buffer Pointer
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    /// Initializes `base` to the product of `lhs` and `rhs`.
    ///
    /// - Parameters:
    ///   - base: A buffer of size `lhs.count` + `rhs.count`.
    ///
    /// - Note: The `base` memory must be uninitialized or the pointee must be a trivial type.
    ///
    @inlinable public static func initialize<T>(
    _ base: inout Base, to lhs: UnsafeBufferPointer<Base.Element>, times rhs: UnsafeBufferPointer<Base.Element>)
    where Base == UnsafeMutableBufferPointer<T> {
        //=--------------------------------------=
        if  lhs.count < 20 || rhs.count < 20 {
            return self.initializeByLongAlgorithm(&base, to: lhs, times: rhs, plus: Base.Element.zero)
        }   else {
            return self.initializeByKaratsubaAlgorithm(&base, to: lhs, times: rhs)
        }
    }
    
    /// Initializes `base` to the square product of `elements`.
    ///
    /// - Parameters:
    ///   - base: A buffer of size `2 * elements.count`.
    ///
    /// - Note: The `base` memory must be uninitialized or the pointee must be a trivial type.
    ///
    @inlinable public static func initialize<T>(
    _ base: inout Base, toSquareProductOf elements: UnsafeBufferPointer<Base.Element>)
    where Base == UnsafeMutableBufferPointer<T> {
        //=--------------------------------------=
        if  elements.count < 20 {
            return self.initializeByLongAlgorithm(&base, toSquareProductOf: elements, plus: Base.Element.zero)
        }   else {
            return self.initializeByKaratsubaAlgorithm(&base, toSquareProductOf: elements)
        }
    }
}
