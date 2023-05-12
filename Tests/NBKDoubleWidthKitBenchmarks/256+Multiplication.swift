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
// MARK: * Int256 x Multiplication
//*============================================================================*

final class Int256BenchmarksOnMultiplication: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplied() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(T(x64: X(3, 0, 0, 0)))

        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs * rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultipliedWrappingAround() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs &* rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultipliedReportingOverflow() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs.multipliedReportingOverflow(by: rhs))
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultipliedFullWidth() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs.multipliedFullWidth(by: rhs))
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testMultipliedByDigit() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs * rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultipliedByDigitWrappingAround() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(Int.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs &* rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultipliedByDigitReportingOverflow() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs.multipliedReportingOverflow(by: rhs))
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultipliedByDigitFullWidth() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs.multipliedFullWidth(by: rhs))
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * UInt256 x Multiplication
//*============================================================================*

final class UInt256BenchmarksOnMultiplication: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplied() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs * rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultipliedWrappingAround() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs &* rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultipliedReportingOverflow() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs.multipliedReportingOverflow(by: rhs))
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultipliedFullWidth() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(T(x64: X(3, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs.multipliedFullWidth(by: rhs))
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testMultipliedByDigit() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs * rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultipliedByDigitWrappingAround() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(UInt.max)

        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs &* rhs)
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultipliedByDigitReportingOverflow() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs.multipliedReportingOverflow(by: rhs))
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testMultipliedByDigitFullWidth() {
        var lhs = _blackHoleIdentity(T(x64: X(3, 3, 3, 0)))
        var rhs = _blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(lhs.multipliedFullWidth(by: rhs))
            _blackHoleInoutIdentity(&lhs)
            _blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
