//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * NBK x Int256
//*============================================================================*

final class Int256Tests: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitX64() {
        XCTAssertEqual(T(x64: X(1, 0, 0, 0)), T(1) <<   0)
        XCTAssertEqual(T(x64: X(0, 1, 0, 0)), T(1) <<  64)
        XCTAssertEqual(T(x64: X(0, 0, 1, 0)), T(1) << 128)
        XCTAssertEqual(T(x64: X(0, 0, 0, 1)), T(1) << 192)
    }
        
    func testInitZero() {
        XCTAssertEqual(T(   ), T(x64: X(0, 0, 0, 0)))
        XCTAssertEqual(T.zero, T(x64: X(0, 0, 0, 0)))
    }
    
    func testInitEdges() {
        XCTAssertEqual(T.min,  T(x64: X(0, 0, 0, 1 << 63)))
        XCTAssertEqual(T.max, ~T(x64: X(0, 0, 0, 1 << 63)))
    }
    
    func testInitComponents() {
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)), T(ascending:  T(x64: X(1, 2, 3, 4)).ascending ))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)), T(descending: T(x64: X(1, 2, 3, 4)).descending))
        
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)), T(ascending:  LH(T.Low (x64:(1, 2)), T.High(x64:(3, 4)))))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)), T(descending: HL(T.High(x64:(3, 4)), T.Low (x64:(1, 2)))))
    }
}

//*============================================================================*
// MARK: * NBK x UInt256
//*============================================================================*

final class UInt256Tests: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitX64() {
        XCTAssertEqual(T(x64: X(1, 0, 0, 0)), T(1) <<   0)
        XCTAssertEqual(T(x64: X(0, 1, 0, 0)), T(1) <<  64)
        XCTAssertEqual(T(x64: X(0, 0, 1, 0)), T(1) << 128)
        XCTAssertEqual(T(x64: X(0, 0, 0, 1)), T(1) << 192)
    }
    
    func testInitZero() {
        XCTAssertEqual(T(   ), T(x64: X(0, 0, 0, 0)))
        XCTAssertEqual(T.zero, T(x64: X(0, 0, 0, 0)))
    }
    
    func testInitEdges() {
        XCTAssertEqual(T.min,  T(x64: X(0, 0, 0, 0)))
        XCTAssertEqual(T.max, ~T(x64: X(0, 0, 0, 0)))
    }
    
    func testInitComponents() {
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)), T(ascending:  T(x64: X(1, 2, 3, 4)).ascending ))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)), T(descending: T(x64: X(1, 2, 3, 4)).descending))
        
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)), T(ascending:  LH(T.Low (x64:(1, 2)), T.High(x64:(3, 4)))))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)), T(descending: HL(T.High(x64:(3, 4)), T.Low (x64:(1, 2)))))
    }
}

#endif
