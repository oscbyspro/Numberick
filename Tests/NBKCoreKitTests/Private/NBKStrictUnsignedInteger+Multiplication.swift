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
// MARK: * NBK x Strict Unsigned Integer x Multiplication x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnMultiplicationAsSubSequence: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small
    //=------------------------------------------------------------------------=
    
    func testMultiplicationByDigitWithAdditionInRange() {
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W,  0,  0, 0 ..< 0, [~0, ~0, ~0, ~0] as W,  0)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W,  0, ~0, 0 ..< 0, [~0, ~0, ~0, ~0] as W, ~0, true)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W, ~0,  0, 0 ..< 0, [~0, ~0, ~0, ~0] as W,  0)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W, ~0, ~0, 0 ..< 0, [~0, ~0, ~0, ~0] as W, ~0, true)
        
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W,  0,  0, 0 ..< 4, [ 0,  0,  0,  0] as W,  0)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W,  0, ~0, 0 ..< 4, [~0,  0,  0,  0] as W,  0)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W, ~0,  0, 0 ..< 4, [ 1, ~0, ~0, ~0] as W, ~1, true)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W, ~0, ~0, 0 ..< 4, [ 0,  0,  0,  0] as W, ~0, true)
        
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W,  0,  0, 0 ..< 3, [ 0,  0,  0, ~0] as W,  0)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W,  0, ~0, 0 ..< 3, [~0,  0,  0, ~0] as W,  0)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W, ~0,  0, 0 ..< 3, [ 1, ~0, ~0, ~0] as W, ~1, true)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W, ~0, ~0, 0 ..< 3, [ 0,  0,  0, ~0] as W, ~0, true)
        
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W,  0,  0, 1 ..< 4, [~0,  0,  0,  0] as W,  0)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W,  0, ~0, 1 ..< 4, [~0, ~0,  0,  0] as W,  0)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W, ~0,  0, 1 ..< 4, [~0,  1, ~0, ~0] as W, ~1, true)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W, ~0, ~0, 1 ..< 4, [~0,  0,  0,  0] as W, ~0, true)
        
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W,  0,  0, 1 ..< 3, [~0,  0,  0, ~0] as W,  0)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W,  0, ~0, 1 ..< 3, [~0, ~0,  0, ~0] as W,  0)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W, ~0,  0, 1 ..< 3, [~0,  1, ~0, ~0] as W, ~1, true)
        NBKAssertMultiplicationByDigitWithAdditionInRange([~0, ~0, ~0, ~0] as W, ~0, ~0, 1 ..< 3, [~0,  0,  0, ~0] as W, ~0, true)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Multiplication x Assertions
//*============================================================================*

private func NBKAssertMultiplicationByDigitWithAdditionInRange(
    _ lhs: [UInt], _ rhs: UInt, _ addend: UInt, _ range: Range<Int>, _ product: [UInt], _ high: UInt, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictUnsignedInteger<[UInt]>.SubSequence
    //=------------------------------------------=
    // multiplication: digit + digit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let top = T.multiplyFullWidth(&lhs, by: rhs, add: addend, in: range)
        XCTAssertEqual(top > 0, overflow, file: file, line: line)
        XCTAssertEqual(lhs,     product,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let ovf = T.multiplyReportingOverflow(&lhs, by: rhs, add: addend, in: range)
        XCTAssertEqual(ovf, overflow, file: file, line: line)
        XCTAssertEqual(lhs, product,  file: file, line: line)
    }
    
    if  range.startIndex == lhs.startIndex {
        var lhs = lhs
        let top = T.multiplyFullWidth(&lhs, by: rhs, add: addend, upTo: range.upperBound)
        XCTAssertEqual(top > 0, overflow, file: file, line: line)
        XCTAssertEqual(lhs,     product,  file: file, line: line)
    }
    
    if  range.startIndex == lhs.startIndex {
        var lhs = lhs
        let ovf = T.multiplyReportingOverflow(&lhs, by: rhs, add: addend, upTo: range.upperBound)
        XCTAssertEqual(ovf, overflow, file: file, line: line)
        XCTAssertEqual(lhs, product,  file: file, line: line)
    }
    
    if  range.startIndex == lhs.startIndex, range.endIndex == lhs.endIndex {
        var lhs = lhs
        let top = T.multiplyFullWidth(&lhs, by: rhs, add: addend)
        XCTAssertEqual(top > 0, overflow, file: file, line: line)
        XCTAssertEqual(lhs,     product,  file: file, line: line)
    }
    
    if  range.startIndex == lhs.startIndex, range.endIndex == lhs.endIndex {
        var lhs = lhs
        let ovf = T.multiplyReportingOverflow(&lhs, by: rhs, add: addend)
        XCTAssertEqual(ovf, overflow, file: file, line: line)
        XCTAssertEqual(lhs, product,  file: file, line: line)
    }
}

#endif
