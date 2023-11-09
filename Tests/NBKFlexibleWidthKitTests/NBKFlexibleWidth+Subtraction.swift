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
// MARK: * NBK x Flexible Width x Subtraction x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnSubtractionAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
        NBKAssertSubtraction(T(3), T(0), Int(0),  T(3))
        NBKAssertSubtraction(T(3), T(1), Int(0),  T(2))
        NBKAssertSubtraction(T(3), T(2), Int(0),  T(1))
        NBKAssertSubtraction(T(3), T(3), Int(0),  T(0))
    }
    
    func testSubtractingReportingOverflow() {
        NBKAssertSubtraction(T(1), T(0), Int(0), T(words:[ 1] as W))
        NBKAssertSubtraction(T(1), T(1), Int(0), T(words:[ 0] as W))
        NBKAssertSubtraction(T(1), T(2), Int(0), T(words:[~0] as W), true)
        NBKAssertSubtraction(T(1), T(3), Int(0), T(words:[~1] as W), true)
    }
    
    func testSubtractingAtIndex() {
        NBKAssertSubtraction(T(words:[~0, ~0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[~1, ~2, ~3, ~0] as W))
        NBKAssertSubtraction(T(words:[ 0, ~0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[~0, ~3, ~3, ~0] as W))
        NBKAssertSubtraction(T(words:[ 0,  0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[~0, ~2, ~4, ~0] as W))
        NBKAssertSubtraction(T(words:[ 0,  0,  0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[~0, ~2, ~3, ~1] as W))
        
        NBKAssertSubtraction(T(words:[~0, ~0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[~0, ~1, ~2, ~3] as W))
        NBKAssertSubtraction(T(words:[ 0, ~0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[ 0, ~1, ~2, ~3] as W))
        NBKAssertSubtraction(T(words:[ 0,  0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[ 0, ~0, ~3, ~3] as W))
        NBKAssertSubtraction(T(words:[ 0,  0,  0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[ 0, ~0, ~2, ~4] as W))
    }
    
    func testSubtractingAtIndexReportingOverflow() {
        NBKAssertSubtraction(T(words:[ 1,  2,  3,  0] as W), T(words:[ 4,  5,  0,  0] as W), Int(0), T(words:[~2, ~3,  2,  0] as W))
        NBKAssertSubtraction(T(words:[ 1,  2,  3,  0] as W), T(words:[ 4,  5,  0,  0] as W), Int(1), T(words:[ 1, ~1, ~2,  0] as W), true)
        NBKAssertSubtraction(T(words:[ 1,  2,  3,  0] as W), T(words:[ 4,  5,  0,  0] as W), Int(2), T(words:[ 1,  2, ~0, ~5] as W), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigit() {
        NBKAssertSubtractionByDigit(T(3), UInt(0), Int(0),  T(3))
        NBKAssertSubtractionByDigit(T(3), UInt(1), Int(0),  T(2))
        NBKAssertSubtractionByDigit(T(3), UInt(2), Int(0),  T(1))
        NBKAssertSubtractionByDigit(T(3), UInt(3), Int(0),  T(0))
    }
    
    func testSubtractingDigitReportingOverflow() {
        NBKAssertSubtractionByDigit(T(1), UInt(0), Int(0), T(words:[ 1] as W))
        NBKAssertSubtractionByDigit(T(1), UInt(1), Int(0), T(words:[ 0] as W))
        NBKAssertSubtractionByDigit(T(1), UInt(2), Int(0), T(words:[~0] as W), true)
        NBKAssertSubtractionByDigit(T(1), UInt(3), Int(0), T(words:[~1] as W), true)
    }
    
    func testSubtractingDigitAtIndex() {
        NBKAssertSubtractionByDigit(T(words:[~0, ~0, ~0, ~0] as W), UInt(3), Int(0), T(words:[~3, ~0, ~0, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0, ~0, ~0, ~0] as W), UInt(3), Int(0), T(words:[~2, ~1, ~0, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0,  0, ~0, ~0] as W), UInt(3), Int(0), T(words:[~2, ~0, ~1, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0,  0,  0, ~0] as W), UInt(3), Int(0), T(words:[~2, ~0, ~0, ~1] as W))
        
        NBKAssertSubtractionByDigit(T(words:[~0, ~0, ~0, ~0] as W), UInt(3), Int(1), T(words:[~0, ~3, ~0, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0, ~0, ~0, ~0] as W), UInt(3), Int(1), T(words:[ 0, ~3, ~0, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0,  0, ~0, ~0] as W), UInt(3), Int(1), T(words:[ 0, ~2, ~1, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0,  0,  0, ~0] as W), UInt(3), Int(1), T(words:[ 0, ~2, ~0, ~1] as W))
    }
    
    func testSubtractingDigitAtIndexReportingOverflow() {
        NBKAssertSubtractionByDigit(T(words:[ 1,  2,  3,  0] as W), UInt(5), Int(0), T(words:[~3,  1,  3,  0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 1,  2,  3,  0] as W), UInt(5), Int(1), T(words:[ 1, ~2,  2,  0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 1,  2,  3,  0] as W), UInt(5), Int(2), T(words:[ 1,  2, ~1,  0] as W), true)
        NBKAssertSubtractionByDigit(T(words:[ 1,  2,  3,  0] as W), UInt(5), Int(3), T(words:[ 1,  2,  3, ~4] as W), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  -= 0)
            XCTAssertNotNil(x.subtract(0, at: 0))
            XCTAssertNotNil(x.subtractReportingOverflow(0, at: 0))
            
            XCTAssertNotNil(x  -  0)
            XCTAssertNotNil(x.subtracting(0, at: 0))
            XCTAssertNotNil(x.subtractingReportingOverflow(0, at: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Subtraction x Assertions
//*============================================================================*

private func NBKAssertSubtraction<T: IntXLOrUIntXL>(
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
    guard let lhs = lhs as? UIntXL, let rhs = rhs as? UIntXL, let partialValue = partialValue as? UIntXL else { 
        return precondition(T.isSigned)
    }
    //=------------------------------------------=
    if  index.isZero {
        XCTAssertEqual(lhs.subtractingReportingOverflow(rhs).partialValue, partialValue, file: file, line: line)
        XCTAssertEqual(lhs.subtractingReportingOverflow(rhs).overflow,     overflow,     file: file, line: line)
        
        XCTAssertEqual({ var x = lhs; let _ = x.subtractReportingOverflow(rhs); return x }(), partialValue, file: file, line: line)
        XCTAssertEqual({ var x = lhs; let o = x.subtractReportingOverflow(rhs); return o }(), overflow,     file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs.subtractingReportingOverflow(rhs, at: index).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(lhs.subtractingReportingOverflow(rhs, at: index).overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.subtractReportingOverflow(rhs, at: index); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.subtractReportingOverflow(rhs, at: index); return o }(), overflow,     file: file, line: line)
}

private func NBKAssertSubtractionByDigit<T: IntXLOrUIntXL>(
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
    guard let lhs = lhs as? UIntXL, let rhs = rhs as? UIntXL.Digit, let partialValue = partialValue as? UIntXL else {
        return precondition(T.isSigned)
    }
    //=------------------------------------------=
    if  index.isZero {
        XCTAssertEqual(lhs.subtractingReportingOverflow(rhs).partialValue, partialValue, file: file, line: line)
        XCTAssertEqual(lhs.subtractingReportingOverflow(rhs).overflow,     overflow,     file: file, line: line)
        
        XCTAssertEqual({ var x = lhs; let _ = x.subtractReportingOverflow(rhs); return x }(), partialValue, file: file, line: line)
        XCTAssertEqual({ var x = lhs; let o = x.subtractReportingOverflow(rhs); return o }(), overflow,     file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs.subtractingReportingOverflow(rhs, at: index).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(lhs.subtractingReportingOverflow(rhs, at: index).overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.subtractReportingOverflow(rhs, at: index); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.subtractReportingOverflow(rhs, at: index); return o }(), overflow,     file: file, line: line)
}

#endif
