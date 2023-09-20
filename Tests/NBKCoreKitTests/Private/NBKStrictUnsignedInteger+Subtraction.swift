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
// MARK: * NBK x Strict Unsigned Integer x Subtraction
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnSubtraction: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtractingLargeFromLargeAtIndex() {
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [3, 0, 0, 0] as W, Int(0), [~2,  0,  2,  3] as W)
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 3, 0, 0] as W, Int(0), [ 0, ~1,  1,  3] as W)
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 0, 3, 0] as W, Int(0), [ 0,  1, ~0,  2] as W)
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 0, 0, 3] as W, Int(0), [ 0,  1,  2,  0] as W)
        
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 0, 0, 3] as W, Int(0), [ 0,  1,  2,  0] as W)
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 0, 3   ] as W, Int(1), [ 0,  1,  2,  0] as W)
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 3      ] as W, Int(2), [ 0,  1,  2,  0] as W)
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [3         ] as W, Int(3), [ 0,  1,  2,  0] as W)
    }
    
    func testSubtractingLargeFromLargeAtIndexReportingOverflow() {
        NBKAssertSubtractionAtIndex([ 0,  0,  0,  0] as W, [0, 0, 0, 0] as W, Int(0), [ 0,  0,  0,  0] as W)
        NBKAssertSubtractionAtIndex([ 0,  0,  0,  0] as W, [1, 0, 0, 0] as W, Int(0), [~0, ~0, ~0, ~0] as W, true)
        
        NBKAssertSubtractionAtIndex([ 3,  2,  1,  0] as W, [4, 0, 0, 0] as W, Int(0), [~0,  1,  1,  0] as W)
        NBKAssertSubtractionAtIndex([ 3,  2,  1,  0] as W, [4, 0, 0   ] as W, Int(1), [ 3, ~1,  0,  0] as W)
        NBKAssertSubtractionAtIndex([ 3,  2,  1,  0] as W, [4, 0      ] as W, Int(2), [ 3,  2, ~2, ~0] as W, true)
        NBKAssertSubtractionAtIndex([ 3,  2,  1,  0] as W, [4         ] as W, Int(3), [ 3,  2,  1, ~3] as W, true)
        
        NBKAssertSubtractionAtIndex([ 3,  2,  1,  0] as W, [4, 0, 0, 0] as W, Int(0), [~0,  1,  1,  0] as W)
        NBKAssertSubtractionAtIndex([ 3,  2,  1,  0] as W, [0, 4, 0, 0] as W, Int(0), [ 3, ~1,  0,  0] as W)
        NBKAssertSubtractionAtIndex([ 3,  2,  1,  0] as W, [0, 0, 4, 0] as W, Int(0), [ 3,  2, ~2, ~0] as W, true)
        NBKAssertSubtractionAtIndex([ 3,  2,  1,  0] as W, [0, 0, 0, 4] as W, Int(0), [ 3,  2,  1, ~3] as W, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small (and Large)
    //=------------------------------------------------------------------------=
    
    func testSubtractingSmallFromLargeAtIndex() {
        NBKAssertSubtractionByDigitAtIndex([~0, ~0, ~0, ~0] as W, UInt(3), Int(0), [~3, ~0, ~0, ~0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0, ~0, ~0, ~0] as W, UInt(3), Int(0), [~2, ~1, ~0, ~0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0,  0, ~0, ~0] as W, UInt(3), Int(0), [~2, ~0, ~1, ~0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0,  0,  0, ~0] as W, UInt(3), Int(0), [~2, ~0, ~0, ~1] as W)
        
        NBKAssertSubtractionByDigitAtIndex([~0, ~0, ~0, ~0] as W, UInt(3), Int(1), [~0, ~3, ~0, ~0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0, ~0, ~0, ~0] as W, UInt(3), Int(1), [ 0, ~3, ~0, ~0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0,  0, ~0, ~0] as W, UInt(3), Int(1), [ 0, ~2, ~1, ~0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0,  0,  0, ~0] as W, UInt(3), Int(1), [ 0, ~2, ~0, ~1] as W)
    }
    
    func testSubtractingSmallFromLargeAtIndexReportingOverflow() {
        NBKAssertSubtractionByDigitAtIndex([ 0,  0,  0,  0] as W, UInt(0), Int(0), [ 0,  0,  0,  0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0,  0,  0,  0] as W, UInt(1), Int(0), [~0, ~0, ~0, ~0] as W, true)
        
        NBKAssertSubtractionByDigitAtIndex([ 3,  2,  1,  0] as W, UInt(4), Int(0), [~0,  1,  1,  0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 3,  2,  1,  0] as W, UInt(4), Int(1), [ 3, ~1,  0,  0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 3,  2,  1,  0] as W, UInt(4), Int(2), [ 3,  2, ~2, ~0] as W, true)
        NBKAssertSubtractionByDigitAtIndex([ 3,  2,  1,  0] as W, UInt(4), Int(3), [ 3,  2,  1, ~3] as W, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Product
    //=------------------------------------------------------------------------=
    
    func testSubtractingProductAtIndex() {
        NBKAssertSubtractionByProductAtIndex([ 0] as W, [ ] as W, UInt(0), UInt(0), false, Int(0), [ 0] as W)
        NBKAssertSubtractionByProductAtIndex([~0] as W, [ ] as W, UInt(0), UInt(0), false, Int(0), [~0] as W)
        NBKAssertSubtractionByProductAtIndex([~0] as W, [ ] as W, UInt(0), UInt(0), true,  Int(0), [~1] as W)
        NBKAssertSubtractionByProductAtIndex([~0] as W, [ ] as W, UInt(0), UInt(2), false, Int(0), [~2] as W)
        NBKAssertSubtractionByProductAtIndex([~0] as W, [ ] as W, UInt(0), UInt(2), true,  Int(0), [~3] as W)
    }
    
    func testSubtractingProductAtIndexReportingOverflow() {
        var pointee: W, limbs: W
        //=--------------------------------------=
        pointee = [~0, ~0, ~0, ~0, ~0, ~0, ~0,  0] as W; limbs = [ 1,  2,  3,  4] as W
         
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(0), [~2, ~4, ~6, ~8, ~0, ~0, ~0,  0] as W)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(1), [~0, ~2, ~4, ~6, ~8, ~0, ~0,  0] as W)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(2), [~0, ~0, ~2, ~4, ~6, ~8, ~0,  0] as W)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(3), [~0, ~0, ~0, ~2, ~4, ~6, ~8,  0] as W)

        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(0), [~2, ~5, ~6, ~8, ~0, ~0, ~0,  0] as W)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(1), [~0, ~2, ~5, ~6, ~8, ~0, ~0,  0] as W)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(2), [~0, ~0, ~2, ~5, ~6, ~8, ~0,  0] as W)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(3), [~0, ~0, ~0, ~2, ~5, ~6, ~8,  0] as W)
        //=--------------------------------------=
        pointee = [~0, ~0, ~0, ~0, ~0, ~0, ~0,  0] as W; limbs = [~1, ~2, ~3, ~4] as W
         
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(0), [ 3,  4,  6,  8, ~1, ~0, ~0,  0] as W)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(1), [~0,  3,  4,  6,  8, ~1, ~0,  0] as W)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(2), [~0, ~0,  3,  4,  6,  8, ~1,  0] as W)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(3), [~0, ~0, ~0,  3,  4,  6,  8, ~0] as W, true)
        
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(0), [ 3,  3,  6,  8, ~1, ~0, ~0,  0] as W)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(1), [~0,  3,  3,  6,  8, ~1, ~0,  0] as W)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(2), [~0, ~0,  3,  3,  6,  8, ~1,  0] as W)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(3), [~0, ~0, ~0,  3,  3,  6,  8, ~0] as W, true)
        //=--------------------------------------=
        pointee = [ 0,  0,  0,  0,  0,  0,  0,  0] as W; limbs = [ 1,  2,  3,  4] as W
        
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(0), [~1, ~4, ~6, ~8, ~0, ~0, ~0, ~0] as W, true)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(1), [ 0, ~1, ~4, ~6, ~8, ~0, ~0, ~0] as W, true)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(2), [ 0,  0, ~1, ~4, ~6, ~8, ~0, ~0] as W, true)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(3), [ 0,  0,  0, ~1, ~4, ~6, ~8, ~0] as W, true)
        
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(0), [~1, ~5, ~6, ~8, ~0, ~0, ~0, ~0] as W, true)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(1), [ 0, ~1, ~5, ~6, ~8, ~0, ~0, ~0] as W, true)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(2), [ 0,  0, ~1, ~5, ~6, ~8, ~0, ~0] as W, true)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(3), [ 0,  0,  0, ~1, ~5, ~6, ~8, ~0] as W, true)
        //=--------------------------------------=
        pointee = [ 0,  0,  0,  0,  0,  0,  0,  0] as W; limbs = [~1, ~2, ~3, ~4] as W
        
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(0), [ 4,  4,  6,  8, ~1, ~0, ~0, ~0] as W, true)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(1), [ 0,  4,  4,  6,  8, ~1, ~0, ~0] as W, true)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(2), [ 0,  0,  4,  4,  6,  8, ~1, ~0] as W, true)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt(0), false, Int(3), [ 0,  0,  0,  4,  4,  6,  8, ~1] as W, true)
        
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(0), [ 4,  3,  6,  8, ~1, ~0, ~0, ~0] as W, true)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(1), [ 0,  4,  3,  6,  8, ~1, ~0, ~0] as W, true)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(2), [ 0,  0,  4,  3,  6,  8, ~1, ~0] as W, true)
        NBKAssertSubtractionByProductAtIndex(pointee, limbs, UInt(2), UInt.max, true, Int(3), [ 0,  0,  0,  4,  3,  6,  8, ~1] as W, true)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Subtraction x Assertions
