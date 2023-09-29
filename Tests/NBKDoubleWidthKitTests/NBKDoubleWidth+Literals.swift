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
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let top    = T(x64: X(0xe7e6e5e4e3e2e1e0, 0xefeeedecebeae9e8, 0xf7f6f5f4f3f2f1f0, 0xfffefdfcfbfaf9f8))
    let bottom = T(x64: X(0x0706050403020100, 0x0f0e0d0c0b0a0908, 0x1716151413121110, 0x1f1e1d1c1b1a1918))
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromIntegerLiteral() {
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),     (0))
        XCTAssertEqual(T(x64: X( 10,  0,  0,  0)),    (10))
        XCTAssertEqual(T(x64: X(  2,  0,  0,  0)),  (0b10))
        XCTAssertEqual(T(x64: X(  8,  0,  0,  0)),  (0o10))
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)),  (0x10))
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)),  (0x10))
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),    (+0))
        XCTAssertEqual(T(x64: X( 10,  0,  0,  0)),   (+10))
        XCTAssertEqual(T(x64: X(  2,  0,  0,  0)), (+0b10))
        XCTAssertEqual(T(x64: X(  8,  0,  0,  0)), (+0o10))
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)), (+0x10))
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)), (+0x10))
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),    (-0))
        XCTAssertEqual(T(x64: X( ~9, ~0, ~0, ~0)),   (-10))
        XCTAssertEqual(T(x64: X( ~1, ~0, ~0, ~0)), (-0b10))
        XCTAssertEqual(T(x64: X( ~7, ~0, ~0, ~0)), (-0o10))
        XCTAssertEqual(T(x64: X(~15, ~0, ~0, ~0)), (-0x10))
        #if SBI && swift(>=5.8)
        XCTAssertEqual(self.top/*-----------*/, (-0x00000000000000000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e20))
        XCTAssertEqual(self.bottom/*--------*/,  (0x000000000000001f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100))
        XCTAssertEqual(T(exactlyIntegerLiteral:  (0x000000000000008000000000000000000000000000000000000000000000000000000000000000)),   nil)
        XCTAssertEqual(T(exactlyIntegerLiteral:  (0x000000000000007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)), T.max)
        XCTAssertEqual(T(exactlyIntegerLiteral: (-0x000000000000008000000000000000000000000000000000000000000000000000000000000000)), T.min)
        XCTAssertEqual(T(exactlyIntegerLiteral: (-0x000000000000008000000000000000000000000000000000000000000000000000000000000001)),   nil)
        
        XCTAssertEqual(self.top/*-----------*/, (-00000001780731860627700044960722568376592200742329637303199754547598369979440672))
        XCTAssertEqual(self.bottom/*--------*/,  (00014074904626401341155369551180448584754667373453244490859944217516317499064576))
        XCTAssertEqual(T(exactlyIntegerLiteral:  (00057896044618658097711785492504343953926634992332820282019728792003956564819968)),   nil)
        XCTAssertEqual(T(exactlyIntegerLiteral:  (00057896044618658097711785492504343953926634992332820282019728792003956564819967)), T.max)
        XCTAssertEqual(T(exactlyIntegerLiteral: (-00057896044618658097711785492504343953926634992332820282019728792003956564819968)), T.min)
        XCTAssertEqual(T(exactlyIntegerLiteral: (-00057896044618658097711785492504343953926634992332820282019728792003956564819969)),   nil)
        #else
        XCTAssertEqual(T(integerLiteral: Int.max),   T(x64: X(UInt64(Int.max), 0, 0, 0)))
        XCTAssertEqual(T(integerLiteral: Int.min),  ~T(x64: X(UInt64(Int.max), 0, 0, 0)))
        #endif
    }
    
    func testFromStringLiteral() {
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),     "0")
        XCTAssertEqual(T(x64: X( 10,  0,  0,  0)),    "10")
        XCTAssertEqual(T(x64: X(  2,  0,  0,  0)),  "0b10")
        XCTAssertEqual(T(x64: X(  8,  0,  0,  0)),  "0o10")
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)),  "0x10")
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)),  "0x10")
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),    "+0")
        XCTAssertEqual(T(x64: X( 10,  0,  0,  0)),   "+10")
        XCTAssertEqual(T(x64: X(  2,  0,  0,  0)), "+0b10")
        XCTAssertEqual(T(x64: X(  8,  0,  0,  0)), "+0o10")
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)), "+0x10")
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)), "+0x10")
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),    "-0")
        XCTAssertEqual(T(x64: X( ~9, ~0, ~0, ~0)),   "-10")
        XCTAssertEqual(T(x64: X( ~1, ~0, ~0, ~0)), "-0b10")
        XCTAssertEqual(T(x64: X( ~7, ~0, ~0, ~0)), "-0o10")
        XCTAssertEqual(T(x64: X(~15, ~0, ~0, ~0)), "-0x10")
        
        XCTAssertEqual(self.top/*----------*/,  "-0x00000000000000000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e20")
        XCTAssertEqual(self.bottom/*-------*/,   "0x000000000000001f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100")
        XCTAssertEqual(T(exactlyStringLiteral:   "0x000000000000008000000000000000000000000000000000000000000000000000000000000000"),   nil)
        XCTAssertEqual(T(exactlyStringLiteral:   "0x000000000000007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"), T.max)
        XCTAssertEqual(T(exactlyStringLiteral:  "-0x000000000000008000000000000000000000000000000000000000000000000000000000000000"), T.min)
        XCTAssertEqual(T(exactlyStringLiteral:  "-0x000000000000008000000000000000000000000000000000000000000000000000000000000001"),   nil)
        
        XCTAssertEqual(self.top/*----------*/,  "-00000001780731860627700044960722568376592200742329637303199754547598369979440672")
        XCTAssertEqual(self.bottom/*-------*/,   "00014074904626401341155369551180448584754667373453244490859944217516317499064576")
        XCTAssertEqual(T(exactlyStringLiteral:   "00057896044618658097711785492504343953926634992332820282019728792003956564819968"),   nil)
        XCTAssertEqual(T(exactlyStringLiteral:   "00057896044618658097711785492504343953926634992332820282019728792003956564819967"), T.max)
        XCTAssertEqual(T(exactlyStringLiteral:  "-00057896044618658097711785492504343953926634992332820282019728792003956564819968"), T.min)
        XCTAssertEqual(T(exactlyStringLiteral:  "-00057896044618658097711785492504343953926634992332820282019728792003956564819969"),   nil)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Literals x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnLiteralsAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let top    = T(x64: X(0xe7e6e5e4e3e2e1e0, 0xefeeedecebeae9e8, 0xf7f6f5f4f3f2f1f0, 0xfffefdfcfbfaf9f8))
    let bottom = T(x64: X(0x0706050403020100, 0x0f0e0d0c0b0a0908, 0x1716151413121110, 0x1f1e1d1c1b1a1918))
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromIntegerLiteral() {
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),     (0))
        XCTAssertEqual(T(x64: X( 10,  0,  0,  0)),    (10))
        XCTAssertEqual(T(x64: X(  2,  0,  0,  0)),  (0b10))
        XCTAssertEqual(T(x64: X(  8,  0,  0,  0)),  (0o10))
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)),  (0x10))
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),    (+0))
        XCTAssertEqual(T(x64: X( 10,  0,  0,  0)),   (+10))
        XCTAssertEqual(T(x64: X(  2,  0,  0,  0)), (+0b10))
        XCTAssertEqual(T(x64: X(  8,  0,  0,  0)), (+0o10))
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)), (+0x10))
        #if SBI && swift(>=5.8)
        XCTAssertEqual(self.top/*-----------*/,  (0x00000000000000fffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0))
        XCTAssertEqual(self.bottom/*--------*/,  (0x000000000000001f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100))
        XCTAssertEqual(T(exactlyIntegerLiteral:  (0x000000000000010000000000000000000000000000000000000000000000000000000000000000)),   nil)
        XCTAssertEqual(T(exactlyIntegerLiteral:  (0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)), T.max)
        XCTAssertEqual(T(exactlyIntegerLiteral:  (0x000000000000000000000000000000000000000000000000000000000000000000000000000000)), T.min)
        XCTAssertEqual(T(exactlyIntegerLiteral: (-0x000000000000000000000000000000000000000000000000000000000000000000000000000001)),   nil)
        
        XCTAssertEqual(self.top/*-----------*/,  (00115790308505455567723526024286119531261069242336003260839703036409543150199264))
        XCTAssertEqual(self.bottom/*--------*/,  (00014074904626401341155369551180448584754667373453244490859944217516317499064576))
        XCTAssertEqual(T(exactlyIntegerLiteral:  (00115792089237316195423570985008687907853269984665640564039457584007913129639936)),   nil)
        XCTAssertEqual(T(exactlyIntegerLiteral:  (00115792089237316195423570985008687907853269984665640564039457584007913129639935)), T.max)
        XCTAssertEqual(T(exactlyIntegerLiteral:  (00000000000000000000000000000000000000000000000000000000000000000000000000000000)), T.min)
        XCTAssertEqual(T(exactlyIntegerLiteral: (-00000000000000000000000000000000000000000000000000000000000000000000000000000001)),   nil)
        #else
        XCTAssertEqual(T(integerLiteral: UInt.max),  T(x64: X(UInt64(UInt.max), 0, 0, 0)))
        XCTAssertEqual(T(integerLiteral: UInt.min),  T(x64: X(UInt64(UInt.min), 0, 0, 0)))
        #endif
    }
    
    func testFromStringLiteral() {
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),     "0")
        XCTAssertEqual(T(x64: X( 10,  0,  0,  0)),    "10")
        XCTAssertEqual(T(x64: X(  2,  0,  0,  0)),  "0b10")
        XCTAssertEqual(T(x64: X(  8,  0,  0,  0)),  "0o10")
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)),  "0x10")
        XCTAssertEqual(T(x64: X(  0,  0,  0,  0)),    "+0")
        XCTAssertEqual(T(x64: X( 10,  0,  0,  0)),   "+10")
        XCTAssertEqual(T(x64: X(  2,  0,  0,  0)), "+0b10")
        XCTAssertEqual(T(x64: X(  8,  0,  0,  0)), "+0o10")
        XCTAssertEqual(T(x64: X( 16,  0,  0,  0)), "+0x10")
        
        XCTAssertEqual(self.top/*----------*/,   "0x00000000000000fffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0")
        XCTAssertEqual(self.bottom/*-------*/,   "0x000000000000001f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100")
        XCTAssertEqual(T(exactlyStringLiteral:   "0x000000000000010000000000000000000000000000000000000000000000000000000000000000"),   nil)
        XCTAssertEqual(T(exactlyStringLiteral:   "0x00000000000000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"), T.max)
        XCTAssertEqual(T(exactlyStringLiteral:   "0x000000000000000000000000000000000000000000000000000000000000000000000000000000"), T.min)
        XCTAssertEqual(T(exactlyStringLiteral:  "-0x000000000000000000000000000000000000000000000000000000000000000000000000000001"),   nil)
        
        XCTAssertEqual(self.top/*----------*/,   "00115790308505455567723526024286119531261069242336003260839703036409543150199264")
        XCTAssertEqual(self.bottom/*-------*/,   "00014074904626401341155369551180448584754667373453244490859944217516317499064576")
        XCTAssertEqual(T(exactlyStringLiteral:   "00115792089237316195423570985008687907853269984665640564039457584007913129639936"),   nil)
        XCTAssertEqual(T(exactlyStringLiteral:   "00115792089237316195423570985008687907853269984665640564039457584007913129639935"), T.max)
        XCTAssertEqual(T(exactlyStringLiteral:   "00000000000000000000000000000000000000000000000000000000000000000000000000000000"), T.min)
        XCTAssertEqual(T(exactlyStringLiteral:  "-00000000000000000000000000000000000000000000000000000000000000000000000000000001"),   nil)
    }
}

#endif
