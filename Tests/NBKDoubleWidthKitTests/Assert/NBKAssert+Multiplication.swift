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
// MARK: * NBK x Assert x Multiplication
//*============================================================================*

func NBKAssertMultiplication<T: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<T>, _ rhs:  NBKDoubleWidth<T>,
_ low: NBKDoubleWidth<T>, _ high: NBKDoubleWidth<T>? = nil, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    let high = high ?? NBKDoubleWidth<T>(repeating: low.isLessThanZero)
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(                 lhs *  rhs,                 low, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs *= rhs; return lhs }(), low, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(                 lhs &*  rhs,                 low, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &*= rhs; return lhs }(), low, file: file, line: line)
        
    XCTAssertEqual(lhs.multipliedReportingOverflow(by: rhs).partialValue, low,      file: file, line: line)
    XCTAssertEqual(lhs.multipliedReportingOverflow(by: rhs).overflow,     overflow, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.multiplyReportingOverflow(by: rhs); return x }(), low,      file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.multiplyReportingOverflow(by: rhs); return o }(), overflow, file: file, line: line)
    
    XCTAssertEqual(NBKDoubleWidth<T>(bitPattern: lhs.multipliedFullWidth(by: rhs).low), low,  file: file, line: line)
    XCTAssertEqual(/*---------*/ lhs.multipliedFullWidth(by: rhs).high, high, file: file, line: line)

    XCTAssertEqual({ var x = lhs; let _ = x.multiplyFullWidth(by: rhs); return x }(), low,  file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.multiplyFullWidth(by: rhs); return o }(), high, file: file, line: line)
}

func NBKAssertMultiplicationByDigit<T: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<T>, _ rhs:  NBKDoubleWidth<T>.Digit,
_ low: NBKDoubleWidth<T>, _ high: NBKDoubleWidth<T>.Digit? = nil, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    let high = high ?? NBKDoubleWidth<T>.Digit(repeating: low.isLessThanZero)
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(                 lhs *  rhs,                 low, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs *= rhs; return lhs }(), low, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(                 lhs &*  rhs,                 low, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &*= rhs; return lhs }(), low, file: file, line: line)
        
    XCTAssertEqual(lhs.multipliedReportingOverflow(by: rhs).partialValue, low,      file: file, line: line)
    XCTAssertEqual(lhs.multipliedReportingOverflow(by: rhs).overflow,     overflow, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.multiplyReportingOverflow(by: rhs); return x }(), low,      file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.multiplyReportingOverflow(by: rhs); return o }(), overflow, file: file, line: line)
    
    XCTAssertEqual(NBKDoubleWidth<T>(bitPattern: lhs.multipliedFullWidth(by: rhs).low), low,  file: file, line: line)
    XCTAssertEqual(/*---------*/ lhs.multipliedFullWidth(by: rhs).high, high, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.multiplyFullWidth(by: rhs); return x }(), low,  file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.multiplyFullWidth(by: rhs); return o }(), high, file: file, line: line)
}
