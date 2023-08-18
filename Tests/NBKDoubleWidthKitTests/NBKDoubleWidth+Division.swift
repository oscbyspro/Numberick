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
// MARK: * NBK x Double Width x Division x Int256
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
final class NBKDoubleWidthTestsOnDivisionAsInt256: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividing() {
        NBKAssertDivision( T( ),  T(1),  T( ),  T( ))
        NBKAssertDivision( T( ),  T(2),  T( ),  T( ))
        NBKAssertDivision( T(7),  T(1),  T(7),  T( ))
        NBKAssertDivision( T(7),  T(2),  T(3),  T(1))
                
        NBKAssertDivision( T(7),  T(3),  T(2),  T(1))
        NBKAssertDivision( T(7), -T(3), -T(2),  T(1))
        NBKAssertDivision(-T(7),  T(3), -T(2), -T(1))
        NBKAssertDivision(-T(7), -T(3),  T(2), -T(1))
    }
    
    func testDividingReportingOverflow() {
        NBKAssertDivision(T( 0),  T( ),  T( 0), T( ), true )
        NBKAssertDivision(T( 1),  T( ),  T( 1), T(1), true )
        NBKAssertDivision(T( 2),  T( ),  T( 2), T(2), true )
        NBKAssertDivision(T.min, -T(1),  T.min, T( ), true )
        NBKAssertDivision(T.max, -T(1), -T.max, T( ), false)
    }
    
    func testDividingWithLargeDividend() {
        NBKAssertDivision( T(x64: X(1, 2, 3, 4)),  T(2),  T(x64: X(0, ~0/2 + 2, 1, 2)),  T(1))
        NBKAssertDivision( T(x64: X(1, 2, 3, 4)), -T(2), -T(x64: X(0, ~0/2 + 2, 1, 2)),  T(1))
        NBKAssertDivision(-T(x64: X(1, 2, 3, 4)),  T(2), -T(x64: X(0, ~0/2 + 2, 1, 2)), -T(1))
        NBKAssertDivision(-T(x64: X(1, 2, 3, 4)), -T(2),  T(x64: X(0, ~0/2 + 2, 1, 2)), -T(1))
        
        NBKAssertDivision( T(x64: X(1, 2, 3, 4)),  T(x64: X(0, ~0/2 + 2, 1, 2)),  T(2),  T(1))
        NBKAssertDivision( T(x64: X(1, 2, 3, 4)), -T(x64: X(0, ~0/2 + 2, 1, 2)), -T(2),  T(1))
        NBKAssertDivision(-T(x64: X(1, 2, 3, 4)), -T(x64: X(0, ~0/2 + 2, 1, 2)),  T(2), -T(1))
        NBKAssertDivision(-T(x64: X(1, 2, 3, 4)),  T(x64: X(0, ~0/2 + 2, 1, 2)), -T(2), -T(1))
    }
    
    func testDividingWithLargeDivisor() {
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X( 1,  2,  3,  4 &+ 1 << 63)),  T(1), -T(x64: X(0, 0, 0, 0)))
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X( 2,  3,  4,  5 &+ 1 << 63)),  T(1), -T(x64: X(1, 1, 1, 1)))
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X( 3,  4,  5,  6 &+ 1 << 63)),  T(1), -T(x64: X(2, 2, 2, 2)))
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X( 4,  5,  6,  7 &+ 1 << 63)),  T(1), -T(x64: X(3, 3, 3, 3)))
        
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X(~0, ~2, ~3, ~4 &+ 1 << 63)), -T(1), -T(x64: X(0, 0, 0, 0)))
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X(~1, ~3, ~4, ~5 &+ 1 << 63)), -T(1), -T(x64: X(1, 1, 1, 1)))
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X(~2, ~4, ~5, ~6 &+ 1 << 63)), -T(1), -T(x64: X(2, 2, 2, 2)))
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X(~3, ~5, ~6, ~7 &+ 1 << 63)), -T(1), -T(x64: X(3, 3, 3, 3)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testDividingByDigit() {
        NBKAssertDivisionByDigit( T( ),  Int(1),  T( ),  Int( ))
        NBKAssertDivisionByDigit( T( ),  Int(2),  T( ),  Int( ))
        NBKAssertDivisionByDigit( T(7),  Int(1),  T(7),  Int( ))
        NBKAssertDivisionByDigit( T(7),  Int(2),  T(3),  Int(1))
                
        NBKAssertDivisionByDigit( T(7),  Int(3),  T(2),  Int(1))
        NBKAssertDivisionByDigit( T(7), -Int(3), -T(2),  Int(1))
        NBKAssertDivisionByDigit(-T(7),  Int(3), -T(2), -Int(1))
        NBKAssertDivisionByDigit(-T(7), -Int(3),  T(2), -Int(1))
    }
    
    func testDividingByDigitReportingOverflow() {
        NBKAssertDivisionByDigit(T( 0),  Int( ),  T( 0), Int( ), true )
        NBKAssertDivisionByDigit(T( 1),  Int( ),  T( 1), Int(1), true )
        NBKAssertDivisionByDigit(T( 2),  Int( ),  T( 2), Int(2), true )
        NBKAssertDivisionByDigit(T.min, -Int(1),  T.min, Int( ), true )
        NBKAssertDivisionByDigit(T.max, -Int(1), -T.max, Int( ), false)
    }
    
    func testDividingByDigitWithLargeDividend() {
        NBKAssertDivisionByDigit( T(x64: X(1, 2, 3, 4)),  Int(2),  T(x64: X(0, ~0/2 + 2, 1, 2)),  Int(1))
        NBKAssertDivisionByDigit( T(x64: X(1, 2, 3, 4)), -Int(2), -T(x64: X(0, ~0/2 + 2, 1, 2)),  Int(1))
        NBKAssertDivisionByDigit(-T(x64: X(1, 2, 3, 4)),  Int(2), -T(x64: X(0, ~0/2 + 2, 1, 2)), -Int(1))
        NBKAssertDivisionByDigit(-T(x64: X(1, 2, 3, 4)), -Int(2),  T(x64: X(0, ~0/2 + 2, 1, 2)), -Int(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Full Width
    //=------------------------------------------------------------------------=
    
    func testDividingFullWidth() {
        var dividend: (high: T, low: M)
        //=--------------------------------------=
        dividend.high = T(x64: X(61, 52, 32,  0))
        dividend.low  = M(x64: X( 6, 17, 35, 61))
        
        NBKAssertDivisionFullWidth(dividend, T(x64: X( 1,  2,  3,  4)), T(x64: X( 5,  6,  7,  8)), T(x64: X( 1,  1,  1,  1)))
        NBKAssertDivisionFullWidth(dividend, T(x64: X( 5,  6,  7,  8)), T(x64: X( 1,  2,  3,  4)), T(x64: X( 1,  1,  1,  1)))
        //=--------------------------------------=
        dividend.high = T(x64: X(34, 16,  5,  0))
        dividend.low  = M(x64: X(34, 54, 63, 62))
        
        NBKAssertDivisionFullWidth(dividend, T(x64: X( 4,  3,  2,  1)), T(x64: X( 9,  7,  6,  5)), T(x64: X(~1, ~1, ~0,  0)))
        NBKAssertDivisionFullWidth(dividend, T(x64: X( 8,  7,  6,  5)), T(x64: X( 4,  3,  2,  1)), T(x64: X( 2,  2,  2,  2)))
        //=--------------------------------------=
        dividend.high = T(x64: X(~0, ~0, ~0, ~0))
        dividend.low  = M(x64: X(~1, ~0, ~0, ~0))
        
        NBKAssertDivisionFullWidth(dividend, T(x64: X( 1,  0,  0,  0)), T(x64: X(~1, ~0, ~0, ~0)), T(x64: X( 0,  0,  0,  0)))
        NBKAssertDivisionFullWidth(dividend, T(x64: X(~0, ~0, ~0, ~0)), T(x64: X( 2,  0,  0,  0)), T(x64: X( 0,  0,  0,  0)))
    }
    
    func testDividingFullWidthReportingOverflow() {
        var dividend: (high: T, low: M)
        //=--------------------------------------=
        dividend.high = T(  )
        dividend.low  = M( 7)

        NBKAssertDivisionFullWidth(dividend, T(  ),  T( 7), T( 7), true)
        //=--------------------------------------=
        dividend.high = T(-1)
        dividend.low  = M( 7)
        
        NBKAssertDivisionFullWidth(dividend, T(  ),  T( 7), T( 7), true)
        //=--------------------------------------=
        dividend.high = T(-1)
        dividend.low  = M.max
        
        NBKAssertDivisionFullWidth(dividend, T( 2),  T(  ), T(-1))
        //=--------------------------------------=
        dividend.high = T(  )
        dividend.low  = M( 1)
        
        NBKAssertDivisionFullWidth(dividend, T(-2),  T(  ), T( 1))
        //=--------------------------------------=
        dividend.high = T(  )
        dividend.low  = M(bitPattern: T.max)

        NBKAssertDivisionFullWidth(dividend, T(-1), -T.max, T(  ))
        //=--------------------------------------=
        dividend.high = T(-1)
        dividend.low  = M(bitPattern: T.min)
        
        NBKAssertDivisionFullWidth(dividend, T(-1),  T.min, T(  ), true)
        //=--------------------------------------=
        dividend.high = T.max >> 1
        dividend.low  = M.max >> 1
        
        NBKAssertDivisionFullWidth(dividend, T.max,  T.max, T.max - 1)
        //=--------------------------------------=
        dividend.high = T.max >> 1
        dividend.low  = M.max >> 1 + 1
        
        NBKAssertDivisionFullWidth(dividend, T.max,  T.min, T(  ), true)
        //=--------------------------------------=
        dividend.high = T.max >> 1 + 1
        dividend.low  = M.max >> 1
        
        NBKAssertDivisionFullWidth(dividend, T.min,  T.min, T.max)
        //=--------------------------------------=
        dividend.high = T.max >> 1 + 1
        dividend.low  = M.max >> 1 + 1
        
        NBKAssertDivisionFullWidth(dividend, T.min,  T.max, T(  ), true)
    }
    
    func testDividingFullWidthReportingOverflowTruncatesQuotient() {
        let dividend: (high: T, low: M)
        //=--------------------------------------=
        dividend.high = T(repeating: true )
        dividend.low  = M(repeating: false)
        
        NBKAssertDivisionFullWidth(dividend, T( ), ~T( ) << (T.bitWidth - 0), T( ), true)
        NBKAssertDivisionFullWidth(dividend, T(1), ~T( ) << (T.bitWidth - 0), T( ), true)
        NBKAssertDivisionFullWidth(dividend, T(2), ~T( ) << (T.bitWidth - 1), T( ))
        NBKAssertDivisionFullWidth(dividend, T(4), ~T( ) << (T.bitWidth - 2), T( ))
        NBKAssertDivisionFullWidth(dividend, T(8), ~T( ) << (T.bitWidth - 3), T( ))
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
// MARK: * NBK x Double Width x Division x UInt256
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
final class NBKDoubleWidthTestsOnDivisionAsUInt256: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividing() {
        NBKAssertDivision(T( ), T(1), T( ), T( ))
        NBKAssertDivision(T( ), T(2), T( ), T( ))
        NBKAssertDivision(T(7), T(1), T(7), T( ))
        NBKAssertDivision(T(7), T(2), T(3), T(1))
    }
    
    func testDividingReportingOverflow() {
        NBKAssertDivision(T( ), T( ), T( ), T( ), true)
        NBKAssertDivision(T(1), T( ), T(1), T(1), true)
        NBKAssertDivision(T(2), T( ), T(2), T(2), true)
    }
    
    func testDividingWithLargeDividend() {
        NBKAssertDivision(T(x64: X(~2,  ~4,  ~6,  9)), T(2), T(x64: X(~1, ~2, ~3, 4)), T(1))
        NBKAssertDivision(T(x64: X(~3,  ~6,  ~9, 14)), T(3), T(x64: X(~1, ~2, ~3, 4)), T(2))
        NBKAssertDivision(T(x64: X(~4,  ~8, ~12, 19)), T(4), T(x64: X(~1, ~2, ~3, 4)), T(3))
        NBKAssertDivision(T(x64: X(~5, ~10, ~15, 24)), T(5), T(x64: X(~1, ~2, ~3, 4)), T(4))
        
        NBKAssertDivision(T(x64: X(~2,  ~4,  ~6,  9)), T(x64: X(~1, ~2, ~3, 4)), T(2), T(1))
        NBKAssertDivision(T(x64: X(~3,  ~6,  ~9, 14)), T(x64: X(~1, ~2, ~3, 4)), T(3), T(2))
        NBKAssertDivision(T(x64: X(~4,  ~8, ~12, 19)), T(x64: X(~1, ~2, ~3, 4)), T(4), T(3))
        NBKAssertDivision(T(x64: X(~5, ~10, ~15, 24)), T(x64: X(~1, ~2, ~3, 4)), T(5), T(4))
    }
    
    func testDividingWithLargeDivisor() {
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X( 1,  2,  3,  4 &+ 1 << 63)), T(1), T(x64: X(0, 0, 0, 0)))
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X( 0,  1,  2,  3 &+ 1 << 63)), T(1), T(x64: X(1, 1, 1, 1)))
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X(~0, ~0,  0,  2 &+ 1 << 63)), T(1), T(x64: X(2, 2, 2, 2)))
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X(~1, ~1, ~0,  0 &+ 1 << 63)), T(1), T(x64: X(3, 3, 3, 3)))
        
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X(~2, ~2, ~1, ~0 &+ 1 << 63)), T(1), T(x64: X(4, 4, 4, 4)))
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X(~3, ~3, ~2, ~1 &+ 1 << 63)), T(1), T(x64: X(5, 5, 5, 5)))
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X(~4, ~4, ~3, ~2 &+ 1 << 63)), T(1), T(x64: X(6, 6, 6, 6)))
        NBKAssertDivision(T(x64: X(1, 2, 3, 4 + 1 << 63)), T(x64: X(~5, ~5, ~4, ~3 &+ 1 << 63)), T(1), T(x64: X(7, 7, 7, 7)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testDividingByDigit() {
        NBKAssertDivisionByDigit(T( ), UInt(1), T( ), UInt( ))
        NBKAssertDivisionByDigit(T( ), UInt(2), T( ), UInt( ))
        NBKAssertDivisionByDigit(T(7), UInt(1), T(7), UInt( ))
        NBKAssertDivisionByDigit(T(7), UInt(2), T(3), UInt(1))
    }
    
    func testDividingByDigitReportingOverflow() {
        NBKAssertDivisionByDigit(T( ), UInt( ), T( ), UInt( ), true)
        NBKAssertDivisionByDigit(T(1), UInt( ), T(1), UInt(1), true)
        NBKAssertDivisionByDigit(T(2), UInt( ), T(2), UInt(2), true)
    }
    
    func testDividingByDigitWithLargeDividend() {
        NBKAssertDivisionByDigit(T(x64: X(~2,  ~4,  ~6,  9)), UInt(2), T(x64: X(~1, ~2, ~3, 4)), UInt(1))
        NBKAssertDivisionByDigit(T(x64: X(~3,  ~6,  ~9, 14)), UInt(3), T(x64: X(~1, ~2, ~3, 4)), UInt(2))
        NBKAssertDivisionByDigit(T(x64: X(~4,  ~8, ~12, 19)), UInt(4), T(x64: X(~1, ~2, ~3, 4)), UInt(3))
        NBKAssertDivisionByDigit(T(x64: X(~5, ~10, ~15, 24)), UInt(5), T(x64: X(~1, ~2, ~3, 4)), UInt(4))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Full Width
    //=------------------------------------------------------------------------=
    
    func testDividingFullWidth() {
        var dividend: (high: T, low: M)
        //=--------------------------------------=
        dividend.high = T(x64: X(61, 52, 32,  0))
        dividend.low  = M(x64: X( 6, 17, 35, 61))
        
        NBKAssertDivisionFullWidth(dividend, T(x64: X(1, 2, 3, 4)), T(x64: X(5, 6, 7, 8)), T(x64: X( 1,  1,  1,  1)))
        NBKAssertDivisionFullWidth(dividend, T(x64: X(5, 6, 7, 8)), T(x64: X(1, 2, 3, 4)), T(x64: X( 1,  1,  1,  1)))
        //=--------------------------------------=
        dividend.high = T(x64: X(34, 16,  5,  0))
        dividend.low  = M(x64: X(34, 54, 63, 62))
        
        NBKAssertDivisionFullWidth(dividend, T(x64: X(4, 3, 2, 1)), T(x64: X(9, 7, 6, 5)), T(x64: X(~1, ~1, ~0,  0)))
        NBKAssertDivisionFullWidth(dividend, T(x64: X(8, 7, 6, 5)), T(x64: X(4, 3, 2, 1)), T(x64: X( 2,  2,  2,  2)))
    }
    
    func testDividingFullWidthReportingOverflow() {
        var dividend: (high: T, low: M)
        //=--------------------------------------=
        dividend.high = T(  )
        dividend.low  = M( 7)
        
        NBKAssertDivisionFullWidth(dividend, T(  ), T( 7), T( 7), true)
        //=--------------------------------------=
        dividend.high = T.max
        dividend.low  = M( 7)
        
        NBKAssertDivisionFullWidth(dividend, T(  ), T( 7), T( 7), true)
        //=--------------------------------------=
        dividend.high = T.max - 1
        dividend.low  = M.max
        
        NBKAssertDivisionFullWidth(dividend, T.max, T.max, T.max - 1)
        //=--------------------------------------=
        dividend.high = T.max
        dividend.low  = M.min
        
        NBKAssertDivisionFullWidth(dividend, T.max, T(  ), T(  ), true)
    }
    
    func testDividingFullWidthReportingOverflowTruncatesQuotient() {
        let dividend: (high: T, low: M)
        //=--------------------------------------=
        dividend.high = T(repeating: true )
        dividend.low  = M(repeating: false)
        
        NBKAssertDivisionFullWidth(dividend, T( ), ~T( ) << (T.bitWidth - 0), T( ), true)
        NBKAssertDivisionFullWidth(dividend, T(1), ~T( ) << (T.bitWidth - 0), T( ), true)
        NBKAssertDivisionFullWidth(dividend, T(2), ~T( ) << (T.bitWidth - 1), T( ), true)
        NBKAssertDivisionFullWidth(dividend, T(4), ~T( ) << (T.bitWidth - 2), T( ), true)
        NBKAssertDivisionFullWidth(dividend, T(8), ~T( ) << (T.bitWidth - 3), T( ), true)
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
// MARK: * NBK x Double Width x Division x UInt256 x Code Coverage
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
final class NBKDoubleWidthTestsOnDivisionAsUInt256CodeCoverage: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Full Width
    //=------------------------------------------------------------------------=
    
    func testDividingFullWidth3212MSB() {
        var dividend: (high: T, low: M)
        //=--------------------------------------=
        dividend.high = T.max << 64
        dividend.low  = M.min
        
        NBKAssertDivisionFullWidth(dividend, T.max, T.max << 64 + 0, T.max << 64)
        //=--------------------------------------=
        dividend.high = T.max << 64
        dividend.low  = M.max
        
        NBKAssertDivisionFullWidth(dividend, T.max, T.max << 64 + 1, T.max << 64)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Division x Assertions
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
private func NBKAssertDivision<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>,
_ quotient: NBKDoubleWidth<H>, _ remainder: NBKDoubleWidth<H>, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(lhs, quotient * rhs + remainder, "lhs != rhs * quotient + remainder", file: file, line: line)
    }
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(lhs / rhs, quotient,  file: file, line: line)
        XCTAssertEqual(lhs % rhs, remainder, file: file, line: line)
        
        XCTAssertEqual({ var x = lhs; x /= rhs; return x }(), quotient,  file: file, line: line)
        XCTAssertEqual({ var x = lhs; x %= rhs; return x }(), remainder, file: file, line: line)
        
        XCTAssertEqual(lhs.quotientAndRemainder(dividingBy: rhs).quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(lhs.quotientAndRemainder(dividingBy: rhs).remainder, remainder, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs.dividedReportingOverflow(by: rhs).partialValue, quotient, file: file, line: line)
    XCTAssertEqual(lhs.dividedReportingOverflow(by: rhs).overflow,     overflow, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.divideReportingOverflow(by: rhs); return x }(), quotient, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.divideReportingOverflow(by: rhs); return o }(), overflow, file: file, line: line)
    
    XCTAssertEqual(lhs.remainderReportingOverflow(dividingBy: rhs).partialValue, remainder, file: file, line: line)
    XCTAssertEqual(lhs.remainderReportingOverflow(dividingBy: rhs).overflow,     overflow,  file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.formRemainderReportingOverflow(dividingBy: rhs); return x }(), remainder, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.formRemainderReportingOverflow(dividingBy: rhs); return o }(), overflow,  file: file, line: line)

    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs).partialValue.quotient,  quotient,  file: file, line: line)
    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs).partialValue.remainder, remainder, file: file, line: line)
    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs).overflow,               overflow,  file: file, line: line)
}

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
private func NBKAssertDivisionByDigit<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>.Digit,
_ quotient: NBKDoubleWidth<H>, _ remainder: NBKDoubleWidth<H>.Digit, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    let extended = NBKDoubleWidth<H>(digit: remainder)
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(lhs, quotient * rhs + remainder, "lhs != rhs * quotient + remainder", file: file, line: line)
    }
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(lhs / rhs, quotient,  file: file, line: line)
        XCTAssertEqual(lhs % rhs, remainder, file: file, line: line)
        
        XCTAssertEqual({ var x = lhs; x /= rhs; return x }(), quotient, file: file, line: line)
        XCTAssertEqual({ var x = lhs; x %= rhs; return x }(), extended, file: file, line: line)
        
        XCTAssertEqual(lhs.quotientAndRemainder(dividingBy: rhs).quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(lhs.quotientAndRemainder(dividingBy: rhs).remainder, remainder, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs.dividedReportingOverflow(by: rhs).partialValue, quotient, file: file, line: line)
    XCTAssertEqual(lhs.dividedReportingOverflow(by: rhs).overflow,     overflow, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.divideReportingOverflow(by: rhs); return x }(), quotient, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.divideReportingOverflow(by: rhs); return o }(), overflow, file: file, line: line)
    
    XCTAssertEqual(lhs.remainderReportingOverflow(dividingBy: rhs).partialValue, remainder, file: file, line: line)
    XCTAssertEqual(lhs.remainderReportingOverflow(dividingBy: rhs).overflow,     overflow,  file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.formRemainderReportingOverflow(dividingBy: rhs); return x }(), extended, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.formRemainderReportingOverflow(dividingBy: rhs); return o }(), overflow, file: file, line: line)

    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs).partialValue.quotient,  quotient,  file: file, line: line)
    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs).partialValue.remainder, remainder, file: file, line: line)
    XCTAssertEqual(lhs.quotientAndRemainderReportingOverflow(dividingBy: rhs).overflow,               overflow,  file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Full Width
//=----------------------------------------------------------------------------=

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
private func NBKAssertDivisionFullWidth<H: NBKFixedWidthInteger>(
_ lhs: HL<NBKDoubleWidth<H>, NBKDoubleWidth<H>.Magnitude>, _ rhs: NBKDoubleWidth<H>,
_ quotient: NBKDoubleWidth<H>, _ remainder: NBKDoubleWidth<H>, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    typealias T  = NBKDoubleWidth<H>
    typealias T2 = NBKDoubleWidth<T>
    //=------------------------------------------=
    let lhs = T2(descending: lhs)
    //=------------------------------------------=
    if !overflow {
        let composite = T2(descending: rhs.multipliedFullWidth(by: quotient)) + T2(remainder)
        XCTAssertEqual(lhs, composite, "lhs != rhs * quotient + remainder", file: file, line: line)
    }
    //=------------------------------------------=
    if !overflow {
        let qr: QR<T, T> = rhs.dividingFullWidth(lhs.descending)
        XCTAssertEqual(qr.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(qr.remainder, remainder, file: file, line: line)
    }
    //=------------------------------------------=
    let qro: PVO<QR<T, T>> = rhs.dividingFullWidthReportingOverflow(lhs.descending)
    XCTAssertEqual(qro.partialValue.quotient,  quotient,  file: file, line: line)
    XCTAssertEqual(qro.partialValue.remainder, remainder, file: file, line: line)
    XCTAssertEqual(qro.overflow,               overflow,  file: file, line: line)
}

#endif
