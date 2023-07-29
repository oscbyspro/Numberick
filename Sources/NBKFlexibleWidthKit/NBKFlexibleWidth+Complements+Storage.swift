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
// MARK: * NBK x Flexible Width x Complements x Unsigned x Storage
//*============================================================================*

extension NBKFlexibleWidth.Magnitude.Storage {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formTwosComplement() {
        _ = self.formTwosComplementSubsequence(true)
    }
    
    @inlinable public mutating func formTwosComplementSubsequence(_ carry: Bool) -> Bool {
        var carry = carry
        
        for index in self.elements.indices {
            carry = self.elements[index].formTwosComplementSubsequence(carry)
        }
        
        return carry as Bool
    }
}
