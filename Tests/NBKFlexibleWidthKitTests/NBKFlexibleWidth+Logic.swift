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
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Logic x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnLogicAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNot() {
        NBKAssertNot(T(words:[ 0,  0,  0,  0] as W), T(words:[~0,  0,  0,  0] as W))
        NBKAssertNot(T(words:[~0, ~0, ~0, ~0] as W), T(words:[ 0,  0,  0,  0] as W))
        
        NBKAssertNot(T(words:[ 0,  1,  2,  3] as W), T(words:[~0, ~1, ~2, ~3] as W))
        NBKAssertNot(T(words:[~0, ~1, ~2, ~3] as W), T(words:[ 0,  1,  2,  3] as W))
    }
    
    func testAnd() {
        NBKAssertAnd(T(words:[ 0,  1,  2,  3] as W), T(words:[ 0,  0,  0,  0] as W), T(words:[ 0,  0,  0,  0] as W))
        NBKAssertAnd(T(words:[ 3,  2,  1,  0] as W), T(words:[ 0,  0,  0,  0] as W), T(words:[ 0,  0,  0,  0] as W))
        
        NBKAssertAnd(T(words:[ 0,  1,  2,  3] as W), T(words:[~0, ~0, ~0, ~0] as W), T(words:[ 0,  1,  2,  3] as W))
        NBKAssertAnd(T(words:[ 3,  2,  1,  0] as W), T(words:[~0, ~0, ~0, ~0] as W), T(words:[ 3,  2,  1,  0] as W))
        
        NBKAssertAnd(T(words:[ 0,  1,  2,  3] as W), T(words:[ 1,  1,  1,  1] as W), T(words:[ 0,  1,  0,  1] as W))
        NBKAssertAnd(T(words:[ 3,  2,  1,  0] as W), T(words:[ 1,  1,  1,  1] as W), T(words:[ 1,  0,  1,  0] as W))
    }
    
    func testOr() {
        NBKAssertOr (T(words:[ 0,  1,  2,  3] as W), T(words:[ 0,  0,  0,  0] as W), T(words:[ 0,  1,  2,  3] as W))
        NBKAssertOr (T(words:[ 3,  2,  1,  0] as W), T(words:[ 0,  0,  0,  0] as W), T(words:[ 3,  2,  1,  0] as W))
        
        NBKAssertOr (T(words:[ 0,  1,  2,  3] as W), T(words:[~0, ~0, ~0, ~0] as W), T(words:[~0, ~0, ~0, ~0] as W))
        NBKAssertOr (T(words:[ 3,  2,  1,  0] as W), T(words:[~0, ~0, ~0, ~0] as W), T(words:[~0, ~0, ~0, ~0] as W))
        
        NBKAssertOr (T(words:[ 0,  1,  2,  3] as W), T(words:[ 1,  1,  1,  1] as W), T(words:[ 1,  1,  3,  3] as W))
        NBKAssertOr (T(words:[ 3,  2,  1,  0] as W), T(words:[ 1,  1,  1,  1] as W), T(words:[ 3,  3,  1,  1] as W))
    }
    
    func testXor() {
        NBKAssertXor(T(words:[ 0,  1,  2,  3] as W), T(words:[ 0,  0,  0,  0] as W), T(words:[ 0,  1,  2,  3] as W))
        NBKAssertXor(T(words:[ 3,  2,  1,  0] as W), T(words:[ 0,  0,  0,  0] as W), T(words:[ 3,  2,  1,  0] as W))
        
        NBKAssertXor(T(words:[ 0,  1,  2,  3] as W), T(words:[~0, ~0, ~0, ~0] as W), T(words:[~0, ~1, ~2, ~3] as W))
        NBKAssertXor(T(words:[ 3,  2,  1,  0] as W), T(words:[~0, ~0, ~0, ~0] as W), T(words:[~3, ~2, ~1, ~0] as W))
        
        NBKAssertXor(T(words:[ 0,  1,  2,  3] as W), T(words:[ 1,  1,  1,  1] as W), T(words:[ 1,  0,  3,  2] as W))
        NBKAssertXor(T(words:[ 3,  2,  1,  0] as W), T(words:[ 1,  1,  1,  1] as W), T(words:[ 2,  3,  0,  1] as W))
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Logic x Assertions
//*============================================================================*

private func NBKAssertNot<T: IntXLOrUIntXL>(
_ operand: T, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    if  operand.words.last != UInt.max {
        XCTAssertEqual(~operand, result, file: file, line: line)
        XCTAssertEqual(~result, operand, file: file, line: line)
    }   else {
        XCTAssertEqual(~operand, result, file: file, line: line)
    }
}

private func NBKAssertAnd<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs: T, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs &  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &= rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual(                 rhs &  lhs,                 result, file: file, line: line)
    XCTAssertEqual({ var rhs = rhs; rhs &= lhs; return rhs }(), result, file: file, line: line)
}

private func NBKAssertOr<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs: T, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs |  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs |= rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual(                 rhs |  lhs,                 result, file: file, line: line)
    XCTAssertEqual({ var rhs = rhs; rhs |= lhs; return rhs }(), result, file: file, line: line)
}

private func NBKAssertXor<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs: T, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs ^  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs ^= rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual(                 rhs ^  lhs,                 result, file: file, line: line)
    XCTAssertEqual({ var rhs = rhs; rhs ^= lhs; return rhs }(), result, file: file, line: line)
}

#endif
