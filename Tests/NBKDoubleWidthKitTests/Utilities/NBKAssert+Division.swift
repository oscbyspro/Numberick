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
// MARK: * NBK x Assert x Division
//*============================================================================*

func NBKAssertDivision<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>,
_ quotient: NBKDoubleWidth<H>, _ remainder: NBKDoubleWidth<H>, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(lhs, quotient * rhs + remainder, "lhs != rhs * quotient + remainder", file: file, line: line)
    }
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
}

func NBKAssertDivisionByDigit<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>.Digit,
_ quotient: NBKDoubleWidth<H>, _ remainder: NBKDoubleWidth<H>.Digit, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    let extended = NBKDoubleWidth<H>(digit: remainder)
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(lhs, quotient * rhs + remainder, "lhs != rhs * quotient + remainder", file: file, line: line)
    }
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

//*============================================================================*
// MARK: * NBK x Assert x Division x Full Width
//*============================================================================*

func NBKAssertDivisionFullWidth<H: NBKFixedWidthInteger>(
_ lhs: HL<NBKDoubleWidth<H>, NBKDoubleWidth<H>.Magnitude>, _ rhs: NBKDoubleWidth<H>,
_ quotient: NBKDoubleWidth<H>, _ remainder: NBKDoubleWidth<H>, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    typealias T  = NBKDoubleWidth<H>
    typealias T2 = NBKDoubleWidth<T>
    //=------------------------------------------=
    let lhs = T2(descending: lhs)
    //=------------------------------------------=
    if !overflow {
        let composite = T2(descending: rhs.multipliedFullWidth(by: quotient)) + T2(remainder)
        XCTAssertEqual(lhs, composite, "lhs != rhs * quotient + remainder", file: file, line: line)
    }
    //=------------------------------------------=
    if !overflow {
        let qr: QR<T, T> = rhs.dividingFullWidth(lhs.descending)
        XCTAssertEqual(qr.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(qr.remainder, remainder, file: file, line: line)
    }
    //=------------------------------------------=
    let qro: PVO<QR<T, T>> = rhs.dividingFullWidthReportingOverflow(lhs.descending)
    XCTAssertEqual(qro.partialValue.quotient,  quotient,  file: file, line: line)
    XCTAssertEqual(qro.partialValue.remainder, remainder, file: file, line: line)
    XCTAssertEqual(qro.overflow,               overflow,  file: file, line: line)
}
