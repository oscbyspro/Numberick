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
    
    func testBitshiftingLeftByBits() {
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),   0, T(x64:[ 1,  2,  3,  4] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),   1, T(x64:[ 2,  4,  6,  8] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),   2, T(x64:[ 4,  8, 12, 16] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),   3, T(x64:[ 8, 16, 24, 32] as X))
    }
    
    func testBitshiftingLeftByWords() {
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),   0, T(x64:[ 1,  2,  3,  4,  0,  0,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),  64, T(x64:[ 0,  1,  2,  3,  4,  0,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X), 128, T(x64:[ 0,  0,  1,  2,  3,  4,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X), 192, T(x64:[ 0,  0,  0,  1,  2,  3,  4,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X), 256, T(x64:[ 0,  0,  0,  0,  1,  2,  3,  4] as X))
    }
    
    func testBitshiftingLeftByWordsAndBits() {
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),   3, T(x64:[ 8, 16, 24, 32,  0,  0,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X),  67, T(x64:[ 0,  8, 16, 24, 32,  0,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X), 131, T(x64:[ 0,  0,  8, 16, 24, 32,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X), 195, T(x64:[ 0,  0,  0,  8, 16, 24, 32,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 1,  2,  3,  4] as X), 259, T(x64:[ 0,  0,  0,  0,  8, 16, 24, 32] as X))
    }
    
    func testBitshiftingLeftSuchThatWordsSplit() {
        NBKAssertShiftLeft(T(x64:[~0,  0,  0,  0] as X),   1, T(x64:[~1,  1,  0,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 0, ~0,  0,  0] as X),   1, T(x64:[ 0, ~1,  1,  0,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 0,  0, ~0,  0] as X),   1, T(x64:[ 0,  0, ~1,  1,  0] as X))
        NBKAssertShiftLeft(T(x64:[ 0,  0,  0, ~0] as X),   1, T(x64:[ 0,  0,  0, ~1,  1] as X))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRightByBits() {
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),   0, T(x64:[ 8, 16, 24, 32] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),   1, T(x64:[ 4,  8, 12, 16] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),   2, T(x64:[ 2,  4,  6,  8] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),   3, T(x64:[ 1,  2,  3,  4] as X))
    }
    
    func testBitshiftingRightByWords() {
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),   0, T(x64:[ 8, 16, 24, 32] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),  64, T(x64:[16, 24, 32,  0] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X), 128, T(x64:[24, 32,  0,  0] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X), 192, T(x64:[32,  0,  0,  0] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X), 256, T(x64:[ 0,  0,  0,  0] as X))
    }
    
    func testBitshiftingRightByWordsAndBits() {
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),   3, T(x64:[ 1,  2,  3,  4] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X),  67, T(x64:[ 2,  3,  4,  0] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X), 131, T(x64:[ 3,  4,  0,  0] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X), 195, T(x64:[ 4,  0,  0,  0] as X))
        NBKAssertShiftRight(T(x64:[8, 16, 24, 32] as X), 259, T(x64:[ 0,  0,  0,  0] as X))
    }
    
    func testBitshiftingRightSuchThatWordsSplit() {
        NBKAssertShiftRight(T(x64:[0,  0,  0,  7] as X),   1, T(x64:[ 0,  0,  1 << 63,  3] as X))
        NBKAssertShiftRight(T(x64:[0,  0,  7,  0] as X),   1, T(x64:[ 0,  1 << 63,  3,  0] as X))
        NBKAssertShiftRight(T(x64:[0,  7,  0,  0] as X),   1, T(x64:[ 1 << 63,  3,  0,  0] as X))
        NBKAssertShiftRight(T(x64:[7,  0,  0,  0] as X),   1, T(x64:[ 3,        0,  0,  0] as X))
    }
    
    func testBitshiftingRightIsUnsigned() {
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X),   0, T(x64:[0, 0, 0, 1 << 63] as X))
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X),  64, T(x64:[0, 0, 1 << 63, 0] as X))
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X), 128, T(x64:[0, 1 << 63, 0, 0] as X))
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X), 192, T(x64:[1 << 63, 0, 0, 0] as X))
        NBKAssertShiftRight(T(x64:[0, 0, 0, 1 << 63] as X), 256, T(x64:[0,       0, 0, 0] as X))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testBitshiftingIsSmart() {
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X) <<   1, T(x64:[2, 4, 6, 8, 0] as X))
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X) >>  -1, T(x64:[2, 4, 6, 8, 0] as X))
        
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X) <<  64, T(x64:[0, 1, 2, 3, 4] as X))
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X) >> -64, T(x64:[0, 1, 2, 3, 4] as X))
    }
    
    func testBitshiftingLeftByMoreThanBitWidthDoesNotTrap() {
        NBKAssertShiftLeft (T(x64:[1] as X),  (UInt.bitWidth + 1), T(x64:[0, 2] as X))
        NBKAssertShiftRight(T(x64:[1] as X), -(UInt.bitWidth + 1), T(x64:[0, 2] as X))
    }
    
    func testBitshiftingRightDoesNotTrap() {
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X) >> Int.max, T.zero)
        XCTAssertEqual(T(x64:[1, 2, 3, 4] as X) << Int.min, T.zero)
    }
    
    func testBitshiftingZeroDoesNotTrap() {
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X) << Int.min, T.zero)
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X) << Int.max, T.zero)
        
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X) >> Int.min, T.zero)
        XCTAssertEqual(T(x64:[0, 0, 0, 0] as X) >> Int.max, T.zero)
    }
    
    func testBitshiftingZeroDoesNotDoAnything() {
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
        
    XCTAssertEqual(lhs.bitshiftedLeftSmart(by:   rhs), result, file: file, line: line)
    XCTAssertEqual(lhs.bitshiftedRightSmart(by: -rhs), result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftSmart(by:   rhs); return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightSmart(by: -rhs); return lhs }(), result, file: file, line: line)
    //=------------------------------------------=
    if  major >= 0, minor >= 0 {
        XCTAssertEqual(lhs.bitshiftedLeft(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(by: rhs); return lhs }(), result, file: file, line: line)
    }
    
    if  major >= 0, minor >= 0 {
        XCTAssertEqual(lhs.bitshiftedLeft(major: major, minor: minor), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(major: major, minor: minor); return lhs }(), result, file: file, line: line)
    }
    
    if  major >= 0, minor == 0 {
        XCTAssertEqual(lhs.bitshiftedLeft(major: major), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(major: major); return lhs }(), result, file: file, line: line)
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
        
    XCTAssertEqual(lhs.bitshiftedRightSmart(by: rhs), result, file: file, line: line)
    XCTAssertEqual(lhs.bitshiftedLeftSmart(by: -rhs), result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightSmart(by: rhs); return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftSmart(by: -rhs); return lhs }(), result, file: file, line: line)
    //=------------------------------------------=
    if  major >= 0, minor >= 0 {
        XCTAssertEqual(lhs.bitshiftedRight(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(by: rhs); return lhs }(), result, file: file, line: line)
    }
    
    if  major >= 0, minor >= 0 {
        XCTAssertEqual(lhs.bitshiftedRight(major: major, minor: minor), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(major: major, minor: minor); return lhs }(), result, file: file, line: line)
    }

    if  major >= 0, minor == 0 {
        XCTAssertEqual(lhs.bitshiftedRight(major: major), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(major: major); return lhs }(), result, file: file, line: line)
    }
}

#endif
