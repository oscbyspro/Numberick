//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x UIntXL x Division
//*============================================================================*

final class UIntXLTestsOnDivision: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividing() {
        NBKAssertDivision(T( ), T(1), T( ), T( ))
        NBKAssertDivision(T( ), T(2), T( ), T( ))
        NBKAssertDivision(T(7), T(1), T(7), T( ))
        NBKAssertDivision(T(7), T(2), T(3), T(1))
    }
    
    func testDividingReportingOverflow() {
        NBKAssertDivision(T( ), T( ), T( ), T( ), true)
        NBKAssertDivision(T(1), T( ), T(1), T(1), true)
        NBKAssertDivision(T(2), T( ), T(2), T(2), true)
    }
    
    func testDividingWithLargeDividend() {
        NBKAssertDivision(T(x64:[~2,  ~4,  ~6,  9] as X), T(2), T(x64:[~1, ~2, ~3, 4] as X), T(1))
        NBKAssertDivision(T(x64:[~3,  ~6,  ~9, 14] as X), T(3), T(x64:[~1, ~2, ~3, 4] as X), T(2))
        NBKAssertDivision(T(x64:[~4,  ~8, ~12, 19] as X), T(4), T(x64:[~1, ~2, ~3, 4] as X), T(3))
        NBKAssertDivision(T(x64:[~5, ~10, ~15, 24] as X), T(5), T(x64:[~1, ~2, ~3, 4] as X), T(4))
        
        NBKAssertDivision(T(x64:[~2,  ~4,  ~6,  9] as X), T(x64:[~1, ~2, ~3, 4] as X), T(2), T(1))
        NBKAssertDivision(T(x64:[~3,  ~6,  ~9, 14] as X), T(x64:[~1, ~2, ~3, 4] as X), T(3), T(2))
        NBKAssertDivision(T(x64:[~4,  ~8, ~12, 19] as X), T(x64:[~1, ~2, ~3, 4] as X), T(4), T(3))
        NBKAssertDivision(T(x64:[~5, ~10, ~15, 24] as X), T(x64:[~1, ~2, ~3, 4] as X), T(5), T(4))
    }
    
    func testDividingWithLargeDivisor() {
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X), T(x64:[ 1,  2,  3,  4 &+ 1 << 63] as X), T(1), T(x64:[0, 0, 0, 0] as X))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X), T(x64:[ 0,  1,  2,  3 &+ 1 << 63] as X), T(1), T(x64:[1, 1, 1, 1] as X))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X), T(x64:[~0, ~0,  0,  2 &+ 1 << 63] as X), T(1), T(x64:[2, 2, 2, 2] as X))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X), T(x64:[~1, ~1, ~0,  0 &+ 1 << 63] as X), T(1), T(x64:[3, 3, 3, 3] as X))
        
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X), T(x64:[~2, ~2, ~1, ~0 &+ 1 << 63] as X), T(1), T(x64:[4, 4, 4, 4] as X))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X), T(x64:[~3, ~3, ~2, ~1 &+ 1 << 63] as X), T(1), T(x64:[5, 5, 5, 5] as X))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X), T(x64:[~4, ~4, ~3, ~2 &+ 1 << 63] as X), T(1), T(x64:[6, 6, 6, 6] as X))
        NBKAssertDivision(T(x64:[1, 2, 3, 4 + 1 << 63] as X), T(x64:[~5, ~5, ~4, ~3 &+ 1 << 63] as X), T(1), T(x64:[7, 7, 7, 7] as X))
    }
    
    func testDividingLikeFullWidth() {
        NBKAssertDivision(M(x64:[06, 17, 35, 61, 61, 52, 32, 00] as X), T(x64:[1, 2, 3, 4] as X), T(x64:[5, 6, 7, 8] as X), T(x64:[ 1,  1,  1,  1] as X))
        NBKAssertDivision(M(x64:[06, 17, 35, 61, 61, 52, 32, 00] as X), T(x64:[5, 6, 7, 8] as X), T(x64:[1, 2, 3, 4] as X), T(x64:[ 1,  1,  1,  1] as X))

        NBKAssertDivision(M(x64:[34, 54, 63, 62, 34, 16, 05, 00] as X), T(x64:[4, 3, 2, 1] as X), T(x64:[9, 7, 6, 5] as X), T(x64:[~1, ~1, ~0,  0] as X))
        NBKAssertDivision(M(x64:[34, 54, 63, 62, 34, 16, 05, 00] as X), T(x64:[8, 7, 6, 5] as X), T(x64:[4, 3, 2, 1] as X), T(x64:[ 2,  2,  2,  2] as X))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testDividingByDigit() {
        NBKAssertDivisionByDigit(T( ), UInt(1), T( ), UInt( ))
        NBKAssertDivisionByDigit(T( ), UInt(2), T( ), UInt( ))
        NBKAssertDivisionByDigit(T(7), UInt(1), T(7), UInt( ))
        NBKAssertDivisionByDigit(T(7), UInt(2), T(3), UInt(1))
    }
    
    func testDividingByDigitReportingOverflow() {
        NBKAssertDivisionByDigit(T( ), UInt( ), T( ), UInt( ), true)
        NBKAssertDivisionByDigit(T(1), UInt( ), T(1), UInt(1), true)
        NBKAssertDivisionByDigit(T(2), UInt( ), T(2), UInt(2), true)
    }
    
    func testDividingByDigitWithLargeDividend() {
        NBKAssertDivisionByDigit(T(words:[~2,  ~4,  ~6,  9] as [UInt]), UInt(2), T(words:[~1, ~2, ~3, 4] as [UInt]), UInt(1))
        NBKAssertDivisionByDigit(T(words:[~3,  ~6,  ~9, 14] as [UInt]), UInt(3), T(words:[~1, ~2, ~3, 4] as [UInt]), UInt(2))
        NBKAssertDivisionByDigit(T(words:[~4,  ~8, ~12, 19] as [UInt]), UInt(4), T(words:[~1, ~2, ~3, 4] as [UInt]), UInt(3))
        NBKAssertDivisionByDigit(T(words:[~5, ~10, ~15, 24] as [UInt]), UInt(5), T(words:[~1, ~2, ~3, 4] as [UInt]), UInt(4))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x /= 0)
            XCTAssertNotNil(x %= 0)
            XCTAssertNotNil(x.divideReportingOverflow(by: 0))
            XCTAssertNotNil(x.formRemainderReportingOverflow(dividingBy: 0))
            
            XCTAssertNotNil(x /  0)
            XCTAssertNotNil(x %  0)
            XCTAssertNotNil(x.dividedReportingOverflow(by: 0))
            XCTAssertNotNil(x.remainderReportingOverflow(dividingBy: 0))
            XCTAssertNotNil(x.quotientAndRemainder(dividingBy: 0))
            XCTAssertNotNil(x.quotientAndRemainderReportingOverflow(dividingBy: 0))
        }
    }
}

#endif
