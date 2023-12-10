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
    
    func testLimit1E6() {
        let ((sieve)) = T(cache: .KiB(128), wheel: .x11, culls: .x67, capacity: 0000155611)!
        
        while sieve.limit < 0001000000 {
            ((sieve)).increment()
        }
        
        XCTAssertEqual(sieve.limit,          0002097151)
        XCTAssertEqual(sieve.elements.last!, 0002097143)
        XCTAssertEqual(sieve.elements.count, 0000155611)
    }
    
    func testLimit1E7() {
        let ((sieve)) = T(cache: .KiB(128), wheel: .x11, culls: .x67, capacity: 0000694716)!
        
        while sieve.limit < 0010000000 {
            ((sieve)).increment()
        }
        
        XCTAssertEqual(sieve.limit,          0010485759)
        XCTAssertEqual(sieve.elements.last!, 0010485751)
        XCTAssertEqual(sieve.elements.count, 0000694716)
    }
    
    func testLimit1E8() {
        let ((sieve)) = T(cache: .KiB(128), wheel: .x11, culls: .x67, capacity: 0005797406)!
        
        while sieve.limit < 0100000000 {
            ((sieve)).increment()
        }
        
        XCTAssertEqual(sieve.limit,          0100663295)
        XCTAssertEqual(sieve.elements.last!, 0100663291)
        XCTAssertEqual(sieve.elements.count, 0005797406)
    }
    
    func testLimit1E9() {
        let ((sieve)) = T(cache: .KiB(128), wheel: .x11, culls: .x67, capacity: 0050863957)!
        
        while sieve.limit < 1000000000 {
            ((sieve)).increment()
        }
        
        XCTAssertEqual(sieve.limit,          1000341503)
        XCTAssertEqual(sieve.elements.last!, 1000341499)
        XCTAssertEqual(sieve.elements.count, 0050863957)
    }
}

#endif
