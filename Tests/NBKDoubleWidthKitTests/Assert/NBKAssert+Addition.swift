//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Assert x Addition
//*============================================================================*

func NBKAssertAddition<T: NBKFixedWidthInteger>(
_ lhs: T, _ rhs: T, _ partialValue: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(                 lhs +  rhs,                 partialValue, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs += rhs; return lhs }(), partialValue, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(                 lhs &+  rhs,                  partialValue, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &+= rhs; return lhs }(),  partialValue, file: file, line: line)
        
    XCTAssertEqual(lhs.addingReportingOverflow(rhs).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(lhs.addingReportingOverflow(rhs).overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.addReportingOverflow(rhs); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.addReportingOverflow(rhs); return o }(), overflow,     file: file, line: line)
}

func NBKAssertAdditionByDigit<T: NBKFixedWidthInteger>(
_ lhs: T, _ rhs: T.Digit, _ partialValue: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(                 lhs +  rhs,                 partialValue, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs += rhs; return lhs }(), partialValue, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(                 lhs &+  rhs,                  partialValue, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &+= rhs; return lhs }(),  partialValue, file: file, line: line)
        
    XCTAssertEqual(lhs.addingReportingOverflow(rhs).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(lhs.addingReportingOverflow(rhs).overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.addReportingOverflow(rhs); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.addReportingOverflow(rhs); return o }(), overflow,     file: file, line: line)
}
