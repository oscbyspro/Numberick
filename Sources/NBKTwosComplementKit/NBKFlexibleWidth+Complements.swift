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
// MARK: * NBK x Flexible Width x Complements
//*============================================================================*

extension PrivateIntXLOrUIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x One's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formOnesComplement() {
        self.storage.formOnesComplement()
        
        if !Self.isSigned {
            self.storage.normalize()
        }
    }

    @inlinable public func onesComplement() -> Self {
        Self(normalizing: self.storage.onesComplement())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formTwosComplement() {
        defer{ self.storage.normalize() }
        return self.storage.formTwosComplement()
    }
    
    @inlinable public func twosComplement() -> Self {
        var result = self
        result.formTwosComplement()
        return result as Self
    }
    
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

//*============================================================================*
// MARK: * NBK x Flexible Width x Complements x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Magnitude
    //=------------------------------------------------------------------------=
    
    @inlinable public var magnitude: Magnitude {
        let isLessThanZero = self.isLessThanZero
        var storage = Magnitude.Storage(bitPattern: self.storage)
        if  isLessThanZero {
            storage.formTwosComplement()
        }
        
        return Magnitude(normalizing: storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Additive Inverse
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func negateReportingOverflow() -> Bool {
        let isTwosComplementMinValue = self.storage.formTwosComplementReportingOverflow()
        if  isTwosComplementMinValue {
            self.storage.append(0 as UInt)
        }   else {
            self.storage.normalize()
        }
        
        return false as Bool
    }

    @inlinable public func negatedReportingOverflow() -> PVO<Self> {
        var partialValue = self
        let overflow = partialValue.negateReportingOverflow()
        return PVO(partialValue, overflow)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Complements x Storage
//*============================================================================*

extension PrivateIntXLOrUIntXLStorage {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x One's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func formOnesComplement() {
        for index in self.elements.indices {
            self.elements[index].formOnesComplement()
        }
    }
    
    @inlinable func onesComplement() -> Self {
        Self(unchecked: Elements(self.elements.lazy.map(~)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable mutating func formTwosComplement() {
        _ = self.formTwosComplementSubsequence(true)
    }
    
    @inlinable mutating func formTwosComplementReportingOverflow() -> Bool {
        self.formTwosComplementSubsequence(true)
    }
    
    @inlinable mutating func formTwosComplementSubsequence(_ carry: Bool) -> Bool {
        var carry = carry
        
        for index in self.elements.indices.dropLast() {
            carry =  self.elements[index].formTwosComplementSubsequence(carry)
        }
        
        return self.tail.formTwosComplementSubsequence(carry)
    }
}
