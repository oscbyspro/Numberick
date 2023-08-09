//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Multiplication x Digit x Unsigned
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Full Width
    //=------------------------------------------------------------------------=
    
    /// Multiplies `limbs` by `multiplicand` and adds `addend`.
    @inlinable public static func multiplyFullWidthAsUnsigned<Limb>(
    _ limbs: inout some MutableCollection<Limb>, by multiplicand: Limb, add addend: Limb)
    -> Limb where Limb: NBKFixedWidthInteger & NBKUnsignedInteger {
        var carry = addend
        
        for index in limbs.indices {
            var subproduct = limbs[index].multipliedFullWidth(by: multiplicand)
            subproduct.high &+= Limb(bit: subproduct.low.addReportingOverflow(carry))
            (carry, limbs[index]) = subproduct as HL<Limb, Limb>
        }
        
        return carry as Limb
    }
}
