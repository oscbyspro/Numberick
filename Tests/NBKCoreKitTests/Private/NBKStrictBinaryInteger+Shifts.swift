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
// MARK: * NBK x Strict Binary Integer x Shifts
//*============================================================================*

final class NBKStrictBinaryIntegerTestsOnShifts: XCTestCase {
    
    private typealias T8 = [UInt8]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitShiftingLeftByBits() {
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8,  0 as UInt8,  0 as Int, [ 1,  2,  3,  4] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8,  0 as UInt8,  1 as Int, [ 2,  4,  6,  8] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8,  0 as UInt8,  2 as Int, [ 4,  8, 12, 16] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8,  0 as UInt8,  3 as Int, [ 8, 16, 24, 32] as T8)
        
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8, ~0 as UInt8,  0 as Int, [ 1,  2,  3,  4] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8, ~0 as UInt8,  1 as Int, [ 3,  4,  6,  8] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8, ~0 as UInt8,  2 as Int, [ 7,  8, 12, 16] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8, ~0 as UInt8,  3 as Int, [15, 16, 24, 32] as T8)
    }
    
    func testBitShiftingLeftByWords() {
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8,  0 as UInt8,  0 as Int, [ 1,  2,  3,  4] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8,  0 as UInt8,  8 as Int, [ 0,  1,  2,  3] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8,  0 as UInt8, 16 as Int, [ 0,  0,  1,  2] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8,  0 as UInt8, 24 as Int, [ 0,  0,  0,  1] as T8)
        
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8, ~0 as UInt8,  0 as Int, [ 1,  2,  3,  4] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8, ~0 as UInt8,  8 as Int, [~0,  1,  2,  3] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8, ~0 as UInt8, 16 as Int, [~0, ~0,  1,  2] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8, ~0 as UInt8, 24 as Int, [~0, ~0, ~0,  1] as T8)
    }
    
    func testBitShiftingLeftByWordsAndBits() {
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8,  0 as UInt8,  3 as Int, [ 8, 16, 24, 32] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8,  0 as UInt8, 11 as Int, [ 0,  8, 16, 24] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8,  0 as UInt8, 19 as Int, [ 0,  0,  8, 16] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8,  0 as UInt8, 27 as Int, [ 0,  0,  0,  8] as T8)
        
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8, ~0 as UInt8,  3 as Int, [15, 16, 24, 32] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8, ~0 as UInt8, 11 as Int, [~0, 15, 16, 24] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8, ~0 as UInt8, 19 as Int, [~0, ~0, 15, 16] as T8)
        NBKAssertShiftLeft([ 1,  2,  3,  4] as T8, ~0 as UInt8, 27 as Int, [~0, ~0, ~0, 15] as T8)
    }
    
    func testBitShiftingLeftSuchThatWordsSplit() {
        NBKAssertShiftLeft([~0,  0,  0,  0] as T8,  0 as UInt8,  1 as Int, [~1,  1,  0,  0] as T8)
        NBKAssertShiftLeft([ 0, ~0,  0,  0] as T8,  0 as UInt8,  1 as Int, [ 0, ~1,  1,  0] as T8)
        NBKAssertShiftLeft([ 0,  0, ~0,  0] as T8,  0 as UInt8,  1 as Int, [ 0,  0, ~1,  1] as T8)
        NBKAssertShiftLeft([ 0,  0,  0, ~0] as T8,  0 as UInt8,  1 as Int, [ 0,  0,  0, ~1] as T8)
        
        NBKAssertShiftLeft([~0,  0,  0,  0] as T8, ~0 as UInt8,  1 as Int, [~0,  1,  0,  0] as T8)
        NBKAssertShiftLeft([ 0, ~0,  0,  0] as T8, ~0 as UInt8,  1 as Int, [ 1, ~1,  1,  0] as T8)
        NBKAssertShiftLeft([ 0,  0, ~0,  0] as T8, ~0 as UInt8,  1 as Int, [ 1,  0, ~1,  1] as T8)
        NBKAssertShiftLeft([ 0,  0,  0, ~0] as T8, ~0 as UInt8,  1 as Int, [ 1,  0,  0, ~1] as T8)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitShiftingRightByBits() {
        NBKAssertShiftRight([8, 16, 24, 32] as T8,  0 as UInt8,  0 as Int, [ 8, 16, 24, 32] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8,  0 as UInt8,  1 as Int, [ 4,  8, 12, 16] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8,  0 as UInt8,  2 as Int, [ 2,  4,  6,  8] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8,  0 as UInt8,  3 as Int, [ 1,  2,  3,  4] as T8)
        
        NBKAssertShiftRight([8, 16, 24, 32] as T8, ~0 as UInt8,  0 as Int, [ 8, 16, 24, 32 + ~0 << 8] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8, ~0 as UInt8,  1 as Int, [ 4,  8, 12, 16 + ~0 << 7] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8, ~0 as UInt8,  2 as Int, [ 2,  4,  6,  8 + ~0 << 6] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8, ~0 as UInt8,  3 as Int, [ 1,  2,  3,  4 + ~0 << 5] as T8)
    }

    func testBitShiftingRightByWords() {
        NBKAssertShiftRight([8, 16, 24, 32] as T8,  0 as UInt8,  0 as Int, [ 8, 16, 24, 32] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8,  0 as UInt8,  8 as Int, [16, 24, 32,  0] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8,  0 as UInt8, 16 as Int, [24, 32,  0,  0] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8,  0 as UInt8, 24 as Int, [32,  0,  0,  0] as T8)
        
        NBKAssertShiftRight([8, 16, 24, 32] as T8, ~0 as UInt8,  0 as Int, [ 8, 16, 24, 32] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8, ~0 as UInt8,  8 as Int, [16, 24, 32, ~0] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8, ~0 as UInt8, 16 as Int, [24, 32, ~0, ~0] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8, ~0 as UInt8, 24 as Int, [32, ~0, ~0, ~0] as T8)
    }

    func testBitShiftingRightByWordsAndBits() {
        NBKAssertShiftRight([8, 16, 24, 32] as T8,  0 as UInt8,  3 as Int, [ 1,  2,  3,  4] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8,  0 as UInt8, 11 as Int, [ 2,  3,  4,  0] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8,  0 as UInt8, 19 as Int, [ 3,  4,  0,  0] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8,  0 as UInt8, 27 as Int, [ 4,  0,  0,  0] as T8)
        
        NBKAssertShiftRight([8, 16, 24, 32] as T8, ~0 as UInt8,  3 as Int, [ 1,   2,   3,   4 + ~0 << 5] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8, ~0 as UInt8, 11 as Int, [ 2,   3,   4 + ~0 << 5,  ~0] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8, ~0 as UInt8, 19 as Int, [ 3,   4 + ~0 << 5,  ~0,  ~0] as T8)
        NBKAssertShiftRight([8, 16, 24, 32] as T8, ~0 as UInt8, 27 as Int, [ 4 + ~0 << 5,  ~0,  ~0,  ~0] as T8)
    }
    
    func testBitShiftingRightSuchThatWordsSplit() {
        NBKAssertShiftRight([0,  0,  0,  7] as T8,  0 as UInt8,  1 as Int, [ 0,   0,   1 << 7, 3] as T8)
        NBKAssertShiftRight([0,  0,  7,  0] as T8,  0 as UInt8,  1 as Int, [ 0,   1 << 7,   3, 0] as T8)
        NBKAssertShiftRight([0,  7,  0,  0] as T8,  0 as UInt8,  1 as Int, [ 1 << 7,   3,   0, 0] as T8)
        NBKAssertShiftRight([7,  0,  0,  0] as T8,  0 as UInt8,  1 as Int, [ 3,        0,   0, 0] as T8)
        
        NBKAssertShiftRight([0,  0,  0,  7] as T8, ~0 as UInt8,  1 as Int, [ 0,   0,   1 << 7, 3 + ~0 << 7] as T8)
        NBKAssertShiftRight([0,  0,  7,  0] as T8, ~0 as UInt8,  1 as Int, [ 0,   1 << 7,   3, 0 + ~0 << 7] as T8)
        NBKAssertShiftRight([0,  7,  0,  0] as T8, ~0 as UInt8,  1 as Int, [ 1 << 7,   3,   0, 0 + ~0 << 7] as T8)
        NBKAssertShiftRight([7,  0,  0,  0] as T8, ~0 as UInt8,  1 as Int, [ 3,        0,   0, 0 + ~0 << 7] as T8)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Shifts x Assertions
//*============================================================================*

private func NBKAssertShiftLeft<T: NBKCoreInteger & NBKUnsignedInteger>(
_ base: [T], _ environment: T, _ distance: Int, _ result: [T],
file: StaticString = #file, line: UInt  = #line) {
    //=------------------------------------------=
    typealias SBI = NBK.StrictBinaryInteger<[T]>
    //=------------------------------------------=
    let (major, minor) = distance.quotientAndRemainder(dividingBy: T.bitWidth)
    //=------------------------------------------=
    if  major >= 1, minor == 0 {
        var base = base
        SBI.bitShiftLeft(&base, environment: environment, majorAtLeastOne: major)
        XCTAssertEqual(base, result, file: file, line: line)
    }
    
    if  major >= 0, minor >= 1 {
        var base = base
        SBI.bitShiftLeft(&base, environment: environment, major: major, minorAtLeastOne: minor)
        XCTAssertEqual(base, result, file: file, line: line)
    }
}

private func NBKAssertShiftRight<T: NBKCoreInteger & NBKUnsignedInteger>(
_ base: [T], _ environment: T, _ distance: Int, _ result: [T],
file: StaticString = #file, line: UInt  = #line) {
    //=------------------------------------------=
    typealias SBI = NBK.StrictBinaryInteger<[T]>
    //=------------------------------------------=
    let (major, minor) = distance.quotientAndRemainder(dividingBy: T.bitWidth)
    //=------------------------------------------=
    if  major >= 1, minor == 0 {
        var base = base
        SBI.bitShiftRight(&base, environment: environment, majorAtLeastOne: major)
        XCTAssertEqual(base, result, file: file, line: line)
    }
    
    if  major >= 0, minor >= 1 {
        var base = base
        SBI.bitShiftRight(&base, environment: environment, major: major, minorAtLeastOne: minor)
        XCTAssertEqual(base, result, file: file, line: line)
    }
}
