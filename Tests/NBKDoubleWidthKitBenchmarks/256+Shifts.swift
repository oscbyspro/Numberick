//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !DEBUG

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Int256 x Shifts
//*============================================================================*

final class Int256BenchmarksOnShifts: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitshiftingLeft() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs << rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingLeftByMasking() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &<< rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingLeftByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitshiftedLeft(words: rhs.words, bits: rhs.bits))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingLeftByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitshiftedLeft(words: rhs.words))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRight() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs >> rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingRightByMasking() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)
                
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &>> rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingRightByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitshiftedRight(words: rhs.words, bits: rhs.bits))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingRightByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitshiftedRight(words: rhs.words))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Shifts
//*============================================================================*

final class UInt256BenchmarksOnShifts: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitshiftingLeft() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs << rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingLeftByMasking() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &<< rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingLeftByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitshiftedLeft(words: rhs.words, bits: rhs.bits))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingLeftByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitshiftedLeft(words: rhs.words))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRight() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs >> rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingRightByMasking() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)
                
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &>> rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingRightByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitshiftedRight(words: rhs.words, bits: rhs.bits))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingRightByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitshiftedRight(words: rhs.words))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
