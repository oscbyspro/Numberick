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
// MARK: * NBK x Assert x Subtraction
//*============================================================================*

func NBKAssertSubtraction<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs: T, _ index: Int, _ partialValue: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow, index.isZero {
        XCTAssertEqual(                 lhs -  rhs,                 partialValue, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs -= rhs; return lhs }(), partialValue, file: file, line: line)
        
        XCTAssertEqual(lhs.subtracting(rhs, at: Int.zero), partialValue, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.subtract(rhs, at: Int.zero); return lhs }(), partialValue, file: file, line: line)
    }
    //=------------------------------------------=
    guard let lhs = lhs as? UIntXL, let rhs = rhs as? UIntXL, let partialValue = partialValue as? UIntXL else { return }
    //=------------------------------------------=
    XCTAssertEqual(lhs.subtractingReportingOverflow(rhs, at: index).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(lhs.subtractingReportingOverflow(rhs, at: index).overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.subtractReportingOverflow(rhs, at: index); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.subtractReportingOverflow(rhs, at: index); return o }(), overflow,     file: file, line: line)
}

func NBKAssertSubtractionByDigit<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs: T.Digit, _ index: Int, _ partialValue: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow, index.isZero {
        XCTAssertEqual(                 lhs -  rhs,                 partialValue, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs -= rhs; return lhs }(), partialValue, file: file, line: line)
        
        XCTAssertEqual(lhs.subtracting(rhs, at: Int.zero), partialValue, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.subtract(rhs, at: Int.zero); return lhs }(), partialValue, file: file, line: line)
    }
    //=------------------------------------------=
    guard let lhs = lhs as? UIntXL, let rhs = rhs as? UIntXL.Digit, let partialValue = partialValue as? UIntXL else { return }
    //=------------------------------------------=
    XCTAssertEqual(lhs.subtractingReportingOverflow(rhs, at: index).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(lhs.subtractingReportingOverflow(rhs, at: index).overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.subtractReportingOverflow(rhs, at: index); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.subtractReportingOverflow(rhs, at: index); return o }(), overflow,     file: file, line: line)
}
