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
// MARK: * NBK x Strict Signed Integer x Comparisons
//*============================================================================*

final class NBKStrictSignedIntegerTestsOnComparisons: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCompareLargeToSmall() {
        NBKAssertComparison([ 2,  2] as X, [ 1] as X,  Int(1))
        NBKAssertComparison([ 2,  2] as X, [~1] as X,  Int(1))
        NBKAssertComparison([~2, ~2] as X, [ 1] as X, -Int(1))
        NBKAssertComparison([~2, ~2] as X, [~1] as X, -Int(1))
    }
    
    func testCompareLargeToLarge() {
        NBKAssertComparison([~0, ~0, ~0, ~0] as X, [~0, ~0, ~0, ~0] as X,  Int(0))
        NBKAssertComparison([~0, ~0, ~0, ~0] as X, [ 0,  0,  0,  0] as X, -Int(1))
        NBKAssertComparison([ 0,  0,  0,  0] as X, [~0, ~0, ~0, ~0] as X,  Int(1))
        NBKAssertComparison([ 0,  0,  0,  0] as X, [ 0,  0,  0,  0] as X,  Int(0))
        
        NBKAssertComparison([ 0,  2,  3,  4] as X, [ 1,  2,  3,  4] as X, -Int(1))
        NBKAssertComparison([ 1,  0,  3,  4] as X, [ 1,  2,  3,  4] as X, -Int(1))
        NBKAssertComparison([ 1,  2,  0,  4] as X, [ 1,  2,  3,  4] as X, -Int(1))
        NBKAssertComparison([ 1,  2,  3,  0] as X, [ 1,  2,  3,  4] as X, -Int(1))
        NBKAssertComparison([ 0,  2,  3,  4] as X, [ 0,  2,  3,  4] as X,  Int(0))
        NBKAssertComparison([ 1,  0,  3,  4] as X, [ 1,  0,  3,  4] as X,  Int(0))
        NBKAssertComparison([ 1,  2,  0,  4] as X, [ 1,  2,  0,  4] as X,  Int(0))
        NBKAssertComparison([ 1,  2,  3,  0] as X, [ 1,  2,  3,  0] as X,  Int(0))
        NBKAssertComparison([ 1,  2,  3,  4] as X, [ 0,  2,  3,  4] as X,  Int(1))
        NBKAssertComparison([ 1,  2,  3,  4] as X, [ 1,  0,  3,  4] as X,  Int(1))
        NBKAssertComparison([ 1,  2,  3,  4] as X, [ 1,  2,  0,  4] as X,  Int(1))
        NBKAssertComparison([ 1,  2,  3,  4] as X, [ 1,  2,  3,  0] as X,  Int(1))
    }
    
    func testCompareSmallToSmallAtIndex() {
        NBKAssertComparisonAtIndex([ 0] as X, [ 0] as X, Int(1),  Int(0))
        NBKAssertComparisonAtIndex([ 1] as X, [ 0] as X, Int(1),  Int(1))
        NBKAssertComparisonAtIndex([~1] as X, [ 0] as X, Int(1), -Int(1))
        NBKAssertComparisonAtIndex([~0] as X, [ 0] as X, Int(1), -Int(1))
        
        NBKAssertComparisonAtIndex([ 0] as X, [ 1] as X, Int(1), -Int(1))
        NBKAssertComparisonAtIndex([ 1] as X, [ 1] as X, Int(1), -Int(1))
        NBKAssertComparisonAtIndex([~1] as X, [ 1] as X, Int(1), -Int(1))
        NBKAssertComparisonAtIndex([~0] as X, [ 1] as X, Int(1), -Int(1))
        
        NBKAssertComparisonAtIndex([ 0] as X, [~1] as X, Int(1),  Int(1))
        NBKAssertComparisonAtIndex([ 1] as X, [~1] as X, Int(1),  Int(1))
        NBKAssertComparisonAtIndex([~1] as X, [~1] as X, Int(1),  Int(1))
        NBKAssertComparisonAtIndex([~0] as X, [~1] as X, Int(1),  Int(1))
        
        NBKAssertComparisonAtIndex([ 0] as X, [~0] as X, Int(1),  Int(1))
        NBKAssertComparisonAtIndex([ 1] as X, [~0] as X, Int(1),  Int(1))
        NBKAssertComparisonAtIndex([~1] as X, [~0] as X, Int(1),  Int(1))
        NBKAssertComparisonAtIndex([~0] as X, [~0] as X, Int(1),  Int(1))
    }
    
    func testCompareLargeToLargeAtIndex() {
        NBKAssertComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as X, [ 0,  0,  0,  0] as X, Int(0),  Int(0))
        NBKAssertComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as X, [ 0,  0,  0,  0] as X, Int(1),  Int(0))
        NBKAssertComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as X, [ 0,  0,  0,  0] as X, Int(2),  Int(0))
        NBKAssertComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as X, [ 0,  0,  0,  0] as X, Int(3),  Int(0))
        NBKAssertComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as X, [ 0,  0,  0,  0] as X, Int(4),  Int(0))
        
        NBKAssertComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as X, [ 1,  2,  3,  4] as X, Int(0), -Int(1))
        NBKAssertComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as X, [ 1,  2,  3,  4] as X, Int(1), -Int(1))
        NBKAssertComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as X, [ 1,  2,  3,  4] as X, Int(2), -Int(1))
        NBKAssertComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as X, [ 1,  2,  3,  4] as X, Int(3), -Int(1))
        NBKAssertComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as X, [ 1,  2,  3,  4] as X, Int(4), -Int(1))
        
        NBKAssertComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as X, [ 0,  0,  0,  0] as X, Int(0),  Int(1))
        NBKAssertComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as X, [ 0,  0,  0,  0] as X, Int(1),  Int(1))
        NBKAssertComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as X, [ 0,  0,  0,  0] as X, Int(2),  Int(1))
        NBKAssertComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as X, [ 0,  0,  0,  0] as X, Int(3),  Int(1))
        NBKAssertComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as X, [ 0,  0,  0,  0] as X, Int(4),  Int(1))
        
        NBKAssertComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as X, [ 1,  2,  3,  4] as X, Int(0),  Int(1))
        NBKAssertComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as X, [ 1,  2,  3,  4] as X, Int(1),  Int(1))
        NBKAssertComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as X, [ 1,  2,  3,  4] as X, Int(2),  Int(0))
        NBKAssertComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as X, [ 1,  2,  3,  4] as X, Int(3), -Int(1))
        NBKAssertComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as X, [ 1,  2,  3,  4] as X, Int(4), -Int(1))
        
        NBKAssertComparisonAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as X, [~1, ~2, ~3, ~4] as X, Int(0), -Int(1))
        NBKAssertComparisonAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as X, [~1, ~2, ~3, ~4] as X, Int(1), -Int(1))
        NBKAssertComparisonAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as X, [~1, ~2, ~3, ~4] as X, Int(2),  Int(1))
        NBKAssertComparisonAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as X, [~1, ~2, ~3, ~4] as X, Int(3),  Int(1))
        NBKAssertComparisonAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as X, [~1, ~2, ~3, ~4] as X, Int(4),  Int(1))
    }
}

//*============================================================================*
// MARK: * NBK x Strict Signed Integer x Comparisons x Assertions
//*============================================================================*

private func NBKAssertComparison(
_ lhs: [UInt], _ rhs: [UInt], _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictSignedInteger
    //=------------------------------------------=
    brr: do {
        XCTAssertEqual(T.compare(lhs, to: rhs),  signum, file: file, line: line)
        XCTAssertEqual(T.compare(rhs, to: lhs), -signum, file: file, line: line)
    }
    
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(T.compare(lhs, to: rhs),  signum, file: file, line: line)
        XCTAssertEqual(T.compare(rhs, to: lhs), -signum, file: file, line: line)
    }}
}

private func NBKAssertComparisonAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictSignedInteger
    //=------------------------------------------=
    NBKAssertComparison(lhs, [UInt](repeating: 0, count: index) + rhs, signum, file: file, line: line)
    //=------------------------------------------=
    brr: do {
        XCTAssertEqual(T.compare(lhs, to: rhs, at: index), signum, file: file, line: line)
    }
    
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(T.compare(lhs, to: rhs, at: index), signum, file: file, line: line)
    }}
}
