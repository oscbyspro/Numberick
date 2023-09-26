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
        NBKAssertDivisionByDigitInRange([ ] as W, UInt(1), 0 ..< 0, [ ] as W, UInt( ))
        NBKAssertDivisionByDigitInRange([ ] as W, UInt(2), 0 ..< 0, [ ] as W, UInt( ))
        NBKAssertDivisionByDigitInRange([0] as W, UInt(1), 0 ..< 1, [0] as W, UInt( ))
        NBKAssertDivisionByDigitInRange([0] as W, UInt(2), 0 ..< 1, [0] as W, UInt( ))
        NBKAssertDivisionByDigitInRange([7] as W, UInt(1), 0 ..< 1, [7] as W, UInt( ))
        NBKAssertDivisionByDigitInRange([7] as W, UInt(2), 0 ..< 1, [3] as W, UInt(1))
    }
    
    func testDividingSmallBySmallReportingOverflow() {
        NBKAssertDivisionByDigitInRange([ ] as W, UInt( ), 0 ..< 0, [ ] as W, UInt( ), true)
        NBKAssertDivisionByDigitInRange([0] as W, UInt( ), 0 ..< 1, [0] as W, UInt( ), true)
        NBKAssertDivisionByDigitInRange([1] as W, UInt( ), 0 ..< 1, [1] as W, UInt(1), true)
        NBKAssertDivisionByDigitInRange([2] as W, UInt( ), 0 ..< 1, [2] as W, UInt(2), true)
    }
    
    func testDividingLargeBySmallWithLargeQuotient() {
        NBKAssertDivisionByDigitInRange([~2,  ~4,  ~6,  9] as W, UInt(2), 0 ..< 0, [~2,  ~4/1,  ~6/1,  9] as W, UInt(0))
        NBKAssertDivisionByDigitInRange([~3,  ~6,  ~9, 14] as W, UInt(3), 0 ..< 0, [~3,  ~6/1,  ~9/1, 14] as W, UInt(0))
        NBKAssertDivisionByDigitInRange([~4,  ~8, ~12, 19] as W, UInt(4), 0 ..< 0, [~4,  ~8/1, ~12/1, 19] as W, UInt(0))
        NBKAssertDivisionByDigitInRange([~5, ~10, ~15, 24] as W, UInt(5), 0 ..< 0, [~5, ~10/1, ~15/1, 24] as W, UInt(0))
        
        NBKAssertDivisionByDigitInRange([~2,  ~4,  ~6,  9] as W, UInt(2), 1 ..< 3, [~2,  ~2/1,  ~6/2,  9] as W, UInt(1))
        NBKAssertDivisionByDigitInRange([~3,  ~6,  ~9, 14] as W, UInt(3), 1 ..< 3, [~3,  ~6/3,  ~9/3, 14] as W, UInt(0))
        NBKAssertDivisionByDigitInRange([~4,  ~8, ~12, 19] as W, UInt(4), 1 ..< 3, [~4,  ~2/1, ~12/4, 19] as W, UInt(3))
        NBKAssertDivisionByDigitInRange([~5, ~10, ~15, 24] as W, UInt(5), 1 ..< 3, [~5, ~10/5, ~15/5, 24] as W, UInt(0))
        
        NBKAssertDivisionByDigitInRange([~2,  ~4,  ~6,  9] as W, UInt(2), 0 ..< 4, [~1,  ~2/1,  ~3/1,  4] as W, UInt(1))
        NBKAssertDivisionByDigitInRange([~3,  ~6,  ~9, 14] as W, UInt(3), 0 ..< 4, [~1,  ~2/1,  ~3/1,  4] as W, UInt(2))
        NBKAssertDivisionByDigitInRange([~4,  ~8, ~12, 19] as W, UInt(4), 0 ..< 4, [~1,  ~2/1,  ~3/1,  4] as W, UInt(3))
        NBKAssertDivisionByDigitInRange([~5, ~10, ~15, 24] as W, UInt(5), 0 ..< 4, [~1,  ~2/1,  ~3/1,  4] as W, UInt(4))
    }
    
    func testDividingLargeBySmallReportingOverflow() {
        NBKAssertDivisionByDigitInRange([1, 2, 3, 4] as W, UInt( ), 0 ..< 4, [1, 2, 3, 4] as W, UInt(1), true)
        NBKAssertDivisionByDigitInRange([1, 2, 3, 4] as W, UInt( ), 0 ..< 3, [1, 2, 3, 4] as W, UInt(1), true)
        NBKAssertDivisionByDigitInRange([1, 2, 3, 4] as W, UInt( ), 0 ..< 2, [1, 2, 3, 4] as W, UInt(1), true)
        NBKAssertDivisionByDigitInRange([1, 2, 3, 4] as W, UInt( ), 0 ..< 1, [1, 2, 3, 4] as W, UInt(1), true)
        NBKAssertDivisionByDigitInRange([1, 2, 3, 4] as W, UInt( ), 0 ..< 0, [1, 2, 3, 4] as W, UInt( ), true)
        
        NBKAssertDivisionByDigitInRange([1, 2, 3, 4] as W, UInt( ), 0 ..< 4, [1, 2, 3, 4] as W, UInt(1), true)
        NBKAssertDivisionByDigitInRange([1, 2, 3, 4] as W, UInt( ), 1 ..< 4, [1, 2, 3, 4] as W, UInt(2), true)
        NBKAssertDivisionByDigitInRange([1, 2, 3, 4] as W, UInt( ), 2 ..< 4, [1, 2, 3, 4] as W, UInt(3), true)
        NBKAssertDivisionByDigitInRange([1, 2, 3, 4] as W, UInt( ), 3 ..< 4, [1, 2, 3, 4] as W, UInt(4), true)
        NBKAssertDivisionByDigitInRange([1, 2, 3, 4] as W, UInt( ), 4 ..< 4, [1, 2, 3, 4] as W, UInt( ), true)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Division x Assertions
//*============================================================================*

private func NBKAssertDivisionByDigitInRange(
_ lhs: [UInt], _ rhs: UInt, _ range: Range<Int>, _ quotient: [UInt], _ remainder: UInt, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictUnsignedInteger<[UInt]>.SubSequence
    //=------------------------------------------=
    brrrrrrrrrrr: do {
        let pvo = T.remainderReportingOverflow(lhs, dividingBy: rhs, in: range)
        XCTAssertEqual(pvo.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(pvo.overflow,     overflow,  file: file, line: line)
    }
    
    brrrrrrrrrrr: do {
        var lhs = lhs
        let pvo = T.formQuotientWithRemainderReportingOverflow(&lhs, dividingBy: rhs, in: range)
        XCTAssertEqual(lhs,              quotient,  file: file, line: line)
        XCTAssertEqual(pvo.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(pvo.overflow,     overflow,  file: file, line: line)
    }
    
    if  range  == lhs.indices {
        let pvo = T.remainderReportingOverflow(lhs, dividingBy: rhs)
        XCTAssertEqual(pvo.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(pvo.overflow,     overflow,  file: file, line: line)
    }
    
    if  range  == lhs.indices {
        var lhs = lhs
        let pvo = T.formQuotientWithRemainderReportingOverflow(&lhs, dividingBy: rhs)
        XCTAssertEqual(lhs,              quotient,  file: file, line: line)
        XCTAssertEqual(pvo.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(pvo.overflow,     overflow,  file: file, line: line)
    }
}

#endif
