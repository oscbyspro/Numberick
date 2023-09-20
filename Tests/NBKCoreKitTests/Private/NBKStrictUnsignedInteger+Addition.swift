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
// MARK: * NBK x Strict Unsigned Integer x Addition
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnAddition: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddingLargeToLargeAtIndex() {
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [3, 0, 0, 0] as W, Int(0), [ 2, ~0, ~2, ~3] as W)
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [0, 3, 0, 0] as W, Int(0), [~0,  1, ~1, ~3] as W)
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [0, 0, 3, 0] as W, Int(0), [~0, ~1,  0, ~2] as W)
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [0, 0, 0, 3] as W, Int(0), [~0, ~1, ~2, ~0] as W)
        
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [0, 0, 0, 3] as W, Int(0), [~0, ~1, ~2, ~0] as W)
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [0, 0, 3   ] as W, Int(1), [~0, ~1, ~2, ~0] as W)
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [0, 3      ] as W, Int(2), [~0, ~1, ~2, ~0] as W)
        NBKAssertAdditionAtIndex([~0, ~1, ~2, ~3] as W, [3         ] as W, Int(3), [~0, ~1, ~2, ~0] as W)
    }
    
    func testAddingLargeToLargeAtIndexReportingOverflow() {
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
    // MARK: Tests x Small (and Large)
    //=------------------------------------------------------------------------=
    
    func testAddingSmallToLargeAtIndex() {
        NBKAssertAdditionByDigitAtIndex([ 0,  0,  0,  0] as W, UInt(3), Int(0), [ 3,  0,  0,  0] as W)
        NBKAssertAdditionByDigitAtIndex([~0,  0,  0,  0] as W, UInt(3), Int(0), [ 2,  1,  0,  0] as W)
        NBKAssertAdditionByDigitAtIndex([~0, ~0,  0,  0] as W, UInt(3), Int(0), [ 2,  0,  1,  0] as W)
        NBKAssertAdditionByDigitAtIndex([~0, ~0, ~0,  0] as W, UInt(3), Int(0), [ 2,  0,  0,  1] as W)
        
        NBKAssertAdditionByDigitAtIndex([ 0,  0,  0,  0] as W, UInt(3), Int(1), [ 0,  3,  0,  0] as W)
        NBKAssertAdditionByDigitAtIndex([~0,  0,  0,  0] as W, UInt(3), Int(1), [~0,  3,  0,  0] as W)
        NBKAssertAdditionByDigitAtIndex([~0, ~0,  0,  0] as W, UInt(3), Int(1), [~0,  2,  1,  0] as W)
        NBKAssertAdditionByDigitAtIndex([~0, ~0, ~0,  0] as W, UInt(3), Int(1), [~0,  2,  0,  1] as W)
    }
    
    func testAddingSmallToLargeAtIndexReportingOverflow() {
        NBKAssertAdditionByDigitAtIndex([~0, ~0, ~0, ~0] as W, UInt(0), Int(0), [~0, ~0, ~0, ~0] as W)
        NBKAssertAdditionByDigitAtIndex([~0, ~0, ~0, ~0] as W, UInt(1), Int(0), [ 0,  0,  0,  0] as W, true)
        
        NBKAssertAdditionByDigitAtIndex([~3, ~2, ~1, ~0] as W, UInt(4), Int(0), [ 0, ~1, ~1, ~0] as W)
        NBKAssertAdditionByDigitAtIndex([~3, ~2, ~1, ~0] as W, UInt(4), Int(1), [~3,  1, ~0, ~0] as W)
        NBKAssertAdditionByDigitAtIndex([~3, ~2, ~1, ~0] as W, UInt(4), Int(2), [~3, ~2,  2,  0] as W, true)
        NBKAssertAdditionByDigitAtIndex([~3, ~2, ~1, ~0] as W, UInt(4), Int(3), [~3, ~2, ~1,  3] as W, true)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Addition x Assertions
//*============================================================================*

private func NBKAssertAdditionAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let lhs = NBK.StrictUnsignedInteger(lhs)
    //=------------------------------------------=
    // increment: elements + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = lhs.increment(by:  rhs, plus: false, at: index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = lhs.incrementInIntersection(by: rhs, plus: false, at: index)
        let max = lhs.increment(by:  min.overflow, at: min.index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = lhs.increment(by: rhs, plus: false, at: index)
        let sfx = Array(repeating: UInt(), count: lhs.base.suffix(from: min.index).count)
        let max = lhs.incrementInIntersection(by: sfx, plus: min.overflow, at: min.index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

private func NBKAssertAdditionByDigitAtIndex(
_ lhs: [UInt], _ rhs: UInt, _ index: Int, _ result: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertAdditionAtIndex(lhs, [rhs], index, result, overflow, file: file, line: line)
    //=------------------------------------------=
    let lhs = NBK.StrictUnsignedInteger(lhs)
    //=------------------------------------------=
    // increment: digit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = lhs.increment(by: rhs, at: index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = lhs.incrementInIntersection(by: rhs, at: index)
        let max = lhs.increment(by:  min.overflow, at: min.index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    //=------------------------------------------=
    // increment: digit + bit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = lhs.increment(by:  rhs, plus: false, at: index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = lhs.incrementInIntersection(by: rhs, plus: false, at: index)
        let max = lhs.increment(by:  min.overflow, at: min.index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs, rhs = rhs
        let min = lhs.incrementInIntersection(by: rhs, plus: false, at: index)
        let sfx = Array(repeating: UInt(), count: lhs.base.suffix(from: min.index).count)
        let max = lhs.incrementInIntersection(by: sfx, plus: min.overflow, at: min.index)
        XCTAssertEqual(lhs.base,     result,   file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

#endif
