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

//*============================================================================*
// MARK: * NBK x Assert x Logic
//*============================================================================*

func NBKAssertNot<T: NBKBinaryInteger>(
_ operand: T, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    if  operand.words.last != UInt.max {
        XCTAssertEqual(~operand, result, file: file, line: line)
        XCTAssertEqual(~result, operand, file: file, line: line)
    }   else {
        XCTAssertEqual(~operand, result, file: file, line: line)
    }
}

func NBKAssertAnd<T: NBKBinaryInteger>(
_ lhs: T, _ rhs: T, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs &  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &= rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual(                 rhs &  lhs,                 result, file: file, line: line)
    XCTAssertEqual({ var rhs = rhs; rhs &= lhs; return rhs }(), result, file: file, line: line)
}

func NBKAssertOr<T: NBKBinaryInteger>(
_ lhs: T, _ rhs: T, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs |  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs |= rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual(                 rhs |  lhs,                 result, file: file, line: line)
    XCTAssertEqual({ var rhs = rhs; rhs |= lhs; return rhs }(), result, file: file, line: line)
}

func NBKAssertXor<T: NBKBinaryInteger>(
_ lhs: T, _ rhs: T, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs ^  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs ^= rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual(                 rhs ^  lhs,                 result, file: file, line: line)
    XCTAssertEqual({ var rhs = rhs; rhs ^= lhs; return rhs }(), result, file: file, line: line)
}
