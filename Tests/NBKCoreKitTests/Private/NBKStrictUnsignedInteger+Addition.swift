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
// MARK: * NBK x Strict Unsigned Integer x Addition x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnAdditionAsSubSequence: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddingLargeToLarge() {
        NBKAssertSubSequenceAddition([ 0,  0,  0,  0] as X, [ 0,  0,  0,  0] as X, false, [ 0,  0,  0,  0] as X)
        NBKAssertSubSequenceAddition([ 0,  0,  0,  0] as X, [ 0,  0,  0,  0] as X, true,  [ 1,  0,  0,  0] as X)
        NBKAssertSubSequenceAddition([ 0,  0,  0,  0] as X, [ 1,  0,  0,  0] as X, false, [ 1,  0,  0,  0] as X)
        NBKAssertSubSequenceAddition([ 0,  0,  0,  0] as X, [ 1,  0,  0,  0] as X, true,  [ 2,  0,  0,  0] as X)
        
        NBKAssertSubSequenceAddition([~0, ~0, ~0, ~0] as X, [ 0,  0,  0,  0] as X, false, [~0, ~0, ~0, ~0] as X)
        NBKAssertSubSequenceAddition([~0, ~0, ~0, ~0] as X, [ 0,  0,  0,  0] as X, true,  [ 0,  0,  0,  0] as X, true)
        NBKAssertSubSequenceAddition([~0, ~0, ~0, ~0] as X, [ 1,  0,  0,  0] as X, false, [ 0,  0,  0,  0] as X, true)
        NBKAssertSubSequenceAddition([~0, ~0, ~0, ~0] as X, [ 1,  0,  0,  0] as X, true,  [ 1,  0,  0,  0] as X, true)
        
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [ 4,  0,  0,  0] as X, false, [ 4,  1,  2,  3] as X)
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [ 0,  4,  0,  0] as X, false, [ 0,  5,  2,  3] as X)
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [ 0,  0,  4,  0] as X, false, [ 0,  1,  6,  3] as X)
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [ 0,  0,  0,  4] as X, false, [ 0,  1,  2,  7] as X)
        
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [ 4,  0,  0,  0] as X, true,  [ 5,  1,  2,  3] as X)
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [ 0,  4,  0,  0] as X, true,  [ 1,  5,  2,  3] as X)
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [ 0,  0,  4,  0] as X, true,  [ 1,  1,  6,  3] as X)
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [ 0,  0,  0,  4] as X, true,  [ 1,  1,  2,  7] as X)
        
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [~4, ~0, ~0, ~0] as X, false, [~4,  0,  2,  3] as X, true)
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [~0, ~4, ~0, ~0] as X, false, [~0, ~3,  1,  3] as X, true)
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [~0, ~0, ~4, ~0] as X, false, [~0,  0, ~1,  2] as X, true)
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [~0, ~0, ~0, ~4] as X, false, [~0,  0,  2, ~0] as X)

        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [~4, ~0, ~0, ~0] as X, true,  [~3,  0,  2,  3] as X, true)
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [~0, ~4, ~0, ~0] as X, true,  [ 0, ~2,  1,  3] as X, true)
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [~0, ~0, ~4, ~0] as X, true,  [ 0,  1, ~1,  2] as X, true)
        NBKAssertSubSequenceAddition([ 0,  1,  2,  3] as X, [~0, ~0, ~0, ~4] as X, true,  [ 0,  1,  2, ~0] as X)
        
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [ 4,  0,  0,  0] as X, false, [ 3, ~0, ~2, ~3] as X)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [ 0,  4,  0,  0] as X, false, [~0,  2, ~1, ~3] as X)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [ 0,  0,  4,  0] as X, false, [~0, ~1,  1, ~2] as X)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [ 0,  0,  0,  4] as X, false, [~0, ~1, ~2,  0] as X, true)

        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [ 4,  0,  0,  0] as X, true,  [ 4, ~0, ~2, ~3] as X)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [ 0,  4,  0,  0] as X, true,  [ 0,  3, ~1, ~3] as X)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [ 0,  0,  4,  0] as X, true,  [ 0, ~0,  1, ~2] as X)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [ 0,  0,  0,  4] as X, true,  [ 0, ~0, ~2,  0] as X, true)
        
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [~4, ~0, ~0, ~0] as X, false, [~5, ~1, ~2, ~3] as X, true)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [~0, ~4, ~0, ~0] as X, false, [~1, ~5, ~2, ~3] as X, true)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [~0, ~0, ~4, ~0] as X, false, [~1, ~1, ~6, ~3] as X, true)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [~0, ~0, ~0, ~4] as X, false, [~1, ~1, ~2, ~7] as X, true)

        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [~4, ~0, ~0, ~0] as X, true,  [~4, ~1, ~2, ~3] as X, true)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [~0, ~4, ~0, ~0] as X, true,  [~0, ~5, ~2, ~3] as X, true)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [~0, ~0, ~4, ~0] as X, true,  [~0, ~1, ~6, ~3] as X, true)
        NBKAssertSubSequenceAddition([~0, ~1, ~2, ~3] as X, [~0, ~0, ~0, ~4] as X, true,  [~0, ~1, ~2, ~7] as X, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small (and Large)
    //=------------------------------------------------------------------------=
    
    func testAddingSmallToLarge() {
        NBKAssertSubSequenceAdditionByDigit([ 0,  0,  0,  0] as X, UInt.min, false, [ 0,  0,  0,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0,  0,  0,  0] as X, UInt.min, false, [~0,  0,  0,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0,  0,  0] as X, UInt.min, false, [~0, ~0,  0,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0, ~0,  0] as X, UInt.min, false, [~0, ~0, ~0,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0, ~0, ~0] as X, UInt.min, false, [~0, ~0, ~0, ~0] as X)
        
        NBKAssertSubSequenceAdditionByDigit([ 0,  0,  0,  0] as X, UInt.min, true,  [ 1,  0,  0,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0,  0,  0,  0] as X, UInt.min, true,  [ 0,  1,  0,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0,  0,  0] as X, UInt.min, true,  [ 0,  0,  1,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0, ~0,  0] as X, UInt.min, true,  [ 0,  0,  0,  1] as X)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0, ~0, ~0] as X, UInt.min, true,  [ 0,  0,  0,  0] as X, true)
        
        NBKAssertSubSequenceAdditionByDigit([ 0,  0,  0,  0] as X, UInt.max, false, [~0,  0,  0,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0,  0,  0,  0] as X, UInt.max, false, [~1,  1,  0,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0,  0,  0] as X, UInt.max, false, [~1,  0,  1,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0, ~0,  0] as X, UInt.max, false, [~1,  0,  0,  1] as X)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0, ~0, ~0] as X, UInt.max, false, [~1,  0,  0,  0] as X, true)
        
        NBKAssertSubSequenceAdditionByDigit([ 0,  0,  0,  0] as X, UInt.max, true,  [ 0,  1,  0,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0,  0,  0,  0] as X, UInt.max, true,  [~0,  1,  0,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0,  0,  0] as X, UInt.max, true,  [~0,  0,  1,  0] as X)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0, ~0,  0] as X, UInt.max, true,  [~0,  0,  0,  1] as X)
        NBKAssertSubSequenceAdditionByDigit([~0, ~0, ~0, ~0] as X, UInt.max, true,  [~0,  0,  0,  0] as X, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Product
    //=------------------------------------------------------------------------=
    
    func testAddingProduct() {
        NBKAssertSubSequenceAdditionByProduct([ 0    ] as X, [ ] as X, UInt( ), UInt(0), [ 0    ] as X)
        NBKAssertSubSequenceAdditionByProduct([ 0    ] as X, [ ] as X, UInt( ), UInt(1), [ 1    ] as X)
        NBKAssertSubSequenceAdditionByProduct([~0    ] as X, [ ] as X, UInt( ), UInt(0), [~0    ] as X)
        NBKAssertSubSequenceAdditionByProduct([~0    ] as X, [ ] as X, UInt( ), UInt(1), [ 0    ] as X, true)
        
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as X, [0] as X, UInt( ), UInt(0), [ 0,  0] as X)
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as X, [0] as X, UInt( ), UInt(1), [ 1,  0] as X)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as X, [0] as X, UInt( ), UInt(0), [~0, ~0] as X)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as X, [0] as X, UInt( ), UInt(1), [ 0,  0] as X, true)
        
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as X, [2] as X, UInt(0), UInt(0), [ 0,  0] as X)
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as X, [2] as X, UInt(0), UInt(1), [ 1,  0] as X)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as X, [2] as X, UInt(0), UInt(0), [~0, ~0] as X)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as X, [2] as X, UInt(0), UInt(1), [ 0,  0] as X, true)
        
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as X, [0] as X, UInt(3), UInt(0), [ 0,  0] as X)
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as X, [0] as X, UInt(3), UInt(1), [ 1,  0] as X)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as X, [0] as X, UInt(3), UInt(0), [~0, ~0] as X)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as X, [0] as X, UInt(3), UInt(1), [ 0,  0] as X, true)
        
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as X, [2] as X, UInt(3), UInt(0), [ 6,  0] as X)
        NBKAssertSubSequenceAdditionByProduct([ 0,  0] as X, [2] as X, UInt(3), UInt(1), [ 7,  0] as X)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as X, [2] as X, UInt(3), UInt(0), [ 5,  0] as X, true)
        NBKAssertSubSequenceAdditionByProduct([~0, ~0] as X, [2] as X, UInt(3), UInt(1), [ 6,  0] as X, true)
    }
    
    func testAddingProductReportingOverflow() {
        var lhs: X, rhs: X
        //=--------------------------------------=
        lhs = [ 0,  0,  0,  0,  0,  0,  0,  0] as X; rhs = [ 1,  2,  3,  4] as X
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt(  ), [ 2,  4,  6,  8,  0,  0,  0,  0] as X)
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt.max, [ 1,  5,  6,  8,  0,  0,  0,  0] as X)
        //=--------------------------------------=
        lhs = [ 0,  0,  0,  0,  0,  0,  0,  0] as X; rhs = [~1, ~2, ~3, ~4] as X
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt(  ), [~3, ~4, ~6, ~8,  1,  0,  0,  0] as X)
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt.max, [~4, ~3, ~6, ~8,  1,  0,  0,  0] as X)
        //=--------------------------------------=
        lhs = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as X; rhs = [ 1,  2,  3,  4] as X
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt(  ), [ 1,  4,  6,  8,  0,  0,  0,  0] as X, true)
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt.max, [ 0,  5,  6,  8,  0,  0,  0,  0] as X, true)
        //=--------------------------------------=
        lhs = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as X; rhs = [~1, ~2, ~3, ~4] as X
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt(  ), [~4, ~4, ~6, ~8,  1,  0,  0,  0] as X, true)
        NBKAssertSubSequenceAdditionByProduct(lhs, rhs, UInt(2), UInt.max, [~5, ~3, ~6, ~8,  1,  0,  0,  0] as X, true)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Addition x Assertions
