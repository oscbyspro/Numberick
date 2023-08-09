//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit

//*============================================================================*
// MARK: * NBK x Division x Digit
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func formQuotientWithRemainderReportingOverflowAsUnsigned<T>(
    _ limbs: inout T, dividingBy divisor: T.Element) -> PVO<T.Element>
    where T: BidirectionalCollection & MutableCollection, T.Element: NBKFixedWidthInteger & NBKUnsignedInteger {
        //=--------------------------------------=
        if  divisor.isZero {
            return PVO(limbs[limbs.startIndex], true)
        }
        //=--------------------------------------=
        var remainder = T.Element.zero
        
        for index in limbs.indices.reversed() {
            (limbs[index], remainder) = divisor.dividingFullWidth(HL(remainder, limbs[index]))
        }
        
        return PVO(remainder, false)
    }
}
