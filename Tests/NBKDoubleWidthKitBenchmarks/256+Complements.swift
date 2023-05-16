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

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * Int256 x Complements
//*============================================================================*

final class Int256BenchmarksOnComplements: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Pattern
    //=------------------------------------------------------------------------=
    
    func testInitBitPattern() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(bitPattern: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testValueAsBitPattern() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(abc.bitPattern)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(abc.magnitude)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(abc.twosComplement())
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
}

//*============================================================================*
// MARK: * UInt256 x Complements
//*============================================================================*

final class UInt256BenchmarksOnComplements: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Pattern
    //=------------------------------------------------------------------------=
        
    func testInitBitPattern() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(bitPattern: abc))
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testValueAsBitPattern() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(abc.bitPattern)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(abc.magnitude)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        var abc = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(abc.twosComplement())
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
}

#endif
