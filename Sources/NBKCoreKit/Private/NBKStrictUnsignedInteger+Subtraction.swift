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
// MARK: * NBK x Strict Unsigned Integer x Subtraction
//*============================================================================*
// MARK: + Bit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrement(
    _ base: inout Base, by  bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(&base, by: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformationsx x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func decrement(
    _ base: inout Base, by  bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        Swift.assert(self.validate(base))
        //=--------------------------------------=
        while bit && index < base.endIndex {
            bit = base[index].subtractReportingOverflow(1 as Base.Element.Digit)
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

    /// Decrements `base` by `digit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrement(
    _ base: inout Base, by  digit: Base.Element, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool
        //=--------------------------------------=
        bit = self.decrement(&base, by: digit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index as Base.Index, overflow: bit as Bool)
    }

    /// Partially decrements `base` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrementInIntersection(
    _ base: inout Base, by  digit: Base.Element, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool
        //=--------------------------------------=
        bit = self.decrementInIntersection(&base, by: digit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index as Base.Index, overflow: bit as Bool)
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Decrements `base` by `digit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func decrement(
    _ base: inout Base, by  digit: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        var bit = self.decrementInIntersection(&base, by: digit, at: &index)
        self.decrement(&base, by: &bit, at: &index); return bit as Bool
    }

    /// Partially decrements `base` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func decrementInIntersection(
    _ base: inout Base, by  digit: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        Swift.assert(self.validate(base))
        //=--------------------------------------=
        defer{ base.formIndex(after: &index) }
        return base[index].subtractReportingOverflow(digit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Digit + Bit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Decrements `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrement(
    _ base: inout Base, by  digit: Base.Element, plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(&base, by: digit, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially decrements `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrementInIntersection(
    _ base: inout Base, by  digit: Base.Element, plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.decrementInIntersection(&base, by: digit, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformationsx x Inout
    //=------------------------------------------------------------------------=
    
    /// Partially decrements `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func decrement(
    _ base: inout Base, by  digit: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        self.decrementInIntersection(&base, by: digit, plus: &bit, at: &index)
        self.decrement(&base, by: &bit, at: &index)
    }

    /// Partially decrements `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func decrementInIntersection(
    _ base: inout Base, by  digit: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        Swift.assert(self.validate(base))
        //=--------------------------------------=
        var digit: Base.Element = digit
        //=--------------------------------------=
        if  bit {
            bit = digit.addReportingOverflow(1 as Base.Element.Digit)
        }

        if !bit {
            bit = base[index].subtractReportingOverflow(digit)
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

    /// Decrements `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrement(
    _ base: inout Base, by  elements: some Collection<Base.Element>, plus bit: Bool = false, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(&base, by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially decrements `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrementInIntersection(
    _ base: inout Base, by  elements: some Collection<Base.Element>, plus bit: Bool = false, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.decrementInIntersection(&base, by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Decrements `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func decrement(
    _ base: inout Base, by  elements: some Collection<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        self.decrementInIntersection(&base, by: elements, plus: &bit, at: &index)
        self.decrement(&base, by: &bit, at: &index)
    }

    /// Partially decrements `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func decrementInIntersection(
    _ base: inout Base, by  elements: some Collection<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        for elementsIndex in elements.indices {
            self.decrementInIntersection(&base, by: elements[elementsIndex], plus: &bit, at: &index)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Elements × Digit + Digit + Bit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by the product of `elements` and `multiplicand` at `index`,
    /// and the sum of `subtrahend` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrement(
    _ base: inout Base, by elements: some Collection<Base.Element>, times multiplicand: Base.Element,
    plus subtrahend: Base.Element = 0, plus bit: Bool = false, at index: Base.Index) -> NBK.IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(&base, by: elements, times: multiplicand, plus: subtrahend, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by the product of `elements` and `multiplicand` at `index`,
    /// and the sum of `subtrahend` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func decrement(
    _ base: inout Base, by elements: some Collection<Base.Element>, times multiplicand: Base.Element,
    plus subtrahend: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        Swift.assert(self.validate(base))
        //=--------------------------------------=
        var last: Base.Element = subtrahend
        
        for elementsIndex in elements.indices {
            var subproduct = elements[elementsIndex].multipliedFullWidth(by: multiplicand)
            last = Base.Element(bit: subproduct.low.addReportingOverflow(last)) &+ subproduct.high
            self.decrementInIntersection(&base, by: subproduct.low, plus: &bit, at: &index)
        }
        
        self.decrement(&base, by: last, plus: &bit, at: &index)
    }
}
