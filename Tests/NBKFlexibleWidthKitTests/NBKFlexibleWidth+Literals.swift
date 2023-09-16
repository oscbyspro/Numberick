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
@testable import NBKFlexibleWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Literals x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnLiteralsAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromIntegerLiteral() {
        XCTAssertEqual(T(x64:[ 10,  0,  0,  0] as X),    (10))
        XCTAssertEqual(T(x64:[ 02,  0,  0,  0] as X),  (0b10))
        XCTAssertEqual(T(x64:[ 08,  0,  0,  0] as X),  (0o10))
        XCTAssertEqual(T(x64:[ 16,  0,  0,  0] as X),  (0x10))
        #if SBI && swift(>=5.8)
        XCTAssertEqual(T(x64:[  0,  0,  0,  0] as X),  (0x000000000000000000000000000000000000000000000000000000000000000000000000000000))
        XCTAssertEqual(T(x64:[ ~0,  0,  0,  0] as X),  (0x00000000000000000000000000000000000000000000000000000000000000ffffffffffffffff))
        XCTAssertEqual(T(x64:[ ~0, ~0,  0,  0] as X),  (0x0000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffff))
        XCTAssertEqual(T(x64:[ ~0, ~0, ~0,  0] as X),  (0x000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff))
        XCTAssertEqual(T(x64:[ ~0, ~0, ~0, ~0] as X),  (0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff))
        XCTAssertEqual(T(x64:[  0, ~0, ~0, ~0] as X),  (0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000))
        XCTAssertEqual(T(x64:[  0,  0, ~0, ~0] as X),  (0x00000000000000ffffffffffffffffffffffffffffffff00000000000000000000000000000000))
        XCTAssertEqual(T(x64:[  0,  0,  0, ~0] as X),  (0x00000000000000ffffffffffffffff000000000000000000000000000000000000000000000000))
        XCTAssertEqual(T(exactlyIntegerLiteral:       (-0x000000000000000000000000000000000000000000000000000000000000000000000000000001)), nil)
        
        XCTAssertEqual(T(x64:[  0,  0,  0,  0] as X),  (00000000000000000000000000000000000000000000000000000000000000000000000000000000))
        XCTAssertEqual(T(x64:[ ~0,  0,  0,  0] as X),  (00000000000000000000000000000000000000000000000000000000000018446744073709551615))
        XCTAssertEqual(T(x64:[ ~0, ~0,  0,  0] as X),  (00000000000000000000000000000000000000000340282366920938463463374607431768211455))
        XCTAssertEqual(T(x64:[ ~0, ~0, ~0,  0] as X),  (00000000000000000000006277101735386680763835789423207666416102355444464034512895))
        XCTAssertEqual(T(x64:[ ~0, ~0, ~0, ~0] as X),  (00115792089237316195423570985008687907853269984665640564039457584007913129639935))
        XCTAssertEqual(T(x64:[  0, ~0, ~0, ~0] as X),  (00115792089237316195423570985008687907853269984665640564039439137263839420088320))
        XCTAssertEqual(T(x64:[  0,  0, ~0, ~0] as X),  (00115792089237316195423570985008687907852929702298719625575994209400481361428480))
        XCTAssertEqual(T(x64:[  0,  0,  0, ~0] as X),  (00115792089237316195417293883273301227089434195242432897623355228563449095127040))
        XCTAssertEqual(T(exactlyIntegerLiteral:       (-00000000000000000000000000000000000000000000000000000000000000000000000000000001)), nil)
        #else
        XCTAssertEqual(T(integerLiteral: UInt.max), T(x64:[UInt64(UInt.max), 0, 0, 0] as X))
        XCTAssertEqual(T(integerLiteral: UInt.min), T(x64:[UInt64(UInt.min), 0, 0, 0] as X))
        #endif
    }
    
    func testFromStringLiteral() {
        XCTAssertEqual(T(x64:[ 10,  0,  0,  0] as X),    "10")
        XCTAssertEqual(T(x64:[ 02,  0,  0,  0] as X),  "0b10")
        XCTAssertEqual(T(x64:[ 08,  0,  0,  0] as X),  "0o10")
        XCTAssertEqual(T(x64:[ 16,  0,  0,  0] as X),  "0x10")
        
        XCTAssertEqual(T(x64:[  0,  0,  0,  0] as X),  "0x000000000000000000000000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(T(x64:[ ~0,  0,  0,  0] as X),  "0x00000000000000000000000000000000000000000000000000000000000000ffffffffffffffff")
        XCTAssertEqual(T(x64:[ ~0, ~0,  0,  0] as X),  "0x0000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64:[ ~0, ~0, ~0,  0] as X),  "0x000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64:[ ~0, ~0, ~0, ~0] as X),  "0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64:[  0, ~0, ~0, ~0] as X),  "0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000")
        XCTAssertEqual(T(x64:[  0,  0, ~0, ~0] as X),  "0x00000000000000ffffffffffffffffffffffffffffffff00000000000000000000000000000000")
        XCTAssertEqual(T(x64:[  0,  0,  0, ~0] as X),  "0x00000000000000ffffffffffffffff000000000000000000000000000000000000000000000000")
        XCTAssertEqual(T(exactlyStringLiteral:        "-0x000000000000000000000000000000000000000000000000000000000000000000000000000001"), nil)
        
        XCTAssertEqual(T(x64:[  0,  0,  0,  0] as X),  "00000000000000000000000000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(T(x64:[ ~0,  0,  0,  0] as X),  "00000000000000000000000000000000000000000000000000000000000018446744073709551615")
        XCTAssertEqual(T(x64:[ ~0, ~0,  0,  0] as X),  "00000000000000000000000000000000000000000340282366920938463463374607431768211455")
        XCTAssertEqual(T(x64:[ ~0, ~0, ~0,  0] as X),  "00000000000000000000006277101735386680763835789423207666416102355444464034512895")
        XCTAssertEqual(T(x64:[ ~0, ~0, ~0, ~0] as X),  "00115792089237316195423570985008687907853269984665640564039457584007913129639935")
        XCTAssertEqual(T(x64:[  0, ~0, ~0, ~0] as X),  "00115792089237316195423570985008687907853269984665640564039439137263839420088320")
        XCTAssertEqual(T(x64:[  0,  0, ~0, ~0] as X),  "00115792089237316195423570985008687907852929702298719625575994209400481361428480")
        XCTAssertEqual(T(x64:[  0,  0,  0, ~0] as X),  "00115792089237316195417293883273301227089434195242432897623355228563449095127040")
        XCTAssertEqual(T(exactlyStringLiteral:        "-00000000000000000000000000000000000000000000000000000000000000000000000000000001"), nil)
    }
}

#endif
