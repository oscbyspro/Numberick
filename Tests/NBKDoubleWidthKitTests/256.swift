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

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Int256
//*============================================================================*

final class Int256Tests: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromX64() {
        XCTAssertEqual(T(x64: X(1, 0, 0, 0)), T(1) <<   0)
        XCTAssertEqual(T(x64: X(0, 1, 0, 0)), T(1) <<  64)
        XCTAssertEqual(T(x64: X(0, 0, 1, 0)), T(1) << 128)
        XCTAssertEqual(T(x64: X(0, 0, 0, 1)), T(1) << 192)
    }
    
    func testFromX32() {
        XCTAssertEqual(T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0)), T(1) <<   0)
        XCTAssertEqual(T(x32: Y(0, 1, 0, 0, 0, 0, 0, 0)), T(1) <<  32)
        XCTAssertEqual(T(x32: Y(0, 0, 1, 0, 0, 0, 0, 0)), T(1) <<  64)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 1, 0, 0, 0, 0)), T(1) <<  96)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 1, 0, 0, 0)), T(1) << 128)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 1, 0, 0)), T(1) << 160)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 0, 1, 0)), T(1) << 192)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 0, 0, 1)), T(1) << 224)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Halves
    //=------------------------------------------------------------------------=
    
    func testHalvesGetSetInit() {
        NBKAssertHalvesGetSetInit(T(x64: X(0, 0, 0, 0)), T.Low(x64:(0, 0)), T.High(x64:(0, 0)))
        NBKAssertHalvesGetSetInit(T(x64: X(1, 2, 0, 0)), T.Low(x64:(1, 2)), T.High(x64:(0, 0)))
        NBKAssertHalvesGetSetInit(T(x64: X(0, 0, 3, 4)), T.Low(x64:(0, 0)), T.High(x64:(3, 4)))
        NBKAssertHalvesGetSetInit(T(x64: X(1, 2, 3, 4)), T.Low(x64:(1, 2)), T.High(x64:(3, 4)))
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
    
    func testFromX64() {
        XCTAssertEqual(T(x64: X(1, 0, 0, 0)), T(1) <<   0)
        XCTAssertEqual(T(x64: X(0, 1, 0, 0)), T(1) <<  64)
        XCTAssertEqual(T(x64: X(0, 0, 1, 0)), T(1) << 128)
        XCTAssertEqual(T(x64: X(0, 0, 0, 1)), T(1) << 192)
    }
    
    func testFromX32() {
        XCTAssertEqual(T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0)), T(1) <<   0)
        XCTAssertEqual(T(x32: Y(0, 1, 0, 0, 0, 0, 0, 0)), T(1) <<  32)
        XCTAssertEqual(T(x32: Y(0, 0, 1, 0, 0, 0, 0, 0)), T(1) <<  64)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 1, 0, 0, 0, 0)), T(1) <<  96)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 1, 0, 0, 0)), T(1) << 128)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 1, 0, 0)), T(1) << 160)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 0, 1, 0)), T(1) << 192)
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 0, 0, 1)), T(1) << 224)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Halves
    //=------------------------------------------------------------------------=
    
    func testHalvesGetSetInit() {
        NBKAssertHalvesGetSetInit(T(x64: X(0, 0, 0, 0)), T.Low(x64:(0, 0)), T.High(x64:(0, 0)))
        NBKAssertHalvesGetSetInit(T(x64: X(1, 2, 0, 0)), T.Low(x64:(1, 2)), T.High(x64:(0, 0)))
        NBKAssertHalvesGetSetInit(T(x64: X(0, 0, 3, 4)), T.Low(x64:(0, 0)), T.High(x64:(3, 4)))
        NBKAssertHalvesGetSetInit(T(x64: X(1, 2, 3, 4)), T.Low(x64:(1, 2)), T.High(x64:(3, 4)))
    }
}

#endif
