//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !DEBUG

import XCTest
#if !COCOAPODS
import NBKCoreKit
import NBKDoubleWidthKit
#else
import Numberick
#endif

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Random x Int256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnRandomAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testRandomInRangeUsingSystemRandomNumberGenerator() {
        var range = NBK.blackHoleIdentity((T.min / 2) ... (T.max / 2))
        var randomness = NBK.blackHoleIdentity(SystemRandomNumberGenerator())
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T.random(in:  range, using: &randomness))
            NBK.blackHoleInoutIdentity(&range)
            NBK.blackHoleInoutIdentity(&randomness)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Random x UInt256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnRandomAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testRandomInRangeUsingSystemRandomNumberGenerator() {
        var range = NBK.blackHoleIdentity((T.min / 2) ... (T.max / 2))
        var randomness = NBK.blackHoleIdentity(SystemRandomNumberGenerator())
        
        for _ in 0 ..< 50_000 {
            NBK.blackHole(T.random(in:  range, using: &randomness))
            NBK.blackHoleInoutIdentity(&range)
            NBK.blackHoleInoutIdentity(&randomness)
        }
    }
}

#endif
