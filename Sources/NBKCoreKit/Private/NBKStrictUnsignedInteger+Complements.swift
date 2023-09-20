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
    
    @inlinable mutating func formOnesComplement() {
        for index in self.storage.indices {
            self.storage[index].formOnesComplement()
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
        
        for index in self.storage.indices {
            carry =  self.storage[index].formTwosComplementSubsequence(carry)
        }
        
        return carry as Bool
    }
}
