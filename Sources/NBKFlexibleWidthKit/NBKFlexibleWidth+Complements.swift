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
        if self.magnitude.isZero || !self.compared(to: Int.min, at: self.magnitude.storage.elements.count - 1).isZero { self.negate() }
    }
    
    @inlinable public func twosComplement() -> Self {
        var result = self; result.formTwosComplement(); return result
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
    
    // TODO: update NBKBinaryInteger/twosComplement() documentation
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formTwosComplement() {
        self.storage.formTwosComplement()
        self.storage.normalize()
    }
    
    @inlinable public func twosComplement() -> Self {
        var result = self; result.formTwosComplement(); return result
    }
}
