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
// MARK: * NBK x Strict Unsigned Integer x Subtraction
//*============================================================================*
// MARK: + Bit
//=----------------------------------------------------------------------------=

extension NBKStrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func decrement(
    by  bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(by: &bit, at: &index)
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
    @inlinable public mutating func decrement(
    by  bit: inout Bool, at index: inout Base.Index) {
        while bit && index < self.base.endIndex {
            bit = self.base[index].subtractReportingOverflow(1 as Base.Element.Digit)
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

    /// Decrements `base` by `digit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func decrement(
    by  digit: Base.Element, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool
        //=--------------------------------------=
        bit = self.decrement(by: digit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index as Base.Index, overflow: bit as Bool)
    }

    /// Partially decrements `base` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func decrementInIntersection(
    by  digit: Base.Element, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool
        //=--------------------------------------=
        bit = self.decrementInIntersection(by: digit, at: &index)
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
    @inlinable public mutating func decrement(
    by  digit: Base.Element, at index: inout Base.Index) -> Bool {
        var bit = self.decrementInIntersection(by: digit, at: &index)
        self.decrement(by: &bit, at: &index); return bit as Bool
    }

    /// Partially decrements `base` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public mutating func decrementInIntersection(
    by  digit: Base.Element, at index: inout Base.Index) -> Bool {
        defer{ self.base.formIndex(after: &index) }
        return self.base[index].subtractReportingOverflow(digit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Digit + Bit
//=----------------------------------------------------------------------------=

extension NBKStrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Decrements `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func decrement(
    by  digit: Base.Element, plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(by: digit, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially decrements `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func decrementInIntersection(
    by  digit: Base.Element, plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool = bit, digit: Base.Element = digit
        //=--------------------------------------=
        self.decrementInIntersection(by: digit, plus: &bit, at: &index)
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
    @inlinable public mutating func decrement(
    by  digit: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        self.decrementInIntersection(by: digit, plus: &bit, at: &index)
        self.decrement(by: &bit, at: &index)
    }

    /// Partially decrements `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public mutating func decrementInIntersection(
    by  digit: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        var digit: Base.Element = digit
        //=--------------------------------------=
        if  bit {
            bit = digit.addReportingOverflow(1 as Base.Element.Digit)
        }

        if !bit {
            bit = self.base[index].subtractReportingOverflow(digit)
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

    /// Decrements `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func decrement(
    by  elements: some Collection<Base.Element>, plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        return NBK.IO(index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially decrements `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func decrementInIntersection(
    by  elements: some Collection<Base.Element>, plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.decrementInIntersection(by: elements, plus: &bit, at: &index)
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
    @inlinable public mutating func decrement(
    by  elements: some Collection<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        self.decrementInIntersection(by: elements, plus: &bit, at: &index)
        self.decrement(by: &bit, at: &index)
    }

    /// Partially decrements `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public mutating func decrementInIntersection(
    by  elements: some Collection<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        for elementIndex in elements.indices {
            self.decrementInIntersection(by: elements[elementIndex], plus: &bit, at: &index)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Elements × Digit + Digit + Bit
//=----------------------------------------------------------------------------=

extension NBKStrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by the product of `elements` and `multiplicand` at `index`,
    /// and the sum of `subtrahend` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public mutating func decrement(
    by elements: some Collection<Base.Element>, times multiplicand: Base.Element, plus subtrahend: Base.Element,
    plus bit: Bool, at index: Base.Index) -> NBK.IO<Base.Index> {
        var index: Base.Index = index, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(by: elements, times: multiplicand, plus: subtrahend, plus: &bit, at: &index)
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
    @inlinable public mutating func decrement(
    by elements: some Collection<Base.Element>, times multiplicand: Base.Element, plus subtrahend: Base.Element,
    plus bit: inout Bool, at index: inout Base.Index) {
        var last: Base.Element = subtrahend
        
        for limbsIndex in elements.indices {
            var subproduct = elements[limbsIndex].multipliedFullWidth(by: multiplicand)
            last = Base.Element(bit: subproduct.low.addReportingOverflow(last)) &+ subproduct.high
            self.decrementInIntersection(by: subproduct.low, plus: &bit, at: &index)
        }
        
        self.decrement(by: last, plus: &bit, at: &index)
    }
}
