//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Tuple Integer x Complements x Unsigned
//*============================================================================*

extension NBK.TupleInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns the `magnitude` of the given `value`.
    ///
    /// ```
    /// ┌─────────────────── → ───────────────────┐
    /// │ value              │ magnitude          │
    /// ├─────────────────── → ───────────────────┤
    /// │ Int(~1), UInt(~1)  │ UInt( 1), UInt( 2) │
    /// │ Int(~0), UInt( 0)  │ UInt( 1), UInt( 0) │
    /// │ Int( 0), UInt( 0)  │ UInt( 0), UInt( 0) │
    /// │ Int( 1), UInt( 0)  │ UInt( 1), UInt( 0) │
    /// │ Int( 1), UInt( 2)  │ UInt( 1), UInt( 2) │
    /// └─────────────────── → ───────────────────┘
    /// ```
    ///
    @_transparent public static func magnitude(of value: Wide2) -> Magnitude.Wide2 {
        var value = value as Wide2
        if  value.high.isLessThanZero {
            var carry = true
            carry = value.low .formTwosComplementSubsequence(carry)
            carry = value.high.formTwosComplementSubsequence(carry)
        }
        
        return NBK.bitCast(value) as Magnitude.Wide2
    }
}
