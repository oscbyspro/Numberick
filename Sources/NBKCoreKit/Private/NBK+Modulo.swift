//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Modulo x Binary Integer
//*============================================================================*

extension NBK {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns `value` modulo `modulus`.
    @inlinable public static func residue<T>(of value: T, modulo modulus: UInt) -> UInt where T: BinaryInteger {
        //=--------------------------------------=
        if  modulus.isPowerOf2 {
            return value._lowWord & (modulus &- 1)
        }
        //=--------------------------------------=
        let minus = T.isSigned && value < (0 as T)
        var residue = (0 as UInt)
        
        for word in value.magnitude.words.reversed() {
            residue = modulus.dividingFullWidth(HL(residue, word)).remainder
        }
        
        return (minus && !residue.isZero) ? (modulus &- residue) : (residue)
    }
    
    /// Returns `value` modulo `source.bitWidth`.
    ///
    /// - Note: Numberick integers have positive, nonzero, bit widths.
    ///
    @inlinable public static func residue<T>(of value: some BinaryInteger, moduloBitWidthOf source: T.Type) -> Int where T: NBKFixedWidthInteger {
        Int(bitPattern: NBK.residue(of: value, modulo: UInt(bitPattern: T.bitWidth)))
    }
}
