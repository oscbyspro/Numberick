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
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Multiplication x Int256
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
final class NBKDoubleWidthTestsOnMultiplicationAsInt256: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplying() {
        NBKAssertMultiplication( T(x64: X(1, 2, 3, 4)),  T(0),  T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplication( T(x64: X(1, 2, 3, 4)), -T(0), -T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplication(-T(x64: X(1, 2, 3, 4)),  T(0), -T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplication(-T(x64: X(1, 2, 3, 4)), -T(0),  T(x64: X(0, 0, 0, 0)))
        
        NBKAssertMultiplication( T(x64: X(1, 2, 3, 4)),  T(1),  T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplication( T(x64: X(1, 2, 3, 4)), -T(1), -T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplication(-T(x64: X(1, 2, 3, 4)),  T(1), -T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplication(-T(x64: X(1, 2, 3, 4)), -T(1),  T(x64: X(1, 2, 3, 4)))
        
        NBKAssertMultiplication( T(x64: X(1, 2, 3, 4)),  T(2),  T(x64: X(2, 4, 6, 8)))
        NBKAssertMultiplication( T(x64: X(1, 2, 3, 4)), -T(2), -T(x64: X(2, 4, 6, 8)))
        NBKAssertMultiplication(-T(x64: X(1, 2, 3, 4)),  T(2), -T(x64: X(2, 4, 6, 8)))
        NBKAssertMultiplication(-T(x64: X(1, 2, 3, 4)), -T(2),  T(x64: X(2, 4, 6, 8)))
    }
    
    func testMultiplyingUsingLargeValues() {
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(2, 0, 0, 0)), T(x64: X( 2,  4,  6,  8)), T(x64: X( 0,  0,  0,  0)))
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(0, 2, 0, 0)), T(x64: X( 0,  2,  4,  6)), T(x64: X( 8,  0,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(0, 0, 2, 0)), T(x64: X( 0,  0,  2,  4)), T(x64: X( 6,  8,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(0, 0, 0, 2)), T(x64: X( 0,  0,  0,  2)), T(x64: X( 4,  6,  8,  0)), true)
        
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)), -T(x64: X(2, 0, 0, 0)), T(x64: X(~1, ~4, ~6, ~8)), T(x64: X(~0, ~0, ~0, ~0)))
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)), -T(x64: X(0, 2, 0, 0)), T(x64: X( 0, ~1, ~4, ~6)), T(x64: X(~8, ~0, ~0, ~0)), true)
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)), -T(x64: X(0, 0, 2, 0)), T(x64: X( 0,  0, ~1, ~4)), T(x64: X(~6, ~8, ~0, ~0)), true)
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)), -T(x64: X(0, 0, 0, 2)), T(x64: X( 0,  0,  0, ~1)), T(x64: X(~4, ~6, ~8, ~0)), true)
        
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(2, 0, 0, 0)), T(x64: X(~3, ~4, ~6, ~8)), T(x64: X(~0, ~0, ~0, ~0)))
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(0, 2, 0, 0)), T(x64: X( 0, ~3, ~4, ~6)), T(x64: X(~8, ~0, ~0, ~0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(0, 0, 2, 0)), T(x64: X( 0,  0, ~3, ~4)), T(x64: X(~6, ~8, ~0, ~0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(0, 0, 0, 2)), T(x64: X( 0,  0,  0, ~3)), T(x64: X(~4, ~6, ~8, ~0)), true)
        
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)), -T(x64: X(2, 0, 0, 0)), T(x64: X( 4,  4,  6,  8)), T(x64: X( 0,  0,  0,  0)))
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)), -T(x64: X(0, 2, 0, 0)), T(x64: X( 0,  4,  4,  6)), T(x64: X( 8,  0,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)), -T(x64: X(0, 0, 2, 0)), T(x64: X( 0,  0,  4,  4)), T(x64: X( 6,  8,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)), -T(x64: X(0, 0, 0, 2)), T(x64: X( 0,  0,  0,  4)), T(x64: X( 4,  6,  8,  0)), true)
    }
    
    func testMultiplyingReportingOverflow() {
        NBKAssertMultiplication(T(  ), T(-1),  T(  ), T(  ), false)
        NBKAssertMultiplication(T(-1), T(  ),  T(  ), T(  ), false)
        
        NBKAssertMultiplication(T.max, T( 1),  T.max, T(  ), false)
        NBKAssertMultiplication(T.max, T(-1), -T.max, T(-1), false)
        NBKAssertMultiplication(T.min, T( 1),  T.min, T(-1), false)
        NBKAssertMultiplication(T.min, T(-1),  T.min, T(  ), true )
        
        NBKAssertMultiplication(T.max, T( 2),  T(-2), T(  ), true )
        NBKAssertMultiplication(T.max, T(-2),  T( 2), T(-1), true )
        NBKAssertMultiplication(T.min, T( 2),  T(  ), T(-1), true )
        NBKAssertMultiplication(T.min, T(-2),  T(  ), T( 1), true )
        
        NBKAssertMultiplication(T.max, T.max,  T( 1), T(x64: X(~0, ~0, ~0, ~0 >>  2)), true)
        NBKAssertMultiplication(T.max, T.min,  T.min, T(x64: X( 0,  0,  0, ~0 << 62)), true)
        NBKAssertMultiplication(T.min, T.max,  T.min, T(x64: X( 0,  0,  0, ~0 << 62)), true)
        NBKAssertMultiplication(T.min, T.min,  T(  ), T(x64: X( 0,  0,  0,  1 << 62)), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testMultiplyingByDigit() {
        NBKAssertMultiplicationByDigit( T(x64: X(1, 2, 3, 4)),  Int(0),  T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplicationByDigit( T(x64: X(1, 2, 3, 4)), -Int(0), -T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplicationByDigit(-T(x64: X(1, 2, 3, 4)),  Int(0), -T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplicationByDigit(-T(x64: X(1, 2, 3, 4)), -Int(0),  T(x64: X(0, 0, 0, 0)))
        
        NBKAssertMultiplicationByDigit( T(x64: X(1, 2, 3, 4)),  Int(1),  T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplicationByDigit( T(x64: X(1, 2, 3, 4)), -Int(1), -T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplicationByDigit(-T(x64: X(1, 2, 3, 4)),  Int(1), -T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplicationByDigit(-T(x64: X(1, 2, 3, 4)), -Int(1),  T(x64: X(1, 2, 3, 4)))
        
        NBKAssertMultiplicationByDigit( T(x64: X(1, 2, 3, 4)),  Int(2),  T(x64: X(2, 4, 6, 8)))
        NBKAssertMultiplicationByDigit( T(x64: X(1, 2, 3, 4)), -Int(2), -T(x64: X(2, 4, 6, 8)))
        NBKAssertMultiplicationByDigit(-T(x64: X(1, 2, 3, 4)),  Int(2), -T(x64: X(2, 4, 6, 8)))
        NBKAssertMultiplicationByDigit(-T(x64: X(1, 2, 3, 4)), -Int(2),  T(x64: X(2, 4, 6, 8)))
    }
    
    func testMultiplyingByDigitUsingLargeValues() {
        NBKAssertMultiplicationByDigit(T(x64: X( 1,  2,  3,  4)),  Int(2), T(x64: X( 2,  4,  6,  8)),  Int(0))
        NBKAssertMultiplicationByDigit(T(x64: X( 1,  2,  3,  4)), -Int(2), T(x64: X(~1, ~4, ~6, ~8)), -Int(1))
        NBKAssertMultiplicationByDigit(T(x64: X(~1, ~2, ~3, ~4)),  Int(2), T(x64: X(~3, ~4, ~6, ~8)), -Int(1))
        NBKAssertMultiplicationByDigit(T(x64: X(~1, ~2, ~3, ~4)), -Int(2), T(x64: X( 4,  4,  6,  8)),  Int(0))
    }
    
    func testMultiplyingByDigitReportingOverflow() {
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

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
final class NBKDoubleWidthTestsOnMultiplicationAsUInt256: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplying() {
        NBKAssertMultiplication(T(x64: X(1, 2, 3, 4)), T(0), T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplication(T(x64: X(1, 2, 3, 4)), T(1), T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplication(T(x64: X(1, 2, 3, 4)), T(2), T(x64: X(2, 4, 6, 8)))
    }
    
    func testMultiplyingUsingLargeValues() {
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(2, 0, 0, 0)), T(x64: X( 2,  4,  6,  8)), T(x64: X( 0,  0,  0,  0)))
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(0, 2, 0, 0)), T(x64: X( 0,  2,  4,  6)), T(x64: X( 8,  0,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(0, 0, 2, 0)), T(x64: X( 0,  0,  2,  4)), T(x64: X( 6,  8,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(0, 0, 0, 2)), T(x64: X( 0,  0,  0,  2)), T(x64: X( 4,  6,  8,  0)), true)
        
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(2, 0, 0, 0)), T(x64: X(~3, ~4, ~6, ~8)), T(x64: X( 1,  0,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(0, 2, 0, 0)), T(x64: X( 0, ~3, ~4, ~6)), T(x64: X(~8,  1,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(0, 0, 2, 0)), T(x64: X( 0,  0, ~3, ~4)), T(x64: X(~6, ~8,  1,  0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(0, 0, 0, 2)), T(x64: X( 0,  0,  0, ~3)), T(x64: X(~4, ~6, ~8,  1)), true)
    }

    func testMultiplyingReportingOverflow() {
        NBKAssertMultiplication(T.max, T( 2), ~T(1),  T(1), true)
        NBKAssertMultiplication(T.max, T.max,  T(1), ~T(1), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testMultipliedByDigit() {
        NBKAssertMultiplicationByDigit(T(x64: X(1, 2, 3, 4)), UInt(0), T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplicationByDigit(T(x64: X(1, 2, 3, 4)), UInt(1), T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplicationByDigit(T(x64: X(1, 2, 3, 4)), UInt(2), T(x64: X(2, 4, 6, 8)))
    }
    
    func testMultiplyingByDigitUsingLargeValues() {
        NBKAssertMultiplicationByDigit(T(x64: X(~1, ~2, ~3, ~4)), UInt(2), T(x64: X(~3, ~4, ~6, ~8)), UInt(1), true )
        NBKAssertMultiplicationByDigit(T(x64: X( 1,  2,  3,  4)), UInt(2), T(x64: X( 2,  4,  6,  8)), UInt(0), false)
    }
    
    func testMultipliedByDigitReportingOverflow() {
        NBKAssertMultiplicationByDigit(T.min, UInt(2),  T(0), UInt(0), false)
        NBKAssertMultiplicationByDigit(T.max, UInt(2), ~T(1), UInt(1), true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit x Addition
    //=------------------------------------------------------------------------=
    
    func testMultiplicationByDigitWithAddition() {
        NBKAssertMultiplicationByDigitWithAddition(T(x64: X(~0, ~0, ~0, ~0)),  0,  0, T(x64: X( 0,  0,  0,  0)),  0, false)
        NBKAssertMultiplicationByDigitWithAddition(T(x64: X(~0, ~0, ~0, ~0)),  0, ~0, T(x64: X(~0,  0,  0,  0)),  0, false)
        NBKAssertMultiplicationByDigitWithAddition(T(x64: X(~0, ~0, ~0, ~0)), ~0,  0, T(x64: X( 1, ~0, ~0, ~0)), ~1, true )
        NBKAssertMultiplicationByDigitWithAddition(T(x64: X(~0, ~0, ~0, ~0)), ~0, ~0, T(x64: X( 0,  0,  0,  0)), ~0, true )
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

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
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

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
private func NBKAssertMultiplicationByDigit<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  NBKDoubleWidth<H>.Digit,
_ low: NBKDoubleWidth<H>, _ high: NBKDoubleWidth<H>.Digit? = nil, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKDoubleWidth<H>
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

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
private func NBKAssertMultiplicationByDigitWithAddition<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  UInt, _ carry: UInt,
_ low: NBKDoubleWidth<H>, _ high: UInt, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) where H == H.Magnitude {
    typealias T = NBKDoubleWidth<H>
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

#endif
