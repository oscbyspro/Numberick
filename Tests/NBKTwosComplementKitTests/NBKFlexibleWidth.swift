//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKTwosComplementKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x IntXL
//*============================================================================*

extension IntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    static let min256 = Self(x64:[ 0,  0,  0, ~0/2 + 1] as X)
    static let max256 = Self(x64:[~0, ~0, ~0, ~0/2 + 0] as X)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(x32: [UInt32]) {
        self.init(words: NBKChunkedInt(x32))
    }
    
    init(x64: [UInt64]) {
        self.init(words: NBKChunkedInt(x64))
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x UIntXL
//*============================================================================*

extension UIntXL {
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    static let min256 = Self(x64:[ 0,  0,  0,  0] as X)
    static let max256 = Self(x64:[~0, ~0, ~0, ~0] as X)
    
    //=------------------------------------------------------------------------=
    // MARK: Initializers
    //=------------------------------------------------------------------------=
    
    init(x32: [UInt32]) {
        self.init(words: NBKChunkedInt(x32))
    }
    
    init(x64: [UInt64]) {
        self.init(words: NBKChunkedInt(x64))
    }
}
