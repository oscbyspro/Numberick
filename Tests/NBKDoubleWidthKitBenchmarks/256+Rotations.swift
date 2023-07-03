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
// MARK: * NBK x Int256 x Rotations
//*============================================================================*

final class Int256BenchmarksOnRotations: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitrotatingLeft() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitrotatedLeft(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitrotatingLeftByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitrotatedLeft(words: rhs.words, bits: rhs.bits))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitrotatingLeftByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitrotatedLeft(words: rhs.words))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitrotatingRight() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitrotatedRight(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitrotatingRightByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitrotatedRight(words: rhs.words, bits: rhs.bits))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitrotatingRightByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitrotatedRight(words: rhs.words))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Rotations
//*============================================================================*

final class UInt256BenchmarksOnRotations: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitrotatingLeft() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitrotatedLeft(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitrotatingLeftByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitrotatedLeft(words: rhs.words, bits: rhs.bits))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitrotatingLeftByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitrotatedLeft(words: rhs.words))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitrotatingRight() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitrotatedRight(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitrotatingRightByWordsAndBits() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitrotatedRight(words: rhs.words, bits: rhs.bits))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitrotatingRightByWords() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity((words: 1, bits: UInt.bitWidth/2))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitrotatedRight(words: rhs.words))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
