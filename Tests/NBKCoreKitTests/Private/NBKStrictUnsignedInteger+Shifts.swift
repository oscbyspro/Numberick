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
// MARK: * NBK x Strict Unsigned Integer x Shifts
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnShiftsAsUInt8: XCTestCase {
    
    private typealias U8 = [UInt8]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitshiftingLeftByBits() {
        NBKAssertShiftLeft([ 1,  2,  3,  4] as U8, 00, [ 1,  2,  3,  4] as U8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as U8, 01, [ 2,  4,  6,  8] as U8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as U8, 02, [ 4,  8, 12, 16] as U8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as U8, 03, [ 8, 16, 24, 32] as U8)
    }
    
    func testBitshiftingLeftByWords() {
        NBKAssertShiftLeft([ 1,  2,  3,  4] as U8, 00, [ 1,  2,  3,  4] as U8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as U8, 08, [ 0,  1,  2,  3] as U8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as U8, 16, [ 0,  0,  1,  2] as U8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as U8, 24, [ 0,  0,  0,  1] as U8)
    }
    
    func testBitshiftingLeftByWordsAndBits() {
        NBKAssertShiftLeft([ 1,  2,  3,  4] as U8, 03, [ 8, 16, 24, 32] as U8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as U8, 11, [ 0,  8, 16, 24] as U8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as U8, 19, [ 0,  0,  8, 16] as U8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as U8, 27, [ 0,  0,  0,  8] as U8)
    }
    
    func testBitshiftingLeftSuchThatWordsSplit() {
        NBKAssertShiftLeft([~0,  0,  0,  0] as U8, 01, [~1,  1,  0,  0] as U8)
        NBKAssertShiftLeft([ 0, ~0,  0,  0] as U8, 01, [ 0, ~1,  1,  0] as U8)
        NBKAssertShiftLeft([ 0,  0, ~0,  0] as U8, 01, [ 0,  0, ~1,  1] as U8)
        NBKAssertShiftLeft([ 0,  0,  0, ~0] as U8, 01, [ 0,  0,  0, ~1] as U8)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRightByBits() {
        NBKAssertShiftRight([8, 16, 24, 32] as U8, 00, [ 8, 16, 24, 32] as U8)
        NBKAssertShiftRight([8, 16, 24, 32] as U8, 01, [ 4,  8, 12, 16] as U8)
        NBKAssertShiftRight([8, 16, 24, 32] as U8, 02, [ 2,  4,  6,  8] as U8)
        NBKAssertShiftRight([8, 16, 24, 32] as U8, 03, [ 1,  2,  3,  4] as U8)
    }
    
    func testBitshiftingRightByWords() {
        NBKAssertShiftRight([8, 16, 24, 32] as U8, 00, [ 8, 16, 24, 32] as U8)
        NBKAssertShiftRight([8, 16, 24, 32] as U8, 08, [16, 24, 32,  0] as U8)
        NBKAssertShiftRight([8, 16, 24, 32] as U8, 16, [24, 32,  0,  0] as U8)
        NBKAssertShiftRight([8, 16, 24, 32] as U8, 24, [32,  0,  0,  0] as U8)
    }
    
    func testBitshiftingRightByWordsAndBits() {
        NBKAssertShiftRight([8, 16, 24, 32] as U8, 03, [ 1,  2,  3,  4] as U8)
        NBKAssertShiftRight([8, 16, 24, 32] as U8, 11, [ 2,  3,  4,  0] as U8)
        NBKAssertShiftRight([8, 16, 24, 32] as U8, 19, [ 3,  4,  0,  0] as U8)
        NBKAssertShiftRight([8, 16, 24, 32] as U8, 27, [ 4,  0,  0,  0] as U8)
    }
    
    func testBitshiftingRightSuchThatWordsSplit() {
        NBKAssertShiftRight([0,  0,  0,  7] as U8, 01, [ 0, 0, 1 << 7, 3] as U8)
        NBKAssertShiftRight([0,  0,  7,  0] as U8, 01, [ 0, 1 << 7, 3, 0] as U8)
        NBKAssertShiftRight([0,  7,  0,  0] as U8, 01, [ 1 << 7, 3, 0, 0] as U8)
        NBKAssertShiftRight([7,  0,  0,  0] as U8, 01, [ 3,      0, 0, 0] as U8)
    }
    
    func testBitshiftingRightIsUnsigned() {
        NBKAssertShiftRight([0, 0, 0, 1 << 7] as U8, 00, [0, 0, 0, 1 << 7] as U8)
        NBKAssertShiftRight([0, 0, 0, 1 << 7] as U8, 08, [0, 0, 1 << 7, 0] as U8)
        NBKAssertShiftRight([0, 0, 0, 1 << 7] as U8, 16, [0, 1 << 7, 0, 0] as U8)
        NBKAssertShiftRight([0, 0, 0, 1 << 7] as U8, 24, [1 << 7, 0, 0, 0] as U8)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Shifts x Assertions
//*============================================================================*

private func NBKAssertShiftLeft<T: NBKCoreInteger & NBKUnsignedInteger>(
_ base: [T], _ distance: Int, _ result: [T],
file: StaticString = #file, line: UInt  = #line) {
    //=------------------------------------------=
    typealias SBI = NBK.StrictUnsignedInteger<[T]>
    //=------------------------------------------=
    let (major, minor) = distance.quotientAndRemainder(dividingBy: T.bitWidth)
    //=------------------------------------------=
    brr: do {
        var base = base
        SBI.bitshiftLeft(&base, by: distance)
        XCTAssertEqual(base, result, file: file, line: line)
    }
    
    brr: do {
        var base = base
        SBI.bitshiftLeft(&base, major: major, minor: minor)
        XCTAssertEqual(base, result, file: file, line: line)
    }

    if  minor.isZero {
        var base = base
        SBI.bitshiftLeft(&base, major: major)
        XCTAssertEqual(base, result, file: file, line: line)
    }
}

private func NBKAssertShiftRight<T: NBKCoreInteger & NBKUnsignedInteger>(
_ base: [T], _ distance: Int, _ result: [T],
file: StaticString = #file, line: UInt  = #line) {
    //=------------------------------------------=
    typealias SBI = NBK.StrictUnsignedInteger<[T]>
    //=------------------------------------------=
    let (major, minor) = distance.quotientAndRemainder(dividingBy: T.bitWidth)
    //=------------------------------------------=
    brr: do {
        var base = base
        SBI.bitshiftRight(&base, by: distance)
        XCTAssertEqual(base, result, file: file, line: line)
    }
    
    brr: do {
        var base = base
        SBI.bitshiftRight(&base, major: major, minor: minor)
        XCTAssertEqual(base, result, file: file, line: line)
    }

    if  minor.isZero {
        var base = base
        SBI.bitshiftRight(&base, major: major)
        XCTAssertEqual(base, result, file: file, line: line)
    }
}

#endif
