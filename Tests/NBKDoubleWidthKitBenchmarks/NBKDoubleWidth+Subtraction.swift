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

private typealias X64 = NBK.U256X64
private typealias X32 = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Subtraction x Int256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnSubtractionAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
        var lhs = NBK.blackHoleIdentity(T(x64: X64(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X64( 0,  1,  2,  3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs - rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X64(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X64( 0,  1,  2,  3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &- rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X64(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X64( 0,  1,  2,  3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.subtractingReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64: X64(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs - rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingDigitWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X64(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(Int.max)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &- rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingDigitReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X64(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(Int.max)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.subtractingReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Subtraction x UInt256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnSubtractionAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
        var lhs = NBK.blackHoleIdentity(T(x64: X64(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X64( 0,  1,  2,  3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs - rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X64(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X64( 0,  1,  2,  3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &- rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X64(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X64( 0,  1,  2,  3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.subtractingReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64: X64(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs - rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingDigitWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X64(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.max)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &- rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingDigitReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X64(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.max)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.subtractingReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
