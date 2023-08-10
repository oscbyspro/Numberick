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
// MARK: * NBK x Limbs x Comparisons
//*============================================================================*

final class NBKTestsOnLimbsByComparisons: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Binary Integer Limbs
    //=------------------------------------------------------------------------=
    
    func testCompareStrictSignedInteger() {
        NBKAssertCompareStrictSignedInteger([ 2,  2        ] as W, [ 1            ] as W,  Int(1))
        NBKAssertCompareStrictSignedInteger([ 2,  2        ] as W, [~1            ] as W,  Int(1))
        NBKAssertCompareStrictSignedInteger([~2, ~2        ] as W, [ 1            ] as W, -Int(1))
        NBKAssertCompareStrictSignedInteger([~2, ~2        ] as W, [~1            ] as W, -Int(1))
        
        NBKAssertCompareStrictSignedInteger([~0, ~0, ~0, ~0] as W, [~0, ~0, ~0, ~0] as W,  Int(0))
        NBKAssertCompareStrictSignedInteger([~0, ~0, ~0, ~0] as W, [ 0,  0,  0,  0] as W, -Int(1))
        NBKAssertCompareStrictSignedInteger([ 0,  0,  0,  0] as W, [~0, ~0, ~0, ~0] as W,  Int(1))
        NBKAssertCompareStrictSignedInteger([ 0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W,  Int(0))
        
        NBKAssertCompareStrictSignedInteger([ 0,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareStrictSignedInteger([ 1,  0,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareStrictSignedInteger([ 1,  2,  0,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareStrictSignedInteger([ 1,  2,  3,  0] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareStrictSignedInteger([ 0,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(0))
        NBKAssertCompareStrictSignedInteger([ 1,  0,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(0))
        NBKAssertCompareStrictSignedInteger([ 1,  2,  0,  4] as W, [ 1,  2,  0,  4] as W,  Int(0))
        NBKAssertCompareStrictSignedInteger([ 1,  2,  3,  0] as W, [ 1,  2,  3,  0] as W,  Int(0))
        NBKAssertCompareStrictSignedInteger([ 1,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(1))
        NBKAssertCompareStrictSignedInteger([ 1,  2,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(1))
        NBKAssertCompareStrictSignedInteger([ 1,  2,  3,  4] as W, [ 1,  2,  0,  4] as W,  Int(1))
        NBKAssertCompareStrictSignedInteger([ 1,  2,  3,  4] as W, [ 1,  2,  3,  0] as W,  Int(1))
    }
    
    func testCompareStrictSignedIntegerAtIndex() {
        NBKAssertCompareStrictSignedIntegerAtIndex([ 1] as W, [ 1] as W, Int(1), -Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([~1] as W, [~1] as W, Int(1),  Int(1))
        
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(0))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(0))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(0))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(0))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(0))

        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0), -Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1), -Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2), -Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))

        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(1))

        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0),  Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1),  Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2),  Int(0))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))
        
        NBKAssertCompareStrictSignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(0), -Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(1), -Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(2),  Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(3),  Int(1))
        NBKAssertCompareStrictSignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(4),  Int(1))
    }
    
    func testCompareLenientUnsignedInteger() {
        NBKAssertCompareLenientUnsignedInteger([ 2,  2        ] as W, [ 1            ] as W,  Int(1))
        NBKAssertCompareLenientUnsignedInteger([ 2,  2        ] as W, [~1            ] as W,  Int(1))
        NBKAssertCompareLenientUnsignedInteger([~2, ~2        ] as W, [ 1            ] as W,  Int(1))
        NBKAssertCompareLenientUnsignedInteger([~2, ~2        ] as W, [~1            ] as W,  Int(1))
        
        NBKAssertCompareLenientUnsignedInteger([~0, ~0, ~0, ~0] as W, [~0, ~0, ~0, ~0] as W,  Int(0))
        NBKAssertCompareLenientUnsignedInteger([~0, ~0, ~0, ~0] as W, [ 0,  0,  0,  0] as W,  Int(1))
        NBKAssertCompareLenientUnsignedInteger([ 0,  0,  0,  0] as W, [~0, ~0, ~0, ~0] as W, -Int(1))
        NBKAssertCompareLenientUnsignedInteger([ 0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W,  Int(0))
        
        NBKAssertCompareLenientUnsignedInteger([ 0,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareLenientUnsignedInteger([ 1,  0,  3,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareLenientUnsignedInteger([ 1,  2,  0,  4] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareLenientUnsignedInteger([ 1,  2,  3,  0] as W, [ 1,  2,  3,  4] as W, -Int(1))
        NBKAssertCompareLenientUnsignedInteger([ 0,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(0))
        NBKAssertCompareLenientUnsignedInteger([ 1,  0,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(0))
        NBKAssertCompareLenientUnsignedInteger([ 1,  2,  0,  4] as W, [ 1,  2,  0,  4] as W,  Int(0))
        NBKAssertCompareLenientUnsignedInteger([ 1,  2,  3,  0] as W, [ 1,  2,  3,  0] as W,  Int(0))
        NBKAssertCompareLenientUnsignedInteger([ 1,  2,  3,  4] as W, [ 0,  2,  3,  4] as W,  Int(1))
        NBKAssertCompareLenientUnsignedInteger([ 1,  2,  3,  4] as W, [ 1,  0,  3,  4] as W,  Int(1))
        NBKAssertCompareLenientUnsignedInteger([ 1,  2,  3,  4] as W, [ 1,  2,  0,  4] as W,  Int(1))
        NBKAssertCompareLenientUnsignedInteger([ 1,  2,  3,  4] as W, [ 1,  2,  3,  0] as W,  Int(1))
    }
    
    func testCompareLenientUnsignedIntegerIsLenient() {
        NBKAssertCompareLenientUnsignedInteger([1] as W, [ ] as W,  Int(1))
        NBKAssertCompareLenientUnsignedInteger([ ] as W, [ ] as W,  Int(0))
        NBKAssertCompareLenientUnsignedInteger([ ] as W, [1] as W, -Int(1))
    }
    
    func testCompareLenientUnsignedIntegerAtIndex() {
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 1] as W, [ 1] as W, Int(1), -Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([~1] as W, [~1] as W, Int(1), -Int(1))
        
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(0))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(0))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(0))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(0))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(0))

        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0), -Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1), -Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2), -Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  0,  0,  0,  0,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))

        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(0),  Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(1),  Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(2),  Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(3),  Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 0,  0,  0,  0] as W, Int(4),  Int(1))

        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(0),  Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(1),  Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(2),  Int(0))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(3), -Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ 0,  0,  1,  2,  3,  4,  0,  0] as W, [ 1,  2,  3,  4] as W, Int(4), -Int(1))
        
        NBKAssertCompareLenientUnsignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(0),  Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(1),  Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(2),  Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(3),  Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([~0, ~0, ~1, ~2, ~3, ~4, ~0, ~0] as W, [~1, ~2, ~3, ~4] as W, Int(4),  Int(1))
    }
    
    func testCompareLenientUnsignedIntegerAtIndexIsLenient() {
        NBKAssertCompareLenientUnsignedIntegerAtIndex([1] as W, [ ] as W, Int(1),  Int(1))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ ] as W, [ ] as W, Int(1),  Int(0))
        NBKAssertCompareLenientUnsignedIntegerAtIndex([ ] as W, [1] as W, Int(1), -Int(1))
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Comparisons x Assertions
//*============================================================================*

