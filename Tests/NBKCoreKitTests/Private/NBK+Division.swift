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
// MARK: * NBK x Division
//*============================================================================*

final class NBKTestsOnDivision: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividingZeroOrMoreByPowerOf2() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger<UInt> {
            NBKAssertDividingZeroOrMoreByPowerOf2(T(0) * T(T.bitWidth/2) + T(0), T(T.bitWidth), T(0), T(0))
            NBKAssertDividingZeroOrMoreByPowerOf2(T(0) * T(T.bitWidth/2) + T(1), T(T.bitWidth), T(0), T(1))
            NBKAssertDividingZeroOrMoreByPowerOf2(T(0) * T(T.bitWidth/2) + T(2), T(T.bitWidth), T(0), T(2))
            NBKAssertDividingZeroOrMoreByPowerOf2(T(0) * T(T.bitWidth/2) + T(3), T(T.bitWidth), T(0), T(3))
            
            NBKAssertDividingZeroOrMoreByPowerOf2(T(1) * T(T.bitWidth/2) + T(0), T(T.bitWidth), T(0), T(0) + T(T.bitWidth/2))
            NBKAssertDividingZeroOrMoreByPowerOf2(T(1) * T(T.bitWidth/2) + T(1), T(T.bitWidth), T(0), T(1) + T(T.bitWidth/2))
            NBKAssertDividingZeroOrMoreByPowerOf2(T(1) * T(T.bitWidth/2) + T(2), T(T.bitWidth), T(0), T(2) + T(T.bitWidth/2))
            NBKAssertDividingZeroOrMoreByPowerOf2(T(1) * T(T.bitWidth/2) + T(3), T(T.bitWidth), T(0), T(3) + T(T.bitWidth/2))
            
            NBKAssertDividingZeroOrMoreByPowerOf2(T(2) * T(T.bitWidth/2) + T(0), T(T.bitWidth), T(1), T(0))
            NBKAssertDividingZeroOrMoreByPowerOf2(T(2) * T(T.bitWidth/2) + T(1), T(T.bitWidth), T(1), T(1))
            NBKAssertDividingZeroOrMoreByPowerOf2(T(2) * T(T.bitWidth/2) + T(2), T(T.bitWidth), T(1), T(2))
            NBKAssertDividingZeroOrMoreByPowerOf2(T(2) * T(T.bitWidth/2) + T(3), T(T.bitWidth), T(1), T(3))
            
            NBKAssertDividingZeroOrMoreByPowerOf2(T(3) * T(T.bitWidth/2) + T(0), T(T.bitWidth), T(1), T(0) + T(T.bitWidth/2))
            NBKAssertDividingZeroOrMoreByPowerOf2(T(3) * T(T.bitWidth/2) + T(1), T(T.bitWidth), T(1), T(1) + T(T.bitWidth/2))
            NBKAssertDividingZeroOrMoreByPowerOf2(T(3) * T(T.bitWidth/2) + T(2), T(T.bitWidth), T(1), T(2) + T(T.bitWidth/2))
            NBKAssertDividingZeroOrMoreByPowerOf2(T(3) * T(T.bitWidth/2) + T(3), T(T.bitWidth), T(1), T(3) + T(T.bitWidth/2))
            
