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
// MARK: * Int256 x Addition
//*============================================================================*

final class Int256BenchmarksOnAddition: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAdding() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X( 0,  1,  2,  3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs + rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testAddingWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X( 0,  1,  2,  3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs &+ rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testAddingReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X( 0,  1,  2,  3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.addingReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testAddingDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs + rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testAddingDigitWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(Int.max)

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs &+ rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testAddingDigitReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.addingReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * UInt256 x Addition
//*============================================================================*

final class UInt256BenchmarksOnAddition: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAdding() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X( 0,  1,  2,  3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs + rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testAddingWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X( 0,  1,  2,  3)))

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs &+ rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testAddingReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X( 0,  1,  2,  3)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.addingReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testAddingDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs + rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testAddingDigitWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs &+ rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testAddingDigitReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~0, ~1, ~2, ~3)))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs.addingReportingOverflow(rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