//*============================================================================*

private func NBKAssertSubSequenceAddition(
_ lhs: [UInt], _ rhs: [UInt], _ bit: Bool, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    // increment: elements + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.increment(&lhs,  by: rhs,   plus: bit)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.incrementInIntersection(&lhs, by: rhs,  plus: bit)
        let max = T.increment(&lhs[min.index...], by: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = T.incrementInIntersection(&lhs, by: rhs,  plus: bit)
        let sfx = Array(repeating: UInt.zero,  count: lhs[min.index... ].count)
        let max = T.increment(&lhs[min.index...], by: sfx,  plus: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
}

private func NBKAssertSubSequenceAdditionByDigit(
_ lhs: [UInt], _ rhs: UInt, _ bit: Bool, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    NBKAssertSubSequenceAddition(lhs, [rhs], bit, result, overflow, file: file, line: line)
    //=------------------------------------------=
    // increment: digit
    //=------------------------------------------=
    if !bit {
        var lhs = lhs
        let max = T.increment(&lhs,  by: rhs)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    if !bit {
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
        let max = T.increment(&lhs,  by: rhs,   plus: bit)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.incrementInIntersection(&lhs, by: rhs, plus: bit)
        let max = T.increment(&lhs[min.index...], by: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = T.incrementInIntersection(&lhs, by: rhs,  plus: bit)
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
