//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Numbers
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Sign & Magnitude
    //=------------------------------------------------------------------------=
    
    @inlinable public static func exactly<T>(sign: Sign, magnitude: T.Magnitude) -> T? where T: NBKFixedWidthInteger {
        var bitPattern = magnitude as T.Magnitude
        var isLessThanZero = (sign == Sign.minus)
        if  isLessThanZero {
            isLessThanZero = !bitPattern.formTwosComplementSubsequence(true)
        }
        
        let value = T(bitPattern: bitPattern)
        return value.isLessThanZero == isLessThanZero ? value : nil
    }
}
