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
// MARK: * NBK x Comparisons
//*============================================================================*

final class NBKTestsOnComparisons: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCompareWordsAsSignedInteger() {
        NBKAssertCompareWordsAsSignedInteger([~0, ~0, ~0, ~0] as W, [~0, ~0, ~0, ~0] as W,  Int(0))
        NBKAssertCompareWordsAsSignedInteger([~0, ~0, ~0, ~0] as W, [ 0,  0,  0,  0] as W, -Int(1))
        NBKAssertCompareWordsAsSignedInteger([ 0,  0,  0,  0] as W, [~0, ~0, ~0, ~0] as W,  Int(1))
        NBKAssertCompareWordsAsSignedInteger([ 0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W,  Int(0))
        
        NBKAssertCompareWordsAsSignedInteger([ 0,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareWordsAsSignedInteger([ 1,  0,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareWordsAsSignedInteger([ 1,  2,  0,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareWordsAsSignedInteger([ 1,  2,  3,  0] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareWordsAsSignedInteger([ 0,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(0))
        NBKAssertCompareWordsAsSignedInteger([ 1,  0,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(0))
        NBKAssertCompareWordsAsSignedInteger([ 1,  2,  0,  4] as W, [ 1,  2,  0,  4] as W,  Int(0))
        NBKAssertCompareWordsAsSignedInteger([ 1,  2,  3,  0] as W, [ 1,  2,  3,  0] as W,  Int(0))
        NBKAssertCompareWordsAsSignedInteger([ 1,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(1))
        NBKAssertCompareWordsAsSignedInteger([ 1,  2,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(1))
        NBKAssertCompareWordsAsSignedInteger([ 1,  2,  3,  4] as W, [ 1,  2,  0,  4] as W,  Int(1))
        NBKAssertCompareWordsAsSignedInteger([ 1,  2,  3,  4] as W, [ 1,  2,  3,  0] as W,  Int(1))
    }
    
    func testCompareWordsAsSignedIntegerAtIndex() {
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(0))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(0))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(0))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(0))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(0))

        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0), -Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1), -Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2), -Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))

        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(1))

        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0),  Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1),  Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2),  Int(0))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))
        
        NBKAssertCompareWordsAsSignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(0), -Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(1), -Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(2),  Int(0))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(3),  Int(1))
        NBKAssertCompareWordsAsSignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(4),  Int(1))
    }
    
    func testCompareWordsAsUnsignedInteger() {
        NBKAssertCompareWordsAsUnsignedInteger([~0, ~0, ~0, ~0] as W, [~0, ~0, ~0, ~0] as W,  Int(0))
        NBKAssertCompareWordsAsUnsignedInteger([~0, ~0, ~0, ~0] as W, [ 0,  0,  0,  0] as W,  Int(1))
        NBKAssertCompareWordsAsUnsignedInteger([ 0,  0,  0,  0] as W, [~0, ~0, ~0, ~0] as W, -Int(1))
        NBKAssertCompareWordsAsUnsignedInteger([ 0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W,  Int(0))
        
        NBKAssertCompareWordsAsUnsignedInteger([ 0,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareWordsAsUnsignedInteger([ 1,  0,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareWordsAsUnsignedInteger([ 1,  2,  0,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareWordsAsUnsignedInteger([ 1,  2,  3,  0] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareWordsAsUnsignedInteger([ 0,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(0))
        NBKAssertCompareWordsAsUnsignedInteger([ 1,  0,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(0))
        NBKAssertCompareWordsAsUnsignedInteger([ 1,  2,  0,  4] as W, [ 1,  2,  0,  4] as W,  Int(0))
        NBKAssertCompareWordsAsUnsignedInteger([ 1,  2,  3,  0] as W, [ 1,  2,  3,  0] as W,  Int(0))
        NBKAssertCompareWordsAsUnsignedInteger([ 1,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(1))
        NBKAssertCompareWordsAsUnsignedInteger([ 1,  2,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(1))
        NBKAssertCompareWordsAsUnsignedInteger([ 1,  2,  3,  4] as W, [ 1,  2,  0,  4] as W,  Int(1))
        NBKAssertCompareWordsAsUnsignedInteger([ 1,  2,  3,  4] as W, [ 1,  2,  3,  0] as W,  Int(1))
    }
    
    func testCompareWordsAsUnsignedIntegerAtIndex() {
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(0))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(0))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(0))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(0))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(0))

        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0), -Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1), -Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2), -Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))

        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(1))

        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0),  Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1),  Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2),  Int(0))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))
        
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(0),  Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(1),  Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(2),  Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(3),  Int(1))
        NBKAssertCompareWordsAsUnsignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(4),  Int(1))
    }
}

//*============================================================================*
// MARK: * NBK x Comparisons x Assertions
//*============================================================================*

private func NBKAssertCompareWordsAsSignedInteger(
_ lhs: [UInt], _ rhs: [UInt], _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(NBK.compareAsSignedIntegers(lhs, to: rhs), signum, file: file, line: line)
    }}
}

private func NBKAssertCompareWordsAsSignedIntegerAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(NBK.compareAsSignedIntegers(lhs, to: rhs, at: index), signum, file: file, line: line)
    }}
}

private func NBKAssertCompareWordsAsUnsignedInteger(
_ lhs: [UInt], _ rhs: [UInt], _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(NBK.compareAsUnsignedIntegers(lhs, to: rhs), signum, file: file, line: line)
    }}
}

private func NBKAssertCompareWordsAsUnsignedIntegerAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(NBK.compareAsUnsignedIntegers(lhs, to: rhs, at: index), signum, file: file, line: line)
    }}
}

#endif
