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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Division x Int or UInt
//*============================================================================*

final class NBKTestsOnDivisionAsIntOrUInt: XCTestCase {
    
    typealias T = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let bitWidth = T(T.bitWidth)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividingByBitWidth() {
        NBKAssertDividingByBitWidthAsIntOrUInt(T(0) * bitWidth + T(0), T(0), T(0))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(0) * bitWidth + T(1), T(0), T(1))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(0) * bitWidth + T(2), T(0), T(2))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(0) * bitWidth + T(3), T(0), T(3))
        
        NBKAssertDividingByBitWidthAsIntOrUInt(T(1) * bitWidth + T(0), T(1), T(0))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(1) * bitWidth + T(1), T(1), T(1))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(1) * bitWidth + T(2), T(1), T(2))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(1) * bitWidth + T(3), T(1), T(3))
        
        NBKAssertDividingByBitWidthAsIntOrUInt(T(2) * bitWidth + T(0), T(2), T(0))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(2) * bitWidth + T(1), T(2), T(1))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(2) * bitWidth + T(2), T(2), T(2))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(2) * bitWidth + T(3), T(2), T(3))
        
        NBKAssertDividingByBitWidthAsIntOrUInt(T.min, T.min / bitWidth, T.min % bitWidth)
        NBKAssertDividingByBitWidthAsIntOrUInt(T.max, T.max / bitWidth, T.max % bitWidth)
    }
}

//*============================================================================*
// MARK: * NBK x Division x Binary Integer
//*============================================================================*

final class NBKTestsOnDivisionAsBinaryInteger: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLeastPositiveResidueDividingByPowerOf2() {
        NBKAssertLeastPositiveResidue( Int8.min, UInt(8), UInt(0))
        NBKAssertLeastPositiveResidue( Int8.max, UInt(8), UInt(7))
        
        NBKAssertLeastPositiveResidue( Int8(-4), UInt(4), UInt(0))
        NBKAssertLeastPositiveResidue( Int8(-3), UInt(4), UInt(1))
        NBKAssertLeastPositiveResidue( Int8(-2), UInt(4), UInt(2))
        NBKAssertLeastPositiveResidue( Int8(-1), UInt(4), UInt(3))
        NBKAssertLeastPositiveResidue( Int8( 0), UInt(4), UInt(0))
        NBKAssertLeastPositiveResidue( Int8( 1), UInt(4), UInt(1))
        NBKAssertLeastPositiveResidue( Int8( 2), UInt(4), UInt(2))
        NBKAssertLeastPositiveResidue( Int8( 3), UInt(4), UInt(3))
        NBKAssertLeastPositiveResidue( Int8( 4), UInt(4), UInt(0))
        
        NBKAssertLeastPositiveResidue(UInt8.min, UInt(8), UInt(0))
        NBKAssertLeastPositiveResidue(UInt8.max, UInt(8), UInt(7))
        
