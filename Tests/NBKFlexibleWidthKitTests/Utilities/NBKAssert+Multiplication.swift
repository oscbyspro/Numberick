//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
@testable import NBKFlexibleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x Assert x Multiplication
//*============================================================================*

func NBKAssertMultiplication<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs:  T, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs *  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs *= rhs; return lhs }(), result, file: file, line: line)
    
    XCTAssertEqual(lhs.multiplied(by: rhs), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.multiply(by: rhs); return lhs }(), result, file: file, line: line)
}

func NBKAssertMultiplicationByDigit<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs:  T.Digit, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(                 lhs *  rhs,                 result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs *= rhs; return lhs }(), result, file: file, line: line)
    
    XCTAssertEqual(lhs.multiplied(by: rhs, adding: UInt.zero), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.multiply(by: rhs, adding: UInt.zero); return lhs }(), result, file: file, line: line)
}
