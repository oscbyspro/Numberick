//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * Int256 x Shifts
//*============================================================================*

final class Int256TestsOnShifts: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x L
    //=------------------------------------------------------------------------=
    
    func testBitshiftingLeftByBits() {
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (  0), T(x64: X( 1,  2,  3,  4)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (  1), T(x64: X( 2,  4,  6,  8)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (  2), T(x64: X( 4,  8, 12, 16)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (  3), T(x64: X( 8, 16, 24, 32)))
    }
    
    func testBitshiftingLeftByWords() {
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (  0), T(x64: X( 1,  2,  3,  4)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << ( 64), T(x64: X( 0,  1,  2,  3)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (128), T(x64: X( 0,  0,  1,  2)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (192), T(x64: X( 0,  0,  0,  1)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (256), T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingLeftByWordsAndBits() {
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (  3), T(x64: X( 8, 16, 24, 32)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << ( 67), T(x64: X( 0,  8, 16, 24)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (131), T(x64: X( 0,  0,  8, 16)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (195), T(x64: X( 0,  0,  0,  8)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (259), T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingLeftSuchThatWordsSplit() {
        XCTAssertEqual(T(x64: X(~0,  0,  0,  0)) << 1, T(x64: X(~1,  1,  0,  0)))
        XCTAssertEqual(T(x64: X( 0, ~0,  0,  0)) << 1, T(x64: X( 0, ~1,  1,  0)))
        XCTAssertEqual(T(x64: X( 0,  0, ~0,  0)) << 1, T(x64: X( 0,  0, ~1,  1)))
        XCTAssertEqual(T(x64: X( 0,  0,  0, ~0)) << 1, T(x64: X( 0,  0,  0, ~1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x R
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRightByBits() {
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (  0), T(x64: X( 8, 16, 24, 32)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (  1), T(x64: X( 4,  8, 12, 16)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (  2), T(x64: X( 2,  4,  6,  8)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (  3), T(x64: X( 1,  2,  3,  4)))
    }
    
    func testBitshiftingRightByWords() {
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (  0), T(x64: X( 8, 16, 24, 32)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> ( 64), T(x64: X(16, 24, 32,  0)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (128), T(x64: X(24, 32,  0,  0)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (192), T(x64: X(32,  0,  0,  0)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (256), T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingRightByWordsAndBits() {
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (  3), T(x64: X( 1,  2,  3,  4)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> ( 67), T(x64: X( 2,  3,  4,  0)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (131), T(x64: X( 3,  4,  0,  0)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (195), T(x64: X( 4,  0,  0,  0)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (259), T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingRightSuchThatWordsSplit() {
        XCTAssertEqual(T(x64: X(0,  0,  0,  7)) >> (  1), T(x64: X( 0,  0,  1 << 63,  3)))
        XCTAssertEqual(T(x64: X(0,  0,  7,  0)) >> (  1), T(x64: X( 0,  1 << 63,  3,  0)))
        XCTAssertEqual(T(x64: X(0,  7,  0,  0)) >> (  1), T(x64: X( 1 << 63,  3,  0,  0)))
        XCTAssertEqual(T(x64: X(7,  0,  0,  0)) >> (  1), T(x64: X( 3,        0,  0,  0)))
    }
    
    func testBitshiftingRightIsSigned() {
        XCTAssertEqual(T(x64: X(0, 0, 0, 1 << 63)) >> (  0), T(x64: X( 0,  0,  0,  1 << 63)))
        XCTAssertEqual(T(x64: X(0, 0, 0, 1 << 63)) >> ( 64), T(x64: X( 0,  0,  1 << 63, ~0)))
        XCTAssertEqual(T(x64: X(0, 0, 0, 1 << 63)) >> (128), T(x64: X( 0,  1 << 63, ~0, ~0)))
        XCTAssertEqual(T(x64: X(0, 0, 0, 1 << 63)) >> (192), T(x64: X( 1 << 63, ~0, ~0, ~0)))
        XCTAssertEqual(T(x64: X(0, 0, 0, 1 << 63)) >> (256), T(x64: X(~0,       ~0, ~0, ~0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testBitshiftingIsSmart() {
        for _ in 0 ..< 100 {
            let x0 = UInt64.random(in: 0 ..< UInt64.max)
            let x1 = UInt64.random(in: 0 ..< UInt64.max)
            let x2 = UInt64.random(in: 0 ..< UInt64.max)
            let x3 = UInt64.random(in: 0 ..< UInt64.max)
            let shift = Int.random(in: 0 ..< T.bitWidth)
            let value = T(x64:(x0, x1, x2, x3))
            
            XCTAssertEqual(value << shift, value >> (-shift))
            XCTAssertEqual(value >> shift, value << (-shift))
        }
    }
    
    func testBitshiftingByMinAmountDoesNotTrap() {
        XCTAssertEqual(T(repeating: true) << Int.min, T(repeating: true ))
        XCTAssertEqual(T(repeating: true) >> Int.min, T(repeating: false))
    }
    
    func testBitshiftingByMaskingIsEquivalentToBitshiftingModuloBitWidth() {
        for _ in 0 ..< 100 {
            let x0 = UInt64.random(in: 0 ..< UInt64.max)
            let x1 = UInt64.random(in: 0 ..< UInt64.max)
            let x2 = UInt64.random(in: 0 ..< UInt64.max)
            let x3 = UInt64.random(in: 0 ..< UInt64.max)
            let shift = Int.random(in: 0 ..< Int.max)
            let value = T(x64:(x0, x1, x2, x3))
            
            XCTAssertEqual(value &<< shift, value << abs(shift % T.bitWidth))
            XCTAssertEqual(value &>> shift, value >> abs(shift % T.bitWidth))
        }
    }
}

//*============================================================================*
// MARK: * UInt256 x Shifts
//*============================================================================*

final class UInt256TestsOnShifts: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x L
    //=------------------------------------------------------------------------=
    
    func testBitshiftingLeftByBits() {
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (  0), T(x64: X( 1,  2,  3,  4)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (  1), T(x64: X( 2,  4,  6,  8)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (  2), T(x64: X( 4,  8, 12, 16)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (  3), T(x64: X( 8, 16, 24, 32)))
    }
    
    func testBitshiftingLeftByWords() {
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (  0), T(x64: X( 1,  2,  3,  4)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << ( 64), T(x64: X( 0,  1,  2,  3)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (128), T(x64: X( 0,  0,  1,  2)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (192), T(x64: X( 0,  0,  0,  1)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (256), T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingLeftByWordsAndBits() {
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (  3), T(x64: X( 8, 16, 24, 32)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << ( 67), T(x64: X( 0,  8, 16, 24)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (131), T(x64: X( 0,  0,  8, 16)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (195), T(x64: X( 0,  0,  0,  8)))
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)) << (259), T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingLeftSuchThatWordsSplit() {
        XCTAssertEqual(T(x64: X(~0,  0,  0,  0)) << 1, T(x64: X(~1,  1,  0,  0)))
        XCTAssertEqual(T(x64: X( 0, ~0,  0,  0)) << 1, T(x64: X( 0, ~1,  1,  0)))
        XCTAssertEqual(T(x64: X( 0,  0, ~0,  0)) << 1, T(x64: X( 0,  0, ~1,  1)))
        XCTAssertEqual(T(x64: X( 0,  0,  0, ~0)) << 1, T(x64: X( 0,  0,  0, ~1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x R
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRightByBits() {
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (  0), T(x64: X( 8, 16, 24, 32)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (  1), T(x64: X( 4,  8, 12, 16)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (  2), T(x64: X( 2,  4,  6,  8)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (  3), T(x64: X( 1,  2,  3,  4)))
    }
    
    func testBitshiftingRightByWords() {
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (  0), T(x64: X( 8, 16, 24, 32)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> ( 64), T(x64: X(16, 24, 32,  0)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (128), T(x64: X(24, 32,  0,  0)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (192), T(x64: X(32,  0,  0,  0)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (256), T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingRightByWordsAndBits() {
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (  3), T(x64: X( 1,  2,  3,  4)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> ( 67), T(x64: X( 2,  3,  4,  0)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (131), T(x64: X( 3,  4,  0,  0)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (195), T(x64: X( 4,  0,  0,  0)))
        XCTAssertEqual(T(x64: X(8, 16, 24, 32)) >> (259), T(x64: X( 0,  0,  0,  0)))
    }
    
    func testBitshiftingRightSuchThatWordsSplit() {
        XCTAssertEqual(T(x64: X(0,  0,  0,  7)) >> (  1), T(x64: X( 0,  0,  1 << 63,  3)))
        XCTAssertEqual(T(x64: X(0,  0,  7,  0)) >> (  1), T(x64: X( 0,  1 << 63,  3,  0)))
        XCTAssertEqual(T(x64: X(0,  7,  0,  0)) >> (  1), T(x64: X( 1 << 63,  3,  0,  0)))
        XCTAssertEqual(T(x64: X(7,  0,  0,  0)) >> (  1), T(x64: X( 3,        0,  0,  0)))
    }
    
    func testBitshiftingRightIsUnsigned() {
        XCTAssertEqual(T(x64: X(0, 0, 0, 1 << 63)) >> (  0), T(x64: X(0, 0, 0, 1 << 63)))
        XCTAssertEqual(T(x64: X(0, 0, 0, 1 << 63)) >> ( 64), T(x64: X(0, 0, 1 << 63, 0)))
        XCTAssertEqual(T(x64: X(0, 0, 0, 1 << 63)) >> (128), T(x64: X(0, 1 << 63, 0, 0)))
        XCTAssertEqual(T(x64: X(0, 0, 0, 1 << 63)) >> (192), T(x64: X(1 << 63, 0, 0, 0)))
        XCTAssertEqual(T(x64: X(0, 0, 0, 1 << 63)) >> (256), T(x64: X(0,       0, 0, 0)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testBitshiftingIsSmart() {
        for _ in 0 ..< 100 {
            let x0 = UInt64.random(in: 0 ..< UInt64.max)
            let x1 = UInt64.random(in: 0 ..< UInt64.max)
            let x2 = UInt64.random(in: 0 ..< UInt64.max)
            let x3 = UInt64.random(in: 0 ..< UInt64.max)
            let shift = Int.random(in: 0 ..< T.bitWidth)
            let value = T(x64:(x0, x1, x2, x3))
            
            XCTAssertEqual(value << shift, value >> (-shift))
            XCTAssertEqual(value >> shift, value << (-shift))
        }
    }
    
    func testBitshiftingByMinAmountDoesNotTrap() {
        XCTAssertEqual(T(repeating: true) << Int.min, T(repeating: false))
        XCTAssertEqual(T(repeating: true) >> Int.min, T(repeating: false))
    }
    
    func testBitshiftingByMaskingIsEquivalentToBitshiftingModuloBitWidth() {
        for _ in 0 ..< 100 {
            let x0 = UInt64.random(in: 0 ..< UInt64.max)
            let x1 = UInt64.random(in: 0 ..< UInt64.max)
            let x2 = UInt64.random(in: 0 ..< UInt64.max)
            let x3 = UInt64.random(in: 0 ..< UInt64.max)
            let shift = Int.random(in: 0 ..< Int.max)
            let value = T(x64:(x0, x1, x2, x3))
            
            XCTAssertEqual(value &<< shift, value << abs(shift % T.bitWidth))
            XCTAssertEqual(value &>> shift, value >> abs(shift % T.bitWidth))
        }
    }
}

#endif
