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
// MARK: * NBK x Limbs x Subtraction x Unsigned
//*============================================================================*

final class NBKTestsOnLimbsBySubtractionAsUnsigned: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtractingAtIndex() {
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [3, 0, 0, 0] as W, Int(0), [~2,  0,  2,  3] as W)
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 3, 0, 0] as W, Int(0), [ 0, ~1,  1,  3] as W)
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 0, 3, 0] as W, Int(0), [ 0,  1, ~0,  2] as W)
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 0, 0, 3] as W, Int(0), [ 0,  1,  2,  0] as W)
        
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 0, 0, 3] as W, Int(0), [ 0,  1,  2,  0] as W)
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 0, 3   ] as W, Int(1), [ 0,  1,  2,  0] as W)
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [0, 3      ] as W, Int(2), [ 0,  1,  2,  0] as W)
        NBKAssertSubtractionAtIndex([ 0,  1,  2,  3] as W, [3         ] as W, Int(3), [ 0,  1,  2,  0] as W)
    }
    
    func testSubtractingAtIndexReportingOverflow() {
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
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigitAtIndex() {
        NBKAssertSubtractionByDigitAtIndex([~0, ~0, ~0, ~0] as W, UInt(3), Int(0), [~3, ~0, ~0, ~0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0, ~0, ~0, ~0] as W, UInt(3), Int(0), [~2, ~1, ~0, ~0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0,  0, ~0, ~0] as W, UInt(3), Int(0), [~2, ~0, ~1, ~0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0,  0,  0, ~0] as W, UInt(3), Int(0), [~2, ~0, ~0, ~1] as W)
        
        NBKAssertSubtractionByDigitAtIndex([~0, ~0, ~0, ~0] as W, UInt(3), Int(1), [~0, ~3, ~0, ~0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0, ~0, ~0, ~0] as W, UInt(3), Int(1), [ 0, ~3, ~0, ~0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0,  0, ~0, ~0] as W, UInt(3), Int(1), [ 0, ~2, ~1, ~0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0,  0,  0, ~0] as W, UInt(3), Int(1), [ 0, ~2, ~0, ~1] as W)
    }
    
    func testSubtractingDigitAtIndexReportingOverflow() {
        NBKAssertSubtractionByDigitAtIndex([ 0,  0,  0,  0] as W, UInt(0), Int(0), [ 0,  0,  0,  0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 0,  0,  0,  0] as W, UInt(1), Int(0), [~0, ~0, ~0, ~0] as W, true)
        
        NBKAssertSubtractionByDigitAtIndex([ 3,  2,  1,  0] as W, UInt(4), Int(0), [~0,  1,  1,  0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 3,  2,  1,  0] as W, UInt(4), Int(1), [ 3, ~1,  0,  0] as W)
        NBKAssertSubtractionByDigitAtIndex([ 3,  2,  1,  0] as W, UInt(4), Int(2), [ 3,  2, ~2, ~0] as W, true)
        NBKAssertSubtractionByDigitAtIndex([ 3,  2,  1,  0] as W, UInt(4), Int(3), [ 3,  2,  1, ~3] as W, true)
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Subtraction x Assertions
//*============================================================================*

private func NBKAssertSubtractionAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ product: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = NBK.decrementSufficientUnsignedInteger(&lhs, by: rhs, at: index, borrowing: false)
        XCTAssertEqual(lhs,          product,  file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = NBK.decrementSufficientUnsignedIntegerInIntersection(&lhs, by: rhs, at: index, borrowing: false)
        let max = NBK.decrementSufficientUnsignedInteger(&lhs, by: Void(), at: min.index, borrowing: min.overflow)
        XCTAssertEqual(lhs,          product,  file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

private func NBKAssertSubtractionByDigitAtIndex(
_ lhs: [UInt], _ rhs: UInt, _ index: Int, _ product: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = NBK.decrementSufficientUnsignedInteger(&lhs, by: rhs, at: index)
        XCTAssertEqual(lhs,          product,  file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = NBK.decrementSufficientUnsignedIntegerInIntersection(&lhs, by: rhs, at: index)
        let max = NBK.decrementSufficientUnsignedInteger(&lhs, by: Void(), at: min.index, borrowing: min.overflow)
        XCTAssertEqual(lhs,          product,  file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let max = NBK.decrementSufficientUnsignedInteger(&lhs, by: rhs, at: index, borrowing: false)
        XCTAssertEqual(lhs,          product,  file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let min = NBK.decrementSufficientUnsignedIntegerInIntersection(&lhs, by: rhs, at: index, borrowing: false)
        let max = NBK.decrementSufficientUnsignedInteger(&lhs, by: Void(), at: min.index, borrowing: min.overflow)
        XCTAssertEqual(lhs,          product,  file: file, line: line)
        XCTAssertEqual(max.overflow, overflow, file: file, line: line)
    }
}

#endif
