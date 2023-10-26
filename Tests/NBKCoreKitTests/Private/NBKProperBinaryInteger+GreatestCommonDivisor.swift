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
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor
//*============================================================================*

final class NBKProperBinaryIntegerTestsOnGreatestCommonDivisor: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSmallPowersOf2() {
        NBKAssertGreatestCommonDivisor( 2 as Int, 16 as Int,  2 as UInt)
        NBKAssertGreatestCommonDivisor( 4 as Int, 16 as Int,  4 as UInt)
        NBKAssertGreatestCommonDivisor( 8 as Int, 16 as Int,  8 as UInt)
        NBKAssertGreatestCommonDivisor(16 as Int, 16 as Int, 16 as UInt)
    }
    
    func testSmallPrimeProducts() {
        // even x even
        NBKAssertGreatestCommonDivisor(2                  as Int, 2 * 5 * 11 as Int, 2          as UInt)
        NBKAssertGreatestCommonDivisor(2 * 3              as Int, 2 * 5 * 11 as Int, 2          as UInt)
        NBKAssertGreatestCommonDivisor(2 * 3 * 5          as Int, 2 * 5 * 11 as Int, 2 * 5      as UInt)
        NBKAssertGreatestCommonDivisor(2 * 3 * 5 * 7      as Int, 2 * 5 * 11 as Int, 2 * 5      as UInt)
        NBKAssertGreatestCommonDivisor(2 * 3 * 5 * 7 * 11 as Int, 2 * 5 * 11 as Int, 2 * 5 * 11 as UInt)
        NBKAssertGreatestCommonDivisor(    3 * 5 * 7 * 11 as Int, 2 * 5 * 11 as Int,     5 * 11 as UInt)
        NBKAssertGreatestCommonDivisor(        5 * 7 * 11 as Int, 2 * 5 * 11 as Int,     5 * 11 as UInt)
        NBKAssertGreatestCommonDivisor(            7 * 11 as Int, 2 * 5 * 11 as Int,         11 as UInt)
        NBKAssertGreatestCommonDivisor(                11 as Int, 2 * 5 * 11 as Int,         11 as UInt)
        // even x odd
        NBKAssertGreatestCommonDivisor(2                  as Int, 3 * 5 * 07 as Int, 1          as UInt)
        NBKAssertGreatestCommonDivisor(2 * 3              as Int, 3 * 5 * 07 as Int, 3          as UInt)
        NBKAssertGreatestCommonDivisor(2 * 3 * 5          as Int, 3 * 5 * 07 as Int, 3 * 5      as UInt)
        NBKAssertGreatestCommonDivisor(2 * 3 * 5 * 7      as Int, 3 * 5 * 07 as Int, 3 * 5 * 07 as UInt)
        NBKAssertGreatestCommonDivisor(2 * 3 * 5 * 7 * 11 as Int, 3 * 5 * 07 as Int, 3 * 5 * 07 as UInt)
        NBKAssertGreatestCommonDivisor(    3 * 5 * 7 * 11 as Int, 3 * 5 * 07 as Int, 3 * 5 * 07 as UInt)
        NBKAssertGreatestCommonDivisor(        5 * 7 * 11 as Int, 3 * 5 * 07 as Int,     5 * 07 as UInt)
        NBKAssertGreatestCommonDivisor(            7 * 11 as Int, 3 * 5 * 07 as Int,         07 as UInt)
        NBKAssertGreatestCommonDivisor(                11 as Int, 3 * 5 * 07 as Int,         01 as UInt)
        // odd  x even
        NBKAssertGreatestCommonDivisor(1                  as Int, 2 * 5 * 11 as Int, 1          as UInt)
        NBKAssertGreatestCommonDivisor(1 * 3              as Int, 2 * 5 * 11 as Int, 1          as UInt)
        NBKAssertGreatestCommonDivisor(1 * 3 * 5          as Int, 2 * 5 * 11 as Int, 1 * 5      as UInt)
        NBKAssertGreatestCommonDivisor(1 * 3 * 5 * 7      as Int, 2 * 5 * 11 as Int, 1 * 5      as UInt)
        NBKAssertGreatestCommonDivisor(1 * 3 * 5 * 7 * 11 as Int, 2 * 5 * 11 as Int, 1 * 5 * 11 as UInt)
        NBKAssertGreatestCommonDivisor(    3 * 5 * 7 * 11 as Int, 2 * 5 * 11 as Int,     5 * 11 as UInt)
        NBKAssertGreatestCommonDivisor(        5 * 7 * 11 as Int, 2 * 5 * 11 as Int,     5 * 11 as UInt)
        NBKAssertGreatestCommonDivisor(            7 * 11 as Int, 2 * 5 * 11 as Int,         11 as UInt)
        NBKAssertGreatestCommonDivisor(                11 as Int, 2 * 5 * 11 as Int,         11 as UInt)
        // odd  x odd
        NBKAssertGreatestCommonDivisor(1                  as Int, 3 * 5 * 07 as Int, 1          as UInt)
        NBKAssertGreatestCommonDivisor(1 * 3              as Int, 3 * 5 * 07 as Int, 3          as UInt)
        NBKAssertGreatestCommonDivisor(1 * 3 * 5          as Int, 3 * 5 * 07 as Int, 3 * 5      as UInt)
        NBKAssertGreatestCommonDivisor(1 * 3 * 5 * 7      as Int, 3 * 5 * 07 as Int, 3 * 5 * 07 as UInt)
        NBKAssertGreatestCommonDivisor(1 * 3 * 5 * 7 * 11 as Int, 3 * 5 * 07 as Int, 3 * 5 * 07 as UInt)
        NBKAssertGreatestCommonDivisor(    3 * 5 * 7 * 11 as Int, 3 * 5 * 07 as Int, 3 * 5 * 07 as UInt)
        NBKAssertGreatestCommonDivisor(        5 * 7 * 11 as Int, 3 * 5 * 07 as Int,     5 * 07 as UInt)
        NBKAssertGreatestCommonDivisor(            7 * 11 as Int, 3 * 5 * 07 as Int,         07 as UInt)
        NBKAssertGreatestCommonDivisor(                11 as Int, 3 * 5 * 07 as Int,         01 as UInt)
    }
    
    func testEveryIntegerDividesZero() {
        for other in -10 ... 10 {
            NBKAssertGreatestCommonDivisor(0 as Int, other, other.magnitude as UInt)
        }
        
        NBKAssertGreatestCommonDivisor(0 as  Int, Int.max,           Int.max.magnitude as UInt)
        NBKAssertGreatestCommonDivisor(0 as UInt, Int.max.magnitude, Int.max.magnitude as UInt)
        NBKAssertGreatestCommonDivisor(0 as UInt, Int.min.magnitude, Int.min.magnitude as UInt)
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor x Assertions
//*============================================================================*

private func NBKAssertGreatestCommonDivisor<T: NBKBinaryInteger>(
_ lhs: T, _ rhs: T, _ gcd: T.Magnitude,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let binary = NBK.ProperBinaryInteger<T>.greatestCommonDivisorByBinaryAlgorithm(of:and:)
    //=------------------------------------------=
    func with(_ lhs: T, _ rhs: T, _ gcd: T.Magnitude) {
        brr: do {
            XCTAssertEqual(binary(0 + lhs, 0 + rhs), gcd, file: file, line: line)
        };  if T.isSigned {
            XCTAssertEqual(binary(0 + lhs, 0 - rhs), gcd, file: file, line: line)
            XCTAssertEqual(binary(0 - lhs, 0 + rhs), gcd, file: file, line: line)
            XCTAssertEqual(binary(0 - lhs, 0 - rhs), gcd, file: file, line: line)
        }
    }
    //=------------------------------------------=
    with(lhs, rhs, gcd)
    with(rhs, lhs, gcd)
    //=------------------------------------------=
    if  T.isSigned {
        NBKAssertGreatestCommonDivisor(lhs.magnitude, rhs.magnitude, gcd, file: file, line: line)
    }
}

#endif