        NBKAssertLeastPositiveResidue(UInt8( 0), UInt(4), UInt(0))
        NBKAssertLeastPositiveResidue(UInt8( 1), UInt(4), UInt(1))
        NBKAssertLeastPositiveResidue(UInt8( 2), UInt(4), UInt(2))
        NBKAssertLeastPositiveResidue(UInt8( 3), UInt(4), UInt(3))
        NBKAssertLeastPositiveResidue(UInt8( 4), UInt(4), UInt(0))
        NBKAssertLeastPositiveResidue(UInt8( 5), UInt(4), UInt(1))
        NBKAssertLeastPositiveResidue(UInt8( 6), UInt(4), UInt(2))
        NBKAssertLeastPositiveResidue(UInt8( 7), UInt(4), UInt(3))
        NBKAssertLeastPositiveResidue(UInt8( 8), UInt(4), UInt(0))
    }
    
    func testLeastPositiveResidueDividingByNonPowerOf2() {
        NBKAssertLeastPositiveResidue( Int8.min, UInt(7), UInt(5))
        NBKAssertLeastPositiveResidue( Int8.max, UInt(7), UInt(1))
        
        NBKAssertLeastPositiveResidue( Int8(-3), UInt(3), UInt(0))
        NBKAssertLeastPositiveResidue( Int8(-2), UInt(3), UInt(1))
        NBKAssertLeastPositiveResidue( Int8(-1), UInt(3), UInt(2))
        NBKAssertLeastPositiveResidue( Int8( 0), UInt(3), UInt(0))
        NBKAssertLeastPositiveResidue( Int8( 1), UInt(3), UInt(1))
        NBKAssertLeastPositiveResidue( Int8( 2), UInt(3), UInt(2))
        NBKAssertLeastPositiveResidue( Int8( 3), UInt(3), UInt(0))
        
        NBKAssertLeastPositiveResidue(UInt8.min, UInt(7), UInt(0))
        NBKAssertLeastPositiveResidue(UInt8.max, UInt(7), UInt(3))
        
        NBKAssertLeastPositiveResidue(UInt8( 0), UInt(3), UInt(0))
        NBKAssertLeastPositiveResidue(UInt8( 1), UInt(3), UInt(1))
        NBKAssertLeastPositiveResidue(UInt8( 2), UInt(3), UInt(2))
        NBKAssertLeastPositiveResidue(UInt8( 3), UInt(3), UInt(0))
        NBKAssertLeastPositiveResidue(UInt8( 4), UInt(3), UInt(1))
        NBKAssertLeastPositiveResidue(UInt8( 5), UInt(3), UInt(2))
        NBKAssertLeastPositiveResidue(UInt8( 6), UInt(3), UInt(0))
    }
    
    func testLeastPositiveResidueReportingOverflow() {
        NBKAssertLeastPositiveResidue( Int8(-4), UInt(0), ~3 as UInt, true)
        NBKAssertLeastPositiveResidue( Int8(-3), UInt(0), ~2 as UInt, true)
        NBKAssertLeastPositiveResidue( Int8(-2), UInt(0), ~1 as UInt, true)
        NBKAssertLeastPositiveResidue( Int8(-1), UInt(0), ~0 as UInt, true)
        NBKAssertLeastPositiveResidue( Int8( 0), UInt(0),  0 as UInt, true)
        NBKAssertLeastPositiveResidue( Int8( 1), UInt(0),  1 as UInt, true)
        NBKAssertLeastPositiveResidue( Int8( 2), UInt(0),  2 as UInt, true)
        NBKAssertLeastPositiveResidue( Int8( 3), UInt(0),  3 as UInt, true)
        
        NBKAssertLeastPositiveResidue(UInt8( 0), UInt(0),  0 as UInt, true)
        NBKAssertLeastPositiveResidue(UInt8( 1), UInt(0),  1 as UInt, true)
        NBKAssertLeastPositiveResidue(UInt8( 2), UInt(0),  2 as UInt, true)
        NBKAssertLeastPositiveResidue(UInt8( 3), UInt(0),  3 as UInt, true)
        NBKAssertLeastPositiveResidue(UInt8( 4), UInt(0),  4 as UInt, true)
        NBKAssertLeastPositiveResidue(UInt8( 5), UInt(0),  5 as UInt, true)
        NBKAssertLeastPositiveResidue(UInt8( 6), UInt(0),  6 as UInt, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Least Positive Residue Dividing By Bit Width Of
    //=------------------------------------------------------------------------=
    
    func testLeastPositiveResidueDividingByBitWidthOf() {
        NBKAssertLeastPositiveResidueDividingByBitWidthOf(Int8.max,  Int8 .self, 07)
        NBKAssertLeastPositiveResidueDividingByBitWidthOf(Int8.max,  Int16.self, 15)
        NBKAssertLeastPositiveResidueDividingByBitWidthOf(Int8.max,  Int32.self, 31)
        NBKAssertLeastPositiveResidueDividingByBitWidthOf(Int8.max,  Int64.self, 63)
        
        NBKAssertLeastPositiveResidueDividingByBitWidthOf(Int8( 21), Int8 .self, 05)
        NBKAssertLeastPositiveResidueDividingByBitWidthOf(Int8( 21), Int16.self, 05)
        NBKAssertLeastPositiveResidueDividingByBitWidthOf(Int8( 21), Int32.self, 21)
        NBKAssertLeastPositiveResidueDividingByBitWidthOf(Int8( 21), Int64.self, 21)
        
        NBKAssertLeastPositiveResidueDividingByBitWidthOf(Int8(-21), Int8 .self, 03)
        NBKAssertLeastPositiveResidueDividingByBitWidthOf(Int8(-21), Int16.self, 11)
        NBKAssertLeastPositiveResidueDividingByBitWidthOf(Int8(-21), Int32.self, 11)
        NBKAssertLeastPositiveResidueDividingByBitWidthOf(Int8(-21), Int64.self, 43)
    }
}

//*============================================================================*
// MARK: * NBK x Division x Assertions
//*============================================================================*

private func NBKAssertDividingByBitWidthAsIntOrUInt(
_ dividend: UInt, _ quotient: UInt, _ remainder: UInt,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(NBK .quotientDividingByBitWidth(dividend), quotient,  file: file, line: line)
    XCTAssertEqual(NBK.remainderDividingByBitWidth(dividend), remainder, file: file, line: line)
    //=------------------------------------------=
    if  let value = Int(exactly: dividend), let quotient = Int(exactly:  quotient), let remainder = Int(exactly: remainder) {
        XCTAssertEqual(NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(value), quotient,  file: file, line: line)
        XCTAssertEqual(NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(value), remainder, file: file, line: line)
    }
}

private func NBKAssertLeastPositiveResidue(
_ dividend: some BinaryInteger, _ divisor: UInt, _ partialValue: UInt, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let leastPositiveResidue = NBK.leastPositiveResidueReportingOverflow(of: dividend, dividingBy: divisor)
    XCTAssertEqual(leastPositiveResidue.partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(leastPositiveResidue.overflow,     overflow,     file: file, line: line)
}

private func NBKAssertLeastPositiveResidueDividingByBitWidthOf(
_ dividend: some BinaryInteger, _ source: (some NBKFixedWidthInteger).Type, _ result: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let leastPositiveResidue = NBK.leastPositiveResidue(of: dividend, dividingByBitWidthOf: source)
    XCTAssertEqual(leastPositiveResidue, result, file: file, line: line)
}

#endif
