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
// MARK: * NBK x Strict Unsigned Integer x Comparisons x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnComparisonsAsSubSequence: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCompareLargeToSmall() {
        NBKAssertSubSequenceComparison([ 2,  2] as W, [ 1] as W,  Int(1))
        NBKAssertSubSequenceComparison([ 2,  2] as W, [~1] as W,  Int(1))
        NBKAssertSubSequenceComparison([~2, ~2] as W, [ 1] as W,  Int(1))
        NBKAssertSubSequenceComparison([~2, ~2] as W, [~1] as W,  Int(1))
    }
    
    func testCompareLargeToLarge() {
        NBKAssertSubSequenceComparison([~0, ~0, ~0, ~0] as W, [~0, ~0, ~0, ~0] as W,  Int(0))
        NBKAssertSubSequenceComparison([~0, ~0, ~0, ~0] as W, [ 0,  0,  0,  0] as W,  Int(1))
        NBKAssertSubSequenceComparison([ 0,  0,  0,  0] as W, [~0, ~0, ~0, ~0] as W, -Int(1))
        NBKAssertSubSequenceComparison([ 0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W,  Int(0))
        
        NBKAssertSubSequenceComparison([ 0,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertSubSequenceComparison([ 1,  0,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertSubSequenceComparison([ 1,  2,  0,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertSubSequenceComparison([ 1,  2,  3,  0] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertSubSequenceComparison([ 0,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(0))
        NBKAssertSubSequenceComparison([ 1,  0,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(0))
        NBKAssertSubSequenceComparison([ 1,  2,  0,  4] as W, [ 1,  2,  0,  4] as W,  Int(0))
        NBKAssertSubSequenceComparison([ 1,  2,  3,  0] as W, [ 1,  2,  3,  0] as W,  Int(0))
        NBKAssertSubSequenceComparison([ 1,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(1))
        NBKAssertSubSequenceComparison([ 1,  2,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(1))
        NBKAssertSubSequenceComparison([ 1,  2,  3,  4] as W, [ 1,  2,  0,  4] as W,  Int(1))
        NBKAssertSubSequenceComparison([ 1,  2,  3,  4] as W, [ 1,  2,  3,  0] as W,  Int(1))
    }
    
    func testCompareIsLenient() {
        NBKAssertSubSequenceComparison([1] as W, [ ] as W,  Int(1))
        NBKAssertSubSequenceComparison([ ] as W, [ ] as W,  Int(0))
        NBKAssertSubSequenceComparison([ ] as W, [1] as W, -Int(1))
    }
    
    func testCompareSmallToSmallAtIndex() {
        NBKAssertSubSequenceComparisonAtIndex([ 0] as W, [ 0] as W, Int(1),  Int(0))
        NBKAssertSubSequenceComparisonAtIndex([ 1] as W, [ 0] as W, Int(1),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([~1] as W, [ 0] as W, Int(1),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([~0] as W, [ 0] as W, Int(1),  Int(1))
        
        NBKAssertSubSequenceComparisonAtIndex([ 0] as W, [ 1] as W, Int(1), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 1] as W, [ 1] as W, Int(1), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([~1] as W, [ 1] as W, Int(1), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([~0] as W, [ 1] as W, Int(1), -Int(1))
        
        NBKAssertSubSequenceComparisonAtIndex([ 0] as W, [~1] as W, Int(1), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 1] as W, [~1] as W, Int(1), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([~1] as W, [~1] as W, Int(1), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([~0] as W, [~1] as W, Int(1), -Int(1))
        
        NBKAssertSubSequenceComparisonAtIndex([ 0] as W, [~0] as W, Int(1), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 1] as W, [~0] as W, Int(1), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([~1] as W, [~0] as W, Int(1), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([~0] as W, [~0] as W, Int(1), -Int(1))
    }
    
    func testComapreLargeToLargeAtIndex() {
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(0))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(0))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(0))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(0))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(0))

        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))

        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(1))

        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2),  Int(0))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))
        
        NBKAssertSubSequenceComparisonAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(0),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(1),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(2),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(3),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(4),  Int(1))
    }
    
    func testCompareAtIndexIsLenient() {
        NBKAssertSubSequenceComparisonAtIndex([1] as W, [ ] as W, Int(1),  Int(1))
        NBKAssertSubSequenceComparisonAtIndex([ ] as W, [ ] as W, Int(1),  Int(0))
        NBKAssertSubSequenceComparisonAtIndex([ ] as W, [1] as W, Int(1), -Int(1))
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Comparisons x Assertions
//*============================================================================*

private func NBKAssertSubSequenceComparison(
_ lhs: [UInt], _ rhs: [UInt], _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictUnsignedInteger<UnsafeBufferPointer<UInt>>.SubSequence
    //=------------------------------------------=
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(T.compare(lhs, to: rhs),  signum, file: file, line: line)
        XCTAssertEqual(T.compare(rhs, to: lhs), -signum, file: file, line: line)
    }}
}

private func NBKAssertSubSequenceComparisonAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.StrictUnsignedInteger<UnsafeBufferPointer<UInt>>.SubSequence
    //=------------------------------------------=
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(T.compare(lhs, to: rhs, at: index), signum, file: file, line: line)
    }}
    //=------------------------------------------=
    NBKAssertSubSequenceComparison(lhs, Array(repeating: 0 as UInt, count: index) + rhs, signum, file: file, line: line)
}

#endif
