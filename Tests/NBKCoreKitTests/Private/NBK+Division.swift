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
// MARK: * NBK x Division x Int or UInt
//*============================================================================*

final class NBKTestsOnDivisionAsIntOrUInt: XCTestCase {
    
    typealias T = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let bitWidth = T(T.bitWidth)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividingByBitWidth() {
        NBKAssertDividingByBitWidthAsIntOrUInt(T(0) * bitWidth + T(0), T(0), T(0))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(0) * bitWidth + T(1), T(0), T(1))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(0) * bitWidth + T(2), T(0), T(2))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(0) * bitWidth + T(3), T(0), T(3))
        
        NBKAssertDividingByBitWidthAsIntOrUInt(T(1) * bitWidth + T(0), T(1), T(0))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(1) * bitWidth + T(1), T(1), T(1))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(1) * bitWidth + T(2), T(1), T(2))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(1) * bitWidth + T(3), T(1), T(3))
        
        NBKAssertDividingByBitWidthAsIntOrUInt(T(2) * bitWidth + T(0), T(2), T(0))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(2) * bitWidth + T(1), T(2), T(1))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(2) * bitWidth + T(2), T(2), T(2))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(2) * bitWidth + T(3), T(2), T(3))
        
        NBKAssertDividingByBitWidthAsIntOrUInt(T.min, T.min / bitWidth, T.min % bitWidth)
        NBKAssertDividingByBitWidthAsIntOrUInt(T.max, T.max / bitWidth, T.max % bitWidth)
    }
}

//*============================================================================*
// MARK: * NBK x Division x Digit x Unsigned
//*============================================================================*

final class NBKTestsOnDivisionByDigitAsUnsigned: XCTestCase {
    
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
// MARK: * NBK x Division x Assertions
//*============================================================================*

private func NBKAssertDividingByBitWidthAsIntOrUInt(
_ value: UInt, _ quotient: UInt, _ remainder: UInt,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(NBK .quotientDividingByBitWidth(value), quotient,  file: file, line: line)
    XCTAssertEqual(NBK.remainderDividingByBitWidth(value), remainder, file: file, line: line)
    //=------------------------------------------=
    if  let value = Int(exactly: value), let quotient = Int(exactly: quotient), let remainder = Int(exactly: remainder) {
        XCTAssertEqual(NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(value), quotient,  file: file, line: line)
        XCTAssertEqual(NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(value), remainder, file: file, line: line)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Digit
//=----------------------------------------------------------------------------=

private func NBKAssertDivisionByDigit<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: [T], _ rhs: T, _ quotient: [T], _ remainder: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    formQuotientWithRemainderReportingOverflowAsLenientUnsignedInteger: do {
        var lhs = lhs
        let pvo = NBK.formQuotientWithRemainderReportingOverflowAsLenientUnsignedInteger(&lhs, dividingBy: rhs)
        XCTAssertEqual(lhs,              quotient,  file: file, line: line)
        XCTAssertEqual(pvo.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(pvo.overflow,     overflow,  file: file, line: line)
    }
}

#endif
