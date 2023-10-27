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
        NBKAssertGreatestCommonDivisorAsSigned( 2 as Int, 16 as Int,  2 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned( 4 as Int, 16 as Int,  4 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned( 8 as Int, 16 as Int,  8 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(16 as Int, 16 as Int, 16 as UInt)
    }
    
    func testSmallPrimeProducts() {
        // even x even
        NBKAssertGreatestCommonDivisorAsSigned(2                  as Int, 2 * 5 * 11 as Int, 2          as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(2 * 3              as Int, 2 * 5 * 11 as Int, 2          as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(2 * 3 * 5          as Int, 2 * 5 * 11 as Int, 2 * 5      as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(2 * 3 * 5 * 7      as Int, 2 * 5 * 11 as Int, 2 * 5      as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(2 * 3 * 5 * 7 * 11 as Int, 2 * 5 * 11 as Int, 2 * 5 * 11 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(    3 * 5 * 7 * 11 as Int, 2 * 5 * 11 as Int,     5 * 11 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(        5 * 7 * 11 as Int, 2 * 5 * 11 as Int,     5 * 11 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(            7 * 11 as Int, 2 * 5 * 11 as Int,         11 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(                11 as Int, 2 * 5 * 11 as Int,         11 as UInt)
        // even x odd
        NBKAssertGreatestCommonDivisorAsSigned(2                  as Int, 3 * 5 * 07 as Int, 1          as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(2 * 3              as Int, 3 * 5 * 07 as Int, 3          as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(2 * 3 * 5          as Int, 3 * 5 * 07 as Int, 3 * 5      as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(2 * 3 * 5 * 7      as Int, 3 * 5 * 07 as Int, 3 * 5 * 07 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(2 * 3 * 5 * 7 * 11 as Int, 3 * 5 * 07 as Int, 3 * 5 * 07 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(    3 * 5 * 7 * 11 as Int, 3 * 5 * 07 as Int, 3 * 5 * 07 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(        5 * 7 * 11 as Int, 3 * 5 * 07 as Int,     5 * 07 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(            7 * 11 as Int, 3 * 5 * 07 as Int,         07 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(                11 as Int, 3 * 5 * 07 as Int,         01 as UInt)
        // odd  x even
        NBKAssertGreatestCommonDivisorAsSigned(1                  as Int, 2 * 5 * 11 as Int, 1          as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(1 * 3              as Int, 2 * 5 * 11 as Int, 1          as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(1 * 3 * 5          as Int, 2 * 5 * 11 as Int, 1 * 5      as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(1 * 3 * 5 * 7      as Int, 2 * 5 * 11 as Int, 1 * 5      as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(1 * 3 * 5 * 7 * 11 as Int, 2 * 5 * 11 as Int, 1 * 5 * 11 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(    3 * 5 * 7 * 11 as Int, 2 * 5 * 11 as Int,     5 * 11 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(        5 * 7 * 11 as Int, 2 * 5 * 11 as Int,     5 * 11 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(            7 * 11 as Int, 2 * 5 * 11 as Int,         11 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(                11 as Int, 2 * 5 * 11 as Int,         11 as UInt)
        // odd  x odd
        NBKAssertGreatestCommonDivisorAsSigned(1                  as Int, 3 * 5 * 07 as Int, 1          as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(1 * 3              as Int, 3 * 5 * 07 as Int, 3          as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(1 * 3 * 5          as Int, 3 * 5 * 07 as Int, 3 * 5      as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(1 * 3 * 5 * 7      as Int, 3 * 5 * 07 as Int, 3 * 5 * 07 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(1 * 3 * 5 * 7 * 11 as Int, 3 * 5 * 07 as Int, 3 * 5 * 07 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(    3 * 5 * 7 * 11 as Int, 3 * 5 * 07 as Int, 3 * 5 * 07 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(        5 * 7 * 11 as Int, 3 * 5 * 07 as Int,     5 * 07 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(            7 * 11 as Int, 3 * 5 * 07 as Int,         07 as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(                11 as Int, 3 * 5 * 07 as Int,         01 as UInt)
    }
    
    func testEveryIntegerDividesZero() {
        for other in -10 ... 10 {
            NBKAssertGreatestCommonDivisorAsSigned(0 as Int, other, other.magnitude as UInt)
        }
        
        NBKAssertGreatestCommonDivisorAsSigned(  0 as  Int, Int.max,           Int.max.magnitude as UInt)
        NBKAssertGreatestCommonDivisorAsUnsigned(0 as UInt, Int.max.magnitude, Int.max.magnitude as UInt)
        NBKAssertGreatestCommonDivisorAsUnsigned(0 as UInt, Int.min.magnitude, Int.min.magnitude as UInt)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testMinSignedIsSpecialBecauseTheGreatestCommonDivisorMayOverflow() {
        func check(lhs: Int, rhs: Int, result: UInt, overflow: Bool = false) {
            let binary = NBK.PBI.greatestCommonDivisorByBinaryAlgorithm(of: lhs, and: rhs)
            XCTAssertEqual(binary, result)
            
            let extended = NBK.PBI.greatestCommonDivisorByExtendedEuclideanAlgorithm(of: lhs, and: rhs)
            XCTAssertEqual(extended.result, result)
            XCTAssertEqual(lhs &* extended.lhsCoefficient &+ rhs &* extended.rhsCoefficient, Int(bitPattern: result))
            
            if  let result = Int(exactly: result) {
                XCTAssertFalse(overflow)
                XCTAssertEqual(extended.lhsQuotient, lhs /  Int(result))
                XCTAssertEqual(extended.rhsQuotient, rhs /  Int(result))
            }   else {
                XCTAssertTrue (overflow)
                XCTAssertEqual(extended.lhsQuotient, lhs >> Int.max)
                XCTAssertEqual(extended.rhsQuotient, rhs >> Int.max)
            }
        }
        
        check(lhs: Int.min, rhs:  Int.min, result: Int.min.magnitude, overflow: true)
        check(lhs: Int.min, rhs: -Int.max, result: 00000000000000001)
        check(lhs: Int.min, rhs: -0000003, result: 00000000000000001)
        check(lhs: Int.min, rhs: -0000002, result: 00000000000000002)
        check(lhs: Int.min, rhs: -0000001, result: 00000000000000001)
        check(lhs: Int.min, rhs:  0000000, result: Int.min.magnitude, overflow: true)
        check(lhs: Int.min, rhs:  0000001, result: 00000000000000001)
        check(lhs: Int.min, rhs:  0000002, result: 00000000000000002)
        check(lhs: Int.min, rhs:  0000003, result: 00000000000000001)
        check(lhs: Int.min, rhs:  Int.max, result: 00000000000000001)
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor x Assertions
//*============================================================================*

private func NBKAssertGreatestCommonDivisorAsSigned<T: NBKSignedInteger>(
_ lhs: T, _ rhs: T, _ gcd: T.Magnitude,
file: StaticString = #file, line: UInt = #line) {
    
    func with(_ lhs: T, _ rhs: T) {
        NBKAssertGreatestCommonDivisorByBinaryAlgorithm(/*---------------*/lhs, rhs, gcd, file: file, line: line)
        NBKAssertGreatestCommonDivisorByExtendedEuclideanAlgorithmAsSigned(lhs, rhs, gcd, file: file, line: line)
        NBKAssertGreatestCommonDivisorAsUnsigned(lhs.magnitude, rhs.magnitude,  /**/ gcd, file: file, line: line)
    }
    
    with(0 + lhs, 0 + rhs)
    with(0 + lhs, 0 - rhs)
    with(0 - lhs, 0 + rhs)
    with(0 - lhs, 0 - rhs)
    
    with(0 + rhs, 0 + lhs)
    with(0 + rhs, 0 - lhs)
    with(0 - rhs, 0 + lhs)
    with(0 - rhs, 0 - lhs)
}

private func NBKAssertGreatestCommonDivisorAsUnsigned<T: NBKUnsignedInteger>(
_ lhs: T, _ rhs: T, _ gcd: T.Magnitude,
file: StaticString = #file, line: UInt = #line) {
    
    func with(_ lhs: T, _ rhs: T) {
        NBKAssertGreatestCommonDivisorByBinaryAlgorithm(lhs, rhs, gcd, file: file, line: line)
        NBKAssertGreatestCommonDivisorByExtendedEuclideanAlgorithmAsUnsigned(lhs, rhs, gcd, file: file, line: line)
    }
    
    with(0 + lhs, 0 + rhs)
    with(0 + rhs, 0 + lhs)
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

private func NBKAssertGreatestCommonDivisorByBinaryAlgorithm<T: NBKBinaryInteger>(
_ lhs: T, _ rhs: T, _ gcd: T.Magnitude,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(NBK.PBI.greatestCommonDivisorByBinaryAlgorithm(of: lhs, and: rhs), gcd, file: file, line: line)
}

private func NBKAssertGreatestCommonDivisorByExtendedEuclideanAlgorithmAsSigned<T: NBKSignedInteger>(
_ lhs: T, _ rhs: T, _ gcd: T.Magnitude,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let extended = NBK.PBI.greatestCommonDivisorByExtendedEuclideanAlgorithm(of: lhs, and: rhs)
    //=------------------------------------------=
    XCTAssertEqual( (gcd), extended.result, file: file,  line: line)
    XCTAssertEqual(T(gcd), lhs * extended.lhsCoefficient + rhs * extended.rhsCoefficient, file: file, line: line)
        
    if !gcd.isZero {
        XCTAssertEqual(extended.lhsQuotient, lhs / T(gcd), file: file, line: line)
        XCTAssertEqual(extended.rhsQuotient, rhs / T(gcd), file: file, line: line)
    }   else {
        XCTAssertEqual(0, lhs, file: file, line: line)
        XCTAssertEqual(0, rhs, file: file, line: line)
        
        XCTAssertEqual(1, extended.lhsQuotient,    file: file, line: line)
        XCTAssertEqual(0, extended.rhsQuotient,    file: file, line: line)
        XCTAssertEqual(1, extended.lhsCoefficient, file: file, line: line)
        XCTAssertEqual(0, extended.rhsCoefficient, file: file, line: line)
    }
}

private func NBKAssertGreatestCommonDivisorByExtendedEuclideanAlgorithmAsUnsigned<T: NBKUnsignedInteger>(
_ lhs: T, _ rhs: T, _ gcd: T.Magnitude,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let extended = NBK.PBI<T>.greatestCommonDivisorByExtendedEuclideanAlgorithm(of: lhs, and: rhs)
    //=------------------------------------------=
    XCTAssertEqual(extended.result, T(gcd), file: file, line: line)
    
    if !gcd.isZero {
        XCTAssertEqual(extended.lhsQuotient, lhs / T(gcd), file: file, line: line)
        XCTAssertEqual(extended.rhsQuotient, rhs / T(gcd), file: file, line: line)
    }   else {
        XCTAssertEqual(0, lhs, file: file, line: line)
        XCTAssertEqual(0, rhs, file: file, line: line)
        
        XCTAssertEqual(1, extended.lhsQuotient,    file: file, line: line)
        XCTAssertEqual(0, extended.rhsQuotient,    file: file, line: line)
        XCTAssertEqual(1, extended.lhsCoefficient, file: file, line: line)
        XCTAssertEqual(0, extended.rhsCoefficient, file: file, line: line)
    }
    
    let x = lhs * extended.lhsCoefficient
    let y = rhs * extended.rhsCoefficient
    let z = extended.even ? x - y : y - x
    XCTAssertEqual(z, gcd, file: file, line: line)
}

#endif