            NBKAssertDividingZeroOrMoreByPowerOf2(T.max, T(T.bitWidth/1),  T.max / T(T.bitWidth/1), T.max % T(T.bitWidth/1))
            NBKAssertDividingZeroOrMoreByPowerOf2(T.max, T(T.bitWidth/2),  T.max / T(T.bitWidth/2), T.max % T(T.bitWidth/2))
            NBKAssertDividingZeroOrMoreByPowerOf2(T.max, T(T.bitWidth/4),  T.max / T(T.bitWidth/4), T.max % T(T.bitWidth/4))
            NBKAssertDividingZeroOrMoreByPowerOf2(T.max, T(T.bitWidth/8),  T.max / T(T.bitWidth/8), T.max % T(T.bitWidth/8))
        }
        
        whereIs( Int.self)
        whereIs(UInt.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Least Positive Residue x Int Or UInt
    //=------------------------------------------------------------------------=
    
    func testLeastPositiveResidueDividingByPowerOf2() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger<UInt> {
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8.min, T( 8),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8.max, T( 8),  7 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-4), T( 4),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-3), T( 4),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-2), T( 4),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-1), T( 4),  3 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 0), T( 4),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 1), T( 4),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 2), T( 4),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 3), T( 4),  3 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 4), T( 4),  0 as T)
            
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8.min, T( 8),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8.max, T( 8),  7 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 0), T( 4),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 1), T( 4),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 2), T( 4),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 3), T( 4),  3 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 4), T( 4),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 5), T( 4),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 6), T( 4),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 7), T( 4),  3 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 8), T( 4),  0 as T)
            
            guard T.isSigned else { return }
            
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8.min, T(-8),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8.max, T(-8),  7 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-4), T(-4),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-3), T(-4),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-2), T(-4),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-1), T(-4),  3 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 0), T(-4),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 1), T(-4),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 2), T(-4),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 3), T(-4),  3 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 4), T(-4),  0 as T)
            
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8.min, T(-8),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8.max, T(-8),  7 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 0), T(-4),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 1), T(-4),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 2), T(-4),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 3), T(-4),  3 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 4), T(-4),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 5), T(-4),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 6), T(-4),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 7), T(-4),  3 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 8), T(-4),  0 as T)
        }
        
        whereIs( Int.self)
        whereIs(UInt.self)
    }
    
    func testLeastPositiveResidueDividingByNonPowerOf2() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger<UInt> {
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8.min, T( 7),  5 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8.max, T( 7),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-3), T( 3),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-2), T( 3),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-1), T( 3),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 0), T( 3),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 1), T( 3),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 2), T( 3),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 3), T( 3),  0 as T)
            
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8.min, T( 7),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8.max, T( 7),  3 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 0), T( 3),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 1), T( 3),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 2), T( 3),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 3), T( 3),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 4), T( 3),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 5), T( 3),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 6), T( 3),  0 as T)
            
            guard T.isSigned else { return }
            
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8.min, T(-7),  5 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8.max, T(-7),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-3), T(-3),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-2), T(-3),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-1), T(-3),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 0), T(-3),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 1), T(-3),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 2), T(-3),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 3), T(-3),  0 as T)
            
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8.min, T(-7),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8.max, T(-7),  3 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 0), T(-3),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 1), T(-3),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 2), T(-3),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 3), T(-3),  0 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 4), T(-3),  1 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 5), T(-3),  2 as T)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 6), T(-3),  0 as T)
        }
        
        whereIs( Int.self)
        whereIs(UInt.self)
    }
    
    func testLeastPositiveResidueReportingOverflow() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger<UInt> {
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-4), T( 0), ~3 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-3), T( 0), ~2 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-2), T( 0), ~1 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8(-1), T( 0), ~0 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 0), T( 0),  0 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 1), T( 0),  1 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 2), T( 0),  2 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8( 3), T( 0),  3 as T, true)
            
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 0), T( 0),  0 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 1), T( 0),  1 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 2), T( 0),  2 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 3), T( 0),  3 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 4), T( 0),  4 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 5), T( 0),  5 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 6), T( 0),  6 as T, true)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt(UInt8( 7), T( 0),  7 as T, true)
            
            guard T.isSigned else { return }
            
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8.min, T( 1),  0 as T, false)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8.min, T(-1),  0 as T, false)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8.max, T( 1),  0 as T, false)
            NBKAssertLeastPositiveResidueDividingByIntOrUInt( Int8.max, T(-1),  0 as T, false)
        }
        
        whereIs( Int.self)
        whereIs(UInt.self)
    }
}

//*============================================================================*
// MARK: * NBK x Division x Assertions
//*============================================================================*

private func NBKAssertDividingZeroOrMoreByPowerOf2<T: NBKCoreInteger>(
_ dividend: T, _ divisor: T, _ quotient: T, _ remainder: T,
file: StaticString = #file, line: UInt = #line) where T.Magnitude == UInt {
    //=------------------------------------------=
    let dividend = NBK.ZeroOrMore(dividend), divisor = NBK.PowerOf2(divisor)
    //=------------------------------------------=
    XCTAssertEqual(NBK .dividing(dividend, by: divisor).quotient,  quotient,  file: file, line: line)
    XCTAssertEqual(NBK .dividing(dividend, by: divisor).remainder, remainder, file: file, line: line)
    XCTAssertEqual(NBK .quotient(dividing: dividend, by: divisor), quotient,  file: file, line: line)
    XCTAssertEqual(NBK.remainder(dividing: dividend, by: divisor), remainder, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Int Or UInt
//=----------------------------------------------------------------------------=

private func NBKAssertLeastPositiveResidueDividingByIntOrUInt<T: NBKCoreInteger>(
_ dividend: some BinaryInteger, _ divisor: T, _ partialValue: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) where T.Magnitude == UInt {
    //=------------------------------------------=
    if  let divisor = NBK.PowerOf2(exactly: divisor) {
        let leastPositiveResidue = NBK.leastPositiveResidue(dividing: dividend, by: divisor)
        XCTAssertEqual(leastPositiveResidue, partialValue, file: file, line: line)
    }

    if  let divisor = NBK.NonZero(exactly: divisor) {
        let leastPositiveResidue = NBK.leastPositiveResidue(dividing: dividend, by: divisor)
        XCTAssertEqual(leastPositiveResidue, partialValue, file: file, line: line)
    }
    
    brr: do {
        let leastPositiveResidue = NBK.leastPositiveResidueReportingOverflow(dividing: dividend, by: divisor)
        XCTAssertEqual(leastPositiveResidue.partialValue, partialValue, file: file, line: line)
        XCTAssertEqual(leastPositiveResidue.overflow,     overflow,     file: file, line: line)
    }
}

#endif
