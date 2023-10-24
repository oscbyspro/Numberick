//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Subtraction x Sub Sequence
//*============================================================================*
// MARK: + Bit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by `bit`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrement(
    _   base: inout Base, by bit: Bool) -> IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(&base, by: &bit, at: &index)
        //=--------------------------------------=
        return IO(index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    /// ### Development
    ///
    /// Comparing the index before the bit is important for performance reasons.
    ///
    @inlinable public static func decrement(
    _   base: inout Base, by bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        Swift.assert(index >= base.startIndex)
        Swift.assert(index <= base.endIndex  )
        //=--------------------------------------=
        while index < base.endIndex, bit {
            bit = base[index].subtractReportingOverflow(1 as Base.Element.Digit)
            base.formIndex(after: &index)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Digit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Decrements `base` by `digit`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrement(
    _   base: inout Base, by digit: Base.Element) -> IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool
        //=--------------------------------------=
        bit = self.decrement(&base, by: digit, at: &index)
        //=--------------------------------------=
        return IO(index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially decrements `base` by `digit`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrementInIntersection(
    _   base: inout Base, by digit: Base.Element) -> IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool
        //=--------------------------------------=
        bit = self.decrementInIntersection(&base, by: digit, at: &index)
        //=--------------------------------------=
        return IO(index: index as Base.Index, overflow: bit as Bool)
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Decrements `base` by `digit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrement(
    _   base: inout Base, by digit: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        var bit = self.decrementInIntersection(&base, by: digit, at: &index)
        //=--------------------------------------=
        self.decrement(&base, by: &bit, at: &index)
        return bit as Bool as Bool as Bool as Bool
    }

    /// Partially decrements `base` by `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrementInIntersection(
    _   base: inout Base, by digit: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        Swift.assert(index >= base.startIndex)
        Swift.assert(index <  base.endIndex  )
        //=--------------------------------------=
        defer{ base.formIndex(after: &index) }
        return base[index].subtractReportingOverflow(digit)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Digit + Bit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Decrements `base` by the sum of `digit` and `bit`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrement(
    _   base: inout Base, by digit: Base.Element, plus bit: Bool) -> IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(&base, by: digit, plus: &bit, at: &index)
        //=--------------------------------------=
        return IO(index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially decrements `base` by the sum of `digit` and `bit`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrementInIntersection(
    _   base: inout Base, by digit: Base.Element, plus bit: Bool) -> IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.decrementInIntersection(&base, by: digit, plus: &bit, at: &index)
        //=--------------------------------------=
        return IO(index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Partially decrements `base` by the sum of `digit` and `bit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func decrement(
    _   base: inout Base, by digit: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
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
    _   base: inout Base, by digit: Base.Element, plus bit: inout Bool, at index: inout Base.Index) {
        //=--------------------------------------=
        Swift.assert(index >= base.startIndex)
        Swift.assert(index <  base.endIndex  )
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

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=

    /// Decrements `base` by the sum of `elements` and `bit`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrement(
    _   base: inout Base, by elements: some Sequence<Base.Element>, plus bit: Bool = false) -> IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.decrement(&base, by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        return IO(index: index as Base.Index, overflow: bit as Bool)
    }

    /// Partially decrements `base` by the sum of `elements` and `bit`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrementInIntersection(
    _   base: inout Base, by elements: some Sequence<Base.Element>, plus bit: Bool = false) -> IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex, bit: Bool = bit
        //=--------------------------------------=
        self.decrementInIntersection(&base, by: elements, plus: &bit, at: &index)
        //=--------------------------------------=
        return IO(index: index as Base.Index, overflow: bit as Bool)
    }

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=

    /// Decrements `base` by the sum of `elements` and `bit` at `index`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @inlinable public static func decrement(
    _   base: inout Base, by elements: some Sequence<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
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
    _   base: inout Base, by elements: some Sequence<Base.Element>, plus bit: inout Bool, at index: inout Base.Index) {
        for element in elements {
            self.decrementInIntersection(&base, by: element, plus: &bit, at: &index)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Elements × Digit + Digit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by `elements` times `multiplier` plus `digit`.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrement(
    _ base: inout Base, by elements: some Sequence<Base.Element>, times multiplier: Base.Element,
    plus digit: Base.Element = 0) -> IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex
        //=--------------------------------------=
        let bit = self.decrement(&base, by: elements, times: multiplier, plus: digit, at: &index)
        //=--------------------------------------=
        return IO(index: index as Base.Index, overflow: bit as Bool)
    }
    
    /// Partially decrements `base` by `elements` times `multiplier` plus `digit`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator and its index in `base`.
    ///
    @discardableResult @inlinable public static func decrementInIntersection(
    _ base: inout Base, by elements: some Sequence<Base.Element>, times multiplier: Base.Element,
    plus digit: Base.Element = 0) -> IO<Base.Index> {
        //=--------------------------------------=
        var index: Base.Index = base.startIndex
        //=--------------------------------------=
        let bit = self.decrementInIntersection(&base, by: elements, times: multiplier, plus: digit, at: &index)
        //=--------------------------------------=
        return IO(index: index as Base.Index, overflow: bit as Bool)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Inout
    //=------------------------------------------------------------------------=
    
    /// Decrements `base` by `elements` times `multiplier` plus `digit` at `index`.
    ///
    /// - Returns: An overflow indicator.
    ///
    @discardableResult @inlinable public static func decrement(
    _ base: inout Base, by elements: some Sequence<Base.Element>, times multiplier: Base.Element,
    plus digit: Base.Element, at index: inout Base.Index) -> Bool {
        var bit = self.decrementInIntersection(&base, by: elements, times: multiplier, plus: digit, at: &index)
        self.decrement(&base, by: &bit, at: &index)
        return bit as Bool as Bool as Bool as Bool
    }
    
    /// Partially decrements `base` by `elements` times `multiplier` plus `digit` at `index`.
    ///
    /// - This operation does not continue beyond the operand intersection.
    ///
    /// - Returns: An overflow indicator.
    ///
    @discardableResult @inlinable public static func decrementInIntersection(
    _ base: inout Base, by elements: some Sequence<Base.Element>, times multiplier: Base.Element,
    plus digit: Base.Element, at index: inout Base.Index) -> Bool {
        //=--------------------------------------=
        var last: Base.Element = digit
        //=--------------------------------------=
        for element in elements {
            //  maximum == (high: ~1, low: 1)
            var wide = element.multipliedFullWidth(by: multiplier)
            //  maximum == (high: ~0, low: 0)
            last   = Base.Element(bit: wide.low.addReportingOverflow(last)) &+ wide.high
            //  this cannot overflow because low == 0 when high == ~0
            last &+= Base.Element(bit: self.decrementInIntersection(&base, by: wide.low, at: &index))
        }
        
        return self.decrementInIntersection(&base, by: last, at: &index)
    }
}
