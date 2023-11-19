//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Shifts x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnShiftsAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitShiftingLeftByBits() {
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64),   0, T(x64:[ 1,  2,  3,  4] as X64))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64),   1, T(x64:[ 2,  4,  6,  8] as X64))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64),   2, T(x64:[ 4,  8, 12, 16] as X64))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64),   3, T(x64:[ 8, 16, 24, 32] as X64))
    }
    
    func testBitShiftingLeftByWords() {
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64),   0, T(x64:[ 1,  2,  3,  4,  0,  0,  0,  0] as X64))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64),  64, T(x64:[ 0,  1,  2,  3,  4,  0,  0,  0] as X64))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64), 128, T(x64:[ 0,  0,  1,  2,  3,  4,  0,  0] as X64))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64), 192, T(x64:[ 0,  0,  0,  1,  2,  3,  4,  0] as X64))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64), 256, T(x64:[ 0,  0,  0,  0,  1,  2,  3,  4] as X64))
    }
    
    func testBitShiftingLeftByWordsAndBits() {
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64),   3, T(x64:[ 8, 16, 24, 32,  0,  0,  0,  0] as X64))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64),  67, T(x64:[ 0,  8, 16, 24, 32,  0,  0,  0] as X64))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64), 131, T(x64:[ 0,  0,  8, 16, 24, 32,  0,  0] as X64))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64), 195, T(x64:[ 0,  0,  0,  8, 16, 24, 32,  0] as X64))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X64), 259, T(x64:[ 0,  0,  0,  0,  8, 16, 24, 32] as X64))
    }
    
    func testBitShiftingLeftSuchThatWordsSplit() {
        NBKAssertShiftLeft(T(x64:[~0,  0,  0,  0] as X64),   1, T(x64:[~1,  1,  0,  0,  0] as X64))
        NBKAssertShiftLeft(T(x64:[ 0, ~0,  0,  0] as X64),   1, T(x64:[ 0, ~1,  1,  0,  0] as X64))
        NBKAssertShiftLeft(T(x64:[ 0,  0, ~0,  0] as X64),   1, T(x64:[ 0,  0, ~1,  1,  0] as X64))
        NBKAssertShiftLeft(T(x64:[ 0,  0,  0, ~0] as X64),   1, T(x64:[ 0,  0,  0, ~1,  1] as X64))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitShiftingRightByBits() {
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64),   0, T(x64:[ 8, 16, 24, 32] as X64))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64),   1, T(x64:[ 4,  8, 12, 16] as X64))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64),   2, T(x64:[ 2,  4,  6,  8] as X64))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64),   3, T(x64:[ 1,  2,  3,  4] as X64))
    }
    
    func testBitShiftingRightByWords() {
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64),   0, T(x64:[ 8, 16, 24, 32] as X64))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64),  64, T(x64:[16, 24, 32,  0] as X64))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64), 128, T(x64:[24, 32,  0,  0] as X64))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64), 192, T(x64:[32,  0,  0,  0] as X64))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64), 256, T(x64:[ 0,  0,  0,  0] as X64))
    }
    
    func testBitShiftingRightByWordsAndBits() {
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64),   3, T(x64:[ 1,  2,  3,  4] as X64))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64),  67, T(x64:[ 2,  3,  4,  0] as X64))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64), 131, T(x64:[ 3,  4,  0,  0] as X64))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64), 195, T(x64:[ 4,  0,  0,  0] as X64))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X64), 259, T(x64:[ 0,  0,  0,  0] as X64))
    }
    
    func testBitShiftingRightSuchThatWordsSplit() {
        NBKAssertShiftRight(T(x64:[0,  0,  0,  7] as X64),   1, T(x64:[ 0,  0,  1 << 63,  3] as X64))
        NBKAssertShiftRight(T(x64:[0,  0,  7,  0] as X64),   1, T(x64:[ 0,  1 << 63,  3,  0] as X64))
        NBKAssertShiftRight(T(x64:[0,  7,  0,  0] as X64),   1, T(x64:[ 1 << 63,  3,  0,  0] as X64))
        NBKAssertShiftRight(T(x64:[7,  0,  0,  0] as X64),   1, T(x64:[ 3,        0,  0,  0] as X64))
    }
    
    func testBitShiftingRightIsUnsigned() {
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X64),   0, T(x64:[0, 0, 0, 1 << 63] as X64))
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X64),  64, T(x64:[0, 0, 1 << 63, 0] as X64))
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X64), 128, T(x64:[0, 1 << 63, 0, 0] as X64))
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X64), 192, T(x64:[1 << 63, 0, 0, 0] as X64))
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X64), 256, T(x64:[0,       0, 0, 0] as X64))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testBitShiftingIsSmart() {
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X64) <<   1, T(x64:[2, 4, 6, 8, 0] as X64))
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X64) >>  -1, T(x64:[2, 4, 6, 8, 0] as X64))
        
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X64) <<  64, T(x64:[0, 1, 2, 3, 4] as X64))
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X64) >> -64, T(x64:[0, 1, 2, 3, 4] as X64))
    }
    
    func testBitShiftingLeftByMoreThanBitWidthDoesNotTrap() {
        NBKAssertShiftLeft (T(x64:[1] as X64),  (UInt.bitWidth + 1), T(x64:[0, 2] as X64))
        NBKAssertShiftRight(T(x64:[1] as X64), -(UInt.bitWidth + 1), T(x64:[0, 2] as X64))
    }
    
    func testBitShiftingRightDoesNotTrap() {
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X64) >> Int.max, T.zero)
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X64) << Int.min, T.zero)
    }
    
    func testBitShiftingZeroDoesNotTrap() {
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X64) << Int.min, T.zero)
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X64) << Int.max, T.zero)
        
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X64) >> Int.min, T.zero)
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X64) >> Int.max, T.zero)
    }
    
    func testBitShiftingZeroDoesNotDoAnything() {
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X64) << (UInt.bitWidth + 0), T.zero)
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X64) << (UInt.bitWidth + 1), T.zero)
        
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X64) >> (UInt.bitWidth + 0), T.zero)
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X64) >> (UInt.bitWidth + 1), T.zero)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Shifts x Assertions
//*============================================================================*

