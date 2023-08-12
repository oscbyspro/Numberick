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
@testable import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Literals x Int256
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Version ≥ iOS 16.4, macOS 13.3
//=----------------------------------------------------------------------------=

/*/SBI*/final class NBKDoubleWidthTestsOnLiteralsAsInt256: XCTestCase {
/*/SBI*/
/*/SBI*/    typealias T = Int256
/*/SBI*/
/*/SBI*/    //=----------------------------------------------------------------=
/*/SBI*/    // MARK: Tests
/*/SBI*/    //=----------------------------------------------------------------=
/*/SBI*/
/*/SBI*/    func testFromIntegerLiteral() {
/*/SBI*/        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)),  0x0000000000000000000000000000000000000000000000000000000000000000)
/*/SBI*/        XCTAssertEqual(T(x64: X(~0,  0,  0,  0)),  0x000000000000000000000000000000000000000000000000ffffffffffffffff)
/*/SBI*/        XCTAssertEqual(T(x64: X(~0, ~0,  0,  0)),  0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff)
/*/SBI*/        XCTAssertEqual(T(x64: X(~0, ~0, ~0,  0)),  0x0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff)
/*/SBI*/        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)), -0x0000000000000000000000000000000000000000000000000000000000000001)
/*/SBI*/        XCTAssertEqual(T(x64: X( 0, ~0, ~0, ~0)), -0x0000000000000000000000000000000000000000000000010000000000000000)
/*/SBI*/        XCTAssertEqual(T(x64: X( 0,  0, ~0, ~0)), -0x0000000000000000000000000000000100000000000000000000000000000000)
/*/SBI*/        XCTAssertEqual(T(x64: X( 0,  0,  0, ~0)), -0x0000000000000001000000000000000000000000000000000000000000000000)
/*/SBI*/
/*/SBI*/        XCTAssertEqual(T(exactlyIntegerLiteral:    0x8000000000000000000000000000000000000000000000000000000000000000),   nil)
/*/SBI*/        XCTAssertEqual(T(exactlyIntegerLiteral:    0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff), T.max)
/*/SBI*/        XCTAssertEqual(T(exactlyIntegerLiteral:   -0x8000000000000000000000000000000000000000000000000000000000000000), T.min)
/*/SBI*/        XCTAssertEqual(T(exactlyIntegerLiteral:   -0x8000000000000000000000000000000000000000000000000000000000000001),   nil)
/*/SBI*/    }
/*/SBI*/}

//=----------------------------------------------------------------------------=
// MARK: + Version < iOS 16.4, macOS 13.3
//=----------------------------------------------------------------------------=

//*SBI*/final class NBKDoubleWidthTestsOnLiteralsAsInt256: XCTestCase {
//*SBI*/
//*SBI*/    typealias T = Int256
//*SBI*/    typealias L = Int256.IntegerLiteralType
//*SBI*/
//*SBI*/    //=----------------------------------------------------------------=
//*SBI*/    // MARK: Tests
//*SBI*/    //=----------------------------------------------------------------=
//*SBI*/
//*SBI*/    func testFromIntegerLiteral() {
//*SBI*/        XCTAssertEqual(T(integerLiteral:  0x7fffffffffffffff as L),  T(x64: X(UInt64(L.max), 0, 0, 0)))
//*SBI*/        XCTAssertEqual(T(integerLiteral:  0x0000000000000000 as L),  T(x64: X(UInt64(L(  )), 0, 0, 0)))
//*SBI*/        XCTAssertEqual(T(integerLiteral: -0x0000000000000001 as L), ~T(x64: X(UInt64(L(  )), 0, 0, 0)))
//*SBI*/        XCTAssertEqual(T(integerLiteral: -0x8000000000000000 as L), ~T(x64: X(UInt64(L.max), 0, 0, 0)))
//*SBI*/    }
//*SBI*/}

//*============================================================================*
// MARK: * NBK x Double Width x Literals x UInt256
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Version ≥ iOS 16.4, macOS 13.3
//=----------------------------------------------------------------------------=

/*/SBI*/final class NBKDoubleWidthTestsOnLiteralsAsUInt256: XCTestCase {
/*/SBI*/
/*/SBI*/    typealias T = UInt256
/*/SBI*/
/*/SBI*/    //=----------------------------------------------------------------=
/*/SBI*/    // MARK: Tests
/*/SBI*/    //=----------------------------------------------------------------=
/*/SBI*/
/*/SBI*/    func testFromIntegerLiteral() {
/*/SBI*/        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)),  0x0000000000000000000000000000000000000000000000000000000000000000)
/*/SBI*/        XCTAssertEqual(T(x64: X(~0,  0,  0,  0)),  0x000000000000000000000000000000000000000000000000ffffffffffffffff)
/*/SBI*/        XCTAssertEqual(T(x64: X(~0, ~0,  0,  0)),  0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff)
/*/SBI*/        XCTAssertEqual(T(x64: X(~0, ~0, ~0,  0)),  0x0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff)
/*/SBI*/        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)),  0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
/*/SBI*/        XCTAssertEqual(T(x64: X( 0, ~0, ~0, ~0)),  0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000)
/*/SBI*/        XCTAssertEqual(T(x64: X( 0,  0, ~0, ~0)),  0xffffffffffffffffffffffffffffffff00000000000000000000000000000000)
/*/SBI*/        XCTAssertEqual(T(x64: X( 0,  0,  0, ~0)),  0xffffffffffffffff000000000000000000000000000000000000000000000000)
/*/SBI*/
/*/SBI*/        XCTAssertEqual(T(exactlyIntegerLiteral:  0x010000000000000000000000000000000000000000000000000000000000000000),   nil)
/*/SBI*/        XCTAssertEqual(T(exactlyIntegerLiteral:  0x00ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff), T.max)
/*/SBI*/        XCTAssertEqual(T(exactlyIntegerLiteral:  0x000000000000000000000000000000000000000000000000000000000000000000), T.min)
/*/SBI*/        XCTAssertEqual(T(exactlyIntegerLiteral: -0x000000000000000000000000000000000000000000000000000000000000000001),   nil)
/*/SBI*/    }
/*/SBI*/}

//=----------------------------------------------------------------------------=
// MARK: + Version < iOS 16.4, macOS 13.3
//=----------------------------------------------------------------------------=

//*SBI*/final class NBKDoubleWidthTestsOnLiteralsAsUInt256: XCTestCase {
//*SBI*/
//*SBI*/    typealias T = UInt256
//*SBI*/    typealias L = UInt256.IntegerLiteralType
//*SBI*/
//*SBI*/    //=----------------------------------------------------------------=
//*SBI*/    // MARK: Tests
//*SBI*/    //=----------------------------------------------------------------=
//*SBI*/
//*SBI*/    func testFromIntegerLiteral() {
//*SBI*/        XCTAssertEqual(T(integerLiteral:  0x7fffffffffffffff as L), T(x64: X(UInt64(L.max), 0, 0, 0)))
//*SBI*/        XCTAssertEqual(T(integerLiteral:  0x0000000000000000 as L), T(x64: X(UInt64(L(  )), 0, 0, 0)))
//*SBI*/        XCTAssertEqual(T(exactly:        -0x0000000000000001 as L), nil)
//*SBI*/        XCTAssertEqual(T(exactly:        -0x8000000000000000 as L), nil)
//*SBI*/    }
//*SBI*/}

#endif
