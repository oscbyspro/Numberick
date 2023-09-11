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
// MARK: * NBK x Resizable Width x Complements x Unsigned
//*============================================================================*

extension NBKResizableWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x One's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formOnesComplement() {
        for index in self.storage.indices {
            self.storage[index].formOnesComplement()
        }
    }
    
    @inlinable public func onesComplement() -> Self {
        Self(unchecked: Storage(self.storage.lazy.map(~)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formTwosComplementReportingOverflow() -> Bool {
        self.formTwosComplementSubsequence(true)
    }
    
    @inlinable public func twosComplementReportingOverflow() -> PVO<Self> {
        var partialValue = self
        let overflow = partialValue.formTwosComplementReportingOverflow()
        return PVO(partialValue, overflow)
    }
    
    @inlinable public mutating func formTwosComplementSubsequence(_ carry: Bool) -> Bool {
        var carry = carry
        
        for index in self.storage.indices {
            carry =  self.storage[index].formTwosComplementSubsequence(carry)
        }
        
        return carry as Bool
    }
    
    @inlinable public func twosComplementSubsequence(_ carry: Bool) -> PVO<Self> {
        var partialValue = self
        let overflow = partialValue.formTwosComplementSubsequence(carry)
        return PVO(partialValue, overflow)
    }
}
