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
// MARK: * NBK x Signed x Subtraction
//*============================================================================*

extension NBKSigned {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    @inlinable public static func -=(lhs: inout Self, rhs: Self) {
        if  lhs.sign != rhs.sign {
            lhs.magnitude += rhs.magnitude
        }   else if lhs.magnitude.subtractReportingOverflow(rhs.magnitude) {
            lhs.sign.toggle()
            lhs.magnitude.formTwosComplement()
        }
    }
    
    @inlinable public static func -(lhs: Self, rhs: Self) -> Self {
        var lhs = lhs; lhs -= rhs; return lhs
    }
}
