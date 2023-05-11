//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK256X64

//*============================================================================*
// MARK: * Int256
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
    
    func testInitParts() {
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)), T(ascending:  LH(T.Low (x64:(1, 2)), T.High(x64:(3, 4)))))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)), T(descending: HL(T.High(x64:(3, 4)), T.Low (x64:(1, 2)))))
    }
    
    func testInitConstants() {
        XCTAssertEqual(T.zero, T(x64: X(0, 0, 0, 0      )))
        XCTAssertEqual(T.min,  T(x64: X(0, 0, 0, 1 << 63)))
        XCTAssertEqual(T.max, ~T(x64: X(0, 0, 0, 1 << 63)))
    }
}

//*============================================================================*
// MARK: * UInt256
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
    
    func testInitParts() {
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)), T(ascending:  LH(T.Low (x64:(1, 2)), T.High(x64:(3, 4)))))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)), T(descending: HL(T.High(x64:(3, 4)), T.Low (x64:(1, 2)))))
    }
    
    func testInitConstants() {
        XCTAssertEqual(T.zero, T(x64: X(0, 0, 0, 0)))
        XCTAssertEqual(T.min,  T(x64: X(0, 0, 0, 0)))
        XCTAssertEqual(T.max, ~T(x64: X(0, 0, 0, 0)))
    }
}

#endif
