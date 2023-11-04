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
// MARK: * NBK x Sign
//*============================================================================*

final class NBKTestsOnSign: XCTestCase {
    
    typealias T = FloatingPointSign
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testASCII() {
        XCTAssertEqual(NBK.ascii(T.plus ), UInt8(ascii: "+"))
        XCTAssertEqual(NBK.ascii(T.minus), UInt8(ascii: "-"))
    }
    
    func testBit() {
        XCTAssertEqual(NBK.bit(T.plus ), false)
        XCTAssertEqual(NBK.bit(T.minus), true )
    }
    
    func testSign() {
        XCTAssertEqual(NBK.sign(false), T.plus )
        XCTAssertEqual(NBK.sign(true ), T.minus)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testNot() {
        XCTAssertEqual(NBK.not(T.plus ), T.minus)
        XCTAssertEqual(NBK.not(T.minus), T.plus )
    }
    
    func testAnd() {
        XCTAssertEqual(NBK.and(T.plus,  T.plus ), T.plus )
        XCTAssertEqual(NBK.and(T.plus,  T.minus), T.plus )
        XCTAssertEqual(NBK.and(T.minus, T.plus ), T.plus )
        XCTAssertEqual(NBK.and(T.minus, T.minus), T.minus)
    }
    
    func testOr() {
        XCTAssertEqual(NBK.or (T.plus,  T.plus ), T.plus )
        XCTAssertEqual(NBK.or (T.plus,  T.minus), T.minus)
        XCTAssertEqual(NBK.or (T.minus, T.plus ), T.minus)
        XCTAssertEqual(NBK.or (T.minus, T.minus), T.minus)
    }
    
    func testXor() {
        XCTAssertEqual(NBK.xor(T.plus,  T.plus ), T.plus )
        XCTAssertEqual(NBK.xor(T.plus,  T.minus), T.minus)
        XCTAssertEqual(NBK.xor(T.minus, T.plus ), T.minus)
        XCTAssertEqual(NBK.xor(T.minus, T.minus), T.plus )
    }
}

#endif
