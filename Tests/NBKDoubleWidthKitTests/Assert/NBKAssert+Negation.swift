//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Assert x Negation
//*============================================================================*

func NBKAssertNegation<T: NBKFixedWidthInteger & NBKSignedInteger>(
_ operand: T, _ partialValue: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(-operand,                                    partialValue, file: file, line: line)
        XCTAssertEqual((operand).negated(),                         partialValue, file: file, line: line)
        XCTAssertEqual({ var x = operand; x.negate(); return x }(), partialValue, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(operand.negatedReportingOverflow().partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(operand.negatedReportingOverflow().overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = operand; let _ = x.negateReportingOverflow(); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = operand; let o = x.negateReportingOverflow(); return o }(), overflow,     file: file, line: line)
}
