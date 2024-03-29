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
// MARK: * NBK x Flexible Width x Division x UIntXL
//*============================================================================*

final class NBKFlexibleWidthBenchmarksOnDivisionAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testQuotientAndRemainder() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(T(x64:[ 0,  1,  2,  3] as X64))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(lhs.quotientAndRemainder(dividingBy: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testQuotientReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(T(x64:[ 0,  1,  2,  3] as X64))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(lhs.dividedReportingOverflow(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testRemainderReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(T(x64:[ 0,  1,  2,  3] as X64))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(lhs.remainderReportingOverflow(dividingBy: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testQuotientAndRemainderDividingByDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(lhs.quotientAndRemainder(dividingBy: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testQuotientDividingByDigitReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(UInt.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(lhs.dividedReportingOverflow(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testRemainderDividingByDigitReportingOverflow() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(UInt.max)

        for _ in 0 ..< 250_000 {
            NBK.blackHole(lhs.remainderReportingOverflow(dividingBy: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
        
    //=------------------------------------------------------------------------=
    // MARK: Tests x Full Width
    //=------------------------------------------------------------------------=
    
    func testDividingFullWidthAs256WhenDivisorIsNormalized() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~0, ~0, ~0, ~1, ~0, ~0, ~0] as X64))
        var rhs = NBK.blackHoleIdentity(T(x64:[~0, ~0, ~0, ~0] as X64)) // msb == true

        for _ in 0 ..< 250_000 {
            NBK.blackHole(lhs.quotientAndRemainder(dividingBy: rhs))
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&lhs)
        }
    }

    func testDividingFullWidthReportingOverflowAs256WhenDivisorIsNormalized() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~0, ~0, ~0, ~1, ~0, ~0, ~0] as X64))
        var rhs = NBK.blackHoleIdentity(T(x64:[~0, ~0, ~0, ~0] as X64)) // msb == true

        for _ in 0 ..< 250_000 {
            NBK.blackHole(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs))
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&lhs)
        }
    }
    
    func testDividingFullWidthAs256WhenDivisorIsNotNormalized() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~0, ~0, ~0, ~1, ~0, ~0, ~0] as X64))
        var rhs = NBK.blackHoleIdentity(T(x64:[~0, ~0, ~0, ~0/2] as X64)) // msb == false

        for _ in 0 ..< 250_000 {
            NBK.blackHole(lhs.quotientAndRemainder(dividingBy: rhs))
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&lhs)
        }
    }

    func testDividingFullWidthReportingOverflowAs256WhenDivisorIsNotNormalized() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~0, ~0, ~0, ~1, ~0, ~0, ~0] as X64))
        var rhs = NBK.blackHoleIdentity(T(x64:[~0, ~0, ~0, ~0/2] as X64)) // msb == false

        for _ in 0 ..< 250_000 {
            NBK.blackHole(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs))
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&lhs)
        }
    }
}

#endif
