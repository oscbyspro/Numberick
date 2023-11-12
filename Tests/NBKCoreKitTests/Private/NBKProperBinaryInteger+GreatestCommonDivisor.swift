//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

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
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testEveryIntegerDividesZero() {
        for other in -10 ... 10 {
            NBKAssertGreatestCommonDivisorAsSigned(0 as Int, other, other.magnitude as UInt)
        }
        
        NBKAssertGreatestCommonDivisorAsSigned(0 as Int, Int.max, Int.max.magnitude as UInt)
        NBKAssertGreatestCommonDivisorAsSigned(0 as Int, Int.min, Int.min.magnitude as UInt, true)
    }
    
    func testMinSignedIsSpecialBecauseTheGreatestCommonDivisorMayOverflow() {
        NBKAssertGreatestCommonDivisorAsSigned(Int.min,  Int.min, Int.min.magnitude, true)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min, -Int.max, 00000000000000001)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min, -0000006, 00000000000000002)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min, -0000005, 00000000000000001)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min, -0000004, 00000000000000004)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min, -0000003, 00000000000000001)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min, -0000002, 00000000000000002)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min, -0000001, 00000000000000001)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min,  0000000, Int.min.magnitude, true)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min,  0000001, 00000000000000001)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min,  0000002, 00000000000000002)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min,  0000003, 00000000000000001)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min,  0000004, 00000000000000004)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min,  0000005, 00000000000000001)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min,  0000006, 00000000000000002)
        NBKAssertGreatestCommonDivisorAsSigned(Int.min,  Int.max, 00000000000000001)
    }
    
    func testEachPairInFibonacciSequenceIsCoprime() {
        var fibonacci = HL(high: 1 as UInt, low: 0 as UInt)
        next: while fibonacci.high >= fibonacci.low {
            NBKAssertGreatestCommonDivisorAsUnsigned(fibonacci.high, fibonacci.low, 0001)
            fibonacci = HL(high: fibonacci.high  &+ (fibonacci.low), low: fibonacci.high)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor x E.E.A.
//*============================================================================*

final class NBKProperBinaryIntegerTestsOnGreatestCommonDivisorByExtendedEuclideanAlgorithm: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWrappingBézoutIdentityWorksForAllPairsOfInt8() {
        self.continueAfterFailure = false
        var maxIteration: UInt8 = 0000000
        
        for lhs in  Int8.min ... Int8.max {
            for rhs in Int8.min ... Int8.max {
                let extended = NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm11(of: lhs, and: rhs)
                maxIteration = Swift.max(maxIteration, extended.iteration)
                XCTAssertEqual(Int8(bitPattern: extended.result), lhs &* extended.lhsCoefficient &+ rhs &* extended.rhsCoefficient)
                XCTAssertEqual(extended.lhsCoefficient < 0, (extended.lhsCoefficient != 0) && (lhs < 0) != extended.iteration.isOdd)
                XCTAssertEqual(extended.rhsCoefficient < 0, (extended.rhsCoefficient != 0) && (rhs < 0) == extended.iteration.isOdd)
            }
        }
        
        XCTAssertEqual(maxIteration, 10)
    }
    
    func testWrappingBézoutIdentityWorksForAllPairsOfUInt8() {
        self.continueAfterFailure = false
        var maxIteration: UInt8 = 0000000
        
        for lhs in  UInt8.min ... UInt8.max {
            for rhs in UInt8.min ... UInt8.max {
                let extended = NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm11(of: lhs, and: rhs)
                maxIteration = Swift.max(maxIteration, extended.iteration)
                
                if !extended.iteration.isOdd {
                    XCTAssertEqual(extended.result, lhs &* extended.lhsCoefficient &- rhs &* extended.rhsCoefficient)
                }   else {
                    XCTAssertEqual(extended.result, rhs &* extended.rhsCoefficient &- lhs &* extended.lhsCoefficient)
                }
            }
        }
        
        XCTAssertEqual(maxIteration, 12)
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor x Assertions
//*============================================================================*

private func NBKAssertGreatestCommonDivisorAsSigned<T: NBKSignedInteger & NBKFixedWidthInteger>(
_ lhs: T, _ rhs: T, _ result: T.Magnitude, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    
    func with(_ lhs: T, _ rhs: T) {
        NBKAssertGreatestCommonDivisorByBinaryAlgorithm(/*-------*/lhs,   rhs, result, overflow, file: file, line: line)
        NBKAssertGreatestCommonDivisorByEuclideanAlgorithmAsSigned(lhs,   rhs, result, overflow, file: file, line: line)
        NBKAssertGreatestCommonDivisorAsUnsigned(lhs.magnitude, rhs.magnitude, result, /*-----*/ file: file, line: line)
    }
    
    brr: do {
        with(0 + lhs, 0 + rhs)
        with(0 + rhs, 0 + lhs)
    }

    if  rhs != T.min {
        with(0 + lhs, 0 - rhs)
        with(0 - rhs, 0 + lhs)
    }
    
    if  lhs != T.min {
        with(0 - lhs, 0 + rhs)
        with(0 + rhs, 0 - lhs)
    }
    
    if  lhs != T.min, rhs != T.min {
        with(0 - lhs, 0 - rhs)
        with(0 - rhs, 0 - lhs)
    }
}

private func NBKAssertGreatestCommonDivisorAsUnsigned<T: NBKUnsignedInteger & NBKFixedWidthInteger>(
_ lhs: T, _ rhs: T, _ result: T.Magnitude,
file: StaticString = #file, line: UInt = #line) {
    
    func with(_ lhs: T, _ rhs: T) {
        NBKAssertGreatestCommonDivisorByBinaryAlgorithm(lhs, rhs, result, false, file: file, line: line)
        NBKAssertGreatestCommonDivisorByEuclideanAlgorithmAsUnsigned(lhs, rhs, result, file: file, line: line)
    }
    
    with(0 + lhs, 0 + rhs)
    with(0 + rhs, 0 + lhs)
}

//=----------------------------------------------------------------------------=
// MARK: + Algorithms
//=----------------------------------------------------------------------------=

private func NBKAssertGreatestCommonDivisorByBinaryAlgorithm<T: NBKBinaryInteger & NBKFixedWidthInteger>(
_ lhs: T, _ rhs: T, _ result: T.Magnitude, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let binary = NBK.PBI.greatestCommonDivisorByBinaryAlgorithm(of: lhs, and: rhs)
    //=------------------------------------------=
    XCTAssertEqual(binary, result, file: file, line: line)
    XCTAssertEqual(T.isSigned && binary == T.min.magnitude, overflow, file: file, line: line)
}

private func NBKAssertGreatestCommonDivisorByEuclideanAlgorithmAsSigned<T: NBKSignedInteger & NBKFixedWidthInteger>(
_ lhs: T, _ rhs: T, _ result: T.Magnitude,  _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let e00 = NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm00(of: lhs, and: rhs)
    let e10 = NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm10(of: lhs, and: rhs)
    let e01 = NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm01(of: lhs, and: rhs)
    let e11 = NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm11(of: lhs, and: rhs)
    //=------------------------------------------=
    XCTAssertEqual(e11.result, result, file: file, line: line)
    XCTAssertEqual(e11.result == T.min.magnitude, overflow, file: file, line: line)
    XCTAssertEqual(lhs &* e11.lhsCoefficient &+ rhs &* e11.rhsCoefficient, T(bitPattern: result), file: file, line: line)
    
    if  result == T.min.magnitude {
        let values   = [lhs, rhs]
        XCTAssert(1 <= values.filter({ $0 == T.min }).count,  file: file, line: line)
        XCTAssert(2 == values.filter({ $0 == T.min }).count + values.filter(\.isZero).count,  file: file, line: line)
        
        XCTAssertEqual(lhs == T.min && rhs != T.min ? -1 : 0, e11.lhsCoefficient, file: file, line: line)
        XCTAssertEqual(rhs == T.min /*-----------*/ ? -1 : 0, e11.rhsCoefficient, file: file, line: line)
        XCTAssertEqual(lhs == T.min /*-----------*/ ? -1 : 0, e11.lhsQuotient,    file: file, line: line)
        XCTAssertEqual(rhs == T.min /*-----------*/ ? -1 : 0, e11.rhsQuotient,    file: file, line: line)
    }   else if result.isZero {
        XCTAssertEqual(0, lhs, file: file, line: line)
        XCTAssertEqual(0, rhs, file: file, line: line)
        
        XCTAssertEqual(1, e11.lhsCoefficient, file: file, line: line)
        XCTAssertEqual(0, e11.rhsCoefficient, file: file, line: line)
        XCTAssertEqual(1, e11.lhsQuotient,    file: file, line: line)
        XCTAssertEqual(0, e11.rhsQuotient,    file: file, line: line)
    }   else {
        XCTAssertEqual(e11.lhsQuotient, lhs / T(result),  file: file, line: line)
        XCTAssertEqual(e11.rhsQuotient, rhs / T(result),  file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(e11.iteration,      e00.iteration,      file: file, line: line)
    XCTAssertEqual(e11.result,         e00.result,         file: file, line: line)
    XCTAssertEqual(e11.iteration,      e10.iteration,      file: file, line: line)
    XCTAssertEqual(e11.result,         e10.result,         file: file, line: line)
    XCTAssertEqual(e11.lhsCoefficient, e10.lhsCoefficient, file: file, line: line)
    XCTAssertEqual(e11.rhsQuotient,    e10.rhsQuotient,    file: file, line: line)
    XCTAssertEqual(e11.iteration,      e01.iteration,      file: file, line: line)
    XCTAssertEqual(e11.result,         e01.result,         file: file, line: line)
    XCTAssertEqual(e11.rhsCoefficient, e01.rhsCoefficient, file: file, line: line)
    XCTAssertEqual(e11.lhsQuotient,    e01.lhsQuotient,    file: file, line: line)
}

private func NBKAssertGreatestCommonDivisorByEuclideanAlgorithmAsUnsigned<T: NBKUnsignedInteger & NBKFixedWidthInteger>(
_ lhs: T, _ rhs: T, _ result: T.Magnitude,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let e00 = NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm00(of: lhs, and: rhs)
    let e10 = NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm10(of: lhs, and: rhs)
    let e01 = NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm01(of: lhs, and: rhs)
    let e11 = NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm11(of: lhs, and: rhs)
    //=------------------------------------------=
    XCTAssertEqual(e11.result, T(result), file: file, line: line)
    
    if !result.isZero {
        XCTAssertEqual(e11.lhsQuotient, lhs / T(result),  file: file, line: line)
        XCTAssertEqual(e11.rhsQuotient, rhs / T(result),  file: file, line: line)
    }   else {
        XCTAssertEqual(0, lhs, file: file, line: line)
        XCTAssertEqual(0, rhs, file: file, line: line)
        
        XCTAssertEqual(1, e11.lhsQuotient,    file: file, line: line)
        XCTAssertEqual(0, e11.rhsQuotient,    file: file, line: line)
        XCTAssertEqual(1, e11.lhsCoefficient, file: file, line: line)
        XCTAssertEqual(0, e11.rhsCoefficient, file: file, line: line)
    }
    
    if !e11.iteration.isOdd {
        XCTAssertEqual(lhs &* e11.lhsCoefficient &- rhs &* e11.rhsCoefficient, result, file: file, line: line)
    }   else {
        XCTAssertEqual(rhs &* e11.rhsCoefficient &- lhs &* e11.lhsCoefficient, result, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(e11.iteration,      e00.iteration,      file: file, line: line)
    XCTAssertEqual(e11.result,         e00.result,         file: file, line: line)
    XCTAssertEqual(e11.iteration,      e10.iteration,      file: file, line: line)
    XCTAssertEqual(e11.result,         e10.result,         file: file, line: line)
    XCTAssertEqual(e11.lhsCoefficient, e10.lhsCoefficient, file: file, line: line)
    XCTAssertEqual(e11.rhsQuotient,    e10.rhsQuotient,    file: file, line: line)
    XCTAssertEqual(e11.iteration,      e01.iteration,      file: file, line: line)
    XCTAssertEqual(e11.result,         e01.result,         file: file, line: line)
    XCTAssertEqual(e11.rhsCoefficient, e01.rhsCoefficient, file: file, line: line)
    XCTAssertEqual(e11.lhsQuotient,    e01.lhsQuotient,    file: file, line: line)
}
