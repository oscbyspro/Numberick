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

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Division x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnDivisionAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividing() {
        NBKAssertDivision(T( ), T(1), T( ), T( ))
        NBKAssertDivision(T( ), T(2), T( ), T( ))
        NBKAssertDivision(T(7), T(1), T(7), T( ))
        NBKAssertDivision(T(7), T(2), T(3), T(1))
    }
    
    func testDividingReportingOverflow() {
        NBKAssertDivision(T( ), T( ), T( ), T( ), true)
        NBKAssertDivision(T(1), T( ), T(1), T(1), true)
        NBKAssertDivision(T(2), T( ), T(2), T(2), true)
    }
    
    func testDividingWithLargeDividend() {
        NBKAssertDivision(T(x64:[~2,  ~4,  ~6,  9] as X64), T(2), T(x64:[~1, ~2, ~3, 4] as X64), T(1))
        NBKAssertDivision(T(x64:[~3,  ~6,  ~9, 14] as X64), T(3), T(x64:[~1, ~2, ~3, 4] as X64), T(2))
        NBKAssertDivision(T(x64:[~4,  ~8, ~12, 19] as X64), T(4), T(x64:[~1, ~2, ~3, 4] as X64), T(3))
        NBKAssertDivision(T(x64:[~5, ~10, ~15, 24] as X64), T(5), T(x64:[~1, ~2, ~3, 4] as X64), T(4))
        
        NBKAssertDivision(T(x64:[~2,  ~4,  ~6,  9] as X64), T(x64:[~1, ~2, ~3, 4] as X64), T(2), T(1))
        NBKAssertDivision(T(x64:[~3,  ~6,  ~9, 14] as X64), T(x64:[~1, ~2, ~3, 4] as X64), T(3), T(2))
        NBKAssertDivision(T(x64:[~4,  ~8, ~12, 19] as X64), T(x64:[~1, ~2, ~3, 4] as X64), T(4), T(3))
        NBKAssertDivision(T(x64:[~5, ~10, ~15, 24] as X64), T(x64:[~1, ~2, ~3, 4] as X64), T(5), T(4))
    }
    
    func testDividingWithLargeDivisor() {
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X64), T(x64:[ 3,  4,  5,  6 &+ 1 << 63] as X64), T(0), T(x64:[1, 2, 3, 4 + 1 << 63] as X64))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X64), T(x64:[ 2,  3,  4,  5 &+ 1 << 63] as X64), T(0), T(x64:[1, 2, 3, 4 + 1 << 63] as X64))

        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X64), T(x64:[ 1,  2,  3,  4 &+ 1 << 63] as X64), T(1), T(x64:[0, 0, 0, 0] as X64))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X64), T(x64:[ 0,  1,  2,  3 &+ 1 << 63] as X64), T(1), T(x64:[1, 1, 1, 1] as X64))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X64), T(x64:[~0, ~0,  0,  2 &+ 1 << 63] as X64), T(1), T(x64:[2, 2, 2, 2] as X64))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X64), T(x64:[~1, ~1, ~0,  0 &+ 1 << 63] as X64), T(1), T(x64:[3, 3, 3, 3] as X64))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X64), T(x64:[~2, ~2, ~1, ~0 &+ 1 << 63] as X64), T(1), T(x64:[4, 4, 4, 4] as X64))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X64), T(x64:[~3, ~3, ~2, ~1 &+ 1 << 63] as X64), T(1), T(x64:[5, 5, 5, 5] as X64))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X64), T(x64:[~4, ~4, ~3, ~2 &+ 1 << 63] as X64), T(1), T(x64:[6, 6, 6, 6] as X64))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X64), T(x64:[~5, ~5, ~4, ~3 &+ 1 << 63] as X64), T(1), T(x64:[7, 7, 7, 7] as X64))
    }
    
    func testDividingLikeFullWidth() {
        var dividend: T
        //=--------------------------------------=
        dividend = T(words:[ 06, 17, 35, 61, 61, 52, 32, 00] as X)
        NBKAssertDivision(dividend, T(words:[ 1,  2,  3,  4] as X), T(words:[ 5,  6,  7,  8] as X), T(words:[ 1,  1,  1,  1] as X))
        NBKAssertDivision(dividend, T(words:[ 5,  6,  7,  8] as X), T(words:[ 1,  2,  3,  4] as X), T(words:[ 1,  1,  1,  1] as X))
        //=--------------------------------------=
        dividend = T(words:[ 34, 54, 63, 62, 34, 16, 05, 00] as X)
        NBKAssertDivision(dividend, T(words:[ 4,  3,  2,  1] as X), T(words:[ 9,  7,  6,  5] as X), T(words:[~1, ~1, ~0,  0] as X))
        NBKAssertDivision(dividend, T(words:[ 8,  7,  6,  5] as X), T(words:[ 4,  3,  2,  1] as X), T(words:[ 2,  2,  2,  2] as X))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit (and Self)
    //=------------------------------------------------------------------------=
    
    func testDividingByDigit() {
        NBKAssertDivisionByDigit(T( ), UInt(1), T( ), UInt( ))
        NBKAssertDivisionByDigit(T( ), UInt(2), T( ), UInt( ))
        NBKAssertDivisionByDigit(T(7), UInt(1), T(7), UInt( ))
        NBKAssertDivisionByDigit(T(7), UInt(2), T(3), UInt(1))
    }
    
    func testDividingByDigitReportingOverflow() {
        NBKAssertDivisionByDigit(T( ), UInt( ), T( ), UInt( ), true)
        NBKAssertDivisionByDigit(T(1), UInt( ), T(1), UInt(1), true)
        NBKAssertDivisionByDigit(T(2), UInt( ), T(2), UInt(2), true)
    }
    
    func testDividingByDigitWithLargeDividend() {
        NBKAssertDivisionByDigit(T(words:[~2,  ~4,  ~6,  9] as X), UInt(2), T(words:[~1, ~2, ~3, 4] as X), UInt(1))
        NBKAssertDivisionByDigit(T(words:[~3,  ~6,  ~9, 14] as X), UInt(3), T(words:[~1, ~2, ~3, 4] as X), UInt(2))
        NBKAssertDivisionByDigit(T(words:[~4,  ~8, ~12, 19] as X), UInt(4), T(words:[~1, ~2, ~3, 4] as X), UInt(3))
        NBKAssertDivisionByDigit(T(words:[~5, ~10, ~15, 24] as X), UInt(5), T(words:[~1, ~2, ~3, 4] as X), UInt(4))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x /= 0)
            XCTAssertNotNil(x %= 0)
            XCTAssertNotNil(x.divideReportingOverflow(by: 0))
            XCTAssertNotNil(x.formRemainderReportingOverflow(dividingBy: 0))
            
            XCTAssertNotNil(x /  0)
            XCTAssertNotNil(x %  0)
            XCTAssertNotNil(x.dividedReportingOverflow(by: 0))
            XCTAssertNotNil(x.remainderReportingOverflow(dividingBy: 0))
            XCTAssertNotNil(x.quotientAndRemainder(dividingBy: 0))
            XCTAssertNotNil(x.quotientAndRemainderReportingOverflow(dividingBy: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Division x UIntXL x Code Coverage
//*============================================================================*

final class NBKFlexibleWidthTestsOnDivisionCodeCoverageAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividingFullWidth3212MSBAsUInt256() {
        var dividend: T, divisor: T, quotient: T, remainder: T
        //=--------------------------------------=
        dividend  = T(x64:[ 0,  0,  0,  0,  0, ~0, ~0, ~0] as X64)
        divisor   = T(x64:[~0, ~0, ~0, ~0,  0,  0,  0,  0] as X64)
        quotient  = T(x64:[ 0, ~0, ~0, ~0,  0,  0,  0,  0] as X64)
        remainder = T(x64:[ 0, ~0, ~0, ~0,  0,  0,  0,  0] as X64)
        NBKAssertDivision(dividend, divisor, quotient, remainder)
        //=--------------------------------------=
        dividend  = T(x64:[~0, ~0, ~0, ~0,  0, ~0, ~0, ~0] as X64)
        divisor   = T(x64:[~0, ~0, ~0, ~0,  0,  0,  0,  0] as X64)
        quotient  = T(x64:[ 1, ~0, ~0, ~0,  0,  0,  0,  0] as X64)
        remainder = T(x64:[ 0, ~0, ~0, ~0,  0,  0,  0,  0] as X64)
        NBKAssertDivision(dividend, divisor, quotient, remainder)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Division x Assertions
//*============================================================================*

private func NBKAssertDivision<T: IntXLOrUIntXL>(
_ dividend: T, _ divisor: T, _ quotient: T, _ remainder: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(dividend, quotient * divisor + remainder, "dividend != divisor * quotient + remainder", file: file, line: line)
    }
    
    if !overflow {
        XCTAssertEqual(dividend / divisor, quotient,  file: file, line: line)
        XCTAssertEqual(dividend % divisor, remainder, file: file, line: line)
    }
    
    if !overflow {
        XCTAssertEqual({ var lhs = dividend; lhs /= divisor; return lhs }(), quotient,  file: file, line: line)
        XCTAssertEqual({ var lhs = dividend; lhs %= divisor; return lhs }(), remainder, file: file, line: line)
    }
    
    if !overflow {
        let out = dividend.quotientAndRemainder(dividingBy: divisor)
        XCTAssertEqual(out.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(out.remainder, remainder, file: file, line: line)
    }
    
    brr: do {
        let out = dividend.dividedReportingOverflow(by: divisor)
        XCTAssertEqual(out.partialValue, quotient, file: file, line: line)
        XCTAssertEqual(out.overflow,     overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = dividend
        let out = lhs.divideReportingOverflow(by: divisor)
        XCTAssertEqual(lhs, quotient, file: file, line: line)
        XCTAssertEqual(out, overflow, file: file, line: line)
    }
    
    brr: do {
        let out = dividend.remainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(out.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(out.overflow,     overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = dividend
        let out = lhs.formRemainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(lhs, remainder, file: file, line: line)
        XCTAssertEqual(out, overflow,  file: file, line: line)
    }
    
    brr: do {
        let pvo = dividend.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(pvo.partialValue.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(pvo.partialValue.remainder, remainder, file: file, line: line)
        XCTAssertEqual(pvo.overflow,               overflow,  file: file, line: line)
    }
}

private func NBKAssertDivisionByDigit<T: IntXLOrUIntXL>(
_ dividend: T, _ divisor: T.Digit, _ quotient: T, _ remainder: T.Digit, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let extended = T(digit: remainder)
    //=------------------------------------------=
    NBKAssertDivision(dividend, T(digit: divisor), quotient, T(digit: remainder), overflow, file: file, line: line)
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(dividend, quotient * divisor + remainder, "dividend != divisor * quotient + remainder", file: file, line: line)
    }
    
    if !overflow {
        XCTAssertEqual(dividend / divisor, quotient,  file: file, line: line)
        XCTAssertEqual(dividend % divisor, remainder, file: file, line: line)
    }
    
    if !overflow {
        XCTAssertEqual({ var lhs = dividend; lhs /= divisor; return lhs }(), quotient, file: file, line: line)
        XCTAssertEqual({ var lhs = dividend; lhs %= divisor; return lhs }(), extended, file: file, line: line)
    }
    
    if !overflow {
        let out = dividend.quotientAndRemainder(dividingBy: divisor)
        XCTAssertEqual(out.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(out.remainder, remainder, file: file, line: line)
    }
    
    brr: do {
        let out = dividend.dividedReportingOverflow(by: divisor)
        XCTAssertEqual(out.partialValue, quotient, file: file, line: line)
        XCTAssertEqual(out.overflow,     overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = dividend
        let out = lhs.divideReportingOverflow(by: divisor)
        XCTAssertEqual(lhs, quotient, file: file, line: line)
        XCTAssertEqual(out, overflow, file: file, line: line)
    }
    
    brr: do {
        let out = dividend.remainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(out.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(out.overflow,     overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = dividend
        let out = lhs.formRemainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(lhs, extended, file: file, line: line)
        XCTAssertEqual(out, overflow, file: file, line: line)
    }
    
    brr: do {
        let pvo = dividend.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(pvo.partialValue.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(pvo.partialValue.remainder, remainder, file: file, line: line)
        XCTAssertEqual(pvo.overflow,               overflow,  file: file, line: line)
    }
    
    guard 
    let dividend  = dividend  as? UIntXL,
    let divisor   = divisor   as? UInt,
    let quotient  = quotient  as? UIntXL,
    let remainder = remainder as? UInt 
    else { return precondition(T.isSigned) }
    
    brr: do {
        var lhs = dividend
        let pvo = lhs.formQuotientWithRemainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(lhs,              quotient,  file: file, line: line)
        XCTAssertEqual(pvo.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(pvo.overflow,     overflow,  file: file, line: line)
    }
}
