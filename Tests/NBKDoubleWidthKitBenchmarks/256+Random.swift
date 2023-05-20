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
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * NBK x Int256 x Random
//*============================================================================*

final class Int256BenchmarksOnRandom: XCTestCase {
    
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
// MARK: * NBK x UInt256 x Random
//*============================================================================*

final class UInt256BenchmarksOnRandom: XCTestCase {
    
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
