//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Logic x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnLogicAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNot() {
        NBKAssertNot(T(x64: X( 0,  1,  2,  3)), T(x64: X(~0, ~1, ~2, ~3)))
        NBKAssertNot(T(x64: X(~0, ~1, ~2, ~3)), T(x64: X( 0,  1,  2,  3)))
    }
    
    func testAnd() {
        NBKAssertAnd(T(x64: X( 0,  1,  2,  3)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  0,  0,  0)))
        NBKAssertAnd(T(x64: X( 3,  2,  1,  0)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  0,  0,  0)))
        
        NBKAssertAnd(T(x64: X( 0,  1,  2,  3)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X( 0,  1,  2,  3)))
        NBKAssertAnd(T(x64: X( 3,  2,  1,  0)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X( 3,  2,  1,  0)))
        
        NBKAssertAnd(T(x64: X( 0,  1,  2,  3)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 0,  1,  0,  1)))
        NBKAssertAnd(T(x64: X( 3,  2,  1,  0)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 1,  0,  1,  0)))
    }
    
    func testOr() {
        NBKAssertOr (T(x64: X( 0,  1,  2,  3)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  1,  2,  3)))
        NBKAssertOr (T(x64: X( 3,  2,  1,  0)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 3,  2,  1,  0)))
        
        NBKAssertOr (T(x64: X( 0,  1,  2,  3)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~0, ~0, ~0, ~0)))
        NBKAssertOr (T(x64: X( 3,  2,  1,  0)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~0, ~0, ~0, ~0)))
        
        NBKAssertOr (T(x64: X( 0,  1,  2,  3)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 1,  1,  3,  3)))
        NBKAssertOr (T(x64: X( 3,  2,  1,  0)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 3,  3,  1,  1)))
    }
    
    func testXor() {
        NBKAssertXor(T(x64: X( 0,  1,  2,  3)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  1,  2,  3)))
        NBKAssertXor(T(x64: X( 3,  2,  1,  0)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 3,  2,  1,  0)))
        
        NBKAssertXor(T(x64: X( 0,  1,  2,  3)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~0, ~1, ~2, ~3)))
        NBKAssertXor(T(x64: X( 3,  2,  1,  0)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~3, ~2, ~1, ~0)))
        
        NBKAssertXor(T(x64: X( 0,  1,  2,  3)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 1,  0,  3,  2)))
        NBKAssertXor(T(x64: X( 3,  2,  1,  0)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 2,  3,  0,  1)))
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Logic x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnLogicAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNot() {
        NBKAssertNot(T(x64: X( 0,  1,  2,  3)), T(x64: X(~0, ~1, ~2, ~3)))
        NBKAssertNot(T(x64: X(~0, ~1, ~2, ~3)), T(x64: X( 0,  1,  2,  3)))
    }
    
    func testAnd() {
        NBKAssertAnd(T(x64: X( 0,  1,  2,  3)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  0,  0,  0)))
        NBKAssertAnd(T(x64: X( 3,  2,  1,  0)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  0,  0,  0)))
        
        NBKAssertAnd(T(x64: X( 0,  1,  2,  3)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X( 0,  1,  2,  3)))
        NBKAssertAnd(T(x64: X( 3,  2,  1,  0)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X( 3,  2,  1,  0)))
        
        NBKAssertAnd(T(x64: X( 0,  1,  2,  3)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 0,  1,  0,  1)))
        NBKAssertAnd(T(x64: X( 3,  2,  1,  0)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 1,  0,  1,  0)))
    }
    
    func testOr() {
        NBKAssertOr (T(x64: X( 0,  1,  2,  3)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  1,  2,  3)))
        NBKAssertOr (T(x64: X( 3,  2,  1,  0)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 3,  2,  1,  0)))
        
        NBKAssertOr (T(x64: X( 0,  1,  2,  3)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~0, ~0, ~0, ~0)))
        NBKAssertOr (T(x64: X( 3,  2,  1,  0)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~0, ~0, ~0, ~0)))
        
        NBKAssertOr (T(x64: X( 0,  1,  2,  3)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 1,  1,  3,  3)))
        NBKAssertOr (T(x64: X( 3,  2,  1,  0)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 3,  3,  1,  1)))
    }
    
    func testXor() {
        NBKAssertXor(T(x64: X( 0,  1,  2,  3)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  1,  2,  3)))
        NBKAssertXor(T(x64: X( 3,  2,  1,  0)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 3,  2,  1,  0)))
        
        NBKAssertXor(T(x64: X( 0,  1,  2,  3)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~0, ~1, ~2, ~3)))
        NBKAssertXor(T(x64: X( 3,  2,  1,  0)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~3, ~2, ~1, ~0)))
        
        NBKAssertXor(T(x64: X( 0,  1,  2,  3)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 1,  0,  3,  2)))
        NBKAssertXor(T(x64: X( 3,  2,  1,  0)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 2,  3,  0,  1)))
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Logic x Assertions
//*============================================================================*

private func NBKAssertNot<H: NBKFixedWidthInteger>(
_ operand: NBKDoubleWidth<H>, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(~operand, result, file: file, line: line)
    XCTAssertEqual(~result, operand, file: file, line: line)
    
    XCTAssertEqual(operand.onesComplement(), result,  file: file, line: line)
    XCTAssertEqual(result .onesComplement(), operand, file: file, line: line)
    
    XCTAssertEqual({ var x = operand; x.formOnesComplement(); return x }(), result,  file: file, line: line)
    XCTAssertEqual({ var x = result;  x.formOnesComplement(); return x }(), operand, file: file, line: line)
}

private func NBKAssertAnd<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs &  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &= rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual(                 rhs &  lhs,                 result, file: file, line: line)
    XCTAssertEqual({ var rhs = rhs; rhs &= lhs; return rhs }(), result, file: file, line: line)
}

private func NBKAssertOr<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs |  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs |= rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual(                 rhs |  lhs,                 result, file: file, line: line)
    XCTAssertEqual({ var rhs = rhs; rhs |= lhs; return rhs }(), result, file: file, line: line)
}

private func NBKAssertXor<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs ^  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs ^= rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual(                 rhs ^  lhs,                 result, file: file, line: line)
    XCTAssertEqual({ var rhs = rhs; rhs ^= lhs; return rhs }(), result, file: file, line: line)
}
