//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Complements
//*============================================================================*

extension NBK.StrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x One's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public static func formOnesComplement(_ base: inout Base) {
        //=--------------------------------------=
        Swift.assert(base.count >= 1)
        //=--------------------------------------=
        for index in base.indices {
            base[index].formOnesComplement()
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public static func formTwosComplement(_ base: inout Base) {
        _ = self.formTwosComplementSubsequence(&base, carry: true)
    }
    
    @inlinable public static func formTwosComplementReportingOverflow(_ base: inout Base) -> Bool {
        self.formTwosComplementSubsequence(&base, carry: true)
    }
    
    @inlinable public static func formTwosComplementSubsequence(_ base: inout Base, carry: Bool) -> Bool {
        //=--------------------------------------=
        Swift.assert(base.count >= 1 as Int)
        //=--------------------------------------=
        var carry = carry
        
        for index in base.indices {
            carry =  base[index].formTwosComplementSubsequence(carry)
        }
        
        return carry as Bool
    }
}
