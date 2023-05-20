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
        let high = High(bitPattern: bitPattern.high)
        self.init(descending: HL(high, bitPattern.low))
    }
    
    @inlinable public var bitPattern: BitPattern {
        let high = BitPattern.High(bitPattern: self.high)
        return BitPattern(descending: HL(high, self.low))
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
    
    @inlinable public mutating func formTwosComplement() {
        var carry: Bool = true
        for index: Int in self.indices {
            (self[index], carry) = (~self[index]).addingReportingOverflow(UInt(bit: carry))
        }
    }
    
    @inlinable public func twosComplement() -> Self {
        var newValue = self; newValue.formTwosComplement(); return newValue
    }
}
