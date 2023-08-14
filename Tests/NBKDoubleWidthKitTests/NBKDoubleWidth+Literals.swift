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
#if swift(>=5.8) && SBI

final class NBKDoubleWidthTestsOnLiteralsAsInt256: XCTestCase {

    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testFromIntegerLiteral() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)),  0x0000000000000000000000000000000000000000000000000000000000000000)
        XCTAssertEqual(T(x64: X(~0,  0,  0,  0)),  0x000000000000000000000000000000000000000000000000ffffffffffffffff)
        XCTAssertEqual(T(x64: X(~0, ~0,  0,  0)),  0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0,  0)),  0x0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)), -0x0000000000000000000000000000000000000000000000000000000000000001)
        XCTAssertEqual(T(x64: X( 0, ~0, ~0, ~0)), -0x0000000000000000000000000000000000000000000000010000000000000000)
        XCTAssertEqual(T(x64: X( 0,  0, ~0, ~0)), -0x0000000000000000000000000000000100000000000000000000000000000000)
        XCTAssertEqual(T(x64: X( 0,  0,  0, ~0)), -0x0000000000000001000000000000000000000000000000000000000000000000)

        XCTAssertEqual(T(exactlyIntegerLiteral:    0x8000000000000000000000000000000000000000000000000000000000000000),   nil)
        XCTAssertEqual(T(exactlyIntegerLiteral:    0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff), T.max)
        XCTAssertEqual(T(exactlyIntegerLiteral:   -0x8000000000000000000000000000000000000000000000000000000000000000), T.min)
        XCTAssertEqual(T(exactlyIntegerLiteral:   -0x8000000000000000000000000000000000000000000000000000000000000001),   nil)
    }
}

#else
//=----------------------------------------------------------------------------=
// MARK: + Version < iOS 16.4, macOS 13.3
//=----------------------------------------------------------------------------=

final class NBKDoubleWidthTestsOnLiteralsAsInt256: XCTestCase {

    typealias T = Int256
    typealias L = Int256.IntegerLiteralType

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testFromIntegerLiteral() {
        XCTAssertEqual(T(integerLiteral:  0x7fffffffffffffff as L),  T(x64: X(UInt64(L.max), 0, 0, 0)))
        XCTAssertEqual(T(integerLiteral:  0x0000000000000000 as L),  T(x64: X(UInt64(L(  )), 0, 0, 0)))
        XCTAssertEqual(T(integerLiteral: -0x0000000000000001 as L), ~T(x64: X(UInt64(L(  )), 0, 0, 0)))
        XCTAssertEqual(T(integerLiteral: -0x8000000000000000 as L), ~T(x64: X(UInt64(L.max), 0, 0, 0)))
    }
}

#endif
//*============================================================================*
// MARK: * NBK x Double Width x Literals x UInt256
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Version ≥ iOS 16.4, macOS 13.3
//=----------------------------------------------------------------------------=
#if swift(>=5.8) && SBI

final class NBKDoubleWidthTestsOnLiteralsAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromIntegerLiteral() {
        XCTAssertEqual(T(x64: X( 0,  0,  0,  0)),  0x0000000000000000000000000000000000000000000000000000000000000000)
        XCTAssertEqual(T(x64: X(~0,  0,  0,  0)),  0x000000000000000000000000000000000000000000000000ffffffffffffffff)
        XCTAssertEqual(T(x64: X(~0, ~0,  0,  0)),  0x00000000000000000000000000000000ffffffffffffffffffffffffffffffff)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0,  0)),  0x0000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff)
        XCTAssertEqual(T(x64: X(~0, ~0, ~0, ~0)),  0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
        XCTAssertEqual(T(x64: X( 0, ~0, ~0, ~0)),  0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000)
        XCTAssertEqual(T(x64: X( 0,  0, ~0, ~0)),  0xffffffffffffffffffffffffffffffff00000000000000000000000000000000)
        XCTAssertEqual(T(x64: X( 0,  0,  0, ~0)),  0xffffffffffffffff000000000000000000000000000000000000000000000000)
        
        XCTAssertEqual(T(exactlyIntegerLiteral:  0x010000000000000000000000000000000000000000000000000000000000000000),   nil)
        XCTAssertEqual(T(exactlyIntegerLiteral:  0x00ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff), T.max)
        XCTAssertEqual(T(exactlyIntegerLiteral:  0x000000000000000000000000000000000000000000000000000000000000000000), T.min)
        XCTAssertEqual(T(exactlyIntegerLiteral: -0x000000000000000000000000000000000000000000000000000000000000000001),   nil)
    }
}

#else
//=----------------------------------------------------------------------------=
// MARK: + Version < iOS 16.4, macOS 13.3
//=----------------------------------------------------------------------------=

final class NBKDoubleWidthTestsOnLiteralsAsUInt256: XCTestCase {
    
    typealias T = UInt256
    typealias L = UInt256.IntegerLiteralType
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromIntegerLiteral() {
        XCTAssertEqual(T(integerLiteral:  0x7fffffffffffffff as L), T(x64: X(UInt64(L.max), 0, 0, 0)))
        XCTAssertEqual(T(integerLiteral:  0x0000000000000000 as L), T(x64: X(UInt64(L(  )), 0, 0, 0)))
        XCTAssertEqual(T(exactly:        -0x0000000000000001 as L), nil)
        XCTAssertEqual(T(exactly:        -0x8000000000000000 as L), nil)
    }
}

#endif
#endif
