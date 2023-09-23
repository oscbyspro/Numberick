//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Complements x Sub Sequence
//*============================================================================*

extension NBK.StrictUnsignedInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public static func formTwosComplementReportingOverflow(_ base: inout Base) -> Bool {
        self.formTwosComplementSubsequence(&base, carry: true)
    }
    
    @inlinable public static func formTwosComplementSubsequence(_ base: inout Base, carry: Bool) -> Bool {
        var carry = carry
        
        for index in base.indices {
            carry =  base[index].formTwosComplementSubsequence(carry)
        }
        
        return carry as Bool
    }
}
