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
    // MARK: Tests x Binary Integer Limbs
    //=------------------------------------------------------------------------=
    
    func testCompareSignedIntegerLimbs() {
        NBKAssertCompareSignedIntegerLimbs([ 2,  2        ] as W, [ 1            ] as W,  Int(1))
        NBKAssertCompareSignedIntegerLimbs([ 2,  2        ] as W, [~1            ] as W,  Int(1))
        NBKAssertCompareSignedIntegerLimbs([~2, ~2        ] as W, [ 1            ] as W, -Int(1))
        NBKAssertCompareSignedIntegerLimbs([~2, ~2        ] as W, [~1            ] as W, -Int(1))
        
        NBKAssertCompareSignedIntegerLimbs([~0, ~0, ~0, ~0] as W, [~0, ~0, ~0, ~0] as W,  Int(0))
        NBKAssertCompareSignedIntegerLimbs([~0, ~0, ~0, ~0] as W, [ 0,  0,  0,  0] as W, -Int(1))
        NBKAssertCompareSignedIntegerLimbs([ 0,  0,  0,  0] as W, [~0, ~0, ~0, ~0] as W,  Int(1))
        NBKAssertCompareSignedIntegerLimbs([ 0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W,  Int(0))
        
        NBKAssertCompareSignedIntegerLimbs([ 0,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareSignedIntegerLimbs([ 1,  0,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareSignedIntegerLimbs([ 1,  2,  0,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareSignedIntegerLimbs([ 1,  2,  3,  0] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareSignedIntegerLimbs([ 0,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(0))
        NBKAssertCompareSignedIntegerLimbs([ 1,  0,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(0))
        NBKAssertCompareSignedIntegerLimbs([ 1,  2,  0,  4] as W, [ 1,  2,  0,  4] as W,  Int(0))
        NBKAssertCompareSignedIntegerLimbs([ 1,  2,  3,  0] as W, [ 1,  2,  3,  0] as W,  Int(0))
        NBKAssertCompareSignedIntegerLimbs([ 1,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(1))
        NBKAssertCompareSignedIntegerLimbs([ 1,  2,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(1))
        NBKAssertCompareSignedIntegerLimbs([ 1,  2,  3,  4] as W, [ 1,  2,  0,  4] as W,  Int(1))
        NBKAssertCompareSignedIntegerLimbs([ 1,  2,  3,  4] as W, [ 1,  2,  3,  0] as W,  Int(1))
    }
    
    func testCompareSignedIntegerLimbsAtIndex() {
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 1] as W, [ 1] as W, Int(1), -Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([~1] as W, [~1] as W, Int(1),  Int(1))
        
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(0))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(0))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(0))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(0))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(0))

        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0), -Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1), -Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2), -Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))

        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(1))

        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0),  Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1),  Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2),  Int(0))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))
        
        NBKAssertCompareSignedIntegerLimbsAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(0), -Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(1), -Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(2),  Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(3),  Int(1))
        NBKAssertCompareSignedIntegerLimbsAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(4),  Int(1))
    }
    
    func testCompareUnsignedIntegerLimbsLenient() {
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 2,  2        ] as W, [ 1            ] as W,  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 2,  2        ] as W, [~1            ] as W,  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([~2, ~2        ] as W, [ 1            ] as W,  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([~2, ~2        ] as W, [~1            ] as W,  Int(1))
        
        NBKAssertCompareUnsignedIntegerLimbsLenient([~0, ~0, ~0, ~0] as W, [~0, ~0, ~0, ~0] as W,  Int(0))
        NBKAssertCompareUnsignedIntegerLimbsLenient([~0, ~0, ~0, ~0] as W, [ 0,  0,  0,  0] as W,  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 0,  0,  0,  0] as W, [~0, ~0, ~0, ~0] as W, -Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W,  Int(0))
        
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 0,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 1,  0,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 1,  2,  0,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 1,  2,  3,  0] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 0,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(0))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 1,  0,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(0))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 1,  2,  0,  4] as W, [ 1,  2,  0,  4] as W,  Int(0))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 1,  2,  3,  0] as W, [ 1,  2,  3,  0] as W,  Int(0))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 1,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 1,  2,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 1,  2,  3,  4] as W, [ 1,  2,  0,  4] as W,  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ 1,  2,  3,  4] as W, [ 1,  2,  3,  0] as W,  Int(1))
    }
    
    func testCompareUnsignedIntegerLimbsLenientIsLenient() {
        NBKAssertCompareUnsignedIntegerLimbsLenient([1] as W, [ ] as W,  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ ] as W, [ ] as W,  Int(0))
        NBKAssertCompareUnsignedIntegerLimbsLenient([ ] as W, [1] as W, -Int(1))
    }
    
    func testCompareUnsignedIntegerLimbsLenientAtIndex() {
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 1] as W, [ 1] as W, Int(1), -Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([~1] as W, [~1] as W, Int(1), -Int(1))
        
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(0))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(0))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(0))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(0))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(0))

        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0), -Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1), -Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2), -Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))

        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(1))

        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0),  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1),  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2),  Int(0))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))
        
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(0),  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(1),  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(2),  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(3),  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(4),  Int(1))
    }
    
    func testCompareUnsignedIntegerLimbsLenientAtIndexIsLenient() {
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([1] as W, [ ] as W, Int(1),  Int(1))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ ] as W, [ ] as W, Int(1),  Int(0))
        NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex([ ] as W, [1] as W, Int(1), -Int(1))
    }
}

//*============================================================================*
// MARK: * NBK x Comparisons x Assertions
//*============================================================================*

private func NBKAssertCompareSignedIntegerLimbs(
_ lhs: [UInt], _ rhs: [UInt], _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(NBK.compareSignedIntegerLimbs(lhs, to: rhs),  signum, file: file, line: line)
        XCTAssertEqual(NBK.compareSignedIntegerLimbs(rhs, to: lhs), -signum, file: file, line: line)
    }}
}

private func NBKAssertCompareSignedIntegerLimbsAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(NBK.compareSignedIntegerLimbs(lhs, to: rhs, at: index),  signum, file: file, line: line)
    }}
    //=------------------------------------------=
    NBKAssertCompareSignedIntegerLimbs(lhs, Array(repeating: UInt.zero, count: index) + rhs, signum, file: file, line: line)
}

private func NBKAssertCompareUnsignedIntegerLimbsLenient(
_ lhs: [UInt], _ rhs: [UInt], _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(NBK.compareUnsignedIntegerLimbsLenient(lhs, to: rhs),  signum, file: file, line: line)
        XCTAssertEqual(NBK.compareUnsignedIntegerLimbsLenient(rhs, to: lhs), -signum, file: file, line: line)
    }}
}

private func NBKAssertCompareUnsignedIntegerLimbsLenientAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(NBK.compareUnsignedIntegerLimbsLenient(lhs, to: rhs, at: index), signum, file: file, line: line)
    }}
    //=------------------------------------------=
    NBKAssertCompareUnsignedIntegerLimbsLenient(lhs, Array(repeating: UInt.zero, count: index) + rhs, signum, file: file, line: line)
}

#endif
