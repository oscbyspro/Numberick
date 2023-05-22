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
// MARK: * NBK x Text x UInt
//*============================================================================*

extension UInt {
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Text
    //=------------------------------------------------------------------------=
    
    @inlinable internal init?(digits: UnsafeBufferPointer<UInt8>, radix: Int) {
        guard !digits.isEmpty else { return nil }
        //=------------------------------------------=
        let multiplier =/**/Self(truncatingIfNeeded: radix)
        let decoder = AnyRadixAlphabetDecoder(radix: radix)
        //=------------------------------------------=
        self.init()
        
        for digit in digits {
            guard let value = decoder.decode(digit)/*----------------------*/ else { return nil }
            guard !self.multiplyReportingOverflow(by: multiplier)/*--------*/ else { return nil }
            guard !self.addReportingOverflow(Self(truncatingIfNeeded: value)) else { return nil }
        }
    }
}