private func NBKAssertShiftLeft<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let (major, minor) = rhs.quotientAndRemainder(dividingBy: UInt.bitWidth)
    //=------------------------------------------=
    XCTAssertEqual(                 lhs <<   rhs,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs >>  -rhs,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs <<=  rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs >>= -rhs; return lhs }(), result, file: file, line: line)
        
    XCTAssertEqual(lhs.bitShiftedLeftSmart(by:   rhs), result, file: file, line: line)
    XCTAssertEqual(lhs.bitShiftedRightSmart(by: -rhs), result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs.bitShiftLeftSmart(by:   rhs); return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.bitShiftRightSmart(by: -rhs); return lhs }(), result, file: file, line: line)
    //=------------------------------------------=
    if  major >= 0, minor >= 0 {
        XCTAssertEqual(lhs.bitShiftedLeft(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitShiftLeft(by: rhs); return lhs }(), result, file: file, line: line)
    }
    
    if  major >= 0, minor >= 0 {
        XCTAssertEqual(lhs.bitShiftedLeft(major: major, minor: minor), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitShiftLeft(major: major, minor: minor); return lhs }(), result, file: file, line: line)
    }
    
    if  major >= 0, minor == 0 {
        XCTAssertEqual(lhs.bitShiftedLeft(major: major), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitShiftLeft(major: major); return lhs }(), result, file: file, line: line)
    }
}

private func NBKAssertShiftRight<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let (major, minor) = rhs.quotientAndRemainder(dividingBy: UInt.bitWidth)
    //=------------------------------------------=
    XCTAssertEqual(                 lhs >>   rhs,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs <<  -rhs,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs >>=  rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs <<= -rhs; return lhs }(), result, file: file, line: line)
        
    XCTAssertEqual(lhs.bitShiftedRightSmart(by: rhs), result, file: file, line: line)
    XCTAssertEqual(lhs.bitShiftedLeftSmart(by: -rhs), result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs.bitShiftRightSmart(by: rhs); return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.bitShiftLeftSmart(by: -rhs); return lhs }(), result, file: file, line: line)
    //=------------------------------------------=
    if  major >= 0, minor >= 0 {
        XCTAssertEqual(lhs.bitShiftedRight(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitShiftRight(by: rhs); return lhs }(), result, file: file, line: line)
    }
    
    if  major >= 0, minor >= 0 {
        XCTAssertEqual(lhs.bitShiftedRight(major: major, minor: minor), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitShiftRight(major: major, minor: minor); return lhs }(), result, file: file, line: line)
    }

    if  major >= 0, minor == 0 {
        XCTAssertEqual(lhs.bitShiftedRight(major: major), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitShiftRight(major: major); return lhs }(), result, file: file, line: line)
    }
}
