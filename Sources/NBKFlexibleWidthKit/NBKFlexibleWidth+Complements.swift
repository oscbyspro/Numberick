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
// MARK: * NBK x Flexible Width x Complements x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formTwosComplement() {
        fatalError("TODO")
    }
    
    @inlinable public func twosComplement() -> Self {
        fatalError("TODO")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Additive Inverse
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func negateReportingOverflow() -> Bool {
        self.sign.toggle()
        return false as Bool
    }
    
    @inlinable public func negatedReportingOverflow() -> PVO<Self> {
        var partialValue = self
        let overflow = partialValue.negateReportingOverflow()
        return PVO(partialValue, overflow)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Complements x Unsigned
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    #warning("tests")
    @inlinable public mutating func formTwosComplement() {
        self.storage.formTwosComplement()
        self.storage.normalize()
    }
    
    #warning("tests")
    @inlinable public func twosComplement() -> Self {
        var result = self; result.formTwosComplement(); return result
    }
}
