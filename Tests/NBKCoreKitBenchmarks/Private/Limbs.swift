//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !DEBUG

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Limbs
//*============================================================================*

final class LimbsBenchmarks: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt64AsUInt32() {
        var abc = NBK.blackHoleIdentity([~1, ~2, ~3, ~4] as [UInt64])
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(NBK.limbs(abc, as: [UInt32].self))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testUInt32AsUInt64() {
        var abc = NBK.blackHoleIdentity([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as [UInt32])
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(NBK.limbs(abc, as: [UInt64].self))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
}

#endif
