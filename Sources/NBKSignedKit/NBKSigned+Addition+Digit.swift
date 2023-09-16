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
// MARK: * NBK x Signed x Addition x Digit
//*============================================================================*

extension NBKSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @_disfavoredOverload @inlinable public static func +=(lhs: inout Self, rhs: Digit) {
        if  lhs.sign == rhs.sign {
            lhs.magnitude += rhs.magnitude
        }   else if lhs.magnitude.subtractReportingOverflow(rhs.magnitude) {
            lhs.sign.toggle()
            lhs.magnitude.formTwosComplement()
        }
    }
    
    @_disfavoredOverload @inlinable public static func +(lhs: Self, rhs: Digit) -> Self {
        var lhs = lhs; lhs += rhs; return lhs
    }
}
