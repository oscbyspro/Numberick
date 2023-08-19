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
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Shifts x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnShiftsAsInt256: XCTestCase {
    
    typealias S = Int256
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitshiftingLeftByBits() {
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),   1, T(x64: X( 2,  4,  6,  8)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),   2, T(x64: X( 4,  8, 12, 16)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),   3, T(x64: X( 8, 16, 24, 32)))
    }
    
    func testBitshiftingLeftByWords() {
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),  64, T(x64: X( 0,  1,  2,  3)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)), 128, T(x64: X( 0,  0,  1,  2)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)), 192, T(x64: X( 0,  0,  0,  1)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)), 256, T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingLeftByWordsAndBits() {
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),   3, T(x64: X( 8, 16, 24, 32)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),  67, T(x64: X( 0,  8, 16, 24)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)), 131, T(x64: X( 0,  0,  8, 16)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)), 195, T(x64: X( 0,  0,  0,  8)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)), 259, T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingLeftSuchThatWordsSplit() {
        NBKAssertShiftLeft(T(x64: X(~0,  0,  0,  0)),   1, T(x64: X(~1,  1,  0,  0)))
        NBKAssertShiftLeft(T(x64: X( 0, ~0,  0,  0)),   1, T(x64: X( 0, ~1,  1,  0)))
        NBKAssertShiftLeft(T(x64: X( 0,  0, ~0,  0)),   1, T(x64: X( 0,  0, ~1,  1)))
        NBKAssertShiftLeft(T(x64: X( 0,  0,  0, ~0)),   1, T(x64: X( 0,  0,  0, ~1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRightByBits() {
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),   0, T(x64: X( 8, 16, 24, 32)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),   1, T(x64: X( 4,  8, 12, 16)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),   2, T(x64: X( 2,  4,  6,  8)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),   3, T(x64: X( 1,  2,  3,  4)))
    }
    
    func testBitshiftingRightByWords() {
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),   0, T(x64: X( 8, 16, 24, 32)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),  64, T(x64: X(16, 24, 32,  0)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)), 128, T(x64: X(24, 32,  0,  0)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)), 192, T(x64: X(32,  0,  0,  0)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)), 256, T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingRightByWordsAndBits() {
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),   3, T(x64: X( 1,  2,  3,  4)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),  67, T(x64: X( 2,  3,  4,  0)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)), 131, T(x64: X( 3,  4,  0,  0)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)), 195, T(x64: X( 4,  0,  0,  0)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)), 259, T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingRightSuchThatWordsSplit() {
        NBKAssertShiftRight(T(x64: X(0,  0,  0,  7)),   1, T(x64: X( 0,  0,  1 << 63,  3)))
        NBKAssertShiftRight(T(x64: X(0,  0,  7,  0)),   1, T(x64: X( 0,  1 << 63,  3,  0)))
        NBKAssertShiftRight(T(x64: X(0,  7,  0,  0)),   1, T(x64: X( 1 << 63,  3,  0,  0)))
        NBKAssertShiftRight(T(x64: X(7,  0,  0,  0)),   1, T(x64: X( 3,        0,  0,  0)))
    }
    
    func testBitshiftingRightIsSigned() {
        NBKAssertShiftRight(T(x64: X(0, 0, 0, 1 << 63)),   0, T(x64: X( 0,  0,  0,  1 << 63)))
        NBKAssertShiftRight(T(x64: X(0, 0, 0, 1 << 63)),  64, T(x64: X( 0,  0,  1 << 63, ~0)))
        NBKAssertShiftRight(T(x64: X(0, 0, 0, 1 << 63)), 128, T(x64: X( 0,  1 << 63, ~0, ~0)))
        NBKAssertShiftRight(T(x64: X(0, 0, 0, 1 << 63)), 192, T(x64: X( 1 << 63, ~0, ~0, ~0)))
        NBKAssertShiftRight(T(x64: X(0, 0, 0, 1 << 63)), 256, T(x64: X(~0,       ~0, ~0, ~0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testBitshiftingIsSmart() {
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) <<   1, T(x64: X(2, 4, 6, 8)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) >>  -1, T(x64: X(2, 4, 6, 8)))
        
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) <<  64, T(x64: X(0, 1, 2, 3)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) >> -64, T(x64: X(0, 1, 2, 3)))
    }
    
    func testBitshiftingByMinDistanceDoesNotTrap() {
        XCTAssertEqual(T(repeating: true) << Int.min, T(repeating: true ))
        XCTAssertEqual(T(repeating: true) >> Int.min, T(repeating: false))
    }
    
    func testBitshiftingByMaskingIsEquivalentToBitshiftingModuloBitWidth() {
        NBKAssertShiftLeftByMasking (T(x64: X(1, 2, 3, 4)),  256, T(x64: X(1, 2, 3, 4)), signitude: S.self)
        NBKAssertShiftLeftByMasking (T(x64: X(1, 2, 3, 4)), -256, T(x64: X(1, 2, 3, 4)), signitude: S.self)
        
        NBKAssertShiftLeftByMasking (T(x64: X(1, 2, 3, 4)),  257, T(x64: X(2, 4, 6, 8)), signitude: S.self)
        NBKAssertShiftLeftByMasking (T(x64: X(1, 2, 3, 4)), -255, T(x64: X(2, 4, 6, 8)), signitude: S.self)
        
        NBKAssertShiftLeftByMasking (T(x64: X(1, 2, 3, 4)),  320, T(x64: X(0, 1, 2, 3)), signitude: S.self)
        NBKAssertShiftLeftByMasking (T(x64: X(1, 2, 3, 4)), -192, T(x64: X(0, 1, 2, 3)), signitude: S.self)
        
        NBKAssertShiftRightByMasking(T(x64: X(2, 4, 6, 8)),  256, T(x64: X(2, 4, 6, 8)), signitude: S.self)
        NBKAssertShiftRightByMasking(T(x64: X(2, 4, 6, 8)), -256, T(x64: X(2, 4, 6, 8)), signitude: S.self)
        
        NBKAssertShiftRightByMasking(T(x64: X(2, 4, 6, 8)),  257, T(x64: X(1, 2, 3, 4)), signitude: S.self)
        NBKAssertShiftRightByMasking(T(x64: X(2, 4, 6, 8)), -255, T(x64: X(1, 2, 3, 4)), signitude: S.self)
        
        NBKAssertShiftRightByMasking(T(x64: X(2, 4, 6, 8)),  320, T(x64: X(4, 6, 8, 0)), signitude: S.self)
        NBKAssertShiftRightByMasking(T(x64: X(2, 4, 6, 8)), -192, T(x64: X(4, 6, 8, 0)), signitude: S.self)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Shifts x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnShiftsAsUInt256: XCTestCase {
    
    typealias S =  Int256
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitshiftingLeftByBits() {
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),   1, T(x64: X( 2,  4,  6,  8)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),   2, T(x64: X( 4,  8, 12, 16)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),   3, T(x64: X( 8, 16, 24, 32)))
    }
    
    func testBitshiftingLeftByWords() {
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),  64, T(x64: X( 0,  1,  2,  3)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)), 128, T(x64: X( 0,  0,  1,  2)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)), 192, T(x64: X( 0,  0,  0,  1)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)), 256, T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingLeftByWordsAndBits() {
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),   3, T(x64: X( 8, 16, 24, 32)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)),  67, T(x64: X( 0,  8, 16, 24)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)), 131, T(x64: X( 0,  0,  8, 16)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)), 195, T(x64: X( 0,  0,  0,  8)))
        NBKAssertShiftLeft(T(x64: X( 1,  2,  3,  4)), 259, T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingLeftSuchThatWordsSplit() {
        NBKAssertShiftLeft(T(x64: X(~0,  0,  0,  0)),   1, T(x64: X(~1,  1,  0,  0)))
        NBKAssertShiftLeft(T(x64: X( 0, ~0,  0,  0)),   1, T(x64: X( 0, ~1,  1,  0)))
        NBKAssertShiftLeft(T(x64: X( 0,  0, ~0,  0)),   1, T(x64: X( 0,  0, ~1,  1)))
        NBKAssertShiftLeft(T(x64: X( 0,  0,  0, ~0)),   1, T(x64: X( 0,  0,  0, ~1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRightByBits() {
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),   0, T(x64: X( 8, 16, 24, 32)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),   1, T(x64: X( 4,  8, 12, 16)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),   2, T(x64: X( 2,  4,  6,  8)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),   3, T(x64: X( 1,  2,  3,  4)))
    }
    
    func testBitshiftingRightByWords() {
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),   0, T(x64: X( 8, 16, 24, 32)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),  64, T(x64: X(16, 24, 32,  0)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)), 128, T(x64: X(24, 32,  0,  0)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)), 192, T(x64: X(32,  0,  0,  0)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)), 256, T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingRightByWordsAndBits() {
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),   3, T(x64: X( 1,  2,  3,  4)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)),  67, T(x64: X( 2,  3,  4,  0)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)), 131, T(x64: X( 3,  4,  0,  0)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)), 195, T(x64: X( 4,  0,  0,  0)))
        NBKAssertShiftRight(T(x64: X(8, 16, 24, 32)), 259, T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingRightSuchThatWordsSplit() {
        NBKAssertShiftRight(T(x64: X(0,  0,  0,  7)),   1, T(x64: X( 0,  0,  1 << 63,  3)))
        NBKAssertShiftRight(T(x64: X(0,  0,  7,  0)),   1, T(x64: X( 0,  1 << 63,  3,  0)))
        NBKAssertShiftRight(T(x64: X(0,  7,  0,  0)),   1, T(x64: X( 1 << 63,  3,  0,  0)))
        NBKAssertShiftRight(T(x64: X(7,  0,  0,  0)),   1, T(x64: X( 3,        0,  0,  0)))
    }
    
    func testBitshiftingRightIsUnsigned() {
        NBKAssertShiftRight(T(x64: X(0, 0, 0, 1 << 63)),   0, T(x64: X(0, 0, 0, 1 << 63)))
        NBKAssertShiftRight(T(x64: X(0, 0, 0, 1 << 63)),  64, T(x64: X(0, 0, 1 << 63, 0)))
        NBKAssertShiftRight(T(x64: X(0, 0, 0, 1 << 63)), 128, T(x64: X(0, 1 << 63, 0, 0)))
        NBKAssertShiftRight(T(x64: X(0, 0, 0, 1 << 63)), 192, T(x64: X(1 << 63, 0, 0, 0)))
        NBKAssertShiftRight(T(x64: X(0, 0, 0, 1 << 63)), 256, T(x64: X(0,       0, 0, 0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testBitshiftingIsSmart() {
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) <<   1, T(x64: X(2, 4, 6, 8)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) >>  -1, T(x64: X(2, 4, 6, 8)))
        
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) <<  64, T(x64: X(0, 1, 2, 3)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) >> -64, T(x64: X(0, 1, 2, 3)))
    }
    
    func testBitshiftingByMinDistanceDoesNotTrap() {
        XCTAssertEqual(T(repeating: true) << Int.min, T(repeating: false))
        XCTAssertEqual(T(repeating: true) >> Int.min, T(repeating: false))
    }
    
    func testBitshiftingByMaskingIsEquivalentToBitshiftingModuloBitWidth() {
        NBKAssertShiftLeftByMasking (T(x64: X(1, 2, 3, 4)),  256, T(x64: X(1, 2, 3, 4)), signitude: S.self)
        NBKAssertShiftLeftByMasking (T(x64: X(1, 2, 3, 4)), -256, T(x64: X(1, 2, 3, 4)), signitude: S.self)
        
        NBKAssertShiftLeftByMasking (T(x64: X(1, 2, 3, 4)),  257, T(x64: X(2, 4, 6, 8)), signitude: S.self)
        NBKAssertShiftLeftByMasking (T(x64: X(1, 2, 3, 4)), -255, T(x64: X(2, 4, 6, 8)), signitude: S.self)
        
        NBKAssertShiftLeftByMasking (T(x64: X(1, 2, 3, 4)),  320, T(x64: X(0, 1, 2, 3)), signitude: S.self)
        NBKAssertShiftLeftByMasking (T(x64: X(1, 2, 3, 4)), -192, T(x64: X(0, 1, 2, 3)), signitude: S.self)
        
        NBKAssertShiftRightByMasking(T(x64: X(2, 4, 6, 8)),  256, T(x64: X(2, 4, 6, 8)), signitude: S.self)
        NBKAssertShiftRightByMasking(T(x64: X(2, 4, 6, 8)), -256, T(x64: X(2, 4, 6, 8)), signitude: S.self)
        
        NBKAssertShiftRightByMasking(T(x64: X(2, 4, 6, 8)),  257, T(x64: X(1, 2, 3, 4)), signitude: S.self)
        NBKAssertShiftRightByMasking(T(x64: X(2, 4, 6, 8)), -255, T(x64: X(1, 2, 3, 4)), signitude: S.self)
        
        NBKAssertShiftRightByMasking(T(x64: X(2, 4, 6, 8)),  320, T(x64: X(4, 6, 8, 0)), signitude: S.self)
        NBKAssertShiftRightByMasking(T(x64: X(2, 4, 6, 8)), -192, T(x64: X(4, 6, 8, 0)), signitude: S.self)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Shifts x Assertions
//*============================================================================*

private func NBKAssertShiftLeft<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  Int, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let (words, bits) = rhs.quotientAndRemainder(dividingBy: UInt.bitWidth)
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
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(                 lhs &<<  rhs,                 result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs &<<= rhs; return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(lhs.bitshiftedLeft(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(by: rhs); return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedLeft(words: words, bits: bits), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(words: words, bits: bits); return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs, bits.isZero {
        XCTAssertEqual(lhs.bitshiftedLeft(words: words), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(words: words); return lhs }(), result, file: file, line: line)
    }
}

private func NBKAssertShiftRight<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  Int, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let (words, bits) = rhs.quotientAndRemainder(dividingBy: UInt.bitWidth)
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
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(                 lhs &>>  rhs,                 result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs &>>= rhs; return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(lhs.bitshiftedRight(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(by: rhs); return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedRight(words: words, bits: bits), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(words: words, bits: bits); return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs, bits.isZero {
        XCTAssertEqual(lhs.bitshiftedRight(words: words), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(words: words); return lhs }(), result, file: file, line: line)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Masking
//=----------------------------------------------------------------------------=

private func NBKAssertShiftLeftByMasking<H: NBKFixedWidthInteger, S: NBKFixedWidthInteger & NBKSignedInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  Int, _ result: NBKDoubleWidth<H>, signitude: S.Type,
file: StaticString = #file, line: UInt = #line) where S.Digit: NBKCoreInteger<UInt> {
    //=------------------------------------------=
    typealias T  = NBKDoubleWidth<H>
    typealias M  = NBKDoubleWidth<H>.Magnitude
    typealias S2 = NBKDoubleWidth<S>
    typealias M2 = NBKDoubleWidth<S>.Magnitude
    precondition(S.Magnitude.self == M.self)
    //=------------------------------------------=
    func NBKAssertWith(_ lhs: T, _ rhs: Int, _ result: T) {
        XCTAssertEqual(lhs &<<   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<<  S(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<< S2(rhs), result, file: file, line: line)
        guard !rhs.isLessThanZero else { return }
        XCTAssertEqual(lhs &<<   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<<  M(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<< M2(rhs), result, file: file, line: line)
    }
    
    NBKAssertWith(lhs, rhs,                result)
    NBKAssertWith(lhs, rhs + lhs.bitWidth, result)
    NBKAssertWith(lhs, rhs - lhs.bitWidth, result)
    //=------------------------------------------=
    func NBKAssertWithProtocolWitnessesOf<T>(_ lhs: T, _ rhs: Int, _ result: T) where T: NBKFixedWidthInteger {
        XCTAssertEqual(lhs &<<   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<<  S(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<< S2(rhs), result, file: file, line: line)
        guard !rhs.isLessThanZero else { return }
        XCTAssertEqual(lhs &<<   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<<  M(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &<< M2(rhs), result, file: file, line: line)
    }
    
    NBKAssertWithProtocolWitnessesOf(lhs, rhs,                result)
    NBKAssertWithProtocolWitnessesOf(lhs, rhs + lhs.bitWidth, result)
    NBKAssertWithProtocolWitnessesOf(lhs, rhs - lhs.bitWidth, result)
}

private func NBKAssertShiftRightByMasking<H: NBKFixedWidthInteger, S: NBKFixedWidthInteger & NBKSignedInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  Int, _ result: NBKDoubleWidth<H>, signitude: S.Type,
file: StaticString = #file, line: UInt = #line) where S.Digit: NBKCoreInteger<UInt> {
    //=------------------------------------------=
    typealias T  = NBKDoubleWidth<H>
    typealias M  = NBKDoubleWidth<H>.Magnitude
    typealias S2 = NBKDoubleWidth<S>
    typealias M2 = NBKDoubleWidth<S>.Magnitude
    precondition(S.Magnitude.self == M.self)
    //=------------------------------------------=
    func NBKAssertWith(_ lhs: T, _ rhs: Int, _ result: T) {
        XCTAssertEqual(lhs &>>   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>>  S(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>> S2(rhs), result, file: file, line: line)
        guard !rhs.isLessThanZero else { return }
        XCTAssertEqual(lhs &>>   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>>  M(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>> M2(rhs), result, file: file, line: line)
    }
    
    NBKAssertWith(lhs, rhs,                result)
    NBKAssertWith(lhs, rhs + lhs.bitWidth, result)
    NBKAssertWith(lhs, rhs - lhs.bitWidth, result)
    //=------------------------------------------=
    func NBKAssertWithProtocolWitnessesOf<T>(_ lhs: T, _ rhs: Int, _ result: T) where T: NBKFixedWidthInteger {
        XCTAssertEqual(lhs &>>   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>>  S(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>> S2(rhs), result, file: file, line: line)
        guard !rhs.isLessThanZero else { return }
        XCTAssertEqual(lhs &>>   (rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>>  M(rhs), result, file: file, line: line)
        XCTAssertEqual(lhs &>> M2(rhs), result, file: file, line: line)
    }
    
    NBKAssertWithProtocolWitnessesOf(lhs, rhs,                result)
    NBKAssertWithProtocolWitnessesOf(lhs, rhs + lhs.bitWidth, result)
    NBKAssertWithProtocolWitnessesOf(lhs, rhs - lhs.bitWidth, result)
}

#endif
