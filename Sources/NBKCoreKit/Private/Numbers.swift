//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Numberx
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Sign & Magnitude
    //=------------------------------------------------------------------------=
    
    @inlinable public static func exactly<T>(sign: FloatingPointSign, magnitude: T.Magnitude) -> T? where T: NBKFixedWidthInteger {
        let isLessThanZero: Bool = (sign == .minus) && !magnitude.isZero
        let value = T(bitPattern: isLessThanZero ? magnitude.twosComplement() : magnitude)
        if  value.isLessThanZero  == isLessThanZero { return value } else { return nil }
    }
}
