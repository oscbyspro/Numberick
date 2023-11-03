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
// MARK: * NBK x Core Integer x Numbers x Int
//*============================================================================*

final class NBKCoreIntegerBenchmarksOnNumbersAsInt: XCTestCase {
    
    typealias T = Int
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Constants
    //=------------------------------------------------------------------------=
    
    func testZero() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.zero)
        }
    }
    
    func testOne() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.one)
        }
    }
    
    func testMin() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.min)
        }
    }
    
    func testMax() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.max)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Core Integer x Numbers x UInt
//*============================================================================*

final class NBKCoreIntegerBenchmarksOnNumbersAsUInt: XCTestCase {
    
    typealias T = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Constants
    //=------------------------------------------------------------------------=
    
    func testZero() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.zero)
        }
    }
    
    func testOne() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.one)
        }
    }
    
    func testMin() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.min)
        }
    }
    
    func testMax() {
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T.max)
        }
    }
}

#endif
