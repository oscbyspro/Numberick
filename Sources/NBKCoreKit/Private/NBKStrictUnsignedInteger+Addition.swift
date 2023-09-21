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

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Addition
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Bit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Increments `base` by `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func increment(
    _ base: inout Base, by bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.increment(&base, by: &bit, at: &index)
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
    @inlinable public static func increment(
    _ base: inout Base, by bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        Swift.assert(index >= 0 as Int)
        Swift.assert(base.count >= 1 as Int)
        Swift.assert(base.count >= index) // void
        //=--------------------------------------=
        while bit && index < base.endIndex {
            bit = base[index].addReportingOverflow(1 as Base.Element.Digit)
            base.formIndex(after: &index)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Digit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Increments `base` by `digit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func increment(
    _ base: inout Base, by digit: Base.Element, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool
        //=--------------------------------------=
        bit = self.increment(&base, by: digit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index as Base.Index, overflow: bit as Bool)
    }

    /// Partially increments `base` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func incrementInIntersection(
    _ base: inout Base, by digit: Base.Element, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool
        //=--------------------------------------=
        bit = self.incrementInIntersection(&base, by: digit, at: &index)
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
    @inlinable public static func increment(
    _ base: inout Base, by digit: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        var bit = self.incrementInIntersection(&base, by: digit, at: &index)
        //=--------------------------------------=
        self.increment(&base, by: &bit, at: &index)
        return bit as Bool as Bool as Bool as Bool
    }

    /// Partially increments `base` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func incrementInIntersection(
    _ base: inout Base, by digit: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        Swift.assert(index >= 0 as Int)
        Swift.assert(base.count >  index)
        //=--------------------------------------=
        defer{ base.formIndex(after: &index) }
        return base[index].addReportingOverflow(digit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Digit + Bit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Increments `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func increment(
    _ base: inout Base, by digit: Base.Element, plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.increment(&base, by: digit, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially increments `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func incrementInIntersection(
    _ base: inout Base, by digit: Base.Element, plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.incrementInIntersection(&base, by: digit, plus: &bit, at: &index)
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
    @inlinable public static func increment(
    _ base: inout Base, by digit: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        self.incrementInIntersection(&base, by: digit, plus: &bit, at: &index)
        self.increment(&base, by: &bit, at: &index)
    }

    /// Partially increments `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func incrementInIntersection(
    _ base: inout Base, by digit: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        Swift.assert(index >= 0 as Int)
        Swift.assert(base.count >= 1 as Int)
        Swift.assert(base.count >  index)
        //=--------------------------------------=
        var digit: Base.Element = digit
        //=--------------------------------------=
        if  bit {
            bit = digit.addReportingOverflow(1 as Base.Element.Digit)
        }

        if !bit {
            bit = base[index].addReportingOverflow(digit)
        }
        //=--------------------------------------=
        base.formIndex(after: &index)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Elements + Bit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {

    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Increments `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func increment(
    _ base: inout Base, by elements: some Collection<Base.Element>, plus bit: Bool = false, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.increment(&base, by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially increments `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func incrementInIntersection(
    _ base: inout Base, by elements: some Collection<Base.Element>, plus bit: Bool = false, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.incrementInIntersection(&base, by: elements, plus: &bit, at: &index)
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
    @inlinable public static func increment(
    _ base: inout Base, by elements: some Collection<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        self.incrementInIntersection(&base, by: elements, plus: &bit, at: &index)
        self.increment(&base, by: &bit, at: &index)
    }

    /// Partially increments `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func incrementInIntersection(
    _ base: inout Base, by elements: some Collection<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        Swift.assert(index >= 0 as Int)
        Swift.assert(base.count >= 1 as Int)
        Swift.assert(base.count >= elements.count + index)
        //=--------------------------------------=
        for elementIndex in elements.indices {
            self.incrementInIntersection(&base, by: elements[elementIndex], plus: &bit, at: &index)
        }
    }
}
