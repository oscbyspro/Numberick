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
// MARK: * NBK x Strict Unsigned Integer x Addition x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnAdditionAsSubSequence: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddingLargeToLarge() {
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as W, [3, 0, 0, 0] as W, [ 2, ~0, ~2, ~3] as W)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as W, [0, 3, 0, 0] as W, [~0,  1, ~1, ~3] as W)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as W, [0, 0, 3, 0] as W, [~0, ~1,  0, ~2] as W)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as W, [0, 0, 0, 3] as W, [~0, ~1, ~2, ~0] as W)
    }
    
    func testAddingLargeToLargeReportingOverflow() {
        NBKAssertSubSequenceAddition([~0, ~0, ~0, ~0] as W, [0, 0, 0, 0] as W, [~0, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceAddition([~0, ~0, ~0, ~0] as W, [1, 0, 0, 0] as W, [ 0,  0,  0,  0] as W, true)
        
        NBKAssertSubSequenceAddition([~3, ~2, ~1, ~0] as W, [4, 0, 0, 0] as W, [ 0, ~1, ~1, ~0] as W)
        NBKAssertSubSequenceAddition([~3, ~2, ~1, ~0] as W, [0, 4, 0, 0] as W, [~3,  1, ~0, ~0] as W)
        NBKAssertSubSequenceAddition([~3, ~2, ~1, ~0] as W, [0, 0, 4, 0] as W, [~3, ~2,  2,  0] as W, true)
        NBKAssertSubSequenceAddition([~3, ~2, ~1, ~0] as W, [0, 0, 0, 4] as W, [~3, ~2, ~1,  3] as W, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small (and Large)
    //=------------------------------------------------------------------------=
    
    func testAddingSmallToLarge() {
        NBKAssertSubSequenceAdditionByDigit([ 0,  0,  0,  0] as W, UInt(3), [ 3,  0,  0,  0] as W)
        NBKAssertSubSequenceAdditionByDigit([~0,  0,  0,  0] as W, UInt(3), [ 2,  1,  0,  0] as W)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0,  0,  0] as W, UInt(3), [ 2,  0,  1,  0] as W)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0, ~0,  0] as W, UInt(3), [ 2,  0,  0,  1] as W)
    }
    
    func testAddingSmallToLargeReportingOverflow() {
        NBKAssertSubSequenceAdditionByDigit([~0, ~0, ~0, ~0] as W, UInt(0), [~0, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0, ~0, ~0] as W, UInt(1), [ 0,  0,  0,  0] as W, true)
        NBKAssertSubSequenceAdditionByDigit([~3, ~2, ~1, ~0] as W, UInt(4), [ 0, ~1, ~1, ~0] as W)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Addition x Assertions
//*============================================================================*

private func NBKAssertSubSequenceAddition(
_ lhs: [UInt], _ rhs: [UInt], _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    // increment: elements + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.increment(&lhs,  by: rhs,   plus: false)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.incrementInIntersection(&lhs, by: rhs,  plus: false)
        let max = T.increment(&lhs[min.index...], by: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = T.incrementInIntersection(&lhs, by: rhs,  plus: false)
        let sfx = Array(repeating: UInt.zero,  count: lhs[min.index... ].count)
        let max = T.increment(&lhs[min.index...], by: sfx,  plus: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
}

private func NBKAssertSubSequenceAdditionByDigit(
_ lhs: [UInt], _ rhs: UInt, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    NBKAssertSubSequenceAddition(lhs, [rhs], result, overflow, file: file, line: line)
    //=------------------------------------------=
    // increment: digit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.increment(&lhs,  by: rhs)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.incrementInIntersection(&lhs, by: rhs)
        let max = T.increment(&lhs[min.index...], by: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    //=------------------------------------------=
    // increment: digit + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.increment(&lhs,  by: rhs,   plus: false)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.incrementInIntersection(&lhs, by: rhs, plus: false)
        let max = T.increment(&lhs[min.index...], by: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = T.incrementInIntersection(&lhs, by: rhs,  plus: false)
        let sfx = Array(repeating: UInt.zero,  count: lhs[min.index... ].count)
        let max = T.increment(&lhs[min.index...], by: sfx,  plus: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
}

#endif
