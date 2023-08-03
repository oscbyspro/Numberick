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
// MARK: * NBK x Bits
//*============================================================================*

final class BitsBenchmarks: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testsNonzeroBitCount() {
        var abc = NBK.blackHoleIdentity([0, 1, 2, 3, 4, 5, 6, 7, 8, 9] as [UInt64])
                
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.nonzeroBitCount(of: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testNonzeroBitCountEquals() {
        var abc = NBK.blackHoleIdentity([0, 1, 2, 3, 4, 5, 6, 7, 8, 9] as [UInt64])

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.nonzeroBitCount(of: abc, equals: 1))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
}

#endif
