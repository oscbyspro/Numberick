//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Complements x Sub Sequence
//*============================================================================*

extension NBK.StrictBinaryInteger.SubSequence where Base: MutableCollection {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x One's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public static func formOnesComplement(_ base: inout Base) {
        for index in base.indices {
            base[index].formOnesComplement()
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations x Two's Complement
    //=------------------------------------------------------------------------=
    
    @inlinable public static func formTwosComplement(_ base: inout Base) {
        _ = Unsigned.formTwosComplementReportingOverflow(&base)
    }
}
