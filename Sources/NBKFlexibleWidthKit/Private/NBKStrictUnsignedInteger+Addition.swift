//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=
// TODO: See whether consuming arguments removes the need for inout in Swift 5.9
//=----------------------------------------------------------------------------=

import NBKCoreKit

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Addition
//*============================================================================*
// MARK: + Bit
//=----------------------------------------------------------------------------=

extension NBKStrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments `base` by `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func increment(
    by  bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.increment(by: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformationsx x Inout
    //=------------------------------------------------------------------------=
    
    /// Increments `base` by `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public mutating func increment(
    by  bit: inout Bool, at index: inout Base.Index) {
        while bit && index < self.base.endIndex {
            bit = self.base[index].addReportingOverflow(1 as Base.Element.Digit)
            self.base.formIndex(after: &index)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Digit
//=----------------------------------------------------------------------------=

extension NBKStrictUnsignedInteger where Base: MutableCollection {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Increments `base` by `digit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func increment(
    by  digit: Base.Element, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool
        //=--------------------------------------=
        bit = self.increment(by: digit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index as Base.Index, overflow: bit as Bool)
    }

    /// Partially increments `base` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func incrementInIntersection(
    by  digit: Base.Element, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool
        //=--------------------------------------=
        bit = self.incrementInIntersection(by: digit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index as Base.Index, overflow: bit as Bool)
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Increments `base` by `digit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public mutating func increment(
    by  digit: Base.Element, at index: inout Base.Index) -> Bool {
        var bit = self.incrementInIntersection(by: digit, at: &index)
        self.increment(by: &bit, at: &index); return bit as Bool
    }

    /// Partially increments `base` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public mutating func incrementInIntersection(
    by  digit: Base.Element, at index: inout Base.Index) -> Bool {
        defer{ self.base.formIndex(after: &index) }
        return self.base[index].addReportingOverflow(digit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Digit + Bit
//=----------------------------------------------------------------------------=

extension NBKStrictUnsignedInteger where Base: MutableCollection {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Increments `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func increment(
    by  digit: Base.Element, plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.increment(by: digit, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially increments `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func incrementInIntersection(
    by  digit: Base.Element, plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool = bit, digit: Base.Element = digit
        //=--------------------------------------=
        self.incrementInIntersection(by: digit, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformationsx x Inout
    //=------------------------------------------------------------------------=
    
    /// Partially increments `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public mutating func increment(
    by  digit: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        self.incrementInIntersection(by: digit, plus: &bit, at: &index)
        self.increment(by: &bit, at: &index)
    }

    /// Partially increments `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public mutating func incrementInIntersection(
    by  digit: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        var digit: Base.Element = digit
        //=--------------------------------------=
        if  bit {
            bit = digit.addReportingOverflow(1 as Base.Element.Digit)
        }

        if !bit {
            bit = self.base[index].addReportingOverflow(digit)
        }
        //=--------------------------------------=
        self.base.formIndex(after: &index)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Elements + Bit
//=----------------------------------------------------------------------------=

extension NBKStrictUnsignedInteger where Base: MutableCollection {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Increments `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func increment(
    by  elements: some Collection<Base.Element>, plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.increment(by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially increments `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func incrementInIntersection(
    by  elements: some Collection<Base.Element>, plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.incrementInIntersection(by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Increments `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public mutating func increment(
    by  elements: some Collection<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        self.incrementInIntersection(by: elements, plus: &bit, at: &index)
        self.increment(by: &bit, at: &index)
    }

    /// Partially increments `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public mutating func incrementInIntersection(
    by  elements: some Collection<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        for elementIndex in elements.indices {
            self.incrementInIntersection(by: elements[elementIndex], plus: &bit, at: &index)
        }
    }
}
