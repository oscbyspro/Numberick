//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Logic x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnLogicAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNot() {
        NBKAssertNot(T(words:[ 0,  0,  0,  0] as X), T(words:[~0,  0,  0,  0] as X))
        NBKAssertNot(T(words:[~0, ~0, ~0, ~0] as X), T(words:[ 0,  0,  0,  0] as X))
        
        NBKAssertNot(T(words:[ 0,  1,  2,  3] as X), T(words:[~0, ~1, ~2, ~3] as X))
        NBKAssertNot(T(words:[~0, ~1, ~2, ~3] as X), T(words:[ 0,  1,  2,  3] as X))
    }
    
    func testAnd() {
        NBKAssertAnd(T(words:[ 0,  1,  2,  3] as X), T(words:[ 0,  0,  0,  0] as X), T(words:[ 0,  0,  0,  0] as X))
        NBKAssertAnd(T(words:[ 3,  2,  1,  0] as X), T(words:[ 0,  0,  0,  0] as X), T(words:[ 0,  0,  0,  0] as X))
        
        NBKAssertAnd(T(words:[ 0,  1,  2,  3] as X), T(words:[~0, ~0, ~0, ~0] as X), T(words:[ 0,  1,  2,  3] as X))
        NBKAssertAnd(T(words:[ 3,  2,  1,  0] as X), T(words:[~0, ~0, ~0, ~0] as X), T(words:[ 3,  2,  1,  0] as X))
        
        NBKAssertAnd(T(words:[ 0,  1,  2,  3] as X), T(words:[ 1,  1,  1,  1] as X), T(words:[ 0,  1,  0,  1] as X))
        NBKAssertAnd(T(words:[ 3,  2,  1,  0] as X), T(words:[ 1,  1,  1,  1] as X), T(words:[ 1,  0,  1,  0] as X))
    }
    
    func testOr() {
        NBKAssertOr (T(words:[ 0,  1,  2,  3] as X), T(words:[ 0,  0,  0,  0] as X), T(words:[ 0,  1,  2,  3] as X))
        NBKAssertOr (T(words:[ 3,  2,  1,  0] as X), T(words:[ 0,  0,  0,  0] as X), T(words:[ 3,  2,  1,  0] as X))
        
        NBKAssertOr (T(words:[ 0,  1,  2,  3] as X), T(words:[~0, ~0, ~0, ~0] as X), T(words:[~0, ~0, ~0, ~0] as X))
        NBKAssertOr (T(words:[ 3,  2,  1,  0] as X), T(words:[~0, ~0, ~0, ~0] as X), T(words:[~0, ~0, ~0, ~0] as X))
        
        NBKAssertOr (T(words:[ 0,  1,  2,  3] as X), T(words:[ 1,  1,  1,  1] as X), T(words:[ 1,  1,  3,  3] as X))
        NBKAssertOr (T(words:[ 3,  2,  1,  0] as X), T(words:[ 1,  1,  1,  1] as X), T(words:[ 3,  3,  1,  1] as X))
    }
    
    func testXor() {
        NBKAssertXor(T(words:[ 0,  1,  2,  3] as X), T(words:[ 0,  0,  0,  0] as X), T(words:[ 0,  1,  2,  3] as X))
        NBKAssertXor(T(words:[ 3,  2,  1,  0] as X), T(words:[ 0,  0,  0,  0] as X), T(words:[ 3,  2,  1,  0] as X))
        
        NBKAssertXor(T(words:[ 0,  1,  2,  3] as X), T(words:[~0, ~0, ~0, ~0] as X), T(words:[~0, ~1, ~2, ~3] as X))
        NBKAssertXor(T(words:[ 3,  2,  1,  0] as X), T(words:[~0, ~0, ~0, ~0] as X), T(words:[~3, ~2, ~1, ~0] as X))
        
        NBKAssertXor(T(words:[ 0,  1,  2,  3] as X), T(words:[ 1,  1,  1,  1] as X), T(words:[ 1,  0,  3,  2] as X))
        NBKAssertXor(T(words:[ 3,  2,  1,  0] as X), T(words:[ 1,  1,  1,  1] as X), T(words:[ 2,  3,  0,  1] as X))
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
