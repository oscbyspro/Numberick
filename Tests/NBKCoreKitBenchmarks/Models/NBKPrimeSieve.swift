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
        let ((sieve)) = T(size: .KiB(128))
        
        while sieve.limit < 1000000 {
            ((sieve)).increment()
        }
                
        XCTAssertEqual(sieve.limit,          2097151)
        XCTAssertEqual(sieve.elements.last!, 2097143)
        XCTAssertEqual(sieve.elements.count, 0155611)
    }
    
    func testLimit1E7() {
        let ((sieve)) = T(size: .KiB(128))
        
        while sieve.limit < 10000000 {
            ((sieve)).increment()
        }
        
        XCTAssertEqual(sieve.limit,          10485759)
        XCTAssertEqual(sieve.elements.last!, 10485751)
        XCTAssertEqual(sieve.elements.count, 00694716)
    }
    
    func testLimit1E8() {
        let ((sieve)) = T(size: .KiB(128))
        
        while sieve.limit < 100000000 {
            ((sieve)).increment()
        }
        
        XCTAssertEqual(sieve.limit,          100663295)
        XCTAssertEqual(sieve.elements.last!, 100663291)
        XCTAssertEqual(sieve.elements.count, 005797406)
    }
    
    func testLimit1E9() {
        let ((sieve)) = T(size: .KiB(128))
        
        while sieve.limit < 1000000000 {
            ((sieve)).increment()
        }
        
        XCTAssertEqual(sieve.limit,          1000341503)
        XCTAssertEqual(sieve.elements.last!, 1000341499)
        XCTAssertEqual(sieve.elements.count, 0050863957)
    }
}

#endif
