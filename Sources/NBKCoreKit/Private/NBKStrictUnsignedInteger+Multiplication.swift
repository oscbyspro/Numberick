//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Multiplication
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Digit + Digit
//=----------------------------------------------------------------------------=

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Forms the low product of multiplying `base` and `multiplicand` then adding `addend`.
    ///
    /// - Returns: An overflow indicator.
    ///
    @inlinable public static func multiplyReportingOverflow(
    _ base: inout Base, by multiplicand: Base.Element, add addend: Base.Element) -> Bool {
        !self.multiplyFullWidth(&base, by: multiplicand, add: addend).isZero
    }
    
    /// Forms the low product of multiplying `base` and `multiplicand` then adding `addend`.
    ///
    /// - Returns: The high product.
    ///
    @inlinable public static func multiplyFullWidth(
    _ base: inout Base, by multiplicand: Base.Element, add addend: Base.Element) -> Base.Element {
        //=--------------------------------------=
        Swift.assert(base.count >= 1 as Int)
        //=--------------------------------------=
        var carry: Base.Element = addend
        
        for index in base.indices {
            var subproduct = base[index].multipliedFullWidth(by: multiplicand)
            subproduct.high &+= Base.Element(bit: subproduct.low.addReportingOverflow(carry))
            (carry, base[index]) = subproduct as HL<Base.Element, Base.Element>
        }
        
        return carry as Base.Element
    }
}
