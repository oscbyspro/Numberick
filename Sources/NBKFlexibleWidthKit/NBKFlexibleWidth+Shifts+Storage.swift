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
// MARK: * NBK x Flexible Width x Shifts x Unsigned x Storage
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Left
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude.Storage {

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=

    @inlinable mutating func bitshiftLeft(words: Int, atLeastOneBit bits: Int) {
        self.elements.withUnsafeMutableBufferPointer {
            NBK.bitshiftLeftAsFixedLimbsCodeBlock(&$0, environment: false, limbs: words, atLeastOneBit: bits)
        }
    }

    @inlinable mutating func bitshiftLeft(atLeastOneWord words: Int) {
        self.elements.withUnsafeMutableBufferPointer {
            NBK.bitshiftLeftAsFixedLimbsCodeBlock(&$0, environment: false, atLeastOneLimb: words)
        }
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Right
//=----------------------------------------------------------------------------=

extension NBKFlexibleWidth.Magnitude.Storage {

    //=------------------------------------------------------------------------=
    // MARK: Transformations x Int
    //=------------------------------------------------------------------------=

    @inlinable mutating func bitshiftRight(words: Int, atLeastOneBit bits: Int) {
        self.elements.withUnsafeMutableBufferPointer {
            NBK.bitshiftRightAsFixedLimbsCodeBlock(&$0, environment: false, limbs: words, atLeastOneBit: bits)
        }
    }
    
    @inlinable mutating func bitshiftRight(atLeastOneWord words: Int) {
        self.elements.withUnsafeMutableBufferPointer {
            NBK.bitshiftRightAsFixedLimbsCodeBlock(&$0, environment: false, atLeastOneLimb: words)
        }
    }
}
