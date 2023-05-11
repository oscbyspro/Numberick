//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * Int256 x Division
//*============================================================================*

final class Int256TestsOnDivision: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividing() {
        NBKAssertDivision( T(0),  T(1),  T(0),  T(0))
        NBKAssertDivision( T(0),  T(2),  T(0),  T(0))
        NBKAssertDivision( T(7),  T(1),  T(7),  T(0))
        NBKAssertDivision( T(7),  T(2),  T(3),  T(1))
                
        NBKAssertDivision( T(7),  T(3),  T(2),  T(1))
        NBKAssertDivision( T(7), -T(3), -T(2),  T(1))
        NBKAssertDivision(-T(7),  T(3), -T(2), -T(1))
        NBKAssertDivision(-T(7), -T(3),  T(2), -T(1))
    }
    
    func testDividingUsingLargeValues() {
        NBKAssertDivision( T(x64: X(1, 2, 3, 4)),  T(2),  T(x64: X(0, ~0/2 + 2, 1, 2)),  T(1))
        NBKAssertDivision( T(x64: X(1, 2, 3, 4)), -T(2), -T(x64: X(0, ~0/2 + 2, 1, 2)),  T(1))
        NBKAssertDivision(-T(x64: X(1, 2, 3, 4)),  T(2), -T(x64: X(0, ~0/2 + 2, 1, 2)), -T(1))
        NBKAssertDivision(-T(x64: X(1, 2, 3, 4)), -T(2),  T(x64: X(0, ~0/2 + 2, 1, 2)), -T(1))
    }
    
    func testDividingReportingOverflow() {
        NBKAssertDivision(T( 0),  T(0), T( 0), T(0), true)
        NBKAssertDivision(T( 1),  T(0), T( 1), T(1), true)
        NBKAssertDivision(T( 2),  T(0), T( 2), T(2), true)
        NBKAssertDivision(T.min, -T(1), T.min, T(0), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Full Width
    //=------------------------------------------------------------------------=
    
    func testDividingFullWidth() {
        var x: (high: T, low: M)
        //=--------------------------------------=
        x.low  = M(x64: X( 6, 17, 35, 61))
        x.high = T(x64: X(61, 52, 32,  0))
        
        NBKAssertDivisionFullWidth(x, T(x64: X( 1,  2,  3,  4)), T(x64: X( 5,  6,  7,  8)), T(x64: X( 1,  1,  1,  1)))
        NBKAssertDivisionFullWidth(x, T(x64: X( 5,  6,  7,  8)), T(x64: X( 1,  2,  3,  4)), T(x64: X( 1,  1,  1,  1)))
        //=--------------------------------------=
        x.low  = M(x64: X(34, 54, 63, 62))
        x.high = T(x64: X(34, 16,  5,  0))
        
        NBKAssertDivisionFullWidth(x, T(x64: X( 4,  3,  2,  1)), T(x64: X( 9,  7,  6,  5)), T(x64: X(~1, ~1, ~0,  0)))
        NBKAssertDivisionFullWidth(x, T(x64: X( 8,  7,  6,  5)), T(x64: X( 4,  3,  2,  1)), T(x64: X( 2,  2,  2,  2)))
        //=--------------------------------------=
        x.low  = M(x64: X(~1, ~0, ~0, ~0))
        x.high = T(x64: X(~0, ~0, ~0, ~0))
        
        NBKAssertDivisionFullWidth(x, T(x64: X( 1,  0,  0,  0)), T(x64: X(~1, ~0, ~0, ~0)), T(x64: X( 0,  0,  0,  0)))
        NBKAssertDivisionFullWidth(x, T(x64: X(~0, ~0, ~0, ~0)), T(x64: X( 2,  0,  0,  0)), T(x64: X( 0,  0,  0,  0)))
    }
    
    func testDividingFullWidthTruncatesQuotient() {
        var x: (high: T, low: M)
        //=--------------------------------------=
        x.low  = M(x64: X( 0,  0,  0,  0))
        x.high = T(x64: X(~0, ~0, ~0, ~0))
        
        NBKAssertDivisionFullWidth(x, T(1), ~T(0) << (T.bitWidth - 0), T(0))
        NBKAssertDivisionFullWidth(x, T(2), ~T(0) << (T.bitWidth - 1), T(0))
        NBKAssertDivisionFullWidth(x, T(4), ~T(0) << (T.bitWidth - 2), T(0))
        NBKAssertDivisionFullWidth(x, T(8), ~T(0) << (T.bitWidth - 3), T(0))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x /= 0)
            XCTAssertNotNil(x %= 0)
            XCTAssertNotNil(x.divideReportingOverflow(by: 0))
            XCTAssertNotNil(x.formRemainderReportingOverflow(dividingBy: 0))
            
            XCTAssertNotNil(x /  0)
            XCTAssertNotNil(x %  0)
            XCTAssertNotNil(x.dividedReportingOverflow(by: 0))
            XCTAssertNotNil(x.remainderReportingOverflow(dividingBy: 0))
            XCTAssertNotNil(x.quotientAndRemainder(dividingBy: 0))
            XCTAssertNotNil(x.quotientAndRemainderReportingOverflow(dividingBy: 0))
            XCTAssertNotNil(x.dividingFullWidth((0, 0)))
        }
    }
}

