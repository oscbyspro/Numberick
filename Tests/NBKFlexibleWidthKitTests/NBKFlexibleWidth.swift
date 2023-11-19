//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x UIntXL
//*============================================================================*

extension NBKFlexibleWidth.Magnitude {
    
    //=------------------------------------------------------------------------=
    // MARK: Constants
    //=------------------------------------------------------------------------=
    
    static let min256 = Self(x64:[ 0,  0,  0,  0] as X64)
    
    static let max256 = Self(x64:[~0, ~0, ~0, ~0] as X64)
    
    static let basket: [Self] = (-5 ... 5).lazy.map(UInt.init(bitPattern:)).flatMap({[
        Self(words:[$0                           ] as X),
        Self(words:[$0, $0 &+ 1                  ] as X),
        Self(words:[$0, $0 &+ 1, $0 &+ 2         ] as X),
        Self(words:[$0, $0 &+ 1, $0 &+ 2, $0 &+ 3] as X),
    ]})
    
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
