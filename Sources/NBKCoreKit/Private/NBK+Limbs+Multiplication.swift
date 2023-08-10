//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Limbs x Multiplication x Digit x Unsigned
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    /// Multiplies `limbs` by `multiplicand` and adds `addend`.
    ///
    /// - Note: In the case where `limbs` is empty, the `addend` is returned.
    ///
    @inlinable public static func multiplyFullWidthLenientUnsignedInteger<T>(
    _ limbs: inout T, by multiplicand: T.Element, add addend: T.Element)
    -> T.Element where T: MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        var carry = addend
        
        for index in limbs.indices {
            var subproduct = limbs[index].multipliedFullWidth(by: multiplicand)
            subproduct.high &+= T.Element(bit: subproduct.low.addReportingOverflow(carry))
            (carry, limbs[index]) = subproduct as HL<T.Element, T.Element>
        }
        
        return carry as T.Element
    }
}
