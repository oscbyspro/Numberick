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
// MARK: * NBK x Prime Sieve
//*============================================================================*

final class NBKPrimeSieveBenchmarks: XCTestCase {
    
    typealias T = NBKPrimeSieve
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func test1000X1() {
        for _ in 0 ..< 1000 {
            NBK.blackHole(T(through: 1))
        }
    }    
    
    func test1000X10() {
        for _ in 0 ..< 1000 {
            NBK.blackHole(T(through: 10))
        }
    }
    
    func test1000X100() {
        for _ in 0 ..< 1000 {
            NBK.blackHole(T(through: 100))
        }
    }
    
    func test1000X1000() {
        for _ in 0 ..< 1000 {
            NBK.blackHole(T(through: 1000))
        }
    }
    
    func test1000X10000() {
        for _ in 0 ..< 1000 {
            NBK.blackHole(T(through: 10000))
        }
    }
    
    func test1000X100000() {
        for _ in 0 ..< 1000 {
            NBK.blackHole(T(through: 100000))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x No Loop
    //=------------------------------------------------------------------------=
    
    func testNoLoopFirst1000() {
        XCTAssertEqual(T(first: .thousand).elements.count, 1000)
    }
    
    func testNoLoopFirst1000000() {
        XCTAssertEqual(T(first:  .million).elements.count, 1000000)
    }
    
    func testNoLoop1E6() {
        XCTAssertEqual(T(through: 0001000000).elements.count, 00078498)
    }
    
    func testNoLoop1E7() {
        XCTAssertEqual(T(through: 0010000000).elements.count, 00664579)
    }
    
    func testNoLoop1E8() {
        XCTAssertEqual(T(through: 0100000000).elements.count, 05761455)
    }
    
    func testNoLoop1E9() {
        XCTAssertEqual(T(through: 1000000000).elements.count, 50847534)
    }
}

#endif
