//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKResizableWidthKit

//*============================================================================*
// MARK: * NBK x Flexible Width x Complements x Signed
//*============================================================================*

extension NBKFlexibleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formOnesComplement() {
        self.add(1 as Int, at: Int.zero)
        self.negate()
    }
    
    @inlinable public func onesComplement() -> Self {
        var result = self; result.formOnesComplement(); return result
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formTwosComplementReportingOverflow() -> Bool {
        self.isTwosComplementMinValue || self.negateReportingOverflow()
    }
    
    @inlinable public func twosComplementReportingOverflow() -> PVO<Self> {
        var partialValue = self
        let overflow = partialValue.formTwosComplementReportingOverflow()
        return PVO(partialValue, overflow)
    }
    
    @inlinable public mutating func formTwosComplementSubsequence(_ carry: Bool) -> Bool {
        switch carry {
        case true : return self.formTwosComplementReportingOverflow()
        case false: self.formOnesComplement(); return false as Bool }
    }
    
    @inlinable public func twosComplementSubsequence(_ carry: Bool) -> PVO<Self> {
        var partialValue = self
        let overflow = partialValue.formTwosComplementSubsequence(carry)
        return PVO(partialValue, overflow)
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
    // MARK: Details x One's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formOnesComplement() {
        self.storage.formOnesComplement()
        self.storage.normalize()
    }

    @inlinable public func onesComplement() -> Self {
        Self(storage: self.storage.onesComplement())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formTwosComplementReportingOverflow() -> Bool {
        defer{ self.storage.normalize() }
        return self.storage.formTwosComplementReportingOverflow()
    }
    
    @inlinable public func twosComplementReportingOverflow() -> PVO<Self> {
        var partialValue = self
        let overflow = partialValue.formTwosComplementReportingOverflow()
        return PVO(partialValue, overflow)
    }
    
    @inlinable public mutating func formTwosComplementSubsequence(_ carry: Bool) -> Bool {
        defer{ self.storage.normalize() }
        return self.storage.formTwosComplementSubsequence(carry)
    }
    
    @inlinable public func twosComplementSubsequence(_ carry: Bool) -> PVO<Self> {
        var partialValue = self
        let overflow = partialValue.formTwosComplementSubsequence(carry)
        return PVO(partialValue, overflow)
    }
}
