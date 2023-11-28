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
    // MARK: Tests x No Loop x Min Count
    //=------------------------------------------------------------------------=
    
    func testNoLoopMinCount1E0() {
        let count = NBK.blackHoleIdentity(1)
        XCTAssertEqual(T(minCount: count).elements[count - 1], 2)
    }
    
    func testNoLoopMinCount1E1() {
        let count = NBK.blackHoleIdentity(10)
        XCTAssertEqual(T(minCount: count).elements[count - 1], 29)
    }
    
    func testNoLoopMinCount1E2() {
        let count = NBK.blackHoleIdentity(100)
        XCTAssertEqual(T(minCount: count).elements[count - 1], 541)
    }
    
    func testNoLoopMinCount1E3() {
        let count = NBK.blackHoleIdentity(1_000)
        XCTAssertEqual(T(minCount: count).elements[count - 1], 7919)
    }
    
    func testNoLoopMinCount1E4() {
        let count = NBK.blackHoleIdentity(10_000)
        XCTAssertEqual(T(minCount: count).elements[count - 1], 104729)
    }
    
    func testNoLoopMinCount1E5() {
        let count = NBK.blackHoleIdentity(100_000)
        XCTAssertEqual(T(minCount: count).elements[count - 1], 1299709)
    }
    
    func testNoLoopMinCount1E6() {
        let count = NBK.blackHoleIdentity(1_000_000)
        XCTAssertEqual(T(minCount: count).elements[count - 1], 15485863)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x No Loop x Through
    //=------------------------------------------------------------------------=
    
    func testNoLoop1E6() {
        XCTAssertGreaterThanOrEqual(T(through: 0001000000).elements.count, 00078498)
    }
    
    func testNoLoop1E7() {
        XCTAssertGreaterThanOrEqual(T(through: 0010000000).elements.count, 00664579)
    }
    
    func testNoLoop1E8() {
        XCTAssertGreaterThanOrEqual(T(through: 0100000000).elements.count, 05761455)
    }
    
    func testNoLoop1E9() {
        XCTAssertGreaterThanOrEqual(T(through: 1000000000).elements.count, 50847534)
    }
}

#endif
