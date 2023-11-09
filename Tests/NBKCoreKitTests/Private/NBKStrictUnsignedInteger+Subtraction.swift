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
// MARK: * NBK x Strict Unsigned Integer x Subtraction x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnSubtractionAsSubSequence: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtractingLargeFromLarge() {
        NBKAssertSubSequenceSubtraction([ 0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, false, [ 0,  0,  0,  0] as W)
        NBKAssertSubSequenceSubtraction([ 0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, true,  [~0, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtraction([ 0,  0,  0,  0] as W, [ 1,  0,  0,  0] as W, false, [~0, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtraction([ 0,  0,  0,  0] as W, [ 1,  0,  0,  0] as W, true,  [~1, ~0, ~0, ~0] as W, true)
        
        NBKAssertSubSequenceSubtraction([~0, ~0, ~0, ~0] as W, [ 0,  0,  0,  0] as W, false, [~0, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceSubtraction([~0, ~0, ~0, ~0] as W, [ 0,  0,  0,  0] as W, true,  [~1, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceSubtraction([~0, ~0, ~0, ~0] as W, [ 1,  0,  0,  0] as W, false, [~1, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceSubtraction([~0, ~0, ~0, ~0] as W, [ 1,  0,  0,  0] as W, true,  [~2, ~0, ~0, ~0] as W)
        
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [ 4,  0,  0,  0] as W, false, [~3,  0,  2,  3] as W)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [ 0,  4,  0,  0] as W, false, [ 0, ~2,  1,  3] as W)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [ 0,  0,  4,  0] as W, false, [ 0,  1, ~1,  2] as W)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [ 0,  0,  0,  4] as W, false, [ 0,  1,  2, ~0] as W, true)
        
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [ 4,  0,  0,  0] as W, true,  [~4,  0,  2,  3] as W)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [ 0,  4,  0,  0] as W, true,  [~0, ~3,  1,  3] as W)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [ 0,  0,  4,  0] as W, true,  [~0,  0, ~1,  2] as W)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [ 0,  0,  0,  4] as W, true,  [~0,  0,  2, ~0] as W, true)
        
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [~4, ~0, ~0, ~0] as W, false, [ 5,  1,  2,  3] as W, true)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [~0, ~4, ~0, ~0] as W, false, [ 1,  5,  2,  3] as W, true)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [~0, ~0, ~4, ~0] as W, false, [ 1,  1,  6,  3] as W, true)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [~0, ~0, ~0, ~4] as W, false, [ 1,  1,  2,  7] as W, true)
        
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [~4, ~0, ~0, ~0] as W, true,  [ 4,  1,  2,  3] as W, true)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [~0, ~4, ~0, ~0] as W, true,  [ 0,  5,  2,  3] as W, true)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [~0, ~0, ~4, ~0] as W, true,  [ 0,  1,  6,  3] as W, true)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [~0, ~0, ~0, ~4] as W, true,  [ 0,  1,  2,  7] as W, true)
        
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [ 4,  0,  0,  0] as W, false, [~4, ~1, ~2, ~3] as W)
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [ 0,  4,  0,  0] as W, false, [~0, ~5, ~2, ~3] as W)
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [ 0,  0,  4,  0] as W, false, [~0, ~1, ~6, ~3] as W)
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [ 0,  0,  0,  4] as W, false, [~0, ~1, ~2, ~7] as W)
        
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [ 4,  0,  0,  0] as W, true,  [~5, ~1, ~2, ~3] as W)
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [ 0,  4,  0,  0] as W, true,  [~1, ~5, ~2, ~3] as W)
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [ 0,  0,  4,  0] as W, true,  [~1, ~1, ~6, ~3] as W)
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [ 0,  0,  0,  4] as W, true,  [~1, ~1, ~2, ~7] as W)
        
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [~4, ~0, ~0, ~0] as W, false, [ 4, ~0, ~2, ~3] as W, true)
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [~0, ~4, ~0, ~0] as W, false, [ 0,  3, ~1, ~3] as W, true)
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [~0, ~0, ~4, ~0] as W, false, [ 0, ~0,  1, ~2] as W, true)
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [~0, ~0, ~0, ~4] as W, false, [ 0, ~0, ~2,  0] as W)
        
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [~4, ~0, ~0, ~0] as W, true,  [ 3, ~0, ~2, ~3] as W, true)
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [~0, ~4, ~0, ~0] as W, true,  [~0,  2, ~1, ~3] as W, true)
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [~0, ~0, ~4, ~0] as W, true,  [~0, ~1,  1, ~2] as W, true)
        NBKAssertSubSequenceSubtraction([~0, ~1, ~2, ~3] as W, [~0, ~0, ~0, ~4] as W, true,  [~0, ~1, ~2,  0] as W)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small (and Large)
    //=------------------------------------------------------------------------=
    
    func testSubtractingSmallFromLarge() {
        NBKAssertSubSequenceSubtractionByDigit([~0, ~0, ~0, ~0] as W, UInt.min, false, [~0, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0, ~0, ~0, ~0] as W, UInt.min, false, [ 0, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0, ~0, ~0] as W, UInt.min, false, [ 0,  0, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0,  0, ~0] as W, UInt.min, false, [ 0,  0,  0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0,  0,  0] as W, UInt.min, false, [ 0,  0,  0,  0] as W)
        
        NBKAssertSubSequenceSubtractionByDigit([~0, ~0, ~0, ~0] as W, UInt.min, true,  [~1, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0, ~0, ~0, ~0] as W, UInt.min, true,  [~0, ~1, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0, ~0, ~0] as W, UInt.min, true,  [~0, ~0, ~1, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0,  0, ~0] as W, UInt.min, true,  [~0, ~0, ~0, ~1] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0,  0,  0] as W, UInt.min, true,  [~0, ~0, ~0, ~0] as W, true)
        
        NBKAssertSubSequenceSubtractionByDigit([~0, ~0, ~0, ~0] as W, UInt.max, false, [ 0, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0, ~0, ~0, ~0] as W, UInt.max, false, [ 1, ~1, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0, ~0, ~0] as W, UInt.max, false, [ 1, ~0, ~1, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0,  0, ~0] as W, UInt.max, false, [ 1, ~0, ~0, ~1] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0,  0,  0] as W, UInt.max, false, [ 1, ~0, ~0, ~0] as W, true)
        
        NBKAssertSubSequenceSubtractionByDigit([~0, ~0, ~0, ~0] as W, UInt.max, true,  [~0, ~1, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0, ~0, ~0, ~0] as W, UInt.max, true,  [ 0, ~1, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0, ~0, ~0] as W, UInt.max, true,  [ 0, ~0, ~1, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0,  0, ~0] as W, UInt.max, true,  [ 0, ~0, ~0, ~1] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0,  0,  0] as W, UInt.max, true,  [ 0, ~0, ~0, ~0] as W, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Product
    //=------------------------------------------------------------------------=
    
    func testSubtractingProduct() {
        NBKAssertSubSequenceSubtractionByProduct([ 0    ] as W, [ ] as W, UInt( ), UInt(0), [ 0    ] as W)
        NBKAssertSubSequenceSubtractionByProduct([ 0    ] as W, [ ] as W, UInt( ), UInt(1), [~0    ] as W, true)
        NBKAssertSubSequenceSubtractionByProduct([~0    ] as W, [ ] as W, UInt( ), UInt(0), [~0    ] as W)
        NBKAssertSubSequenceSubtractionByProduct([~0    ] as W, [ ] as W, UInt( ), UInt(1), [~1    ] as W)
        
        NBKAssertSubSequenceSubtractionByProduct([ 0,  0] as W, [0] as W, UInt( ), UInt(0), [ 0,  0] as W)
        NBKAssertSubSequenceSubtractionByProduct([ 0,  0] as W, [0] as W, UInt( ), UInt(1), [~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProduct([~0, ~0] as W, [0] as W, UInt( ), UInt(0), [~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByProduct([~0, ~0] as W, [0] as W, UInt( ), UInt(1), [~1, ~0] as W)
        
        NBKAssertSubSequenceSubtractionByProduct([ 0,  0] as W, [2] as W, UInt(0), UInt(0), [ 0,  0] as W)
        NBKAssertSubSequenceSubtractionByProduct([ 0,  0] as W, [2] as W, UInt(0), UInt(1), [~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProduct([~0, ~0] as W, [2] as W, UInt(0), UInt(0), [~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByProduct([~0, ~0] as W, [2] as W, UInt(0), UInt(1), [~1, ~0] as W)
        
        NBKAssertSubSequenceSubtractionByProduct([ 0,  0] as W, [0] as W, UInt(3), UInt(0), [ 0,  0] as W)
        NBKAssertSubSequenceSubtractionByProduct([ 0,  0] as W, [0] as W, UInt(3), UInt(1), [~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProduct([~0, ~0] as W, [0] as W, UInt(3), UInt(0), [~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByProduct([~0, ~0] as W, [0] as W, UInt(3), UInt(1), [~1, ~0] as W)
        
        NBKAssertSubSequenceSubtractionByProduct([ 0,  0] as W, [2] as W, UInt(3), UInt(0), [~5, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProduct([ 0,  0] as W, [2] as W, UInt(3), UInt(1), [~6, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProduct([~0, ~0] as W, [2] as W, UInt(3), UInt(0), [~6, ~0] as W)
        NBKAssertSubSequenceSubtractionByProduct([~0, ~0] as W, [2] as W, UInt(3), UInt(1), [~7, ~0] as W)
    }
    
    func testSubtractingProductReportingOverflow() {
        var lhs: W, rhs: W
        //=--------------------------------------=
        lhs = [ 0,  0,  0,  0,  0,  0,  0,  0] as W;  rhs = [ 1,  2,  3,  4] as W
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt(  ), [~1, ~4, ~6, ~8, ~0, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt.max, [~0, ~5, ~6, ~8, ~0, ~0, ~0, ~0] as W, true)
        //=--------------------------------------=
        lhs = [ 0,  0,  0,  0,  0,  0,  0,  0] as W;  rhs = [~1, ~2, ~3, ~4] as W
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt(  ), [ 4,  4,  6,  8, ~1, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt.max, [ 5,  3,  6,  8, ~1, ~0, ~0, ~0] as W, true)
        //=--------------------------------------=
        lhs = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as W;  rhs = [ 1,  2,  3,  4] as W
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt( ),  [~2, ~4, ~6, ~8, ~0, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt.max, [~1, ~5, ~6, ~8, ~0, ~0, ~0, ~0] as W)
        //=--------------------------------------=
        lhs = [~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as W;  rhs = [~1, ~2, ~3, ~4] as W
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt(  ), [ 3,  4,  6,  8, ~1, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt.max, [ 4,  3,  6,  8, ~1, ~0, ~0, ~0] as W)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Subtraction x Assertions
//*============================================================================*

private func NBKAssertSubSequenceSubtraction(
_ lhs: [UInt], _ rhs: [UInt], _ bit: Bool, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    // decrement: elements + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.decrement(&lhs,  by: rhs,   plus: bit)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.decrementInIntersection(&lhs, by: rhs,  plus: bit)
        let max = T.decrement(&lhs[min.index...], by: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = T.decrementInIntersection(&lhs, by: rhs,  plus: bit)
        let sfx = Array(repeating: UInt.zero,  count: lhs[min.index... ].count)
        let max = T.decrement(&lhs[min.index...], by: sfx,  plus: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
}

private func NBKAssertSubSequenceSubtractionByDigit(
_ lhs: [UInt], _ rhs: UInt, _ bit: Bool, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    NBKAssertSubSequenceSubtraction(lhs, [rhs], bit, result, overflow, file: file, line: line)
    //=------------------------------------------=
    // decrement: digit
    //=------------------------------------------=
    if !bit {
        var lhs = lhs
        let max = T.decrement(&lhs,  by: rhs)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    if !bit {
        var lhs = lhs
        let min = T.decrementInIntersection(&lhs, by: rhs)
        let max = T.decrement(&lhs[min.index...], by: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    //=------------------------------------------=
    // decrement: digit + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.decrement(&lhs,  by: rhs,   plus: bit)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.decrementInIntersection(&lhs, by: rhs,  plus: bit)
        let max = T.decrement(&lhs[min.index...], by: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = T.decrementInIntersection(&lhs, by: rhs,  plus: bit)
        let sfx = Array(repeating: UInt.zero,  count: lhs[min.index... ].count)
        let max = T.decrement(&lhs[min.index...], by: sfx,  plus: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
}

private func NBKAssertSubSequenceSubtractionByProduct(
_ lhs: [UInt], _ rhs: [UInt], _ multiplier: UInt, _ digit: UInt, _ product: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    // decrement: elements × digit + digit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.decrement(&lhs,  by: rhs,  times: multiplier, plus: digit)
        XCTAssertEqual(lhs,          product,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.decrementInIntersection(&lhs, by: rhs, times: multiplier, plus: digit)
        let max = T.decrement(&lhs[min.index...], by: min.overflow)
        XCTAssertEqual(lhs,          product,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
}

#endif
