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
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [3, 0, 0, 0] as W, [~2,  0,  2,  3] as W)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [0, 3, 0, 0] as W, [ 0, ~1,  1,  3] as W)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [0, 0, 3, 0] as W, [ 0,  1, ~0,  2] as W)
        NBKAssertSubSequenceSubtraction([ 0,  1,  2,  3] as W, [0, 0, 0, 3] as W, [ 0,  1,  2,  0] as W)
    }
    
    func testSubtractingLargeFromLargeReportingOverflow() {
        NBKAssertSubSequenceSubtraction([ 0,  0,  0,  0] as W, [0, 0, 0, 0] as W, [ 0,  0,  0,  0] as W)
        NBKAssertSubSequenceSubtraction([ 0,  0,  0,  0] as W, [1, 0, 0, 0] as W, [~0, ~0, ~0, ~0] as W, true)
        
        NBKAssertSubSequenceSubtraction([ 3,  2,  1,  0] as W, [4, 0, 0, 0] as W, [~0,  1,  1,  0] as W)
        NBKAssertSubSequenceSubtraction([ 3,  2,  1,  0] as W, [0, 4, 0, 0] as W, [ 3, ~1,  0,  0] as W)
        NBKAssertSubSequenceSubtraction([ 3,  2,  1,  0] as W, [0, 0, 4, 0] as W, [ 3,  2, ~2, ~0] as W, true)
        NBKAssertSubSequenceSubtraction([ 3,  2,  1,  0] as W, [0, 0, 0, 4] as W, [ 3,  2,  1, ~3] as W, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small (and Large)
    //=------------------------------------------------------------------------=
    
    func testSubtractingSmallFromLarge() {
        NBKAssertSubSequenceSubtractionByDigit([~0, ~0, ~0, ~0] as W, UInt(3), [~3, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0, ~0, ~0, ~0] as W, UInt(3), [~2, ~1, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0, ~0, ~0] as W, UInt(3), [~2, ~0, ~1, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0,  0, ~0] as W, UInt(3), [~2, ~0, ~0, ~1] as W)
    }
    
    func testSubtractingSmallFromLargeReportingOverflow() {
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0,  0,  0] as W, UInt(0), [ 0,  0,  0,  0] as W)
        NBKAssertSubSequenceSubtractionByDigit([ 0,  0,  0,  0] as W, UInt(1), [~0, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByDigit([ 3,  2,  1,  0] as W, UInt(4), [~0,  1,  1,  0] as W)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Product
    //=------------------------------------------------------------------------=
    
    func testSubtractingProduct() {
        NBKAssertSubSequenceSubtractionByProduct([ 0] as W, [ ] as W, UInt(0), UInt(0), false, [ 0] as W)
        NBKAssertSubSequenceSubtractionByProduct([~0] as W, [ ] as W, UInt(0), UInt(0), false, [~0] as W)
        NBKAssertSubSequenceSubtractionByProduct([~0] as W, [ ] as W, UInt(0), UInt(0), true,  [~1] as W)
    }
    
    func testSubtractingProductReportingOverflow() {
        var lhs: W, rhs: W
        //=--------------------------------------=
        lhs = [~0, ~0, ~0, ~0, ~0, ~0, ~0,  0] as W;  rhs = [ 1,  2,  3,  4] as W
         
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt(0), false, [~2, ~4, ~6, ~8, ~0, ~0, ~0,  0] as W)
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt.max, true, [~2, ~5, ~6, ~8, ~0, ~0, ~0,  0] as W)
        //=--------------------------------------=
        lhs = [~0, ~0, ~0, ~0, ~0, ~0, ~0,  0] as W;  rhs = [~1, ~2, ~3, ~4] as W
         
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt(0), false, [ 3,  4,  6,  8, ~1, ~0, ~0,  0] as W)
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt.max, true, [ 3,  3,  6,  8, ~1, ~0, ~0,  0] as W)
        //=--------------------------------------=
        lhs = [ 0,  0,  0,  0,  0,  0,  0,  0] as W;  rhs = [ 1,  2,  3,  4] as W
        
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt(0), false, [~1, ~4, ~6, ~8, ~0, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt.max, true, [~1, ~5, ~6, ~8, ~0, ~0, ~0, ~0] as W, true)
        //=--------------------------------------=
        lhs = [ 0,  0,  0,  0,  0,  0,  0,  0] as W;  rhs = [~1, ~2, ~3, ~4] as W
        
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt(0), false, [ 4,  4,  6,  8, ~1, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProduct(lhs, rhs, UInt(2), UInt.max, true, [ 4,  3,  6,  8, ~1, ~0, ~0, ~0] as W, true)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Subtraction x Assertions
//*============================================================================*

private func NBKAssertSubSequenceSubtraction(
_ lhs: [UInt], _ rhs: [UInt], _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    // decrement: elements + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.decrement(&lhs,  by: rhs,   plus: false)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.decrementInIntersection(&lhs, by: rhs,  plus: false)
        let max = T.decrement(&lhs[min.index...], by: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = T.decrementInIntersection(&lhs, by: rhs,  plus: false)
        let sfx = Array(repeating: UInt.zero,  count: lhs[min.index... ].count)
        let max = T.decrement(&lhs[min.index...], by: sfx,  plus: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
}

private func NBKAssertSubSequenceSubtractionByDigit(
_ lhs: [UInt], _ rhs: UInt, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    NBKAssertSubSequenceSubtraction(lhs, [rhs], result, overflow, file: file, line: line)
    //=------------------------------------------=
    // decrement: digit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.decrement(&lhs,  by: rhs)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
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
        let max = T.decrement(&lhs,  by: rhs,   plus: false)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.decrementInIntersection(&lhs, by: rhs,  plus: false)
        let max = T.decrement(&lhs[min.index...], by: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = T.decrementInIntersection(&lhs, by: rhs,  plus: false)
        let sfx = Array(repeating: UInt.zero,  count: lhs[min.index... ].count)
        let max = T.decrement(&lhs[min.index...], by: sfx,  plus: min.overflow)
        XCTAssertEqual(lhs,          result,    file: file, line: line)
        XCTAssertEqual(max.overflow, overflow,  file: file, line: line)
    }
}

private func NBKAssertSubSequenceSubtractionByProduct(
_ lhs: [UInt], _ rhs: [UInt], _ multiplicand: UInt, _ digit: UInt, _ bit: Bool, _ product: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    // decrement: limbs × digit + digit + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.decrement(&lhs,  by: rhs, times: multiplicand, plus: digit, plus: bit)
        XCTAssertEqual(lhs,          product,  file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

#endif
