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
        Self.normalize(&self.storage)
    }

    @inlinable public func onesComplement() -> Self {
        Self(normalizing: self.storage.onesComplement())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formTwosComplement() {
        defer{ Self.normalize(&self.storage) }
        return self.storage.formTwosComplement()
    }
    
    @inlinable public func twosComplement() -> Self {
        var result = self
        result.formTwosComplement()
        return result as Self
    }
    
    @inlinable public mutating func formTwosComplementReportingOverflow() -> Bool {
        defer{ Self.normalize(&self.storage) }
        return self.storage.formTwosComplementReportingOverflow(as: Digit.self)
    }
    
    @inlinable public func twosComplementReportingOverflow() -> PVO<Self> {
        var partialValue = self
        let overflow = partialValue.formTwosComplementReportingOverflow()
        return PVO(partialValue, overflow)
    }
    
    @inlinable public mutating func formTwosComplementSubsequence(_ carry: Bool) -> Bool {
        defer{ Self.normalize(&self.storage) }
        return self.storage.formTwosComplementSubsequence(carry, as: Digit.self)
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
        var storage = self.storage
        if  isLessThanZero {
            storage.formTwosComplement()
        }
        
        Magnitude.normalize(&storage)
        return Magnitude(unchecked: storage)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Additive Inverse
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func negateReportingOverflow() -> Bool {
        self.formTwosComplement(); return false
    }

    @inlinable public func negatedReportingOverflow() -> PVO<Self> {
        PVO(self.twosComplement(), false)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Complements x Storage
//*============================================================================*

extension StorageXL {
    
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
        _ = self.formTwosComplementSubsequence(true, as: UInt.self)
    }
    
    @inlinable mutating func formTwosComplementReportingOverflow<T>(as digit: T.Type) -> Bool where T: NBKCoreInteger<UInt> {
        self.formTwosComplementSubsequence(true, as: T.self)
    }
    
    @inlinable mutating func formTwosComplementSubsequence<T>(_ carry: Bool, as digit: T.Type) -> Bool where T: NBKCoreInteger<UInt> {
        var carry = carry
        let lastIndex = self.elements.index(before: self.elements.endIndex)
        
        for index in self.elements.startIndex ..< lastIndex {
            carry =  self.elements[index].formTwosComplementSubsequence(carry)
        }
        
        return self[lastIndex,as: T.self].formTwosComplementSubsequence(carry)
    }
}
