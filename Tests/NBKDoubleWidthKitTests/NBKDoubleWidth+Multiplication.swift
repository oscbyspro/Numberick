//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X64 = NBK.U256X64
private typealias X32 = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Multiplication x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnMultiplicationAsInt256: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplyingLargeByLarge() {
        NBKAssertMultiplication(T(x64: X64( 1,  2,  3,  4)),  T(x64: X64(2, 0, 0, 0)), T(x64: X64( 2,  4,  6,  8)), T(x64: X64( 0,  0,  0,  0)))
        NBKAssertMultiplication(T(x64: X64( 1,  2,  3,  4)),  T(x64: X64(0, 2, 0, 0)), T(x64: X64( 0,  2,  4,  6)), T(x64: X64( 8,  0,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X64( 1,  2,  3,  4)),  T(x64: X64(0, 0, 2, 0)), T(x64: X64( 0,  0,  2,  4)), T(x64: X64( 6,  8,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X64( 1,  2,  3,  4)),  T(x64: X64(0, 0, 0, 2)), T(x64: X64( 0,  0,  0,  2)), T(x64: X64( 4,  6,  8,  0)), true)
        
        NBKAssertMultiplication(T(x64: X64( 1,  2,  3,  4)), -T(x64: X64(2, 0, 0, 0)), T(x64: X64(~1, ~4, ~6, ~8)), T(x64: X64(~0, ~0, ~0, ~0)))
        NBKAssertMultiplication(T(x64: X64( 1,  2,  3,  4)), -T(x64: X64(0, 2, 0, 0)), T(x64: X64( 0, ~1, ~4, ~6)), T(x64: X64(~8, ~0, ~0, ~0)), true)
        NBKAssertMultiplication(T(x64: X64( 1,  2,  3,  4)), -T(x64: X64(0, 0, 2, 0)), T(x64: X64( 0,  0, ~1, ~4)), T(x64: X64(~6, ~8, ~0, ~0)), true)
        NBKAssertMultiplication(T(x64: X64( 1,  2,  3,  4)), -T(x64: X64(0, 0, 0, 2)), T(x64: X64( 0,  0,  0, ~1)), T(x64: X64(~4, ~6, ~8, ~0)), true)
        
        NBKAssertMultiplication(T(x64: X64(~1, ~2, ~3, ~4)),  T(x64: X64(2, 0, 0, 0)), T(x64: X64(~3, ~4, ~6, ~8)), T(x64: X64(~0, ~0, ~0, ~0)))
        NBKAssertMultiplication(T(x64: X64(~1, ~2, ~3, ~4)),  T(x64: X64(0, 2, 0, 0)), T(x64: X64( 0, ~3, ~4, ~6)), T(x64: X64(~8, ~0, ~0, ~0)), true)
        NBKAssertMultiplication(T(x64: X64(~1, ~2, ~3, ~4)),  T(x64: X64(0, 0, 2, 0)), T(x64: X64( 0,  0, ~3, ~4)), T(x64: X64(~6, ~8, ~0, ~0)), true)
        NBKAssertMultiplication(T(x64: X64(~1, ~2, ~3, ~4)),  T(x64: X64(0, 0, 0, 2)), T(x64: X64( 0,  0,  0, ~3)), T(x64: X64(~4, ~6, ~8, ~0)), true)
        
        NBKAssertMultiplication(T(x64: X64(~1, ~2, ~3, ~4)), -T(x64: X64(2, 0, 0, 0)), T(x64: X64( 4,  4,  6,  8)), T(x64: X64( 0,  0,  0,  0)))
        NBKAssertMultiplication(T(x64: X64(~1, ~2, ~3, ~4)), -T(x64: X64(0, 2, 0, 0)), T(x64: X64( 0,  4,  4,  6)), T(x64: X64( 8,  0,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X64(~1, ~2, ~3, ~4)), -T(x64: X64(0, 0, 2, 0)), T(x64: X64( 0,  0,  4,  4)), T(x64: X64( 6,  8,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X64(~1, ~2, ~3, ~4)), -T(x64: X64(0, 0, 0, 2)), T(x64: X64( 0,  0,  0,  4)), T(x64: X64( 4,  6,  8,  0)), true)
    }
    
    func testMultiplyingEdgesByEdgesReportingOverflow() {
        NBKAssertMultiplication(T.max, T.max,  T( 1), T(x64: X64(~0, ~0, ~0, ~0 >>  2)), true)
        NBKAssertMultiplication(T.max, T.min,  T.min, T(x64: X64( 0,  0,  0, ~0 << 62)), true)
        NBKAssertMultiplication(T.min, T.max,  T.min, T(x64: X64( 0,  0,  0, ~0 << 62)), true)
        NBKAssertMultiplication(T.min, T.min,  T(  ), T(x64: X64( 0,  0,  0,  1 << 62)), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit (and Self)
    //=------------------------------------------------------------------------=
    
    func testMultiplyingLargeBySmall() {
        NBKAssertMultiplicationByDigit( T(x64: X64( 1,  2,  3,  4)),  Int(0),  T(x64: X64(0, 0, 0, 0)))
        NBKAssertMultiplicationByDigit( T(x64: X64( 1,  2,  3,  4)), -Int(0), -T(x64: X64(0, 0, 0, 0)))
        NBKAssertMultiplicationByDigit(-T(x64: X64( 1,  2,  3,  4)),  Int(0), -T(x64: X64(0, 0, 0, 0)))
        NBKAssertMultiplicationByDigit(-T(x64: X64( 1,  2,  3,  4)), -Int(0),  T(x64: X64(0, 0, 0, 0)))
        
        NBKAssertMultiplicationByDigit( T(x64: X64( 1,  2,  3,  4)),  Int(1),  T(x64: X64(1, 2, 3, 4)))
        NBKAssertMultiplicationByDigit( T(x64: X64( 1,  2,  3,  4)), -Int(1), -T(x64: X64(1, 2, 3, 4)))
        NBKAssertMultiplicationByDigit(-T(x64: X64( 1,  2,  3,  4)),  Int(1), -T(x64: X64(1, 2, 3, 4)))
        NBKAssertMultiplicationByDigit(-T(x64: X64( 1,  2,  3,  4)), -Int(1),  T(x64: X64(1, 2, 3, 4)))
        
        NBKAssertMultiplicationByDigit( T(x64: X64( 1,  2,  3,  4)),  Int(2),  T(x64: X64(2, 4, 6, 8)))
        NBKAssertMultiplicationByDigit( T(x64: X64( 1,  2,  3,  4)), -Int(2), -T(x64: X64(2, 4, 6, 8)))
        NBKAssertMultiplicationByDigit(-T(x64: X64( 1,  2,  3,  4)),  Int(2), -T(x64: X64(2, 4, 6, 8)))
        NBKAssertMultiplicationByDigit(-T(x64: X64( 1,  2,  3,  4)), -Int(2),  T(x64: X64(2, 4, 6, 8)))
        
        NBKAssertMultiplicationByDigit( T(x64: X64( 1,  2,  3,  4)),  Int(2),  T(x64: X64( 2,  4,  6,  8)),  Int(0))
        NBKAssertMultiplicationByDigit( T(x64: X64( 1,  2,  3,  4)), -Int(2),  T(x64: X64(~1, ~4, ~6, ~8)), -Int(1))
        NBKAssertMultiplicationByDigit( T(x64: X64(~1, ~2, ~3, ~4)),  Int(2),  T(x64: X64(~3, ~4, ~6, ~8)), -Int(1))
        NBKAssertMultiplicationByDigit( T(x64: X64(~1, ~2, ~3, ~4)), -Int(2),  T(x64: X64( 4,  4,  6,  8)),  Int(0))
    }
    
    func testMultiplyingEdgesBySmallReportingOverflow() {
        NBKAssertMultiplicationByDigit(T(  ), Int(-1),  T(  ), Int(  ), false)
        NBKAssertMultiplicationByDigit(T(-1), Int(  ),  T(  ), Int(  ), false)
        
        NBKAssertMultiplicationByDigit(T.max, Int( 1),  T.max, Int(  ), false)
        NBKAssertMultiplicationByDigit(T.max, Int(-1), -T.max, Int(-1), false)
        NBKAssertMultiplicationByDigit(T.min, Int( 1),  T.min, Int(-1), false)
        NBKAssertMultiplicationByDigit(T.min, Int(-1),  T.min, Int(  ), true )
        
        NBKAssertMultiplicationByDigit(T.max, Int( 2),  T(-2), Int(  ), true )
        NBKAssertMultiplicationByDigit(T.max, Int(-2),  T( 2), Int(-1), true )
        NBKAssertMultiplicationByDigit(T.min, Int( 2),  T(  ), Int(-1), true )
        NBKAssertMultiplicationByDigit(T.min, Int(-2),  T(  ), Int( 1), true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  *= 0)
            XCTAssertNotNil(x &*= 0)
            XCTAssertNotNil(x.multiplyReportingOverflow(by: 0))
            XCTAssertNotNil(x.multiplyFullWidth(by: 0))
            
            XCTAssertNotNil(x  *  0)
            XCTAssertNotNil(x &*  0)
            XCTAssertNotNil(x.multipliedReportingOverflow(by: 0))
            XCTAssertNotNil(x.multipliedFullWidth(by: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Multiplication x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnMultiplicationAsUInt256: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplyingLargeByLarge() {
        NBKAssertMultiplication(T(x64: X64( 1,  2,  3,  4)),  T(x64: X64(2, 0, 0, 0)), T(x64: X64( 2,  4,  6,  8)), T(x64: X64( 0,  0,  0,  0)))
        NBKAssertMultiplication(T(x64: X64( 1,  2,  3,  4)),  T(x64: X64(0, 2, 0, 0)), T(x64: X64( 0,  2,  4,  6)), T(x64: X64( 8,  0,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X64( 1,  2,  3,  4)),  T(x64: X64(0, 0, 2, 0)), T(x64: X64( 0,  0,  2,  4)), T(x64: X64( 6,  8,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X64( 1,  2,  3,  4)),  T(x64: X64(0, 0, 0, 2)), T(x64: X64( 0,  0,  0,  2)), T(x64: X64( 4,  6,  8,  0)), true)
        
        NBKAssertMultiplication(T(x64: X64(~1, ~2, ~3, ~4)),  T(x64: X64(2, 0, 0, 0)), T(x64: X64(~3, ~4, ~6, ~8)), T(x64: X64( 1,  0,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X64(~1, ~2, ~3, ~4)),  T(x64: X64(0, 2, 0, 0)), T(x64: X64( 0, ~3, ~4, ~6)), T(x64: X64(~8,  1,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X64(~1, ~2, ~3, ~4)),  T(x64: X64(0, 0, 2, 0)), T(x64: X64( 0,  0, ~3, ~4)), T(x64: X64(~6, ~8,  1,  0)), true)
        NBKAssertMultiplication(T(x64: X64(~1, ~2, ~3, ~4)),  T(x64: X64(0, 0, 0, 2)), T(x64: X64( 0,  0,  0, ~3)), T(x64: X64(~4, ~6, ~8,  1)), true)
    }

    func testMultiplyingLargeByLargeReportingOverflow() {
        NBKAssertMultiplication(T.max, T( 2), ~T(1),  T(1), true)
        NBKAssertMultiplication(T.max, T.max,  T(1), ~T(1), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit (and Self)
    //=------------------------------------------------------------------------=
    
    func testMultiplyingLargeBySmall() {
        NBKAssertMultiplicationByDigit(T(x64: X64(1, 2, 3, 4)), UInt(0), T(x64: X64(0, 0, 0, 0)))
        NBKAssertMultiplicationByDigit(T(x64: X64(1, 2, 3, 4)), UInt(1), T(x64: X64(1, 2, 3, 4)))
        NBKAssertMultiplicationByDigit(T(x64: X64(1, 2, 3, 4)), UInt(2), T(x64: X64(2, 4, 6, 8)))
    }
    
    func testMultiplyingLargeBySmallReportingOverflow() {
        NBKAssertMultiplicationByDigit(T(x64: X64(~1, ~2, ~3, ~4)), UInt(2), T(x64: X64(~3, ~4, ~6, ~8)), UInt(1), true )
        NBKAssertMultiplicationByDigit(T(x64: X64( 1,  2,  3,  4)), UInt(2), T(x64: X64( 2,  4,  6,  8)), UInt(0), false)
    }
    
    func testMultiplyingEdgesBySmallReportingOverflow() {
        NBKAssertMultiplicationByDigit(T.min, UInt(2),  T(0), UInt(0), false)
        NBKAssertMultiplicationByDigit(T.max, UInt(2), ~T(1), UInt(1), true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit (and Self) x Addition
    //=------------------------------------------------------------------------=
    
    func testMultiplyingLargeBySmallWithAdditionReportingOverflow() {
        NBKAssertMultiplicationByDigitWithAddition(T(x64: X64(~0, ~0, ~0, ~0)),  0,  0, T(x64: X64( 0,  0,  0,  0)),  0, false)
        NBKAssertMultiplicationByDigitWithAddition(T(x64: X64(~0, ~0, ~0, ~0)),  0, ~0, T(x64: X64(~0,  0,  0,  0)),  0, false)
        NBKAssertMultiplicationByDigitWithAddition(T(x64: X64(~0, ~0, ~0, ~0)), ~0,  0, T(x64: X64( 1, ~0, ~0, ~0)), ~1, true )
        NBKAssertMultiplicationByDigitWithAddition(T(x64: X64(~0, ~0, ~0, ~0)), ~0, ~0, T(x64: X64( 0,  0,  0,  0)), ~0, true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  *= 0)
            XCTAssertNotNil(x &*= 0)
            XCTAssertNotNil(x.multiply(by: 0,  add: 0))
            XCTAssertNotNil(x.multiplyReportingOverflow(by: 0))
            XCTAssertNotNil(x.multiplyReportingOverflow(by: 0, add: 0))
            XCTAssertNotNil(x.multiplyFullWidth(by: 0))
            XCTAssertNotNil(x.multiplyFullWidth(by: 0, add: 0))
            
            XCTAssertNotNil(x  *  0)
            XCTAssertNotNil(x &*  0)
            XCTAssertNotNil(x.multiplied(by: 0, adding: 0))
            XCTAssertNotNil(x.multipliedReportingOverflow(by: 0))
            XCTAssertNotNil(x.multipliedReportingOverflow(by: 0, adding: 0))
            XCTAssertNotNil(x.multipliedFullWidth(by: 0))
            XCTAssertNotNil(x.multipliedFullWidth(by: 0, adding: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Multiplication x Assertions
//*============================================================================*

private func NBKAssertMultiplication<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  NBKDoubleWidth<H>,
_ low: NBKDoubleWidth<H>, _ high: NBKDoubleWidth<H>? = nil, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    let high = high ?? T(repeating: low.isLessThanZero)
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(                 lhs *  rhs,                 low, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs *= rhs; return lhs }(), low, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(                 lhs &*  rhs,                 low, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &*= rhs; return lhs }(), low, file: file, line: line)
        
    XCTAssertEqual(lhs.multipliedReportingOverflow(by: rhs).partialValue, low,      file: file, line: line)
    XCTAssertEqual(lhs.multipliedReportingOverflow(by: rhs).overflow,     overflow, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.multiplyReportingOverflow(by: rhs); return x }(), low,      file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.multiplyReportingOverflow(by: rhs); return o }(), overflow, file: file, line: line)
    
    XCTAssertEqual(T(bitPattern: lhs.multipliedFullWidth(by: rhs).low), low,  file: file, line: line)
    XCTAssertEqual(/*---------*/ lhs.multipliedFullWidth(by: rhs).high, high, file: file, line: line)

    XCTAssertEqual({ var x = lhs; let _ = x.multiplyFullWidth(by: rhs); return x }(), low,  file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.multiplyFullWidth(by: rhs); return o }(), high, file: file, line: line)
}

private func NBKAssertMultiplicationByDigit<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  NBKDoubleWidth<H>.Digit,
_ low: NBKDoubleWidth<H>, _ high: NBKDoubleWidth<H>.Digit? = nil, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    NBKAssertMultiplication(lhs, T(digit: rhs), low, high.map(T.init(digit:)), overflow, file: file, line: line)
    //=------------------------------------------=
    let high = high ?? T.Digit(repeating: low.isLessThanZero)
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(                 lhs *  rhs,                 low, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs *= rhs; return lhs }(), low, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(                 lhs &*  rhs,                 low, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &*= rhs; return lhs }(), low, file: file, line: line)
        
    XCTAssertEqual(lhs.multipliedReportingOverflow(by: rhs).partialValue, low,      file: file, line: line)
    XCTAssertEqual(lhs.multipliedReportingOverflow(by: rhs).overflow,     overflow, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.multiplyReportingOverflow(by: rhs); return x }(), low,      file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.multiplyReportingOverflow(by: rhs); return o }(), overflow, file: file, line: line)
    
    XCTAssertEqual(T(bitPattern: lhs.multipliedFullWidth(by: rhs).low), low,  file: file, line: line)
    XCTAssertEqual(/*---------*/ lhs.multipliedFullWidth(by: rhs).high, high, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.multiplyFullWidth(by: rhs); return x }(), low,  file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.multiplyFullWidth(by: rhs); return o }(), high, file: file, line: line)
}

private func NBKAssertMultiplicationByDigitWithAddition<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  UInt, _ carry: UInt,
_ low: NBKDoubleWidth<H>, _ high: UInt, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) where H == H.Magnitude {
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    if  carry.isZero {
        NBKAssertMultiplicationByDigit(lhs, rhs, low, high, overflow, file: file, line: line)
    }
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(lhs.multiplied(by: rhs, adding: carry), low, file: file, line: line)
        XCTAssertEqual({ var x = lhs; x.multiply(by: rhs, add: carry); return x }(), low, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs.multipliedReportingOverflow(by: rhs, adding: carry).partialValue, low,      file: file, line: line)
    XCTAssertEqual(lhs.multipliedReportingOverflow(by: rhs, adding: carry).overflow,     overflow, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.multiplyReportingOverflow(by: rhs, add: carry); return x }(), low,      file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.multiplyReportingOverflow(by: rhs, add: carry); return o }(), overflow, file: file, line: line)
    
    XCTAssertEqual(T(bitPattern: lhs.multipliedFullWidth(by: rhs, adding: carry).low), low,  file: file, line: line)
    XCTAssertEqual(/*---------*/ lhs.multipliedFullWidth(by: rhs, adding: carry).high, high, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.multiplyFullWidth(by: rhs, add: carry); return x }(), low,  file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.multiplyFullWidth(by: rhs, add: carry); return o }(), high, file: file, line: line)
}
