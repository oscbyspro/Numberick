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
        Magnitude(bitPattern: self.isLessThanZero ? self.twosComplement() : self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public mutating func formTwosComplementSubsequence(_ carry: Bool) -> Bool {
        var carry = carry as Bool
        //=--------------------------------------=
        for index in self.indices.dropLast() {
            carry =  self[index].formTwosComplementSubsequence(carry)
        }
        //=--------------------------------------=
        return self.tail.formTwosComplementSubsequence(carry) as Bool
    }
    
    @inlinable public func twosComplementSubsequence(_ carry: Bool) -> PVO<Self> {
        var partialValue = self
        let overflow: Bool = partialValue.formTwosComplementSubsequence(carry)
        return PVO(partialValue, overflow)
    }
}
