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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Shifts x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnShiftsAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitShiftingLeftByBits() {
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),   0, T(x64:[ 1,  2,  3,  4] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),   1, T(x64:[ 2,  4,  6,  8] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),   2, T(x64:[ 4,  8, 12, 16] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),   3, T(x64:[ 8, 16, 24, 32] as X))
    }
    
    func testBitShiftingLeftByWords() {
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),   0, T(x64:[ 1,  2,  3,  4,  0,  0,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),  64, T(x64:[ 0,  1,  2,  3,  4,  0,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X), 128, T(x64:[ 0,  0,  1,  2,  3,  4,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X), 192, T(x64:[ 0,  0,  0,  1,  2,  3,  4,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X), 256, T(x64:[ 0,  0,  0,  0,  1,  2,  3,  4] as X))
    }
    
    func testBitShiftingLeftByWordsAndBits() {
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),   3, T(x64:[ 8, 16, 24, 32,  0,  0,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),  67, T(x64:[ 0,  8, 16, 24, 32,  0,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X), 131, T(x64:[ 0,  0,  8, 16, 24, 32,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X), 195, T(x64:[ 0,  0,  0,  8, 16, 24, 32,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X), 259, T(x64:[ 0,  0,  0,  0,  8, 16, 24, 32] as X))
    }
    
    func testBitShiftingLeftSuchThatWordsSplit() {
        NBKAssertShiftLeft(T(x64:[~0,  0,  0,  0] as X),   1, T(x64:[~1,  1,  0,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 0, ~0,  0,  0] as X),   1, T(x64:[ 0, ~1,  1,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 0,  0, ~0,  0] as X),   1, T(x64:[ 0,  0, ~1,  1,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 0,  0,  0, ~0] as X),   1, T(x64:[ 0,  0,  0, ~1,  1] as X))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitShiftingRightByBits() {
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),   0, T(x64:[ 8, 16, 24, 32] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),   1, T(x64:[ 4,  8, 12, 16] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),   2, T(x64:[ 2,  4,  6,  8] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),   3, T(x64:[ 1,  2,  3,  4] as X))
    }
    
    func testBitShiftingRightByWords() {
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),   0, T(x64:[ 8, 16, 24, 32] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),  64, T(x64:[16, 24, 32,  0] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X), 128, T(x64:[24, 32,  0,  0] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X), 192, T(x64:[32,  0,  0,  0] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X), 256, T(x64:[ 0,  0,  0,  0] as X))
    }
    
    func testBitShiftingRightByWordsAndBits() {
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),   3, T(x64:[ 1,  2,  3,  4] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),  67, T(x64:[ 2,  3,  4,  0] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X), 131, T(x64:[ 3,  4,  0,  0] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X), 195, T(x64:[ 4,  0,  0,  0] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X), 259, T(x64:[ 0,  0,  0,  0] as X))
    }
    
    func testBitShiftingRightSuchThatWordsSplit() {
        NBKAssertShiftRight(T(x64:[0,  0,  0,  7] as X),   1, T(x64:[ 0,  0,  1 << 63,  3] as X))
        NBKAssertShiftRight(T(x64:[0,  0,  7,  0] as X),   1, T(x64:[ 0,  1 << 63,  3,  0] as X))
        NBKAssertShiftRight(T(x64:[0,  7,  0,  0] as X),   1, T(x64:[ 1 << 63,  3,  0,  0] as X))
        NBKAssertShiftRight(T(x64:[7,  0,  0,  0] as X),   1, T(x64:[ 3,        0,  0,  0] as X))
    }
    
    func testBitShiftingRightIsUnsigned() {
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X),   0, T(x64:[0, 0, 0, 1 << 63] as X))
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X),  64, T(x64:[0, 0, 1 << 63, 0] as X))
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X), 128, T(x64:[0, 1 << 63, 0, 0] as X))
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X), 192, T(x64:[1 << 63, 0, 0, 0] as X))
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X), 256, T(x64:[0,       0, 0, 0] as X))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testBitShiftingIsSmart() {
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X) <<   1, T(x64:[2, 4, 6, 8, 0] as X))
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X) >>  -1, T(x64:[2, 4, 6, 8, 0] as X))
        
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X) <<  64, T(x64:[0, 1, 2, 3, 4] as X))
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X) >> -64, T(x64:[0, 1, 2, 3, 4] as X))
    }
    
    func testBitShiftingLeftByMoreThanBitWidthDoesNotTrap() {
        NBKAssertShiftLeft (T(x64:[1] as X),  (UInt.bitWidth + 1), T(x64:[0, 2] as X))
        NBKAssertShiftRight(T(x64:[1] as X), -(UInt.bitWidth + 1), T(x64:[0, 2] as X))
    }
    
    func testBitShiftingRightDoesNotTrap() {
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X) >> Int.max, T.zero)
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X) << Int.min, T.zero)
    }
    
    func testBitShiftingZeroDoesNotTrap() {
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X) << Int.min, T.zero)
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X) << Int.max, T.zero)
        
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X) >> Int.min, T.zero)
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X) >> Int.max, T.zero)
    }
    
    func testBitShiftingZeroDoesNotDoAnything() {
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X) << (UInt.bitWidth + 0), T.zero)
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X) << (UInt.bitWidth + 1), T.zero)
        
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X) >> (UInt.bitWidth + 0), T.zero)
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X) >> (UInt.bitWidth + 1), T.zero)
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
