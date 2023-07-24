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
// MARK: * NBK x Arithmagick x Binary Integer
//*============================================================================*

extension BinaryInteger {
    
    //=------------------------------------------------------------------------=
    // MARK: Transformations
    //=------------------------------------------------------------------------=
    
    /// Returns `self` modulo `other.bitWidth`.
    @inlinable func moduloBitWidth<T>(of other: T.Type) -> Int where T: FixedWidthInteger {
        Int(bitPattern: NBK.residue(of: self, modulo: UInt(bitPattern: T.bitWidth)))
    }
}
