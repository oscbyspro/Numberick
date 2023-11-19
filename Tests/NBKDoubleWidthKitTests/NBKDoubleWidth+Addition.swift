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
// MARK: * NBK x Double Width x Addition x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnAdditionAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAddingLargeToLarge() {
        NBKAssertAddition(T(x64: X64(~0, ~0, ~0,  0)),  T(x64: X64(3, 0, 0, 0)), T(x64: X64( 2,  0,  0,  1)))
        NBKAssertAddition(T(x64: X64(~0, ~0, ~0,  0)),  T(x64: X64(0, 3, 0, 0)), T(x64: X64(~0,  2,  0,  1)))
        NBKAssertAddition(T(x64: X64(~0, ~0, ~0,  0)),  T(x64: X64(0, 0, 3, 0)), T(x64: X64(~0, ~0,  2,  1)))
        NBKAssertAddition(T(x64: X64(~0, ~0, ~0,  0)),  T(x64: X64(0, 0, 0, 3)), T(x64: X64(~0, ~0, ~0,  3)))
        
        NBKAssertAddition(T(x64: X64(~0, ~0, ~0,  0)), -T(x64: X64(3, 0, 0, 0)), T(x64: X64(~3, ~0, ~0,  0)))
        NBKAssertAddition(T(x64: X64(~0, ~0, ~0,  0)), -T(x64: X64(0, 3, 0, 0)), T(x64: X64(~0, ~3, ~0,  0)))
        NBKAssertAddition(T(x64: X64(~0, ~0, ~0,  0)), -T(x64: X64(0, 0, 3, 0)), T(x64: X64(~0, ~0, ~3,  0)))
        NBKAssertAddition(T(x64: X64(~0, ~0, ~0,  0)), -T(x64: X64(0, 0, 0, 3)), T(x64: X64(~0, ~0, ~0, ~2)))
        
        NBKAssertAddition(T(x64: X64( 0,  0,  0, ~0)),  T(x64: X64(3, 0, 0, 0)), T(x64: X64( 3,  0,  0, ~0)))
        NBKAssertAddition(T(x64: X64( 0,  0,  0, ~0)),  T(x64: X64(0, 3, 0, 0)), T(x64: X64( 0,  3,  0, ~0)))
        NBKAssertAddition(T(x64: X64( 0,  0,  0, ~0)),  T(x64: X64(0, 0, 3, 0)), T(x64: X64( 0,  0,  3, ~0)))
        NBKAssertAddition(T(x64: X64( 0,  0,  0, ~0)),  T(x64: X64(0, 0, 0, 3)), T(x64: X64( 0,  0,  0,  2)))
        
        NBKAssertAddition(T(x64: X64( 0,  0,  0, ~0)), -T(x64: X64(3, 0, 0, 0)), T(x64: X64(~2, ~0, ~0, ~1)))
        NBKAssertAddition(T(x64: X64( 0,  0,  0, ~0)), -T(x64: X64(0, 3, 0, 0)), T(x64: X64( 0, ~2, ~0, ~1)))
        NBKAssertAddition(T(x64: X64( 0,  0,  0, ~0)), -T(x64: X64(0, 0, 3, 0)), T(x64: X64( 0,  0, ~2, ~1)))
        NBKAssertAddition(T(x64: X64( 0,  0,  0, ~0)), -T(x64: X64(0, 0, 0, 3)), T(x64: X64( 0,  0,  0, ~3)))
    }
    
    func testAddingHalvesToHalvesReportingOverflow() {
        NBKAssertAddition(T(high: .max, low: .max), T(-1), T(high: .max, low: .max - 1)) // carry 1st
        NBKAssertAddition(T(high: .min, low: .max), T(-1), T(high: .min, low: .max - 1)) // carry 2nd
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit (and Self)
    //=------------------------------------------------------------------------=
    
    func testAddingSmallToSmall() {
        NBKAssertAdditionByDigit(T( 1), Int( 2), T( 3))
        NBKAssertAdditionByDigit(T( 1), Int( 1), T( 2))
        NBKAssertAdditionByDigit(T( 1), Int( 0), T( 1))
        NBKAssertAdditionByDigit(T( 1), Int(-1), T( 0))
        NBKAssertAdditionByDigit(T( 1), Int(-2), T(-1))
        
        NBKAssertAdditionByDigit(T( 0), Int( 2), T( 2))
        NBKAssertAdditionByDigit(T( 0), Int( 1), T( 1))
        NBKAssertAdditionByDigit(T( 0), Int( 0), T( 0))
        NBKAssertAdditionByDigit(T( 0), Int(-1), T(-1))
        NBKAssertAdditionByDigit(T( 0), Int(-2), T(-2))
        
        NBKAssertAdditionByDigit(T(-1), Int( 2), T( 1))
        NBKAssertAdditionByDigit(T(-1), Int( 1), T( 0))
        NBKAssertAdditionByDigit(T(-1), Int( 0), T(-1))
        NBKAssertAdditionByDigit(T(-1), Int(-1), T(-2))
        NBKAssertAdditionByDigit(T(-1), Int(-2), T(-3))
    }
    
    func testAddingSmallToLarge() {
        NBKAssertAdditionByDigit(T(x64: X64(~0, ~0, ~0,  0)),  Int(3), T(x64: X64( 2,  0,  0,  1)))
        NBKAssertAdditionByDigit(T(x64: X64(~0, ~0, ~0,  0)), -Int(3), T(x64: X64(~3, ~0, ~0,  0)))
        NBKAssertAdditionByDigit(T(x64: X64( 0,  0,  0, ~0)),  Int(3), T(x64: X64( 3,  0,  0, ~0)))
        NBKAssertAdditionByDigit(T(x64: X64( 0,  0,  0, ~0)), -Int(3), T(x64: X64(~2, ~0, ~0, ~1)))
    }
    
    func testAddingSmallToEdgesReportingOverflow() {
        NBKAssertAdditionByDigit(T.min, Int( 1), T.min + T(1))
        NBKAssertAdditionByDigit(T.min, Int(-1), T.max,  true)
        NBKAssertAdditionByDigit(T.max, Int( 1), T.min,  true)
        NBKAssertAdditionByDigit(T.max, Int(-1), T.max - T(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  += 0)
            XCTAssertNotNil(x &+= 0)
            XCTAssertNotNil(x.addReportingOverflow(0))
            
            XCTAssertNotNil(x  +  0)
            XCTAssertNotNil(x &+  0)
            XCTAssertNotNil(x.addingReportingOverflow(0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Addition x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnAdditionAsUInt256: XCTestCase {

    typealias T = UInt256

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testAddingLargeToLarge() {
        NBKAssertAddition(T(x64: X64(~0, ~0, ~0,  0)), T(x64: X64(3, 0, 0, 0)), T(x64: X64( 2,  0,  0,  1)))
        NBKAssertAddition(T(x64: X64(~0, ~0, ~0,  0)), T(x64: X64(0, 3, 0, 0)), T(x64: X64(~0,  2,  0,  1)))
        NBKAssertAddition(T(x64: X64(~0, ~0, ~0,  0)), T(x64: X64(0, 0, 3, 0)), T(x64: X64(~0, ~0,  2,  1)))
        NBKAssertAddition(T(x64: X64(~0, ~0, ~0,  0)), T(x64: X64(0, 0, 0, 3)), T(x64: X64(~0, ~0, ~0,  3)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit (and Self)
    //=------------------------------------------------------------------------=

    func testAddingSmallToSmall() {
        NBKAssertAdditionByDigit(T(0), UInt(0), T(0))
        NBKAssertAdditionByDigit(T(0), UInt(1), T(1))
        NBKAssertAdditionByDigit(T(0), UInt(2), T(2))
        
        NBKAssertAdditionByDigit(T(1), UInt(0), T(1))
        NBKAssertAdditionByDigit(T(1), UInt(1), T(2))
        NBKAssertAdditionByDigit(T(1), UInt(2), T(3))
    }
    
    func testAddingSmallToLarge() {
        NBKAssertAdditionByDigit(T(x64: X64( 0,  0,  0,  0)), UInt(3), T(x64: X64(3, 0, 0, 0)))
        NBKAssertAdditionByDigit(T(x64: X64(~0,  0,  0,  0)), UInt(3), T(x64: X64(2, 1, 0, 0)))
        NBKAssertAdditionByDigit(T(x64: X64(~0, ~0,  0,  0)), UInt(3), T(x64: X64(2, 0, 1, 0)))
        NBKAssertAdditionByDigit(T(x64: X64(~0, ~0, ~0,  0)), UInt(3), T(x64: X64(2, 0, 0, 1)))
    }
    
    func testAddingSmallToEdgesReportingOverflow() {
        NBKAssertAdditionByDigit(T.min, UInt(1), T.min + T(1))
        NBKAssertAdditionByDigit(T.max, UInt(1), T.min,  true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  += 0)
            XCTAssertNotNil(x &+= 0)
            XCTAssertNotNil(x.addReportingOverflow(0))
            
            XCTAssertNotNil(x  +  0)
            XCTAssertNotNil(x &+  0)
            XCTAssertNotNil(x.addingReportingOverflow(0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Addition x Assertions
//*============================================================================*

private func NBKAssertAddition<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>,
_ partialValue: NBKDoubleWidth<H>, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(                 lhs +  rhs,                 partialValue, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs += rhs; return lhs }(), partialValue, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(                 lhs &+  rhs,                  partialValue, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &+= rhs; return lhs }(),  partialValue, file: file, line: line)
        
    XCTAssertEqual(lhs.addingReportingOverflow(rhs).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(lhs.addingReportingOverflow(rhs).overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.addReportingOverflow(rhs); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.addReportingOverflow(rhs); return o }(), overflow,     file: file, line: line)
}

private func NBKAssertAdditionByDigit<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>.Digit,
_ partialValue: NBKDoubleWidth<H>, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertAddition(lhs, NBKDoubleWidth<H>(digit: rhs), partialValue, overflow, file: file, line: line)
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(                 lhs +  rhs,                 partialValue, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs += rhs; return lhs }(), partialValue, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(                 lhs &+  rhs,                  partialValue, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &+= rhs; return lhs }(),  partialValue, file: file, line: line)
        
    XCTAssertEqual(lhs.addingReportingOverflow(rhs).partialValue, partialValue, file: file, line: line)
    XCTAssertEqual(lhs.addingReportingOverflow(rhs).overflow,     overflow,     file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.addReportingOverflow(rhs); return x }(), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.addReportingOverflow(rhs); return o }(), overflow,     file: file, line: line)
}
