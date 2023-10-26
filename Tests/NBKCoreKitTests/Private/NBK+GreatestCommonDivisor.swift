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
import XCTest

//*============================================================================*
// MARK: * NBK x Greatest Common Divisor
//*============================================================================*

final class NBKTestsOnGreatestCommonDivisor: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSmallValues() {
        NBKAssertGreatestCommonDivisor(2                  as Int, 3 * 5 * 7 as Int, 1         as UInt)
        NBKAssertGreatestCommonDivisor(2 * 3              as Int, 3 * 5 * 7 as Int, 3         as UInt)
        NBKAssertGreatestCommonDivisor(2 * 3 * 5          as Int, 3 * 5 * 7 as Int, 3 * 5     as UInt)
        NBKAssertGreatestCommonDivisor(2 * 3 * 5 * 7      as Int, 3 * 5 * 7 as Int, 3 * 5 * 7 as UInt)
        NBKAssertGreatestCommonDivisor(2 * 3 * 5 * 7 * 11 as Int, 3 * 5 * 7 as Int, 3 * 5 * 7 as UInt)
        NBKAssertGreatestCommonDivisor(    3 * 5 * 7 * 11 as Int, 3 * 5 * 7 as Int, 3 * 5 * 7 as UInt)
        NBKAssertGreatestCommonDivisor(        5 * 7 * 11 as Int, 3 * 5 * 7 as Int,     5 * 7 as UInt)
        NBKAssertGreatestCommonDivisor(            7 * 11 as Int, 3 * 5 * 7 as Int,         7 as UInt)
        NBKAssertGreatestCommonDivisor(                11 as Int, 3 * 5 * 7 as Int,         1 as UInt)
    }
    
    func testEverythingDividesZero() {
        for other in -10 ... 10 {
            NBKAssertGreatestCommonDivisor(0 as Int, other, other.magnitude as UInt)
        }
        
        NBKAssertGreatestCommonDivisor(0 as  Int, Int.max,           Int.max.magnitude as UInt)
        NBKAssertGreatestCommonDivisor(0 as UInt, Int.max.magnitude, Int.max.magnitude as UInt)
        NBKAssertGreatestCommonDivisor(0 as UInt, Int.min.magnitude, Int.min.magnitude as UInt)
    }
}

//*============================================================================*
// MARK: * NBK x Greatest Common Divisor x Assertions
//*============================================================================*

private func NBKAssertGreatestCommonDivisor<T: NBKBinaryInteger>(
_ lhs: T, _ rhs: T, _ gcd: T.Magnitude,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    func with(_ lhs: T, _ rhs: T, _ gcd: T.Magnitude) {
        brr: do {
            XCTAssertEqual(NBK.greatestCommonDivisorByBinaryAlgorithm(of: 0 + lhs, and: 0 + rhs), gcd, file: file, line: line)
        };  if T.isSigned {
            XCTAssertEqual(NBK.greatestCommonDivisorByBinaryAlgorithm(of: 0 + lhs, and: 0 - rhs), gcd, file: file, line: line)
            XCTAssertEqual(NBK.greatestCommonDivisorByBinaryAlgorithm(of: 0 - lhs, and: 0 + rhs), gcd, file: file, line: line)
            XCTAssertEqual(NBK.greatestCommonDivisorByBinaryAlgorithm(of: 0 - lhs, and: 0 - rhs), gcd, file: file, line: line)
        }
    }
    //=------------------------------------------=
    with(lhs, rhs, gcd)
    with(rhs, lhs, gcd)
}

#endif
