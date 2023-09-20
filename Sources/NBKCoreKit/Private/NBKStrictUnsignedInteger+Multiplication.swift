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
    @inlinable public mutating func multiplyReportingOverflow(
    by  multiplicand: Base.Element, add addend: Base.Element) -> Bool {
        !self.multiplyFullWidth(by: multiplicand, add: addend).isZero        
    }
    
    /// Forms the low product of multiplying `base` and `multiplicand` then adding `addend`.
    ///
    /// - Returns: The high product.
    ///
    @inlinable public mutating func multiplyFullWidth(
    by  multiplicand: Base.Element, add addend: Base.Element) -> Base.Element {
        Self.multiplyFullWidthCodeBlock(&self.storage, by: multiplicand, add: addend)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Algorithms (pointerless performance)
    //=------------------------------------------------------------------------=
    
    /// Forms the low product of multiplying `base` and `multiplicand` then adding `addend`.
    ///
    /// - Returns: The high product.
    ///
    @inlinable public static func multiplyFullWidthCodeBlock(
    _ base: inout Base, by multiplicand: Base.Element, add addend: Base.Element) -> Base.Element {
        //=--------------------------------------=
        Swift.assert(!base.isEmpty)
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
