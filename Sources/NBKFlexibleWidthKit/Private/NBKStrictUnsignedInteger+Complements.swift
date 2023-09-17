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
// MARK: * NBK x Strict Unsigned Integer x Complements
//*============================================================================*

extension NBKStrictUnsignedInteger where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x One's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func formOnesComplement() {
        for index in self.base.indices {
            self.base[index].formOnesComplement()
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func formTwosComplement() {
        _ = self.formTwosComplementSubsequence(true)
    }
    
    @inlinable mutating func formTwosComplementReportingOverflow() -> Bool {
        self.formTwosComplementSubsequence(true)
    }
    
    @inlinable mutating func formTwosComplementSubsequence(_ carry: Bool) -> Bool {
        var carry = carry
        
        for index in self.base.indices {
            carry =  self.base[index].formTwosComplementSubsequence(carry)
        }
        
        return carry as Bool
    }
}
