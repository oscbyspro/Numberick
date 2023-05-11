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
// MARK: * Int256 x Endianness
//*============================================================================*

final class Int256TestsOnEndianness: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let b1 = UInt64(1).bigEndian, l1 = UInt64(1).littleEndian
    let b2 = UInt64(2).bigEndian, l2 = UInt64(2).littleEndian
    let b3 = UInt64(3).bigEndian, l3 = UInt64(3).littleEndian
    let b4 = UInt64(4).bigEndian, l4 = UInt64(4).littleEndian
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBigEndian() {
        XCTAssertEqual(T(x64: X(b4, b3, b2, b1)), T(x64: X(01 ,02, 03, 04)).bigEndian)
        XCTAssertEqual(T(x64: X(01, 02, 03, 04)), T(x64: X(b4, b3, b2, b1)).bigEndian)
        
        XCTAssertEqual(T(x64: X(b4, b3, b2, b1)), T(bigEndian: T(x64: X(01, 02, 03, 04))))
        XCTAssertEqual(T(x64: X(01, 02, 03, 04)), T(bigEndian: T(x64: X(b4, b3, b2, b1))))
    }
    
    func testLittleEndian() {
        XCTAssertEqual(T(x64: X(l1, l2, l3, l4)), T(x64: X(01 ,02, 03, 04)).littleEndian)
        XCTAssertEqual(T(x64: X(01, 02, 03, 04)), T(x64: X(l1, l2, l3, l4)).littleEndian)
        
        XCTAssertEqual(T(x64: X(l1, l2, l3, l4)), T(littleEndian: T(x64: X(01, 02, 03, 04))))
        XCTAssertEqual(T(x64: X(01, 02, 03, 04)), T(littleEndian: T(x64: X(l1, l2, l3, l4))))
    }
}

//*============================================================================*
// MARK: * UInt256 x Endianness
//*============================================================================*

final class UInt256TestsOnEndianness: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let b1 = UInt64(1).bigEndian, l1 = UInt64(1).littleEndian
    let b2 = UInt64(2).bigEndian, l2 = UInt64(2).littleEndian
    let b3 = UInt64(3).bigEndian, l3 = UInt64(3).littleEndian
    let b4 = UInt64(4).bigEndian, l4 = UInt64(4).littleEndian
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testBigEndian() {
        XCTAssertEqual(T(x64: X(b4, b3, b2, b1)), T(x64: X(01 ,02, 03, 04)).bigEndian)
        XCTAssertEqual(T(x64: X(01, 02, 03, 04)), T(x64: X(b4, b3, b2, b1)).bigEndian)
        
        XCTAssertEqual(T(x64: X(b4, b3, b2, b1)), T(bigEndian: T(x64: X(01, 02, 03, 04))))
        XCTAssertEqual(T(x64: X(01, 02, 03, 04)), T(bigEndian: T(x64: X(b4, b3, b2, b1))))
    }
    
    func testLittleEndian() {
        XCTAssertEqual(T(x64: X(l1, l2, l3, l4)), T(x64: X(01 ,02, 03, 04)).littleEndian)
        XCTAssertEqual(T(x64: X(01, 02, 03, 04)), T(x64: X(l1, l2, l3, l4)).littleEndian)
        
        XCTAssertEqual(T(x64: X(l1, l2, l3, l4)), T(littleEndian: T(x64: X(01, 02, 03, 04))))
        XCTAssertEqual(T(x64: X(01, 02, 03, 04)), T(littleEndian: T(x64: X(l1, l2, l3, l4))))
    }
}

#endif
