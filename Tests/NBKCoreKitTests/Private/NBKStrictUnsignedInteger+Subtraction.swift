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
    
    func testSubtractingLargeFromLargeAtIndex() {
        NBKAssertSubSequenceSubtractionAtIndex([ 0,  1,  2,  3] as W, [3, 0, 0, 0] as W, Int(0), [~2,  0,  2,  3] as W)
        NBKAssertSubSequenceSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 3, 0, 0] as W, Int(0), [ 0, ~1,  1,  3] as W)
        NBKAssertSubSequenceSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 0, 3, 0] as W, Int(0), [ 0,  1, ~0,  2] as W)
        NBKAssertSubSequenceSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 0, 0, 3] as W, Int(0), [ 0,  1,  2,  0] as W)
        
        NBKAssertSubSequenceSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 0, 0, 3] as W, Int(0), [ 0,  1,  2,  0] as W)
        NBKAssertSubSequenceSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 0, 3   ] as W, Int(1), [ 0,  1,  2,  0] as W)
        NBKAssertSubSequenceSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 3      ] as W, Int(2), [ 0,  1,  2,  0] as W)
        NBKAssertSubSequenceSubtractionAtIndex([ 0,  1,  2,  3] as W, [3         ] as W, Int(3), [ 0,  1,  2,  0] as W)
    }
    
    func testSubtractingLargeFromLargeAtIndexReportingOverflow() {
        NBKAssertSubSequenceSubtractionAtIndex([ 0,  0,  0,  0] as W, [0, 0, 0, 0] as W, Int(0), [ 0,  0,  0,  0] as W)
        NBKAssertSubSequenceSubtractionAtIndex([ 0,  0,  0,  0] as W, [1, 0, 0, 0] as W, Int(0), [~0, ~0, ~0, ~0] as W, true)
        
        NBKAssertSubSequenceSubtractionAtIndex([ 3,  2,  1,  0] as W, [4, 0, 0, 0] as W, Int(0), [~0,  1,  1,  0] as W)
        NBKAssertSubSequenceSubtractionAtIndex([ 3,  2,  1,  0] as W, [4, 0, 0   ] as W, Int(1), [ 3, ~1,  0,  0] as W)
        NBKAssertSubSequenceSubtractionAtIndex([ 3,  2,  1,  0] as W, [4, 0      ] as W, Int(2), [ 3,  2, ~2, ~0] as W, true)
        NBKAssertSubSequenceSubtractionAtIndex([ 3,  2,  1,  0] as W, [4         ] as W, Int(3), [ 3,  2,  1, ~3] as W, true)
        
        NBKAssertSubSequenceSubtractionAtIndex([ 3,  2,  1,  0] as W, [4, 0, 0, 0] as W, Int(0), [~0,  1,  1,  0] as W)
        NBKAssertSubSequenceSubtractionAtIndex([ 3,  2,  1,  0] as W, [0, 4, 0, 0] as W, Int(0), [ 3, ~1,  0,  0] as W)
        NBKAssertSubSequenceSubtractionAtIndex([ 3,  2,  1,  0] as W, [0, 0, 4, 0] as W, Int(0), [ 3,  2, ~2, ~0] as W, true)
        NBKAssertSubSequenceSubtractionAtIndex([ 3,  2,  1,  0] as W, [0, 0, 0, 4] as W, Int(0), [ 3,  2,  1, ~3] as W, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small (and Large)
    //=------------------------------------------------------------------------=
    
    func testSubtractingSmallFromLargeAtIndex() {
        NBKAssertSubSequenceSubtractionByDigitAtIndex([~0, ~0, ~0, ~0] as W, UInt(3), Int(0), [~3, ~0, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigitAtIndex([ 0, ~0, ~0, ~0] as W, UInt(3), Int(0), [~2, ~1, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigitAtIndex([ 0,  0, ~0, ~0] as W, UInt(3), Int(0), [~2, ~0, ~1, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigitAtIndex([ 0,  0,  0, ~0] as W, UInt(3), Int(0), [~2, ~0, ~0, ~1] as W)
        
        NBKAssertSubSequenceSubtractionByDigitAtIndex([~0, ~0, ~0, ~0] as W, UInt(3), Int(1), [~0, ~3, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigitAtIndex([ 0, ~0, ~0, ~0] as W, UInt(3), Int(1), [ 0, ~3, ~0, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigitAtIndex([ 0,  0, ~0, ~0] as W, UInt(3), Int(1), [ 0, ~2, ~1, ~0] as W)
        NBKAssertSubSequenceSubtractionByDigitAtIndex([ 0,  0,  0, ~0] as W, UInt(3), Int(1), [ 0, ~2, ~0, ~1] as W)
    }
    
    func testSubtractingSmallFromLargeAtIndexReportingOverflow() {
        NBKAssertSubSequenceSubtractionByDigitAtIndex([ 0,  0,  0,  0] as W, UInt(0), Int(0), [ 0,  0,  0,  0] as W)
        NBKAssertSubSequenceSubtractionByDigitAtIndex([ 0,  0,  0,  0] as W, UInt(1), Int(0), [~0, ~0, ~0, ~0] as W, true)
        
        NBKAssertSubSequenceSubtractionByDigitAtIndex([ 3,  2,  1,  0] as W, UInt(4), Int(0), [~0,  1,  1,  0] as W)
        NBKAssertSubSequenceSubtractionByDigitAtIndex([ 3,  2,  1,  0] as W, UInt(4), Int(1), [ 3, ~1,  0,  0] as W)
        NBKAssertSubSequenceSubtractionByDigitAtIndex([ 3,  2,  1,  0] as W, UInt(4), Int(2), [ 3,  2, ~2, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByDigitAtIndex([ 3,  2,  1,  0] as W, UInt(4), Int(3), [ 3,  2,  1, ~3] as W, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Product
    //=------------------------------------------------------------------------=
    
    func testSubtractingProductAtIndex() {
        NBKAssertSubSequenceSubtractionByProductAtIndex([ 0] as W, [ ] as W, UInt(0), UInt(0), false, Int(0), [ 0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex([~0] as W, [ ] as W, UInt(0), UInt(0), false, Int(0), [~0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex([~0] as W, [ ] as W, UInt(0), UInt(0), true,  Int(0), [~1] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex([~0] as W, [ ] as W, UInt(0), UInt(2), false, Int(0), [~2] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex([~0] as W, [ ] as W, UInt(0), UInt(2), true,  Int(0), [~3] as W)
    }
    
    func testSubtractingProductAtIndexReportingOverflow() {
        var lhs: W, rhs: W
        //=--------------------------------------=
        lhs = [~0, ~0, ~0, ~0, ~0, ~0, ~0,  0] as W; rhs = [ 1,  2,  3,  4] as W
         
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(0), [~2, ~4, ~6, ~8, ~0, ~0, ~0,  0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(1), [~0, ~2, ~4, ~6, ~8, ~0, ~0,  0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(2), [~0, ~0, ~2, ~4, ~6, ~8, ~0,  0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(3), [~0, ~0, ~0, ~2, ~4, ~6, ~8,  0] as W)

        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(0), [~2, ~5, ~6, ~8, ~0, ~0, ~0,  0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(1), [~0, ~2, ~5, ~6, ~8, ~0, ~0,  0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(2), [~0, ~0, ~2, ~5, ~6, ~8, ~0,  0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(3), [~0, ~0, ~0, ~2, ~5, ~6, ~8,  0] as W)
        //=--------------------------------------=
        lhs = [~0, ~0, ~0, ~0, ~0, ~0, ~0,  0] as W; rhs = [~1, ~2, ~3, ~4] as W
         
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(0), [ 3,  4,  6,  8, ~1, ~0, ~0,  0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(1), [~0,  3,  4,  6,  8, ~1, ~0,  0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(2), [~0, ~0,  3,  4,  6,  8, ~1,  0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(3), [~0, ~0, ~0,  3,  4,  6,  8, ~0] as W, true)
        
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(0), [ 3,  3,  6,  8, ~1, ~0, ~0,  0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(1), [~0,  3,  3,  6,  8, ~1, ~0,  0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(2), [~0, ~0,  3,  3,  6,  8, ~1,  0] as W)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(3), [~0, ~0, ~0,  3,  3,  6,  8, ~0] as W, true)
        //=--------------------------------------=
        lhs = [ 0,  0,  0,  0,  0,  0,  0,  0] as W; rhs = [ 1,  2,  3,  4] as W
        
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(0), [~1, ~4, ~6, ~8, ~0, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(1), [ 0, ~1, ~4, ~6, ~8, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(2), [ 0,  0, ~1, ~4, ~6, ~8, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(3), [ 0,  0,  0, ~1, ~4, ~6, ~8, ~0] as W, true)
        
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(0), [~1, ~5, ~6, ~8, ~0, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(1), [ 0, ~1, ~5, ~6, ~8, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(2), [ 0,  0, ~1, ~5, ~6, ~8, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(3), [ 0,  0,  0, ~1, ~5, ~6, ~8, ~0] as W, true)
        //=--------------------------------------=
        lhs = [ 0,  0,  0,  0,  0,  0,  0,  0] as W; rhs = [~1, ~2, ~3, ~4] as W
        
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(0), [ 4,  4,  6,  8, ~1, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(1), [ 0,  4,  4,  6,  8, ~1, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(2), [ 0,  0,  4,  4,  6,  8, ~1, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt(0), false, Int(3), [ 0,  0,  0,  4,  4,  6,  8, ~1] as W, true)
        
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(0), [ 4,  3,  6,  8, ~1, ~0, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(1), [ 0,  4,  3,  6,  8, ~1, ~0, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(2), [ 0,  0,  4,  3,  6,  8, ~1, ~0] as W, true)
        NBKAssertSubSequenceSubtractionByProductAtIndex(lhs, rhs, UInt(2), UInt.max, true, Int(3), [ 0,  0,  0,  4,  3,  6,  8, ~1] as W, true)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Subtraction x Assertions
//*============================================================================*

private func NBKAssertSubSequenceSubtractionAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictUnsignedInteger<[UInt]>.SubSequence
    //=------------------------------------------=
    // decrement: elements + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.decrement(&lhs,  by: rhs,  plus: false, at: index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.decrementInIntersection(&lhs, by: rhs, plus: false, at: index)
        let max = T.decrement(&lhs,  by: min.overflow, at: min.index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = T.decrementInIntersection(&lhs, by: rhs, plus: false, at: index)
        let sfx = Array(repeating:   UInt(),  count: lhs.suffix(from: min.index).count)
        let max = T.decrement(&lhs,  by: sfx,  plus: min.overflow,at: min.index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

private func NBKAssertSubSequenceSubtractionByDigitAtIndex(
_ lhs: [UInt], _ rhs: UInt, _ index: Int, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictUnsignedInteger<[UInt]>.SubSequence
    //=------------------------------------------=
    NBKAssertSubSequenceSubtractionAtIndex(lhs, [rhs], index, result, overflow, file: file, line: line)
    //=------------------------------------------=
    // decrement: digit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.decrement(&lhs,  by: rhs,  at: index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.decrementInIntersection(&lhs, by: rhs,  at: index)
        let max = T.decrement(&lhs,  by: min.overflow, at:  min.index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    //=------------------------------------------=
    // decrement: digit + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.decrement(&lhs,  by: rhs,  plus: false, at: index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = T.decrementInIntersection(&lhs, by: rhs, plus: false, at: index)
        let max = T.decrement(&lhs,  by: min.overflow, at: min.index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = T.decrementInIntersection(&lhs, by: rhs, plus: false, at: index)
        let sfx = Array(repeating:   UInt(), count: lhs.suffix(from: min.index).count)
        let max = T.decrement(&lhs,  by: sfx, plus: min.overflow,at: min.index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

private func NBKAssertSubSequenceSubtractionByProductAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ multiplicand: UInt, _ digit: UInt, _ bit: Bool, _ index: Int, _ product: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictUnsignedInteger<[UInt]>.SubSequence
    //=------------------------------------------=
    // decrement: limbs × digit + digit + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = T.decrement(&lhs,  by: rhs, times: multiplicand, plus: digit, plus: bit, at: index)
        XCTAssertEqual(lhs,          product,  file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

#endif
