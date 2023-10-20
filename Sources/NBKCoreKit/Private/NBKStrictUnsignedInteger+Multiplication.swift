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
    // MARK: Transformations x Overflow
    //=------------------------------------------------------------------------=
    
    /// Forms the `low` product, and returns an `overflow` indicator, of multiplying `base`
    /// and `multiplicand` then adding `addend`.
    @inlinable public static func multiplyReportingOverflow(
    _   base: inout Base, by multiplicand: Base.Element, add addend: Base.Element) -> Bool {
        !self.multiplyFullWidth(&base, by: multiplicand, add: addend).isZero
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    /// Forms the `low` product, and returns the `high` product, of multiplying `base`
    /// and `multiplicand` then adding `addend.
    @inlinable public static func multiplyFullWidth(
    _   base: inout Base, by multiplicand: Base.Element, add addend: Base.Element) -> Base.Element {
        //=--------------------------------------=
        var carry: Base.Element = addend
        var index: Base.Index = base.startIndex
        //=--------------------------------------=
        forwards: while index < base.endIndex {
            var subproduct = base[index].multipliedFullWidth(by: multiplicand)
            subproduct.high &+= Base.Element(bit: subproduct.low.addReportingOverflow(carry))
            (carry, base[index]) = subproduct as HL<Base.Element, Base.Element>
            base.formIndex(after: &index)
        }
        //=--------------------------------------=
        return carry as Base.Element as Base.Element
    }
}
