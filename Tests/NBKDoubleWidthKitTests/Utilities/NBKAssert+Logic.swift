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

//*============================================================================*
// MARK: * NBK x Assert x Logic
//*============================================================================*

func NBKAssertNot<H: NBKFixedWidthInteger>(
_ operand: NBKDoubleWidth<H>, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(~operand, result, file: file, line: line)
    XCTAssertEqual(~result, operand, file: file, line: line)
    
    XCTAssertEqual(operand.onesComplement(), result,  file: file, line: line)
    XCTAssertEqual(result .onesComplement(), operand, file: file, line: line)
    
    XCTAssertEqual({ var x = operand; x.formOnesComplement(); return x }(), result,  file: file, line: line)
    XCTAssertEqual({ var x = result;  x.formOnesComplement(); return x }(), operand, file: file, line: line)
}

func NBKAssertAnd<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs &  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &= rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual(                 rhs &  lhs,                 result, file: file, line: line)
    XCTAssertEqual({ var rhs = rhs; rhs &= lhs; return rhs }(), result, file: file, line: line)
}

func NBKAssertOr<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs |  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs |= rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual(                 rhs |  lhs,                 result, file: file, line: line)
    XCTAssertEqual({ var rhs = rhs; rhs |= lhs; return rhs }(), result, file: file, line: line)
}

func NBKAssertXor<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs ^  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs ^= rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual(                 rhs ^  lhs,                 result, file: file, line: line)
    XCTAssertEqual({ var rhs = rhs; rhs ^= lhs; return rhs }(), result, file: file, line: line)
}