//*============================================================================*

private func NBKAssertSubtractionAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let lhs = NBK.StrictUnsignedInteger(lhs)
    //=------------------------------------------=
    // decrement: elements + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = lhs.decrement(by:  rhs, plus: false, at: index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = lhs.decrementInIntersection(by: rhs, plus: false, at: index)
        let max = lhs.decrement(by:  min.overflow, at:  min.index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = lhs.decrementInIntersection(by: rhs, plus: false, at: index)
        let sfx = Array(repeating: UInt(), count: lhs.base.suffix(from: min.index).count)
        let max = lhs.decrementInIntersection(by: sfx, plus: min.overflow, at: min.index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

private func NBKAssertSubtractionByDigitAtIndex(
_ lhs: [UInt], _ rhs: UInt, _ index: Int, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertSubtractionAtIndex(lhs, [rhs], index, result, overflow, file: file, line: line)
    //=------------------------------------------=
    let lhs = NBK.StrictUnsignedInteger(lhs)
    //=------------------------------------------=
    // decrement: digit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = lhs.decrement(by: rhs, at: index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = lhs.decrementInIntersection(by: rhs, at: index)
        let max = lhs.decrement(by:  min.overflow, at:  min.index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    //=------------------------------------------=
    // decrement: digit + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = lhs.decrement(by:  rhs, plus: false, at: index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = lhs.decrementInIntersection(by: rhs, plus: false, at: index)
        let max = lhs.decrement(by:  min.overflow, at: min.index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = lhs.decrementInIntersection(by: rhs, plus: false, at: index)
        let sfx = Array(repeating: UInt(), count: lhs.base.suffix(from: min.index).count)
        let max = lhs.decrementInIntersection(by: sfx, plus: min.overflow, at: min.index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

private func NBKAssertSubtractionByProductAtIndex(
_ lhs: [UInt], _ limbs: [UInt], _ multiplicand: UInt, _ digit: UInt, _ bit: Bool, _ index: Int, _ product: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let lhs = NBK.StrictUnsignedInteger(lhs)
    //=------------------------------------------=
    // decrement: limbs × digit + digit + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = lhs.decrement(by:  limbs, times: multiplicand, plus: digit, plus: bit, at: index)
        XCTAssertEqual(lhs.base,     product,  file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

#endif
