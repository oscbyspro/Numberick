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
    
    func testResidueModuloPowerOf2AsInt8() {
        NBKAssertResidueModulo( Int8.min, UInt(8), UInt(0))
        NBKAssertResidueModulo( Int8.max, UInt(8), UInt(7))
        
        NBKAssertResidueModulo( Int8(-4), UInt(4), UInt(0))
        NBKAssertResidueModulo( Int8(-3), UInt(4), UInt(1))
        NBKAssertResidueModulo( Int8(-2), UInt(4), UInt(2))
        NBKAssertResidueModulo( Int8(-1), UInt(4), UInt(3))
        NBKAssertResidueModulo( Int8( 0), UInt(4), UInt(0))
        NBKAssertResidueModulo( Int8( 1), UInt(4), UInt(1))
        NBKAssertResidueModulo( Int8( 2), UInt(4), UInt(2))
        NBKAssertResidueModulo( Int8( 3), UInt(4), UInt(3))
        NBKAssertResidueModulo( Int8( 4), UInt(4), UInt(0))
    }
    
    func testResidueModuloPowerOf2AsUInt8() {
        NBKAssertResidueModulo(UInt8.min, UInt(8), UInt(0))
        NBKAssertResidueModulo(UInt8.max, UInt(8), UInt(7))
        
        NBKAssertResidueModulo(UInt8( 0), UInt(4), UInt(0))
        NBKAssertResidueModulo(UInt8( 1), UInt(4), UInt(1))
        NBKAssertResidueModulo(UInt8( 2), UInt(4), UInt(2))
        NBKAssertResidueModulo(UInt8( 3), UInt(4), UInt(3))
        NBKAssertResidueModulo(UInt8( 4), UInt(4), UInt(0))
        NBKAssertResidueModulo(UInt8( 5), UInt(4), UInt(1))
        NBKAssertResidueModulo(UInt8( 6), UInt(4), UInt(2))
        NBKAssertResidueModulo(UInt8( 7), UInt(4), UInt(3))
        NBKAssertResidueModulo(UInt8( 8), UInt(4), UInt(0))
    }
    
    func testResidueModuloNonPowerOf2Int8() {
        NBKAssertResidueModulo( Int8.min, UInt(7), UInt(5))
        NBKAssertResidueModulo( Int8.max, UInt(7), UInt(1))
        
        NBKAssertResidueModulo( Int8(-3), UInt(3), UInt(0))
        NBKAssertResidueModulo( Int8(-2), UInt(3), UInt(1))
        NBKAssertResidueModulo( Int8(-1), UInt(3), UInt(2))
        NBKAssertResidueModulo( Int8( 0), UInt(3), UInt(0))
        NBKAssertResidueModulo( Int8( 1), UInt(3), UInt(1))
        NBKAssertResidueModulo( Int8( 2), UInt(3), UInt(2))
        NBKAssertResidueModulo( Int8( 3), UInt(3), UInt(0))
    }
    
    func testResidueModuloNonPowerOf2AsUInt8() {
        NBKAssertResidueModulo(UInt8.min, UInt(7), UInt(0))
        NBKAssertResidueModulo(UInt8.max, UInt(7), UInt(3))
        
        NBKAssertResidueModulo(UInt8( 0), UInt(3), UInt(0))
        NBKAssertResidueModulo(UInt8( 1), UInt(3), UInt(1))
        NBKAssertResidueModulo(UInt8( 2), UInt(3), UInt(2))
        NBKAssertResidueModulo(UInt8( 3), UInt(3), UInt(0))
        NBKAssertResidueModulo(UInt8( 4), UInt(3), UInt(1))
        NBKAssertResidueModulo(UInt8( 5), UInt(3), UInt(2))
        NBKAssertResidueModulo(UInt8( 6), UInt(3), UInt(0))
    }
    
    func testResidueReportingOverflowAsInt8() {
        NBKAssertResidueModulo( Int8(-4), UInt(0), ~3 as UInt, true)
        NBKAssertResidueModulo( Int8(-3), UInt(0), ~2 as UInt, true)
        NBKAssertResidueModulo( Int8(-2), UInt(0), ~1 as UInt, true)
        NBKAssertResidueModulo( Int8(-1), UInt(0), ~0 as UInt, true)
        NBKAssertResidueModulo( Int8( 0), UInt(0),  0 as UInt, true)
        NBKAssertResidueModulo( Int8( 1), UInt(0),  1 as UInt, true)
        NBKAssertResidueModulo( Int8( 2), UInt(0),  2 as UInt, true)
        NBKAssertResidueModulo( Int8( 3), UInt(0),  3 as UInt, true)
    }
    
    func testResidueReportingOverflowAsUInt8() {
        NBKAssertResidueModulo(UInt8( 0), UInt(0),  0 as UInt, true)
        NBKAssertResidueModulo(UInt8( 1), UInt(0),  1 as UInt, true)
        NBKAssertResidueModulo(UInt8( 2), UInt(0),  2 as UInt, true)
        NBKAssertResidueModulo(UInt8( 3), UInt(0),  3 as UInt, true)
        NBKAssertResidueModulo(UInt8( 4), UInt(0),  4 as UInt, true)
        NBKAssertResidueModulo(UInt8( 5), UInt(0),  5 as UInt, true)
        NBKAssertResidueModulo(UInt8( 6), UInt(0),  6 as UInt, true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Modulo Bit Width Of
    //=------------------------------------------------------------------------=
    
    func testResidueModuloBitWidthOf() {
        NBKAssertResidueModuloBitWidthOf(Int8.max,  Int8 .self, 07)
        NBKAssertResidueModuloBitWidthOf(Int8.max,  Int16.self, 15)
        NBKAssertResidueModuloBitWidthOf(Int8.max,  Int32.self, 31)
        NBKAssertResidueModuloBitWidthOf(Int8.max,  Int64.self, 63)
        
        NBKAssertResidueModuloBitWidthOf(Int8( 21), Int8 .self, 05)
        NBKAssertResidueModuloBitWidthOf(Int8( 21), Int16.self, 05)
        NBKAssertResidueModuloBitWidthOf(Int8( 21), Int32.self, 21)
        NBKAssertResidueModuloBitWidthOf(Int8( 21), Int64.self, 21)
        
        NBKAssertResidueModuloBitWidthOf(Int8(-21), Int8 .self, 03)
        NBKAssertResidueModuloBitWidthOf(Int8(-21), Int16.self, 11)
        NBKAssertResidueModuloBitWidthOf(Int8(-21), Int32.self, 11)
        NBKAssertResidueModuloBitWidthOf(Int8(-21), Int64.self, 43)
    }
}

//*============================================================================*
// MARK: * NBK x Division x Assertions
//*============================================================================*

private func NBKAssertDividingByBitWidthAsIntOrUInt(
_ value: UInt, _ quotient: UInt, _ remainder: UInt,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(NBK .quotientDividingByBitWidth(value), quotient,  file: file, line: line)
    XCTAssertEqual(NBK.remainderDividingByBitWidth(value), remainder, file: file, line: line)
    //=------------------------------------------=
    if  let value = Int(exactly: value), let quotient = Int(exactly: quotient), let remainder = Int(exactly: remainder) {
        XCTAssertEqual(NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(value), quotient,  file: file, line: line)
        XCTAssertEqual(NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(value), remainder, file: file, line: line)
    }
}

private func NBKAssertResidueModulo(
_ value: some BinaryInteger, _ modulus: UInt, _ partialValue: UInt, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(NBK.residueReportingOverflow(of: value, modulo: modulus).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(NBK.residueReportingOverflow(of: value, modulo: modulus).overflow,     overflow,     file: file, line: line)
}

private func NBKAssertResidueModuloBitWidthOf(
_ value: some BinaryInteger, _ source: (some NBKFixedWidthInteger).Type, _ result: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(NBK.residue(of: value, moduloBitWidthOf: source),                result, file: file, line: line)
    XCTAssertEqual(NBK.residue(of: value, moduloBitWidthOf: source.Magnitude.self), result, file: file, line: line)
}

#endif
