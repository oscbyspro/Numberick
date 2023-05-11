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
// MARK: * Int256 x Shifts
//*============================================================================*

final class Int256BenchmarksOnShifts: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x L
    //=------------------------------------------------------------------------=
    
    func testBitshiftingLeft() {
        var lhs = _blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = _blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs << rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingLeftByMasking() {
        var lhs = _blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = _blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs &<< rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x R
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRight() {
        var lhs = _blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = _blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs >> rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingRightByMasking() {
        var lhs = _blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = _blackHoleIdentity(UInt.bitWidth * 3/2)
                
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs &>> rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * UInt256 x Shifts
//*============================================================================*

final class UInt256BenchmarksOnShifts: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x L
    //=------------------------------------------------------------------------=
    
    func testBitshiftingLeft() {
        var lhs = _blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = _blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs << rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingLeftByMasking() {
        var lhs = _blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = _blackHoleIdentity(UInt.bitWidth * 3/2)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs &<< rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x R
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRight() {
        var lhs = _blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = _blackHoleIdentity(UInt.bitWidth * 3/2)

        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs >> rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testBitshiftingRightByMasking() {
        var lhs = _blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = _blackHoleIdentity(UInt.bitWidth * 3/2)
                
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs &>> rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
