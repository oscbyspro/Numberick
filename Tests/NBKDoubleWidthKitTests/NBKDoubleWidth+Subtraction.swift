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
// MARK: * NBK x Double Width x Subtraction x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnSubtractionAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
        NBKAssertSubtraction(T( 1), T( 2), T(-1))
        NBKAssertSubtraction(T( 1), T( 1), T( 0))
        NBKAssertSubtraction(T( 1), T( 0), T( 1))
        NBKAssertSubtraction(T( 1), T(-1), T( 2))
        NBKAssertSubtraction(T( 1), T(-2), T( 3))
        
        NBKAssertSubtraction(T( 0), T( 2), T(-2))
        NBKAssertSubtraction(T( 0), T( 1), T(-1))
        NBKAssertSubtraction(T( 0), T( 0), T( 0))
        NBKAssertSubtraction(T( 0), T(-1), T( 1))
        NBKAssertSubtraction(T( 0), T(-2), T( 2))
        
        NBKAssertSubtraction(T(-1), T( 2), T(-3))
        NBKAssertSubtraction(T(-1), T( 1), T(-2))
        NBKAssertSubtraction(T(-1), T( 0), T(-1))
        NBKAssertSubtraction(T(-1), T(-1), T( 0))
        NBKAssertSubtraction(T(-1), T(-2), T( 1))
    }
    
    func testSubtractingUsingLargeValues() {
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)), -T(x64: X(3, 0, 0, 0)), T(x64: X( 2,  0,  0,  1)))
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)), -T(x64: X(0, 3, 0, 0)), T(x64: X(~0,  2,  0,  1)))
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)), -T(x64: X(0, 0, 3, 0)), T(x64: X(~0, ~0,  2,  1)))
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)), -T(x64: X(0, 0, 0, 3)), T(x64: X(~0, ~0, ~0,  3)))
        
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)),  T(x64: X(3, 0, 0, 0)), T(x64: X(~3, ~0, ~0,  0)))
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)),  T(x64: X(0, 3, 0, 0)), T(x64: X(~0, ~3, ~0,  0)))
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)),  T(x64: X(0, 0, 3, 0)), T(x64: X(~0, ~0, ~3,  0)))
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)),  T(x64: X(0, 0, 0, 3)), T(x64: X(~0, ~0, ~0, ~2)))
        
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)), -T(x64: X(3, 0, 0, 0)), T(x64: X( 3,  0,  0, ~0)))
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)), -T(x64: X(0, 3, 0, 0)), T(x64: X( 0,  3,  0, ~0)))
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)), -T(x64: X(0, 0, 3, 0)), T(x64: X( 0,  0,  3, ~0)))
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)), -T(x64: X(0, 0, 0, 3)), T(x64: X( 0,  0,  0,  2)))
        
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)),  T(x64: X(3, 0, 0, 0)), T(x64: X(~2, ~0, ~0, ~1)))
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)),  T(x64: X(0, 3, 0, 0)), T(x64: X( 0, ~2, ~0, ~1)))
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)),  T(x64: X(0, 0, 3, 0)), T(x64: X( 0,  0, ~2, ~1)))
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)),  T(x64: X(0, 0, 0, 3)), T(x64: X( 0,  0,  0, ~3)))
    }
    
    func testSubtractingReportingOverflow() {
        NBKAssertSubtraction(T.min, T( 2), T.max - T(1), true )
        NBKAssertSubtraction(T.max, T( 2), T.max - T(2), false)
        
        NBKAssertSubtraction(T.min, T(-2), T.min + T(2), false)
        NBKAssertSubtraction(T.max, T(-2), T.min + T(1), true )
        
        NBKAssertSubtraction(T(high: .min, low: .min), T(-1), T(high: .min, low: .min + 1)) // carry 1st
        NBKAssertSubtraction(T(high: .max, low: .min), T(-1), T(high: .max, low: .min + 1)) // carry 2nd
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigit() {
        NBKAssertSubtractionByDigit(T( 1), Int( 2), T(-1))
        NBKAssertSubtractionByDigit(T( 1), Int( 1), T( 0))
        NBKAssertSubtractionByDigit(T( 1), Int( 0), T( 1))
        NBKAssertSubtractionByDigit(T( 1), Int(-1), T( 2))
        NBKAssertSubtractionByDigit(T( 1), Int(-2), T( 3))
        
        NBKAssertSubtractionByDigit(T( 0), Int( 2), T(-2))
        NBKAssertSubtractionByDigit(T( 0), Int( 1), T(-1))
        NBKAssertSubtractionByDigit(T( 0), Int( 0), T( 0))
        NBKAssertSubtractionByDigit(T( 0), Int(-1), T( 1))
        NBKAssertSubtractionByDigit(T( 0), Int(-2), T( 2))
        
        NBKAssertSubtractionByDigit(T(-1), Int( 2), T(-3))
        NBKAssertSubtractionByDigit(T(-1), Int( 1), T(-2))
        NBKAssertSubtractionByDigit(T(-1), Int( 0), T(-1))
        NBKAssertSubtractionByDigit(T(-1), Int(-1), T( 0))
        NBKAssertSubtractionByDigit(T(-1), Int(-2), T( 1))
    }
    
    func testSubtractingDigitUsingLargeValues() {
        NBKAssertSubtractionByDigit(T(x64: X(~0, ~0, ~0,  0)), -Int(3), T(x64: X( 2,  0,  0,  1)))
        NBKAssertSubtractionByDigit(T(x64: X(~0, ~0, ~0,  0)),  Int(3), T(x64: X(~3, ~0, ~0,  0)))
        NBKAssertSubtractionByDigit(T(x64: X( 0,  0,  0, ~0)), -Int(3), T(x64: X( 3,  0,  0, ~0)))
        NBKAssertSubtractionByDigit(T(x64: X( 0,  0,  0, ~0)),  Int(3), T(x64: X(~2, ~0, ~0, ~1)))
    }
    
    func testSubtractingDigitReportingOverflow() {
        NBKAssertSubtractionByDigit(T.min, Int( 2), T.max - T(1), true )
        NBKAssertSubtractionByDigit(T.min, Int(-2), T.min + T(2), false)
        NBKAssertSubtractionByDigit(T.max, Int( 2), T.max - T(2), false)
        NBKAssertSubtractionByDigit(T.max, Int(-2), T.min + T(1), true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  -= 0)
            XCTAssertNotNil(x &-= 0)
            XCTAssertNotNil(x.subtractReportingOverflow(0))
            
            XCTAssertNotNil(x  -  0)
            XCTAssertNotNil(x &-  0)
            XCTAssertNotNil(x.subtractingReportingOverflow(0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Subtraction x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnSubtractionAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
        NBKAssertSubtraction(T(3), T(0), T(3))
        NBKAssertSubtraction(T(3), T(1), T(2))
        NBKAssertSubtraction(T(3), T(2), T(1))
        NBKAssertSubtraction(T(3), T(3), T(0))
    }
    
    func testSubtractingUsingLargeValues() {
        NBKAssertSubtraction(T(x64: X(0, ~0, ~0, ~0)), T(x64: X(3, 0, 0, 0)), T(x64: X(~2, ~1, ~0, ~0)))
        NBKAssertSubtraction(T(x64: X(0, ~0, ~0, ~0)), T(x64: X(0, 3, 0, 0)), T(x64: X( 0, ~3, ~0, ~0)))
        NBKAssertSubtraction(T(x64: X(0, ~0, ~0, ~0)), T(x64: X(0, 0, 3, 0)), T(x64: X( 0, ~0, ~3, ~0)))
        NBKAssertSubtraction(T(x64: X(0, ~0, ~0, ~0)), T(x64: X(0, 0, 0, 3)), T(x64: X( 0, ~0, ~0, ~3)))
    }
    
    func testSubtractingReportingOverflow() {
        NBKAssertSubtraction(T.min, T(2), T.max - T(1), true )
        NBKAssertSubtraction(T.max, T(2), T.max - T(2), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigit() {
        NBKAssertSubtractionByDigit(T(3), UInt(0), T(3))
        NBKAssertSubtractionByDigit(T(3), UInt(1), T(2))
        NBKAssertSubtractionByDigit(T(3), UInt(2), T(1))
        NBKAssertSubtractionByDigit(T(3), UInt(3), T(0))
    }
    
    func testSubtractingDigitUsingLargeValues() {
        NBKAssertSubtractionByDigit(T(x64: X(~0, ~0, ~0, ~0)), UInt(3), T(x64: X(~3, ~0, ~0, ~0)))
        NBKAssertSubtractionByDigit(T(x64: X( 0, ~0, ~0, ~0)), UInt(3), T(x64: X(~2, ~1, ~0, ~0)))
        NBKAssertSubtractionByDigit(T(x64: X( 0,  0, ~0, ~0)), UInt(3), T(x64: X(~2, ~0, ~1, ~0)))
        NBKAssertSubtractionByDigit(T(x64: X( 0,  0,  0, ~0)), UInt(3), T(x64: X(~2, ~0, ~0, ~1)))
    }
    
    func testSubtractingDigitReportingOverflow() {
        NBKAssertSubtractionByDigit(T.min, UInt(2), T.max - T(1), true )
        NBKAssertSubtractionByDigit(T.max, UInt(2), T.max - T(2), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  -= 0)
            XCTAssertNotNil(x &-= 0)
            XCTAssertNotNil(x.subtractReportingOverflow(0))
            
            XCTAssertNotNil(x  -  0)
            XCTAssertNotNil(x &-  0)
            XCTAssertNotNil(x.subtractingReportingOverflow(0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Subtraction x Assertions
//*============================================================================*

private func NBKAssertSubtraction<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>,
_ partialValue: NBKDoubleWidth<H>, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(                 lhs -  rhs,                 partialValue, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs -= rhs; return lhs }(), partialValue, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(                 lhs &-  rhs,                  partialValue, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &-= rhs; return lhs }(),  partialValue, file: file, line: line)
        
    XCTAssertEqual(lhs.subtractingReportingOverflow(rhs).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(lhs.subtractingReportingOverflow(rhs).overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.subtractReportingOverflow(rhs); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.subtractReportingOverflow(rhs); return o }(), overflow,     file: file, line: line)
}

private func NBKAssertSubtractionByDigit<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>.Digit,
_ partialValue: NBKDoubleWidth<H>, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(                 lhs -  rhs,                 partialValue, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs -= rhs; return lhs }(), partialValue, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(                 lhs &-  rhs,                 partialValue, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &-= rhs; return lhs }(), partialValue, file: file, line: line)
        
    XCTAssertEqual(lhs.subtractingReportingOverflow(rhs).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(lhs.subtractingReportingOverflow(rhs).overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.subtractReportingOverflow(rhs); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.subtractReportingOverflow(rhs); return o }(), overflow,     file: file, line: line)
}

#endif
