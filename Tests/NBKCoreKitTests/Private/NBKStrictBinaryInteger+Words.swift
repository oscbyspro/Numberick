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

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Words
//*============================================================================*

final class NBKStrictBinaryIntegerTestsOnWords: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWithUnsafeWordsOfInt() {
        NBKAssertWithBitPatternOf(Int(-4), [~3])
        NBKAssertWithBitPatternOf(Int(-3), [~2])
        NBKAssertWithBitPatternOf(Int(-2), [~1])
        NBKAssertWithBitPatternOf(Int(-1), [~0])
        NBKAssertWithBitPatternOf(Int( 0), [ 0])
        NBKAssertWithBitPatternOf(Int( 1), [ 1])
        NBKAssertWithBitPatternOf(Int( 2), [ 2])
        NBKAssertWithBitPatternOf(Int( 3), [ 3])
    }
    
    func testWithUnsafeWordsOfUInt() {
        NBKAssertWithBitPatternOf(UInt(0), [ 0])
        NBKAssertWithBitPatternOf(UInt(1), [ 1])
        NBKAssertWithBitPatternOf(UInt(2), [ 2])
        NBKAssertWithBitPatternOf(UInt(3), [ 3])
        NBKAssertWithBitPatternOf(UInt(4), [ 4])
        NBKAssertWithBitPatternOf(UInt(5), [ 5])
        NBKAssertWithBitPatternOf(UInt(6), [ 6])
        NBKAssertWithBitPatternOf(UInt(7), [ 7])
    }
}

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Words x Assertions
//*============================================================================*

private func NBKAssertWithBitPatternOf<T: NBKCoreInteger>(
_ lhs: T, _ rhs: [T.BitPattern],
file: StaticString = #file, line: UInt  = #line) {
    //=------------------------------------------=
    typealias SBI = NBK.StrictBinaryInteger<UnsafeBufferPointer<T.BitPattern>>
    //=------------------------------------------=
    SBI.withUnsafeBufferPointer(to: lhs.bitPattern) {
        XCTAssertEqual(Array($0), rhs, file: file, line: line)
    }
}

#endif
