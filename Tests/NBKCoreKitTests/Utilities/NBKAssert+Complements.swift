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
// MARK: * NBK x Assert x Complements
//*============================================================================*

func NBKAssertBitPattern<T: NBKFixedWidthInteger>(
_ integer: T, _ bitPattern: T.BitPattern,
file: StaticString = #file, line: UInt = #line) where T.BitPattern: Equatable {
    typealias B = T.BitPattern
    //=------------------------------------------=
    XCTAssertEqual(integer   .bitPattern,  bitPattern,  file: file, line: line)
    XCTAssertEqual(integer, T(bitPattern:  bitPattern), file: file, line: line)
    XCTAssertEqual(bitPattern.bitPattern,  bitPattern,  file: file, line: line)
    XCTAssertEqual(B(bitPattern: integer), bitPattern,  file: file, line: line)
}

func NBKAssertOnesComplement<T: NBKFixedWidthInteger>(
_ integer: T, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(integer.onesComplement(),                               result, file: file, line: line)
    XCTAssertEqual(integer.twosComplementSubsequence(false).partialValue,  result, file: file, line: line)
    
    XCTAssertEqual({ var x = integer; let _ = x.formOnesComplement();                  return x }(), result, file: file, line: line)
    XCTAssertEqual({ var x = integer; let _ = x.formTwosComplementSubsequence(false);  return x }(), result, file: file, line: line)
}

func NBKAssertTwosComplement<T: NBKFixedWidthInteger>(
_ integer: T, _ partialValue: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(integer.twosComplement(),                               partialValue, file: file, line: line)
    XCTAssertEqual(integer.twosComplementReportingOverflow().partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(integer.twosComplementReportingOverflow().overflow,     overflow,     file: file, line: line)
    XCTAssertEqual(integer.twosComplementSubsequence(true  ).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(integer.twosComplementSubsequence(true  ).overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = integer;         x.formTwosComplement();                  return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = integer; let _ = x.formTwosComplementReportingOverflow(); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = integer; let o = x.formTwosComplementReportingOverflow(); return o }(), overflow,     file: file, line: line)
    XCTAssertEqual({ var x = integer; let _ = x.formTwosComplementSubsequence(true  ); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = integer; let o = x.formTwosComplementSubsequence(true  ); return o }(), overflow,     file: file, line: line)
}

func NBKAssertAdditiveInverse<T: NBKFixedWidthInteger & NBKSignedInteger>(
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
