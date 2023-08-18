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
// MARK: * NBK x Double Width x Complements
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
extension NBKDoubleWidth {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Bit Pattern
    //=------------------------------------------------------------------------=
    
    @inlinable public init(bitPattern: BitPattern) {
        self = Swift.unsafeBitCast(bitPattern, to: Self.self)
    }
    
    @inlinable public var bitPattern: BitPattern {
        Swift.unsafeBitCast(self, to: BitPattern.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Magnitude
    //=------------------------------------------------------------------------=
    
    @inlinable public var magnitude: Magnitude {
        var value = self
        if  value.isLessThanZero {
            value.formTwosComplement()
        }
        
        return Magnitude(bitPattern: value)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x One's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formOnesComplement() {
        self.low .formOnesComplement()
        self.high.formOnesComplement()
    }
    
    @inlinable public func onesComplement() -> Self {
        Self(high: ~self.high, low: ~self.low)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formTwosComplementReportingOverflow() -> Bool {
        self.formTwosComplementSubsequence(true)
    }
    
    @inlinable public func twosComplementReportingOverflow() -> PVO<Self> {
        self.twosComplementSubsequence(true)
    }
    
    @inlinable public mutating func formTwosComplementSubsequence(_ carry: Bool) -> Bool {
        let carry = self.low .formTwosComplementSubsequence(carry)
        return /**/ self.high.formTwosComplementSubsequence(carry)
    }
    
    @inlinable public func twosComplementSubsequence(_ carry: Bool) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.formTwosComplementSubsequence(carry)
        return PVO(partialValue, overflow)
    }
}
