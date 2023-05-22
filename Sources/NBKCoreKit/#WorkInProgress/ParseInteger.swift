//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x ???
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=
    
    @inlinable public static func parseUnsignedCoreIntegerDigits<T>(ascii: UnsafeBufferPointer<UInt8>, radix: Int) -> T?
    where T: NBKFixedWidthInteger & NBKUnsignedInteger {
        //=------------------------------------------=
        guard !ascii.isEmpty else { return nil }
        //=------------------------------------------=
        var result: T = 0
        let decoder = AnyRadixAlphabetDecoder(radix: radix)
        let multiplicand = T(truncatingIfNeeded: radix)
        
        for digit in ascii {
            guard let value = decoder.decode(digit) else { return nil }
            let addend = T(truncatingIfNeeded: value)
            
            guard !result.multiplyReportingOverflow(by: multiplicand) else { return nil }
            guard !result.addReportingOverflow(addend)/*-----------*/ else { return nil }
        }
        
        return result
    }
}
