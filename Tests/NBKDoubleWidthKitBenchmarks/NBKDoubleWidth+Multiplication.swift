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
// MARK: * NBK x Double Width x Multiplication x Int256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnMultiplicationAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplying() {
        var lhs = NBK.blackHoleIdentity( T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(-T(x64: X(3, 0, 0, 0)))

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs * rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultiplyingWrappingAround() {
        var lhs = NBK.blackHoleIdentity( T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(-T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &* rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultiplyingReportingOverflow() {
        var lhs = NBK.blackHoleIdentity( T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(-T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.multipliedReportingOverflow(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultiplyingFullWidth() {
        var lhs = NBK.blackHoleIdentity( T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(-T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.multipliedFullWidth(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testMultiplyingByDigit() {
        var lhs = NBK.blackHoleIdentity( T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(-Int.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs * rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultiplyingByDigitWrappingAround() {
        var lhs = NBK.blackHoleIdentity( T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(-Int.max)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &* rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultiplyingByDigitReportingOverflow() {
        var lhs = NBK.blackHoleIdentity( T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(-Int.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.multipliedReportingOverflow(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultiplyingByDigitFullWidth() {
        var lhs = NBK.blackHoleIdentity( T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(-Int.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.multipliedFullWidth(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Multiplication x UInt256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnMultiplicationAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplying() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs * rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultiplyingWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &* rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultiplyingReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.multipliedReportingOverflow(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultiplyingFullWidth() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.multipliedFullWidth(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testMultiplyingByDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs * rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultiplyingByDigitWrappingAround() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(UInt.max)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs &* rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultiplyingByDigitReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.multipliedReportingOverflow(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultiplyingByDigitFullWidth() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.multipliedFullWidth(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
