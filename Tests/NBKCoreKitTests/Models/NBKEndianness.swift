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
import XCTest

//*============================================================================*
// MARK: * NBK x Endianness
//*============================================================================*

final class NBKEndiannessTests: XCTestCase {
    
    typealias T = NBKEndianness
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSystemValue() {
        #if  _endian(little)
        XCTAssertEqual(T.system, T.little)
        #elseif _endian(big)
        XCTAssertEqual(T.system, T.big)
        #endif
    }
    
    func testOppositeValue() {
        XCTAssertEqual(!T.big, T.little)
        XCTAssertEqual(!T.little, T.big)
    }
    
    func testToRawValue() {
        XCTAssertEqual(0x00 as UInt8, T.little.rawValue)
        XCTAssertEqual(0x01 as UInt8, T.big.rawValue)
    }
    
    func testFromRawValue() {
        XCTAssertEqual(T(rawValue: 0x00 as UInt8), T.little)
        XCTAssertEqual(T(rawValue: 0x01 as UInt8), T.big)
        XCTAssertEqual(T(rawValue: 0x02 as UInt8), nil)
    }
}

#endif