private func NBKAssertCompareStrictSignedInteger(
_ lhs: [UInt], _ rhs: [UInt], _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(NBK.compareStrictSignedInteger(lhs, to: rhs),  signum, file: file, line: line)
        XCTAssertEqual(NBK.compareStrictSignedInteger(rhs, to: lhs), -signum, file: file, line: line)
    }}
}

private func NBKAssertCompareStrictSignedIntegerAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(NBK.compareStrictSignedInteger(lhs, to: rhs, at: index),  signum, file: file, line: line)
    }}
    //=------------------------------------------=
    NBKAssertCompareStrictSignedInteger(lhs, Array(repeating: UInt.zero, count: index) + rhs, signum, file: file, line: line)
}

private func NBKAssertCompareLenientUnsignedInteger(
_ lhs: [UInt], _ rhs: [UInt], _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(NBK.compareLenientUnsignedInteger(lhs, to: rhs),  signum, file: file, line: line)
        XCTAssertEqual(NBK.compareLenientUnsignedInteger(rhs, to: lhs), -signum, file: file, line: line)
    }}
}

private func NBKAssertCompareLenientUnsignedIntegerAtIndex(
_ lhs: [UInt], _ rhs: [UInt], _ index: Int, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    lhs.withUnsafeBufferPointer { lhs in
    rhs.withUnsafeBufferPointer { rhs in
        XCTAssertEqual(NBK.compareLenientUnsignedInteger(lhs, to: rhs, at: index), signum, file: file, line: line)
    }}
    //=------------------------------------------=
    NBKAssertCompareLenientUnsignedInteger(lhs, Array(repeating: UInt.zero, count: index) + rhs, signum, file: file, line: line)
}

#endif
