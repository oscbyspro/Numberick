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
import NBKFlexibleWidthKit
@testable import NBKSignedKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Signed x Literals x SIntXL
//*============================================================================*

final class NBKSignedTestsOnLiteralsAsSIntXL: XCTestCase {
    
    typealias T = NBKSigned<UIntXL>
    typealias M = NBKSigned<UIntXL>.Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let top256    = T(M(x64:[0xe7e6e5e4e3e2e1e0, 0xefeeedecebeae9e8, 0xf7f6f5f4f3f2f1f0, 0xfffefdfcfbfaf9f8] as X))
    let bottom256 = T(M(x64:[0x0706050403020100, 0x0f0e0d0c0b0a0908, 0x1716151413121110, 0x1f1e1d1c1b1a1918] as X))
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromIntegerLiteral() {
        XCTAssertEqual( T(M(x64:[ 10,  0,  0,  0] as X)),    (10))
        XCTAssertEqual( T(M(x64:[ 02,  0,  0,  0] as X)),  (0b10))
        XCTAssertEqual( T(M(x64:[ 08,  0,  0,  0] as X)),  (0o10))
        XCTAssertEqual( T(M(x64:[ 16,  0,  0,  0] as X)),  (0x10))
        
        XCTAssertEqual( T(integerLiteral: Int.max),  T(M(x64:[UInt64(UInt.max / 2 + 0), 0, 0, 0] as X)))
        XCTAssertEqual( T(integerLiteral: Int.min), -T(M(x64:[UInt64(UInt.max / 2 + 1), 0, 0, 0] as X)))
    }
    
    func testFromStringLiteral() {
        XCTAssertEqual( T(M(x64:[ 10,  0,  0,  0] as X)),    "10")
        XCTAssertEqual( T(M(x64:[ 02,  0,  0,  0] as X)),  "0b10")
        XCTAssertEqual( T(M(x64:[ 08,  0,  0,  0] as X)),  "0o10")
        XCTAssertEqual( T(M(x64:[ 16,  0,  0,  0] as X)),  "0x10")
        XCTAssertEqual(-T(M(x64:[ 10,  0,  0,  0] as X)),   "-10")
        XCTAssertEqual(-T(M(x64:[ 02,  0,  0,  0] as X)), "-0b10")
        XCTAssertEqual(-T(M(x64:[ 08,  0,  0,  0] as X)), "-0o10")
        XCTAssertEqual(-T(M(x64:[ 16,  0,  0,  0] as X)), "-0x10")
        
        XCTAssertEqual(self.top256/*-------*/,   "0x00000000000000fffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0")
        XCTAssertEqual(self.bottom256/*----*/,   "0x000000000000001f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100")
        XCTAssertEqual(T(exactlyStringLiteral:   "0x000000000000010000000000000000000000000000000000000000000000000000000000000000"), T.max256 + 1)
        XCTAssertEqual(T(exactlyStringLiteral:   "0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"), T.max256)
        XCTAssertEqual(T(exactlyStringLiteral:  "-0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"), T.min256)
        XCTAssertEqual(T(exactlyStringLiteral:  "-0x000000000000010000000000000000000000000000000000000000000000000000000000000000"), T.min256 - 1)

        XCTAssertEqual(self.top256/*-------*/,   "00115790308505455567723526024286119531261069242336003260839703036409543150199264")
        XCTAssertEqual(self.bottom256/*----*/,   "00014074904626401341155369551180448584754667373453244490859944217516317499064576")
        XCTAssertEqual(T(exactlyStringLiteral:   "00115792089237316195423570985008687907853269984665640564039457584007913129639936"), T.max256 + 1)
        XCTAssertEqual(T(exactlyStringLiteral:   "00115792089237316195423570985008687907853269984665640564039457584007913129639935"), T.max256)
        XCTAssertEqual(T(exactlyStringLiteral:  "-00115792089237316195423570985008687907853269984665640564039457584007913129639935"), T.min256)
        XCTAssertEqual(T(exactlyStringLiteral:  "-00115792089237316195423570985008687907853269984665640564039457584007913129639936"), T.min256 - 1)
    }
}

#endif
