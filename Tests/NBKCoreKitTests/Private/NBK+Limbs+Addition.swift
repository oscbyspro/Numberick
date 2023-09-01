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
// MARK: * NBK x Limbs x Addition x Unsigned
//*============================================================================*

final class NBKTestsOnLimbsByAdditionAsUnsigned: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddingAtIndex() {
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [3, 0, 0, 0] as W, Int(0), [ 2, ~0, ~2, ~3] as W)
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [0, 3, 0, 0] as W, Int(0), [~0,  1, ~1, ~3] as W)
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [0, 0, 3, 0] as W, Int(0), [~0, ~1,  0, ~2] as W)
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [0, 0, 0, 3] as W, Int(0), [~0, ~1, ~2, ~0] as W)
        
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [0, 0, 0, 3] as W, Int(0), [~0, ~1, ~2, ~0] as W)
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [0, 0, 3   ] as W, Int(1), [~0, ~1, ~2, ~0] as W)
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [0, 3      ] as W, Int(2), [~0, ~1, ~2, ~0] as W)
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [3         ] as W, Int(3), [~0, ~1, ~2, ~0] as W)
    }
    
    func testAddingAtIndexReportingOverflow() {
        NBKAssertAdditionAtIndex([~0, ~0, ~0, ~0] as W, [0, 0, 0, 0] as W, Int(0), [~0, ~0, ~0, ~0] as W)
        NBKAssertAdditionAtIndex([~0, ~0, ~0, ~0] as W, [1, 0, 0, 0] as W, Int(0), [ 0,  0,  0,  0] as W, true)
        
        NBKAssertAdditionAtIndex([~3, ~2, ~1, ~0] as W, [4, 0, 0, 0] as W, Int(0), [ 0, ~1, ~1, ~0] as W)
        NBKAssertAdditionAtIndex([~3, ~2, ~1, ~0] as W, [4, 0, 0   ] as W, Int(1), [~3,  1, ~0, ~0] as W)
        NBKAssertAdditionAtIndex([~3, ~2, ~1, ~0] as W, [4, 0      ] as W, Int(2), [~3, ~2,  2,  0] as W, true)
        NBKAssertAdditionAtIndex([~3, ~2, ~1, ~0] as W, [4         ] as W, Int(3), [~3, ~2, ~1,  3] as W, true)
        
        NBKAssertAdditionAtIndex([~3, ~2, ~1, ~0] as W, [4, 0, 0, 0] as W, Int(0), [ 0, ~1, ~1, ~0] as W)
        NBKAssertAdditionAtIndex([~3, ~2, ~1, ~0] as W, [0, 4, 0, 0] as W, Int(0), [~3,  1, ~0, ~0] as W)
        NBKAssertAdditionAtIndex([~3, ~2, ~1, ~0] as W, [0, 0, 4, 0] as W, Int(0), [~3, ~2,  2,  0] as W, true)
        NBKAssertAdditionAtIndex([~3, ~2, ~1, ~0] as W, [0, 0, 0, 4] as W, Int(0), [~3, ~2, ~1,  3] as W, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testAddingDigitAtIndex() {
        NBKAssertAdditionByDigitAtIndex([ 0,  0,  0,  0] as W, UInt(3), Int(0), [ 3,  0,  0,  0] as W)
        NBKAssertAdditionByDigitAtIndex([~0,  0,  0,  0] as W, UInt(3), Int(0), [ 2,  1,  0,  0] as W)
        NBKAssertAdditionByDigitAtIndex([~0, ~0,  0,  0] as W, UInt(3), Int(0), [ 2,  0,  1,  0] as W)
        NBKAssertAdditionByDigitAtIndex([~0, ~0, ~0,  0] as W, UInt(3), Int(0), [ 2,  0,  0,  1] as W)
        
        NBKAssertAdditionByDigitAtIndex([ 0,  0,  0,  0] as W, UInt(3), Int(1), [ 0,  3,  0,  0] as W)
        NBKAssertAdditionByDigitAtIndex([~0,  0,  0,  0] as W, UInt(3), Int(1), [~0,  3,  0,  0] as W)
        NBKAssertAdditionByDigitAtIndex([~0, ~0,  0,  0] as W, UInt(3), Int(1), [~0,  2,  1,  0] as W)
        NBKAssertAdditionByDigitAtIndex([~0, ~0, ~0,  0] as W, UInt(3), Int(1), [~0,  2,  0,  1] as W)
    }
    
    func testAddingDigitAtIndexReportingOverflow() {
        NBKAssertAdditionByDigitAtIndex([~0, ~0, ~0, ~0] as W, UInt(0), Int(0), [~0, ~0, ~0, ~0] as W)
        NBKAssertAdditionByDigitAtIndex([~0, ~0, ~0, ~0] as W, UInt(1), Int(0), [ 0,  0,  0,  0] as W, true)
        
        NBKAssertAdditionByDigitAtIndex([~3, ~2, ~1, ~0] as W, UInt(4), Int(0), [ 0, ~1, ~1, ~0] as W)
        NBKAssertAdditionByDigitAtIndex([~3, ~2, ~1, ~0] as W, UInt(4), Int(1), [~3,  1, ~0, ~0] as W)
        NBKAssertAdditionByDigitAtIndex([~3, ~2, ~1, ~0] as W, UInt(4), Int(2), [~3, ~2,  2,  0] as W, true)
        NBKAssertAdditionByDigitAtIndex([~3, ~2, ~1, ~0] as W, UInt(4), Int(3), [~3, ~2, ~1,  3] as W, true)
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Addition x Assertions
//*============================================================================*

private func NBKAssertAdditionAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    // increment: limbs + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = NBK.incrementSufficientUnsignedInteger(&lhs, by: rhs, plus: false, at: index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = NBK.incrementSufficientUnsignedIntegerInIntersection(&lhs, by: rhs, plus: false, at: index)
        let max = NBK.incrementSufficientUnsignedInteger(&lhs, by: min.overflow, at:  min.index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = NBK.incrementSufficientUnsignedIntegerInIntersection(&lhs, by: rhs, plus: false, at: index)
        let sfx = Array(repeating: 0 as UInt, count: lhs.suffix(from: min.index).count)
        let max = NBK.incrementSufficientUnsignedIntegerInIntersection(&lhs, by: sfx, plus: min.overflow, at: min.index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

private func NBKAssertAdditionByDigitAtIndex(
_ lhs: [UInt], _ rhs: UInt, _ index: Int, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    // increment: digit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = NBK.incrementSufficientUnsignedInteger(&lhs, by: rhs, at: index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = NBK.incrementSufficientUnsignedIntegerInIntersection(&lhs, by: rhs, at: index)
        let max = NBK.incrementSufficientUnsignedInteger(&lhs, by: min.overflow, at:  min.index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    //=------------------------------------------=
    // increment: digit + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = NBK.incrementSufficientUnsignedInteger(&lhs, by: rhs, plus: false, at: index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = NBK.incrementSufficientUnsignedIntegerInIntersection(&lhs, by: rhs, plus: false, at: index)
        let max = NBK.incrementSufficientUnsignedInteger(&lhs, by: min.overflow, at:  min.index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = NBK.incrementSufficientUnsignedIntegerInIntersection(&lhs, by: rhs, plus: false, at: index)
        let sfx = Array(repeating: 0 as UInt, count: lhs.suffix(from: min.index).count)
        let max = NBK.incrementSufficientUnsignedIntegerInIntersection(&lhs, by: sfx, plus: min.overflow, at: min.index)
        XCTAssertEqual(lhs,          result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

#endif
