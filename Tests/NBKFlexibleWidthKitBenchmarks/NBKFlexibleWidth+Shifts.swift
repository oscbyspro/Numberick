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
import NBKFlexibleWidthKit
import XCTest

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Shifts x UIntXL
//*============================================================================*

final class NBKFlexibleWidthBenchmarksOnShiftsAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitShiftingLeft() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs << rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingLeftByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.bitShiftedLeft(major: rhs.major))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingLeftByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.bitShiftedLeft(major: rhs.major, minor: rhs.minor))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitShiftingRight() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs >> rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingRightByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.bitShiftedRight(major: rhs.major))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingRightByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.bitShiftedRight(major: rhs.major, minor: rhs.minor))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x In Both Directions
    //=------------------------------------------------------------------------=

    func testBitShiftingInBothDirectionsInout() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.bitShiftLeft (by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            
            NBK.blackHole(lhs.bitShiftRight(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingInBothDirectionsByWordsInout() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.bitShiftLeft (major: rhs.major))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            
            NBK.blackHole(lhs.bitShiftRight(major: rhs.major))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitShiftingInBothDirectionsByWordsAndBitsInout() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity((major: 1, minor: UInt.bitWidth/2))

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.bitShiftLeft (major: rhs.major, minor: rhs.minor))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            
            NBK.blackHole(lhs.bitShiftRight(major: rhs.major, minor: rhs.minor))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
