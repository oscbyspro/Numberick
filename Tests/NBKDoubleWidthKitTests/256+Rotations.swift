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
// MARK: * NBK x Int256 x Rotations
//*============================================================================*

final class Int256TestsOnRotations: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=

    func testBitrotatingLeftByBits() {
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   1, T(x64: X( 2,  4,  6,  8)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   2, T(x64: X( 4,  8, 12, 16)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   3, T(x64: X( 8, 16, 24, 32)))
    }
    
    func testBitrotatingLeftByWords() {
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),  64, T(x64: X( 4,  1,  2,  3)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)), 128, T(x64: X( 3,  4,  1,  2)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)), 192, T(x64: X( 2,  3,  4,  1)))
    }
    
    func testBitrotatingLeftByWordsAndBits() {
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   3, T(x64: X( 8, 16, 24, 32)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),  67, T(x64: X(32,  8, 16, 24)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)), 131, T(x64: X(24, 32,  8, 16)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)), 195, T(x64: X(16, 24, 32,  8)))
    }
    
    func testBitrotatingLeftSuchThatWordsSplit() {
        NBKAssertRotateLeft(T(x64: X(~0,  0,  0,  0)),   1, T(x64: X(~1,  1,  0,  0)))
        NBKAssertRotateLeft(T(x64: X( 0, ~0,  0,  0)),   1, T(x64: X( 0, ~1,  1,  0)))
        NBKAssertRotateLeft(T(x64: X( 0,  0, ~0,  0)),   1, T(x64: X( 0,  0, ~1,  1)))
        NBKAssertRotateLeft(T(x64: X( 0,  0,  0, ~0)),   1, T(x64: X( 1,  0,  0, ~1)))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitrotatingRightByBits() {
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)),   0, T(x64: X( 8, 16, 24, 32)))
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)),   1, T(x64: X( 4,  8, 12, 16)))
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)),   2, T(x64: X( 2,  4,  6,  8)))
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)),   3, T(x64: X( 1,  2,  3,  4)))
    }
    
    func testBitrotatingRightByWords() {
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)),  64, T(x64: X( 2,  3,  4,  1)))
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)), 128, T(x64: X( 3,  4,  1,  2)))
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)), 192, T(x64: X( 4,  1,  2,  3)))
    }
    
    func testBitrotatingRightByWordsAndBits() {
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)),   3, T(x64: X( 1,  2,  3,  4)))
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)),  67, T(x64: X( 2,  3,  4,  1)))
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)), 131, T(x64: X( 3,  4,  1,  2)))
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)), 195, T(x64: X( 4,  1,  2,  3)))
    }
    
    func testBitrotatingRightSuchThatWordsSplit() {
        NBKAssertRotateRight(T(x64: X(0,  0,  0,  7)),   1, T(x64: X( 0,  0,  1 << 63,  3)))
        NBKAssertRotateRight(T(x64: X(0,  0,  7,  0)),   1, T(x64: X( 0,  1 << 63,  3,  0)))
        NBKAssertRotateRight(T(x64: X(0,  7,  0,  0)),   1, T(x64: X( 1 << 63,  3,  0,  0)))
        NBKAssertRotateRight(T(x64: X(7,  0,  0,  0)),   1, T(x64: X( 3,  0,  0,  1 << 63)))
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Rotations
//*============================================================================*

final class UInt256TestsOnRotations: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitrotatingLeftByBits() {
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   1, T(x64: X( 2,  4,  6,  8)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   2, T(x64: X( 4,  8, 12, 16)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   3, T(x64: X( 8, 16, 24, 32)))
    }
    
    func testBitrotatingLeftByWords() {
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),  64, T(x64: X( 4,  1,  2,  3)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)), 128, T(x64: X( 3,  4,  1,  2)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)), 192, T(x64: X( 2,  3,  4,  1)))
    }
    
    func testBitrotatingLeftByWordsAndBits() {
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   3, T(x64: X( 8, 16, 24, 32)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),  67, T(x64: X(32,  8, 16, 24)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)), 131, T(x64: X(24, 32,  8, 16)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)), 195, T(x64: X(16, 24, 32,  8)))
    }
    
    func testBitrotatingLeftSuchThatWordsSplit() {
        NBKAssertRotateLeft(T(x64: X(~0,  0,  0,  0)),   1, T(x64: X(~1,  1,  0,  0)))
        NBKAssertRotateLeft(T(x64: X( 0, ~0,  0,  0)),   1, T(x64: X( 0, ~1,  1,  0)))
        NBKAssertRotateLeft(T(x64: X( 0,  0, ~0,  0)),   1, T(x64: X( 0,  0, ~1,  1)))
        NBKAssertRotateLeft(T(x64: X( 0,  0,  0, ~0)),   1, T(x64: X( 1,  0,  0, ~1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitrotatingRightByBits() {
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)),   0, T(x64: X( 8, 16, 24, 32)))
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)),   1, T(x64: X( 4,  8, 12, 16)))
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)),   2, T(x64: X( 2,  4,  6,  8)))
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)),   3, T(x64: X( 1,  2,  3,  4)))
    }
    
    func testBitrotatingRightByWords() {
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)),  64, T(x64: X( 2,  3,  4,  1)))
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)), 128, T(x64: X( 3,  4,  1,  2)))
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)), 192, T(x64: X( 4,  1,  2,  3)))
    }
    
    func testBitrotatingRightByWordsAndBits() {
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)),   3, T(x64: X( 1,  2,  3,  4)))
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)),  67, T(x64: X( 2,  3,  4,  1)))
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)), 131, T(x64: X( 3,  4,  1,  2)))
        NBKAssertRotateRight(T(x64: X(8, 16, 24, 32)), 195, T(x64: X( 4,  1,  2,  3)))
    }
    
    func testBitrotatingRightSuchThatWordsSplit() {
        NBKAssertRotateRight(T(x64: X(0,  0,  0,  7)),   1, T(x64: X( 0,  0,  1 << 63,  3)))
        NBKAssertRotateRight(T(x64: X(0,  0,  7,  0)),   1, T(x64: X( 0,  1 << 63,  3,  0)))
        NBKAssertRotateRight(T(x64: X(0,  7,  0,  0)),   1, T(x64: X( 1 << 63,  3,  0,  0)))
        NBKAssertRotateRight(T(x64: X(7,  0,  0,  0)),   1, T(x64: X( 3,  0,  0,  1 << 63)))
    }
}

#endif
