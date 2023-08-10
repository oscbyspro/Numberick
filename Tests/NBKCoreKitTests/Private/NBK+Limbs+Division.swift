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
// MARK: * NBK x Limbs x Division x Digit x Unsigned
//*============================================================================*

final class NBKTestsOnLimbsByDivisionByDigitAsUnsigned: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividingByDigit() {
        NBKAssertDivisionByDigit([ ] as W, UInt(1), [ ] as W, UInt( ))
        NBKAssertDivisionByDigit([ ] as W, UInt(2), [ ] as W, UInt( ))
        NBKAssertDivisionByDigit([7] as W, UInt(1), [7] as W, UInt( ))
        NBKAssertDivisionByDigit([7] as W, UInt(2), [3] as W, UInt(1))
    }
    
    func testDividingByDigitReportingOverflow() {
        NBKAssertDivisionByDigit([ ] as W, UInt( ), [ ] as W, UInt( ), true)
        NBKAssertDivisionByDigit([1] as W, UInt( ), [1] as W, UInt(1), true)
        NBKAssertDivisionByDigit([2] as W, UInt( ), [2] as W, UInt(2), true)
    }
    
    func testDividingByDigitWithLargeDividend() {
        NBKAssertDivisionByDigit([~2,  ~4,  ~6,  9] as W, UInt(2), [~1, ~2, ~3, 4] as W, UInt(1))
        NBKAssertDivisionByDigit([~3,  ~6,  ~9, 14] as W, UInt(3), [~1, ~2, ~3, 4] as W, UInt(2))
        NBKAssertDivisionByDigit([~4,  ~8, ~12, 19] as W, UInt(4), [~1, ~2, ~3, 4] as W, UInt(3))
        NBKAssertDivisionByDigit([~5, ~10, ~15, 24] as W, UInt(5), [~1, ~2, ~3, 4] as W, UInt(4))
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Division x Assertions
//*============================================================================*

private func NBKAssertDivisionByDigit<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: [T], _ rhs: T, _ quotient: [T], _ remainder: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    brrrrrrrrrrr: do {
        var lhs = lhs
        let pvo = NBK.formQuotientWithRemainderReportingOverflowAsLenientUnsignedInteger(&lhs, dividingBy: rhs)
        XCTAssertEqual(lhs,              quotient,  file: file, line: line)
        XCTAssertEqual(pvo.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(pvo.overflow,     overflow,  file: file, line: line)
    }
}

#endif
