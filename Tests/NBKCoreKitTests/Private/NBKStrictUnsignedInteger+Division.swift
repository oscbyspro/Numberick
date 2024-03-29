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

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Division x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnDivisionAsSubSequence: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small
    //=------------------------------------------------------------------------=
    
    func testDividingSmallBySmall() {
        NBKAssertDivisionByDigit([ ] as X, UInt(1), [ ] as X, UInt( ))
        NBKAssertDivisionByDigit([ ] as X, UInt(2), [ ] as X, UInt( ))
        NBKAssertDivisionByDigit([0] as X, UInt(1), [0] as X, UInt( ))
        NBKAssertDivisionByDigit([0] as X, UInt(2), [0] as X, UInt( ))
        NBKAssertDivisionByDigit([7] as X, UInt(1), [7] as X, UInt( ))
        NBKAssertDivisionByDigit([7] as X, UInt(2), [3] as X, UInt(1))
    }
    
    func testDividingSmallBySmallReportingOverflow() {
        NBKAssertDivisionByDigit([ ] as X, UInt( ), [ ] as X, UInt( ), true)
        NBKAssertDivisionByDigit([0] as X, UInt( ), [0] as X, UInt( ), true)
        NBKAssertDivisionByDigit([1] as X, UInt( ), [1] as X, UInt(1), true)
        NBKAssertDivisionByDigit([2] as X, UInt( ), [2] as X, UInt(2), true)
    }
    
    func testDividingLargeBySmallWithLargeQuotient() {
        NBKAssertDivisionByDigit([~2,  ~4,  ~6,  9] as X, UInt(2), [~1,  ~2/1,  ~3/1,  4] as X, UInt(1))
        NBKAssertDivisionByDigit([~3,  ~6,  ~9, 14] as X, UInt(3), [~1,  ~2/1,  ~3/1,  4] as X, UInt(2))
        NBKAssertDivisionByDigit([~4,  ~8, ~12, 19] as X, UInt(4), [~1,  ~2/1,  ~3/1,  4] as X, UInt(3))
        NBKAssertDivisionByDigit([~5, ~10, ~15, 24] as X, UInt(5), [~1,  ~2/1,  ~3/1,  4] as X, UInt(4))
    }
    
    func testDividingLargeBySmallReportingOverflow() {
        NBKAssertDivisionByDigit([1, 2, 3, 4] as X, UInt( ), [1, 2, 3, 4] as X, UInt(1), true)
        NBKAssertDivisionByDigit([1, 2, 3, 4] as X, UInt( ), [1, 2, 3, 4] as X, UInt(1), true)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Division x Assertions
//*============================================================================*

private func NBKAssertDivisionByDigitWithNonZeroDivisor(
_ lhs: [UInt], _ rhs: NBK.NonZero<UInt>, _ quotient: [UInt], _ remainder: UInt, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    brr: do {
        let rem = T.remainder(dividing: lhs, by: rhs)
        XCTAssertEqual(rem, remainder, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let rem = T.formQuotientWithRemainder(dividing:  &lhs, by: rhs)
        XCTAssertEqual(lhs, quotient,  file: file, line: line)
        XCTAssertEqual(rem, remainder, file: file, line: line)
    }
}

private func NBKAssertDivisionByDigit(
_ lhs: [UInt], _ rhs: UInt, _ quotient: [UInt], _ remainder: UInt, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    if  let rhs = NBK.NonZero(exactly: rhs) {
        NBKAssertDivisionByDigitWithNonZeroDivisor(lhs, rhs, quotient, remainder, overflow, file: file, line: line)
    }
    //=------------------------------------------=
    brr: do {
        let pvo = T.remainderReportingOverflow(dividing:  lhs,  by: rhs)
        XCTAssertEqual(pvo.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(pvo.overflow,     overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let pvo = T.formQuotientWithRemainderReportingOverflow(dividing: &lhs, by: rhs)
        XCTAssertEqual(lhs,              quotient,  file: file, line: line)
        XCTAssertEqual(pvo.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(pvo.overflow,     overflow,  file: file, line: line)
    }
}
