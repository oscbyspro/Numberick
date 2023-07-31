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
// MARK: * NBK x Assert x Division
//*============================================================================*

func NBKAssertDivision<T: NBKBinaryInteger>(
_ lhs: T, _ rhs: T, _ quotient: T, _ remainder: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(lhs, quotient * rhs + remainder, "lhs != rhs * quotient + remainder", file: file, line: line)
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(lhs / rhs, quotient,  file: file, line: line)
        XCTAssertEqual(lhs % rhs, remainder, file: file, line: line)
        
        XCTAssertEqual({ var x = lhs; x /= rhs; return x }(), quotient,  file: file, line: line)
        XCTAssertEqual({ var x = lhs; x %= rhs; return x }(), remainder, file: file, line: line)
        
        XCTAssertEqual(lhs.quotientAndRemainder(dividingBy: rhs).quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(lhs.quotientAndRemainder(dividingBy: rhs).remainder, remainder, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs.dividedReportingOverflow(by: rhs).partialValue, quotient, file: file, line: line)
    XCTAssertEqual(lhs.dividedReportingOverflow(by: rhs).overflow,     overflow, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.divideReportingOverflow(by: rhs); return x }(), quotient, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.divideReportingOverflow(by: rhs); return o }(), overflow, file: file, line: line)
    
    XCTAssertEqual(lhs.remainderReportingOverflow(dividingBy: rhs).partialValue, remainder, file: file, line: line)
    XCTAssertEqual(lhs.remainderReportingOverflow(dividingBy: rhs).overflow,     overflow,  file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.formRemainderReportingOverflow(dividingBy: rhs); return x }(), remainder, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.formRemainderReportingOverflow(dividingBy: rhs); return o }(), overflow,  file: file, line: line)

    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs).partialValue.quotient,  quotient,  file: file, line: line)
    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs).partialValue.remainder, remainder, file: file, line: line)
    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs).overflow,               overflow,  file: file, line: line)
    //=------------------------------------------=
    guard let lhs = lhs as? UIntXL, let rhs = rhs as? UIntXL, let quotient = quotient as? UIntXL, let remainder = remainder as? UIntXL else { return }
    //=------------------------------------------=
    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflowAsNormal(dividingBy: rhs).partialValue.quotient,  quotient,  file: file, line: line)
    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflowAsNormal(dividingBy: rhs).partialValue.remainder, remainder, file: file, line: line)
    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflowAsNormal(dividingBy: rhs).overflow,               overflow,  file: file, line: line)
}

func NBKAssertDivisionByDigit<T: NBKBinaryInteger>(
_ lhs: T, _ rhs: T.Digit, _ quotient: T, _ remainder: T.Digit, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    let extended = T(digit: remainder)
    //=------------------------------------------=
    XCTAssertEqual(lhs, quotient * rhs + remainder, "lhs != rhs * quotient + remainder", file: file, line: line)
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(lhs / rhs, quotient,  file: file, line: line)
        XCTAssertEqual(lhs % rhs, remainder, file: file, line: line)
        
        XCTAssertEqual({ var x = lhs; x /= rhs; return x }(), quotient, file: file, line: line)
        XCTAssertEqual({ var x = lhs; x %= rhs; return x }(), extended, file: file, line: line)
        
        XCTAssertEqual(lhs.quotientAndRemainder(dividingBy: rhs).quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(lhs.quotientAndRemainder(dividingBy: rhs).remainder, remainder, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs.dividedReportingOverflow(by: rhs).partialValue, quotient, file: file, line: line)
    XCTAssertEqual(lhs.dividedReportingOverflow(by: rhs).overflow,     overflow, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.divideReportingOverflow(by: rhs); return x }(), quotient, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.divideReportingOverflow(by: rhs); return o }(), overflow, file: file, line: line)
    
    XCTAssertEqual(lhs.remainderReportingOverflow(dividingBy: rhs).partialValue, remainder, file: file, line: line)
    XCTAssertEqual(lhs.remainderReportingOverflow(dividingBy: rhs).overflow,     overflow,  file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.formRemainderReportingOverflow(dividingBy: rhs); return x }(), extended, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.formRemainderReportingOverflow(dividingBy: rhs); return o }(), overflow, file: file, line: line)

    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs).partialValue.quotient,  quotient,  file: file, line: line)
    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs).partialValue.remainder, remainder, file: file, line: line)
    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs).overflow,               overflow,  file: file, line: line)
}
