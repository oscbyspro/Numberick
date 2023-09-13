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

final class NBKDoubleWidthTestsOnLiteralsAsInt256: XCTestCase {

    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testFromIntegerLiteral() {
        XCTAssertEqual(T(x64: X( 10,  0,  0,  0)),    (10))
        XCTAssertEqual(T(x64: X( 02,  0,  0,  0)),  (0b10))
        XCTAssertEqual(T(x64: X( 08,  0,  0,  0)),  (0o10))
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)),  (0x10))
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)),  (0x10))
        XCTAssertEqual(T(x64: X( ~9, ~0, ~0, ~0)),   (-10))
        XCTAssertEqual(T(x64: X( ~1, ~0, ~0, ~0)), (-0b10))
        XCTAssertEqual(T(x64: X( ~7, ~0, ~0, ~0)), (-0o10))
        XCTAssertEqual(T(x64: X(~15, ~0, ~0, ~0)), (-0x10))
        #if SBI && swift(>=5.8)
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),  (0x000000000000000000000000000000000000000000000000000000000000000000000000000000))
        XCTAssertEqual(T(x64: X( ~0,  0,  0,  0)),  (0x00000000000000000000000000000000000000000000000000000000000000ffffffffffffffff))
        XCTAssertEqual(T(x64: X( ~0, ~0,  0,  0)),  (0x0000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffff))
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0,  0)),  (0x000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff))
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0, ~0)), (-0x000000000000000000000000000000000000000000000000000000000000000000000000000001))
        XCTAssertEqual(T(x64: X(  0, ~0, ~0, ~0)), (-0x000000000000000000000000000000000000000000000000000000000000010000000000000000))
        XCTAssertEqual(T(x64: X(  0,  0, ~0, ~0)), (-0x000000000000000000000000000000000000000000000100000000000000000000000000000000))
        XCTAssertEqual(T(x64: X(  0,  0,  0, ~0)), (-0x000000000000000000000000000001000000000000000000000000000000000000000000000000))
        
        XCTAssertEqual(T(exactlyIntegerLiteral:     (0x000000000000008000000000000000000000000000000000000000000000000000000000000000)),   nil)
        XCTAssertEqual(T(exactlyIntegerLiteral:     (0x000000000000007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)), T.max)
        XCTAssertEqual(T(exactlyIntegerLiteral:    (-0x000000000000008000000000000000000000000000000000000000000000000000000000000000)), T.min)
        XCTAssertEqual(T(exactlyIntegerLiteral:    (-0x000000000000008000000000000000000000000000000000000000000000000000000000000001)),   nil)
        
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),  (00000000000000000000000000000000000000000000000000000000000000000000000000000000))
        XCTAssertEqual(T(x64: X( ~0,  0,  0,  0)),  (00000000000000000000000000000000000000000000000000000000000018446744073709551615))
        XCTAssertEqual(T(x64: X( ~0, ~0,  0,  0)),  (00000000000000000000000000000000000000000340282366920938463463374607431768211455))
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0,  0)),  (00000000000000000000006277101735386680763835789423207666416102355444464034512895))
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0, ~0)), (-00000000000000000000000000000000000000000000000000000000000000000000000000000001))
        XCTAssertEqual(T(x64: X(  0, ~0, ~0, ~0)), (-00000000000000000000000000000000000000000000000000000000000018446744073709551616))
        XCTAssertEqual(T(x64: X(  0,  0, ~0, ~0)), (-00000000000000000000000000000000000000000340282366920938463463374607431768211456))
        XCTAssertEqual(T(x64: X(  0,  0,  0, ~0)), (-00000000000000000000006277101735386680763835789423207666416102355444464034512896))
        
        XCTAssertEqual(T(exactlyIntegerLiteral:     (00057896044618658097711785492504343953926634992332820282019728792003956564819968)),   nil)
        XCTAssertEqual(T(exactlyIntegerLiteral:     (00057896044618658097711785492504343953926634992332820282019728792003956564819967)), T.max)
        XCTAssertEqual(T(exactlyIntegerLiteral:    (-00057896044618658097711785492504343953926634992332820282019728792003956564819968)), T.min)
        XCTAssertEqual(T(exactlyIntegerLiteral:    (-00057896044618658097711785492504343953926634992332820282019728792003956564819969)),   nil)
        #else
        XCTAssertEqual(T(integerLiteral: Int.max),   T(x64: X(UInt64(Int.max), 0, 0, 0)))
        XCTAssertEqual(T(integerLiteral: Int.min),  ~T(x64: X(UInt64(Int.max), 0, 0, 0)))
        #endif
    }
    
    func testFromStringLiteral() {
        XCTAssertEqual(T(x64: X( 10,  0,  0,  0)),    "10")
        XCTAssertEqual(T(x64: X( 02,  0,  0,  0)),  "0b10")
        XCTAssertEqual(T(x64: X( 08,  0,  0,  0)),  "0o10")
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)),  "0x10")
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)),  "0x10")
        XCTAssertEqual(T(x64: X( ~9, ~0, ~0, ~0)),   "-10")
        XCTAssertEqual(T(x64: X( ~1, ~0, ~0, ~0)), "-0b10")
        XCTAssertEqual(T(x64: X( ~7, ~0, ~0, ~0)), "-0o10")
        XCTAssertEqual(T(x64: X(~15, ~0, ~0, ~0)), "-0x10")
        
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),  "0x000000000000000000000000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(T(x64: X( ~0,  0,  0,  0)),  "0x00000000000000000000000000000000000000000000000000000000000000ffffffffffffffff")
        XCTAssertEqual(T(x64: X( ~0, ~0,  0,  0)),  "0x0000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0,  0)),  "0x000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0, ~0)), "-0x000000000000000000000000000000000000000000000000000000000000000000000000000001")
        XCTAssertEqual(T(x64: X(  0, ~0, ~0, ~0)), "-0x000000000000000000000000000000000000000000000000000000000000010000000000000000")
        XCTAssertEqual(T(x64: X(  0,  0, ~0, ~0)), "-0x000000000000000000000000000000000000000000000100000000000000000000000000000000")
        XCTAssertEqual(T(x64: X(  0,  0,  0, ~0)), "-0x000000000000000000000000000001000000000000000000000000000000000000000000000000")
        
        XCTAssertEqual(T(exactlyStringLiteral:      "0x000000000000008000000000000000000000000000000000000000000000000000000000000000"),   nil)
        XCTAssertEqual(T(exactlyStringLiteral:      "0x000000000000007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"), T.max)
        XCTAssertEqual(T(exactlyStringLiteral:     "-0x000000000000008000000000000000000000000000000000000000000000000000000000000000"), T.min)
        XCTAssertEqual(T(exactlyStringLiteral:     "-0x000000000000008000000000000000000000000000000000000000000000000000000000000001"),   nil)
        
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),  "00000000000000000000000000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(T(x64: X( ~0,  0,  0,  0)),  "00000000000000000000000000000000000000000000000000000000000018446744073709551615")
        XCTAssertEqual(T(x64: X( ~0, ~0,  0,  0)),  "00000000000000000000000000000000000000000340282366920938463463374607431768211455")
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0,  0)),  "00000000000000000000006277101735386680763835789423207666416102355444464034512895")
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0, ~0)), "-00000000000000000000000000000000000000000000000000000000000000000000000000000001")
        XCTAssertEqual(T(x64: X(  0, ~0, ~0, ~0)), "-00000000000000000000000000000000000000000000000000000000000018446744073709551616")
        XCTAssertEqual(T(x64: X(  0,  0, ~0, ~0)), "-00000000000000000000000000000000000000000340282366920938463463374607431768211456")
        XCTAssertEqual(T(x64: X(  0,  0,  0, ~0)), "-00000000000000000000006277101735386680763835789423207666416102355444464034512896")
        
        XCTAssertEqual(T(exactlyStringLiteral:      "00057896044618658097711785492504343953926634992332820282019728792003956564819968"),   nil)
        XCTAssertEqual(T(exactlyStringLiteral:      "00057896044618658097711785492504343953926634992332820282019728792003956564819967"), T.max)
        XCTAssertEqual(T(exactlyStringLiteral:     "-00057896044618658097711785492504343953926634992332820282019728792003956564819968"), T.min)
        XCTAssertEqual(T(exactlyStringLiteral:     "-00057896044618658097711785492504343953926634992332820282019728792003956564819969"),   nil)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Literals x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnLiteralsAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromIntegerLiteral() {
        XCTAssertEqual(T(x64: X( 10,  0,  0,  0)),    (10))
        XCTAssertEqual(T(x64: X( 02,  0,  0,  0)),  (0b10))
        XCTAssertEqual(T(x64: X( 08,  0,  0,  0)),  (0o10))
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)),  (0x10))
        #if SBI && swift(>=5.8)
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),  (0x000000000000000000000000000000000000000000000000000000000000000000000000000000))
        XCTAssertEqual(T(x64: X( ~0,  0,  0,  0)),  (0x00000000000000000000000000000000000000000000000000000000000000ffffffffffffffff))
        XCTAssertEqual(T(x64: X( ~0, ~0,  0,  0)),  (0x0000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffff))
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0,  0)),  (0x000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff))
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0, ~0)),  (0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff))
        XCTAssertEqual(T(x64: X(  0, ~0, ~0, ~0)),  (0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000))
        XCTAssertEqual(T(x64: X(  0,  0, ~0, ~0)),  (0x00000000000000ffffffffffffffffffffffffffffffff00000000000000000000000000000000))
        XCTAssertEqual(T(x64: X(  0,  0,  0, ~0)),  (0x00000000000000ffffffffffffffff000000000000000000000000000000000000000000000000))
        
        XCTAssertEqual(T(exactlyIntegerLiteral:     (0x000000000000010000000000000000000000000000000000000000000000000000000000000000)),   nil)
        XCTAssertEqual(T(exactlyIntegerLiteral:     (0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)), T.max)
        XCTAssertEqual(T(exactlyIntegerLiteral:     (0x000000000000000000000000000000000000000000000000000000000000000000000000000000)), T.min)
        XCTAssertEqual(T(exactlyIntegerLiteral:    (-0x000000000000000000000000000000000000000000000000000000000000000000000000000001)),   nil)
        
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),  (00000000000000000000000000000000000000000000000000000000000000000000000000000000))
        XCTAssertEqual(T(x64: X( ~0,  0,  0,  0)),  (00000000000000000000000000000000000000000000000000000000000018446744073709551615))
        XCTAssertEqual(T(x64: X( ~0, ~0,  0,  0)),  (00000000000000000000000000000000000000000340282366920938463463374607431768211455))
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0,  0)),  (00000000000000000000006277101735386680763835789423207666416102355444464034512895))
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0, ~0)),  (00115792089237316195423570985008687907853269984665640564039457584007913129639935))
        XCTAssertEqual(T(x64: X(  0, ~0, ~0, ~0)),  (00115792089237316195423570985008687907853269984665640564039439137263839420088320))
        XCTAssertEqual(T(x64: X(  0,  0, ~0, ~0)),  (00115792089237316195423570985008687907852929702298719625575994209400481361428480))
        XCTAssertEqual(T(x64: X(  0,  0,  0, ~0)),  (00115792089237316195417293883273301227089434195242432897623355228563449095127040))
        
        XCTAssertEqual(T(exactlyIntegerLiteral:     (00115792089237316195423570985008687907853269984665640564039457584007913129639936)),   nil)
        XCTAssertEqual(T(exactlyIntegerLiteral:     (00115792089237316195423570985008687907853269984665640564039457584007913129639935)), T.max)
        XCTAssertEqual(T(exactlyIntegerLiteral:     (00000000000000000000000000000000000000000000000000000000000000000000000000000000)), T.min)
        XCTAssertEqual(T(exactlyIntegerLiteral:    (-00000000000000000000000000000000000000000000000000000000000000000000000000000001)),   nil)
        #else
        XCTAssertEqual(T(integerLiteral: UInt.max),  T(x64: X(UInt64(UInt.max), 0, 0, 0)))
        XCTAssertEqual(T(integerLiteral: UInt.min),  T(x64: X(UInt64(UInt.min), 0, 0, 0)))
        #endif
    }
    
    func testFromStringLiteral() {
        XCTAssertEqual(T(x64: X( 10,  0,  0,  0)),    "10")
        XCTAssertEqual(T(x64: X( 02,  0,  0,  0)),  "0b10")
        XCTAssertEqual(T(x64: X( 08,  0,  0,  0)),  "0o10")
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)),  "0x10")
        
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),  "0x000000000000000000000000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(T(x64: X( ~0,  0,  0,  0)),  "0x00000000000000000000000000000000000000000000000000000000000000ffffffffffffffff")
        XCTAssertEqual(T(x64: X( ~0, ~0,  0,  0)),  "0x0000000000000000000000000000000000000000000000ffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0,  0)),  "0x000000000000000000000000000000ffffffffffffffffffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0, ~0)),  "0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff")
        XCTAssertEqual(T(x64: X(  0, ~0, ~0, ~0)),  "0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000")
        XCTAssertEqual(T(x64: X(  0,  0, ~0, ~0)),  "0x00000000000000ffffffffffffffffffffffffffffffff00000000000000000000000000000000")
        XCTAssertEqual(T(x64: X(  0,  0,  0, ~0)),  "0x00000000000000ffffffffffffffff000000000000000000000000000000000000000000000000")
        
        XCTAssertEqual(T(exactlyStringLiteral:      "0x000000000000010000000000000000000000000000000000000000000000000000000000000000"),   nil)
        XCTAssertEqual(T(exactlyStringLiteral:      "0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"), T.max)
        XCTAssertEqual(T(exactlyStringLiteral:      "0x000000000000000000000000000000000000000000000000000000000000000000000000000000"), T.min)
        XCTAssertEqual(T(exactlyStringLiteral:     "-0x000000000000000000000000000000000000000000000000000000000000000000000000000001"),   nil)
        
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),  "00000000000000000000000000000000000000000000000000000000000000000000000000000000")
        XCTAssertEqual(T(x64: X( ~0,  0,  0,  0)),  "00000000000000000000000000000000000000000000000000000000000018446744073709551615")
        XCTAssertEqual(T(x64: X( ~0, ~0,  0,  0)),  "00000000000000000000000000000000000000000340282366920938463463374607431768211455")
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0,  0)),  "00000000000000000000006277101735386680763835789423207666416102355444464034512895")
        XCTAssertEqual(T(x64: X( ~0, ~0, ~0, ~0)),  "00115792089237316195423570985008687907853269984665640564039457584007913129639935")
        XCTAssertEqual(T(x64: X(  0, ~0, ~0, ~0)),  "00115792089237316195423570985008687907853269984665640564039439137263839420088320")
        XCTAssertEqual(T(x64: X(  0,  0, ~0, ~0)),  "00115792089237316195423570985008687907852929702298719625575994209400481361428480")
        XCTAssertEqual(T(x64: X(  0,  0,  0, ~0)),  "00115792089237316195417293883273301227089434195242432897623355228563449095127040")
        
        XCTAssertEqual(T(exactlyStringLiteral:      "00115792089237316195423570985008687907853269984665640564039457584007913129639936"),   nil)
        XCTAssertEqual(T(exactlyStringLiteral:      "00115792089237316195423570985008687907853269984665640564039457584007913129639935"), T.max)
        XCTAssertEqual(T(exactlyStringLiteral:      "00000000000000000000000000000000000000000000000000000000000000000000000000000000"), T.min)
        XCTAssertEqual(T(exactlyStringLiteral:     "-00000000000000000000000000000000000000000000000000000000000000000000000000000001"),   nil)
    }
}

#endif
