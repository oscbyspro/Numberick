//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import XCTest
#if !COCOAPODS
import NBKCoreKit
import NBKDoubleWidthKit
#else
import Numberick
#endif

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Complements x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnComplementsAsInt256: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Pattern
    //=------------------------------------------------------------------------=
    
    func testBitPattern() {
        NBKAssertBitPattern(T(-1),  (M.max))
        NBKAssertBitPattern(T(  ),  (M.min))
        
        NBKAssertBitPattern(T.min,  (M(1) << (M.bitWidth - 1)))
        NBKAssertBitPattern(T.max, ~(M(1) << (M.bitWidth - 1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        XCTAssertEqual(T(-1).magnitude, M(1))
        XCTAssertEqual(T(  ).magnitude, M( ))
        XCTAssertEqual(T( 1).magnitude, M(1))
        
        XCTAssertEqual(T.min.magnitude,  (M(1) << (M.bitWidth - 1)))
        XCTAssertEqual(T.max.magnitude, ~(M(1) << (M.bitWidth - 1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x One's Complement
    //=------------------------------------------------------------------------=
    
    func testOneComplement() {
        NBKAssertOnesComplement(-T(1),  T(0))
        NBKAssertOnesComplement(-T( ), -T(1))
        NBKAssertOnesComplement( T( ), -T(1))
        NBKAssertOnesComplement( T(1), -T(2))
        
        NBKAssertOnesComplement(T.min, T.max)
        NBKAssertOnesComplement(T.max, T.min)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        NBKAssertTwosComplement(-T(1),  T(1))
        NBKAssertTwosComplement(-T( ),  T( ))
        NBKAssertTwosComplement( T( ), -T( ))
        NBKAssertTwosComplement( T(1), -T(1))
        
        NBKAssertTwosComplement(T.min, T.min + 0, true)
        NBKAssertTwosComplement(T.max, T.min + 1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Additive Inverse
    //=------------------------------------------------------------------------=
    
    func testAdditiveInverse() {
        NBKAssertAdditiveInverse(-T(1),  T(1))
        NBKAssertAdditiveInverse(-T( ),  T( ))
        NBKAssertAdditiveInverse( T( ), -T( ))
        NBKAssertAdditiveInverse( T(1), -T(1))
    }
    
    func testAdditiveInverseReportingOverflow() {
        NBKAssertAdditiveInverse(T.min + T( ), T.min,  true)
        NBKAssertAdditiveInverse(T.min + T(1), T.max - T( ))
        NBKAssertAdditiveInverse(T.max - T(1), T.min + T(2))
        NBKAssertAdditiveInverse(T.max - T( ), T.min + T(1))
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Complements x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnComplementsAsUInt256: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Pattern
    //=------------------------------------------------------------------------=
    
    func testBitPattern() {
        NBKAssertBitPattern(T.min, M.min)
        NBKAssertBitPattern(T.max, M.max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        XCTAssertEqual(T(  ).magnitude, M(  ))
        XCTAssertEqual(T( 1).magnitude, M( 1))
        
        XCTAssertEqual(T.min.magnitude, M.min)
        XCTAssertEqual(T.max.magnitude, M.max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x One's Complement
    //=------------------------------------------------------------------------=
    
    func testOneComplement() {
        NBKAssertOnesComplement(T(  ), T.max - 0)
        NBKAssertOnesComplement(T( 1), T.max - 1)
        NBKAssertOnesComplement(T( 2), T.max - 2)
        NBKAssertOnesComplement(T( 3), T.max - 3)
        
        NBKAssertOnesComplement(T.min, T.max + 0)
        NBKAssertOnesComplement(T.max, T.min + 0)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        NBKAssertTwosComplement(T(  ), T.min - 0, true)
        NBKAssertTwosComplement(T( 1), T.max - 0)
        NBKAssertTwosComplement(T( 2), T.max - 1)
        NBKAssertTwosComplement(T( 3), T.max - 2)
        
        NBKAssertTwosComplement(T.min, T.min + 0, true)
        NBKAssertTwosComplement(T.max, T.min + 1)
    }
}


//*============================================================================*
// MARK: * NBK x Double Width x Complements x Assertions
//*============================================================================*

private func NBKAssertBitPattern<H: NBKFixedWidthInteger>(
_ integer: NBKDoubleWidth<H>, _ bitPattern: NBKDoubleWidth<H>.BitPattern,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKDoubleWidth<H>
    typealias B = NBKDoubleWidth<H>.BitPattern
    //=------------------------------------------=
    XCTAssertEqual(integer   .bitPattern,  bitPattern,  file: file, line: line)
    XCTAssertEqual(integer, T(bitPattern:  bitPattern), file: file, line: line)
    XCTAssertEqual(bitPattern.bitPattern,  bitPattern,  file: file, line: line)
    XCTAssertEqual(B(bitPattern: integer), bitPattern,  file: file, line: line)
}

private func NBKAssertBitPattern<T: NBKFixedWidthInteger>(
_ integer: T, _ bitPattern: T.BitPattern,
file: StaticString = #file, line: UInt = #line) where T.BitPattern: Equatable {
    XCTAssertEqual(integer   .bitPattern, bitPattern,  file: file, line: line)
    XCTAssertEqual(integer, T(bitPattern: bitPattern), file: file, line: line)
    XCTAssertEqual(bitPattern.bitPattern, bitPattern,  file: file, line: line)
    XCTAssertEqual(T.BitPattern(bitPattern:  integer), bitPattern, file: file, line: line)
}

private func NBKAssertOnesComplement<H: NBKFixedWidthInteger>(
_ integer: NBKDoubleWidth<H>, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(integer.onesComplement(),                               result, file: file, line: line)
    XCTAssertEqual(integer.twosComplementSubsequence(false).partialValue,  result, file: file, line: line)
    
    XCTAssertEqual({ var x = integer; let _ = x.formOnesComplement();                  return x }(), result, file: file, line: line)
    XCTAssertEqual({ var x = integer; let _ = x.formTwosComplementSubsequence(false);  return x }(), result, file: file, line: line)
}

private func NBKAssertTwosComplement<H: NBKFixedWidthInteger>(
_ integer: NBKDoubleWidth<H>, _ partialValue: NBKDoubleWidth<H>, _ overflow: Bool = false,
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

private func NBKAssertAdditiveInverse<H: NBKFixedWidthInteger & NBKSignedInteger>(
_ operand: NBKDoubleWidth<H>, _ partialValue: NBKDoubleWidth<H>, _ overflow: Bool = false,
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

#endif
