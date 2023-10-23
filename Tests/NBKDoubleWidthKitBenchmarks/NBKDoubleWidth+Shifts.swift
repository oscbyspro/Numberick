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
// MARK: * NBK x Double Width x Shifts x Int256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnShiftsAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitShiftingLeft() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs << rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingLeftByMasking() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &<< rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingLeftByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitShiftedLeft(major: rhs.major))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingLeftByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitShiftedLeft(major: rhs.major, minor: rhs.minor))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitShiftingRight() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs >> rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingRightByMasking() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)
                
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &>> rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingRightByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitShiftedRight(major: rhs.major))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingRightByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitShiftedRight(major: rhs.major, minor: rhs.minor))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Shifts x UInt256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnShiftsAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitShiftingLeft() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs << rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingLeftByMasking() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &<< rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingLeftByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitShiftedLeft(major: rhs.major))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingLeftByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitShiftedLeft(major: rhs.major, minor: rhs.minor))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitShiftingRight() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs >> rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingRightByMasking() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)
                
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &>> rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingRightByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitShiftedRight(major: rhs.major))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingRightByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitShiftedRight(major: rhs.major, minor: rhs.minor))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
