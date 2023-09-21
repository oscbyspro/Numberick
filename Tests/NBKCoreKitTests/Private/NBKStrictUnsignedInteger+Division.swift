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
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Division x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnDivisionAsSubSequence: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small
    //=------------------------------------------------------------------------=
    
    func testDividingSmallBySmall() {
        NBKAssertSubSequenceDivisionByDigit([0] as W, UInt(1), [0] as W, UInt( ))
        NBKAssertSubSequenceDivisionByDigit([0] as W, UInt(2), [0] as W, UInt( ))
        NBKAssertSubSequenceDivisionByDigit([7] as W, UInt(1), [7] as W, UInt( ))
        NBKAssertSubSequenceDivisionByDigit([7] as W, UInt(2), [3] as W, UInt(1))
    }
    
    func testDividingSmallBySmallReportingOverflow() {
        NBKAssertSubSequenceDivisionByDigit([0] as W, UInt( ), [0] as W, UInt( ), true)
        NBKAssertSubSequenceDivisionByDigit([1] as W, UInt( ), [1] as W, UInt(1), true)
        NBKAssertSubSequenceDivisionByDigit([2] as W, UInt( ), [2] as W, UInt(2), true)
    }
    
    func testDividingLargeBySmallWithLargeQuotient() {
        NBKAssertSubSequenceDivisionByDigit([~2,  ~4,  ~6,  9] as W, UInt(2), [~1, ~2, ~3, 4] as W, UInt(1))
        NBKAssertSubSequenceDivisionByDigit([~3,  ~6,  ~9, 14] as W, UInt(3), [~1, ~2, ~3, 4] as W, UInt(2))
        NBKAssertSubSequenceDivisionByDigit([~4,  ~8, ~12, 19] as W, UInt(4), [~1, ~2, ~3, 4] as W, UInt(3))
        NBKAssertSubSequenceDivisionByDigit([~5, ~10, ~15, 24] as W, UInt(5), [~1, ~2, ~3, 4] as W, UInt(4))
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Division x Sub Sequence x Assertions
//*============================================================================*

private func NBKAssertSubSequenceDivisionByDigit(
_ lhs: [UInt], _ rhs: UInt, _ quotient: [UInt], _ remainder: UInt, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictUnsignedInteger<[UInt]>.SubSequence
    //=------------------------------------------=
    brrrrrrrrrrr: do {
        var lhs = lhs
        let pvo = T.formQuotientWithRemainderReportingOverflow(&lhs, dividingBy: rhs)
        XCTAssertEqual(lhs,              quotient,  file: file, line: line)
        XCTAssertEqual(pvo.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(pvo.overflow,     overflow,  file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(T.remainderReportingOverflow(lhs, dividingBy: rhs).partialValue, remainder, file: file, line: line)
    XCTAssertEqual(T.remainderReportingOverflow(lhs, dividingBy: rhs).overflow,     overflow,  file: file, line: line)
}

#endif
