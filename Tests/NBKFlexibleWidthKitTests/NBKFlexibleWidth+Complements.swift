//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Complements x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnComplementsAsUIntXL: XCTestCase {

    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        XCTAssertEqual(T(words:[ 1,  0,  0,  0] as W).magnitude, M(words:[ 1,  0,  0,  0] as W))
        XCTAssertEqual(T(words:[~0,  0,  0,  0] as W).magnitude, M(words:[~0,  0,  0,  0] as W))
        XCTAssertEqual(T(words:[ 1,  1,  1,  1] as W).magnitude, M(words:[ 1,  1,  1,  1] as W))
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as W).magnitude, M(words:[~0, ~0, ~0, ~0] as W))
        
        XCTAssertEqual(T(magnitude: M(words:[ 1,  0,  0,  0] as W)), M(words:[ 1,  0,  0,  0] as W))
        XCTAssertEqual(T(magnitude: M(words:[~0,  0,  0,  0] as W)), M(words:[~0,  0,  0,  0] as W))
        XCTAssertEqual(T(magnitude: M(words:[ 1,  1,  1,  1] as W)), M(words:[ 1,  1,  1,  1] as W))
        XCTAssertEqual(T(magnitude: M(words:[~0, ~0, ~0, ~0] as W)), M(words:[~0, ~0, ~0, ~0] as W))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x One's Complement
    //=------------------------------------------------------------------------=
    
    func testOnesComplement() {
        NBKAssertOnesComplement(T(words:[ 0,  0,  0,  0] as W), T(words:[~0,  0,  0,  0] as W))
        NBKAssertOnesComplement(T(words:[ 1,  0,  0,  0] as W), T(words:[~1,  0,  0,  0] as W))
        NBKAssertOnesComplement(T(words:[~0,  0,  0,  0] as W), T(words:[ 0,  0,  0,  0] as W))
        NBKAssertOnesComplement(T(words:[ 1,  1,  1,  1] as W), T(words:[~1, ~1, ~1, ~1] as W))
        NBKAssertOnesComplement(T(words:[~0, ~0, ~0, ~0] as W), T(words:[ 0,  0,  0,  0] as W))
        
        NBKAssertOnesComplement(T(words:[~0, ~0, ~0, ~0/2 + 0] as W), T(words:[ 0,  0,  0, ~0/2 + 1] as W))
        NBKAssertOnesComplement(T(words:[ 0,  0,  0, ~0/2 + 1] as W), T(words:[~0, ~0, ~0, ~0/2 + 0] as W))
        NBKAssertOnesComplement(T(words:[ 1,  0,  0, ~0/2 + 1] as W), T(words:[~1, ~0, ~0, ~0/2 + 0] as W))

        NBKAssertOnesComplement(T(words:[ 1,  0,  0, ~0/2 + 1] as W), T(words:[~1, ~0, ~0, ~0/2 + 0] as W))
        NBKAssertOnesComplement(T(words:[ 0,  0,  0, ~0/2 + 1] as W), T(words:[~0, ~0, ~0, ~0/2 + 0] as W))
        NBKAssertOnesComplement(T(words:[~0, ~0, ~0, ~0/2 + 0] as W), T(words:[ 0,  0,  0, ~0/2 + 1] as W))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        NBKAssertTwosComplement(T(words:[ 0,  0,  0,  0] as W), T(words:[ 0,  0,  0,  0] as W), true)
        NBKAssertTwosComplement(T(words:[ 1,  0,  0,  0] as W), T(words:[~0,  0,  0,  0] as W))
        NBKAssertTwosComplement(T(words:[~0,  0,  0,  0] as W), T(words:[ 1,  0,  0,  0] as W))
        NBKAssertTwosComplement(T(words:[ 1,  1,  1,  1] as W), T(words:[~0, ~1, ~1, ~1] as W))
        NBKAssertTwosComplement(T(words:[~0, ~0, ~0, ~0] as W), T(words:[ 1,  0,  0,  0] as W))
        
        NBKAssertTwosComplement(T(words:[~0, ~0, ~0, ~0/2 + 0] as W), T(words:[ 1,  0,  0, ~0/2 + 1] as W))
        NBKAssertTwosComplement(T(words:[ 0,  0,  0, ~0/2 + 1] as W), T(words:[ 0,  0,  0, ~0/2 + 1] as W))
        NBKAssertTwosComplement(T(words:[ 1,  0,  0, ~0/2 + 1] as W), T(words:[~0, ~0, ~0, ~0/2 + 0] as W))

        NBKAssertTwosComplement(T(words:[ 1,  0,  0, ~0/2 + 1] as W), T(words:[~0, ~0, ~0, ~0/2 + 0] as W))
        NBKAssertTwosComplement(T(words:[ 0,  0,  0, ~0/2 + 1] as W), T(words:[ 0,  0,  0, ~0/2 + 1] as W))
        NBKAssertTwosComplement(T(words:[~0, ~0, ~0, ~0/2 + 0] as W), T(words:[ 1,  0,  0, ~0/2 + 1] as W))
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Complements x Assertions
//*============================================================================*

private func NBKAssertOnesComplement<T: NBKBinaryInteger>(
_ integer: T, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(integer.onesComplement(),                              result, file: file, line: line)
    XCTAssertEqual(integer.twosComplementSubsequence(false).partialValue, result, file: file, line: line)
    
    XCTAssertEqual({ var x = integer; let _ = x.formOnesComplement();                  return x }(), result, file: file, line: line)
    XCTAssertEqual({ var x = integer; let _ = x.formTwosComplementSubsequence(false);  return x }(), result, file: file, line: line)
}

private func NBKAssertTwosComplement<T: NBKBinaryInteger>(
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

#endif