//*============================================================================*
// MARK: * UInt256 x Division
//*============================================================================*

final class UInt256TestsOnDivision: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividing() {
        NBKAssertDivision(T(0), T(1), T(0), T(0))
        NBKAssertDivision(T(0), T(2), T(0), T(0))
        NBKAssertDivision(T(7), T(1), T(7), T(0))
        NBKAssertDivision(T(7), T(2), T(3), T(1))
    }
    
    func testDividingUsingLargeValues() {
        NBKAssertDivision(T(x64: X(~2,  ~4,  ~6,  9)), T(2), T(x64: X(~1, ~2, ~3, 4)), T(1))
        NBKAssertDivision(T(x64: X(~3,  ~6,  ~9, 14)), T(3), T(x64: X(~1, ~2, ~3, 4)), T(2))
        NBKAssertDivision(T(x64: X(~4,  ~8, ~12, 19)), T(4), T(x64: X(~1, ~2, ~3, 4)), T(3))
        NBKAssertDivision(T(x64: X(~5, ~10, ~15, 24)), T(5), T(x64: X(~1, ~2, ~3, 4)), T(4))
    }
    
    func testDividingReportingOverflow() {
        NBKAssertDivision(T(0), T(0), T(0), T(0), true)
        NBKAssertDivision(T(1), T(0), T(1), T(1), true)
        NBKAssertDivision(T(2), T(0), T(2), T(2), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Full Width
    //=------------------------------------------------------------------------=
    
    func testDividingFullWidth() {
        var x: (high: T, low: T)
        //=--------------------------------------=
        x.low  = T(x64: X( 6, 17, 35, 61))
        x.high = T(x64: X(61, 52, 32,  0))
        
        NBKAssertDivisionFullWidth(x, T(x64: X(1, 2, 3, 4)), T(x64: X(5, 6, 7, 8)), T(x64: X( 1,  1,  1,  1)))
        NBKAssertDivisionFullWidth(x, T(x64: X(5, 6, 7, 8)), T(x64: X(1, 2, 3, 4)), T(x64: X( 1,  1,  1,  1)))
        //=--------------------------------------=
        x.low  = T(x64: X(34, 54, 63, 62))
        x.high = T(x64: X(34, 16,  5,  0))
        
        NBKAssertDivisionFullWidth(x, T(x64: X(4, 3, 2, 1)), T(x64: X(9, 7, 6, 5)), T(x64: X(~1, ~1, ~0,  0)))
        NBKAssertDivisionFullWidth(x, T(x64: X(8, 7, 6, 5)), T(x64: X(4, 3, 2, 1)), T(x64: X( 2,  2,  2,  2)))
    }
    
    func testDividingFullWidthTruncatesQuotient() {
        var x: (high: T, low: T)
        //=--------------------------------------=
        x.low  = T(x64: X( 0,  0,  0,  0))
        x.high = T(x64: X(~0, ~0, ~0, ~0))
        
        NBKAssertDivisionFullWidth(x, T(1), ~T(0) << (T.bitWidth - 0), T(0))
        NBKAssertDivisionFullWidth(x, T(2), ~T(0) << (T.bitWidth - 1), T(0))
        NBKAssertDivisionFullWidth(x, T(4), ~T(0) << (T.bitWidth - 2), T(0))
        NBKAssertDivisionFullWidth(x, T(8), ~T(0) << (T.bitWidth - 3), T(0))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x /= 0)
            XCTAssertNotNil(x %= 0)
            XCTAssertNotNil(x.divideReportingOverflow(by: 0))
            XCTAssertNotNil(x.formRemainderReportingOverflow(dividingBy: 0))
            
            XCTAssertNotNil(x /  0)
            XCTAssertNotNil(x %  0)
            XCTAssertNotNil(x.dividedReportingOverflow(by: 0))
            XCTAssertNotNil(x.remainderReportingOverflow(dividingBy: 0))
            XCTAssertNotNil(x.quotientAndRemainder(dividingBy: 0))
            XCTAssertNotNil(x.quotientAndRemainderReportingOverflow(dividingBy: 0))
            XCTAssertNotNil(x.dividingFullWidth((0, 0)))
        }
    }
}

#endif
