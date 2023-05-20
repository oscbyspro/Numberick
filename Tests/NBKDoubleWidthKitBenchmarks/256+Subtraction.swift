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
// MARK: * NBK x Int256 x Subtraction
//*============================================================================*

final class Int256BenchmarksOnSubtraction: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X( 0,  1,  2,  3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs - rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X( 0,  1,  2,  3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs &- rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X( 0,  1,  2,  3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.subtractingReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs - rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingDigitWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(Int.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs &- rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingDigitReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(Int.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.subtractingReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Subtraction
//*============================================================================*

final class UInt256BenchmarksOnSubtraction: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X( 0,  1,  2,  3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs - rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X( 0,  1,  2,  3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs &- rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X( 0,  1,  2,  3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.subtractingReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs - rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingDigitWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs &- rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingDigitReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.subtractingReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
