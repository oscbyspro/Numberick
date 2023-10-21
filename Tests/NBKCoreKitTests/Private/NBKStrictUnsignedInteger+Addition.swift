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
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Product
    //=------------------------------------------------------------------------=
    
    func testAddingProduct() {
        NBKAssertSubSequenceAdditionByProduct([ 0    ] as W, [ ] as W, UInt( ), UInt(0), [ 0    ] as W)
        NBKAssertSubSequenceAdditionByProduct([ 0    ] as W, [ ] as W, UInt( ), UInt(1), [ 1    ] as W)
        NBKAssertSubSequenceAdditionByProduct([~0    ] as W, [ ] as W, UInt( ), UInt(0), [~0    ] as W)
        NBKAssertSubSequenceAdditionByProduct([~0    ] as W, [ ] as W, UInt( ), UInt(1), [ 0    ] as W, true)
        
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as W, [0] as W, UInt( ), UInt(0), [ 0,  0] as W)
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as W, [0] as W, UInt( ), UInt(1), [ 1,  0] as W)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as W, [0] as W, UInt( ), UInt(0), [~0, ~0] as W)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as W, [0] as W, UInt( ), UInt(1), [ 0,  0] as W, true)
        
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as W, [2] as W, UInt(0), UInt(0), [ 0,  0] as W)
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as W, [2] as W, UInt(0), UInt(1), [ 1,  0] as W)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as W, [2] as W, UInt(0), UInt(0), [~0, ~0] as W)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as W, [2] as W, UInt(0), UInt(1), [ 0,  0] as W, true)
        
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as W, [0] as W, UInt(3), UInt(0), [ 0,  0] as W)
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as W, [0] as W, UInt(3), UInt(1), [ 1,  0] as W)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as W, [0] as W, UInt(3), UInt(0), [~0, ~0] as W)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as W, [0] as W, UInt(3), UInt(1), [ 0,  0] as W, true)
        
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as W, [2] as W, UInt(3), UInt(0), [ 6,  0] as W)
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as W, [2] as W, UInt(3), UInt(1), [ 7,  0] as W)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as W, [2] as W, UInt(3), UInt(0), [ 5,  0] as W, true)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as W, [2] as W, UInt(3), UInt(1), [ 6,  0] as W, true)
    }
    
    func testAddingProductReportingOverflow() {
        var lhs: W, rhs: W
        //=--------------------------------------=
        lhs = [ 0,  0,  0,  0,  0,  0,  0,  0] as W; rhs = [ 1,  2,  3,  4] as W
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt(  ), [ 2,  4,  6,  8,  0,  0,  0,  0] as W)
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt.max, [ 1,  5,  6,  8,  0,  0,  0,  0] as W)
        //=--------------------------------------=
        lhs = [ 0,  0,  0,  0,  0,  0,  0,  0] as W; rhs = [~1, ~2, ~3, ~4] as W
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt(  ), [~3, ~4, ~6, ~8,  1,  0,  0,  0] as W)
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt.max, [~4, ~3, ~6, ~8,  1,  0,  0,  0] as W)
        //=--------------------------------------=
        lhs = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as W; rhs = [ 1,  2,  3,  4] as W
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt(  ), [ 1,  4,  6,  8,  0,  0,  0,  0] as W, true)
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt.max, [ 0,  5,  6,  8,  0,  0,  0,  0] as W, true)
        //=--------------------------------------=
        lhs = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as W; rhs = [~1, ~2, ~3, ~4] as W
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt(  ), [~4, ~4, ~6, ~8,  1,  0,  0,  0] as W, true)
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt.max, [~5, ~3, ~6, ~8,  1,  0,  0,  0] as W, true)
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

private func NBKAssertSubSequenceAdditionByProduct(
_ lhs: [UInt], _ rhs: [UInt], _ multiplier: UInt, _ digit: UInt, _ product: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    // increment: elements × digit + digit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.increment(&lhs,  by: rhs,  times: multiplier, plus: digit)
        XCTAssertEqual(lhs,          product,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.incrementInIntersection(&lhs, by: rhs, times: multiplier, plus: digit)
        let max = T.increment(&lhs[min.index...], by: min.overflow)
        XCTAssertEqual(lhs,          product,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
}

#endif
