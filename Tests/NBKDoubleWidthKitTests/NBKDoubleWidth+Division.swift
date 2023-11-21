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
// MARK: * NBK x Double Width x Division x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnDivisionAsInt256: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividingLargeByLarge() {
        NBKAssertDivision( T(x64: X64(1, 2, 3, 4)),  T(x64: X64(0, ~0/2 + 2, 1, 2)),  T(2),  T(1))
        NBKAssertDivision( T(x64: X64(1, 2, 3, 4)), -T(x64: X64(0, ~0/2 + 2, 1, 2)), -T(2),  T(1))
        NBKAssertDivision(-T(x64: X64(1, 2, 3, 4)), -T(x64: X64(0, ~0/2 + 2, 1, 2)),  T(2), -T(1))
        NBKAssertDivision(-T(x64: X64(1, 2, 3, 4)),  T(x64: X64(0, ~0/2 + 2, 1, 2)), -T(2), -T(1))
    }
    
    func testDividingLargeByLargeWithLargeRemainder() {
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64( 1,  2,  3,  4 &+ 1 << 63)),  T(1), -T(x64: X64(0, 0, 0, 0)))
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64( 2,  3,  4,  5 &+ 1 << 63)),  T(1), -T(x64: X64(1, 1, 1, 1)))
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64( 3,  4,  5,  6 &+ 1 << 63)),  T(1), -T(x64: X64(2, 2, 2, 2)))
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64( 4,  5,  6,  7 &+ 1 << 63)),  T(1), -T(x64: X64(3, 3, 3, 3)))
        
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64(~0, ~2, ~3, ~4 &+ 1 << 63)), -T(1), -T(x64: X64(0, 0, 0, 0)))
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64(~1, ~3, ~4, ~5 &+ 1 << 63)), -T(1), -T(x64: X64(1, 1, 1, 1)))
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64(~2, ~4, ~5, ~6 &+ 1 << 63)), -T(1), -T(x64: X64(2, 2, 2, 2)))
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64(~3, ~5, ~6, ~7 &+ 1 << 63)), -T(1), -T(x64: X64(3, 3, 3, 3)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit (and Self)
    //=------------------------------------------------------------------------=
    
    func testDividingSmallBySmall() {
        NBKAssertDivisionByDigit( T( ),  Int(1),  T( ),  Int( ))
        NBKAssertDivisionByDigit( T( ),  Int(2),  T( ),  Int( ))
        NBKAssertDivisionByDigit( T(7),  Int(1),  T(7),  Int( ))
        NBKAssertDivisionByDigit( T(7),  Int(2),  T(3),  Int(1))
                
        NBKAssertDivisionByDigit( T(7),  Int(3),  T(2),  Int(1))
        NBKAssertDivisionByDigit( T(7), -Int(3), -T(2),  Int(1))
        NBKAssertDivisionByDigit(-T(7),  Int(3), -T(2), -Int(1))
        NBKAssertDivisionByDigit(-T(7), -Int(3),  T(2), -Int(1))
    }
    
    func testDividingLargeBySmall() {
        NBKAssertDivisionByDigit( T(x64: X64(1, 2, 3, 4)),  Int(2),  T(x64: X64(0, ~0/2 + 2, 1, 2)),  Int(1))
        NBKAssertDivisionByDigit( T(x64: X64(1, 2, 3, 4)), -Int(2), -T(x64: X64(0, ~0/2 + 2, 1, 2)),  Int(1))
        NBKAssertDivisionByDigit(-T(x64: X64(1, 2, 3, 4)),  Int(2), -T(x64: X64(0, ~0/2 + 2, 1, 2)), -Int(1))
        NBKAssertDivisionByDigit(-T(x64: X64(1, 2, 3, 4)), -Int(2),  T(x64: X64(0, ~0/2 + 2, 1, 2)), -Int(1))
    }
    
    func testDividingBySmallReportingOverflow() {
        NBKAssertDivisionByDigit(T( 0),  Int( ),  T( 0), Int( ), true )
        NBKAssertDivisionByDigit(T( 1),  Int( ),  T( 1), Int(1), true )
        NBKAssertDivisionByDigit(T( 2),  Int( ),  T( 2), Int(2), true )
        NBKAssertDivisionByDigit(T.min, -Int(1),  T.min, Int( ), true )
        NBKAssertDivisionByDigit(T.max, -Int(1), -T.max, Int( ), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Full Width
    //=------------------------------------------------------------------------=
    
    func testDividingFullWidth() {
        var dividend: (high: T, low: M)
        //=--------------------------------------=
        dividend.high = T(x64: X64(61, 52, 32,  0))
        dividend.low  = M(x64: X64( 6, 17, 35, 61))
        
        NBKAssertDivisionFullWidth(dividend, T(x64: X64( 1,  2,  3,  4)), T(x64: X64( 5,  6,  7,  8)), T(x64: X64( 1,  1,  1,  1)))
        NBKAssertDivisionFullWidth(dividend, T(x64: X64( 5,  6,  7,  8)), T(x64: X64( 1,  2,  3,  4)), T(x64: X64( 1,  1,  1,  1)))
        //=--------------------------------------=
        dividend.high = T(x64: X64(34, 16,  5,  0))
        dividend.low  = M(x64: X64(34, 54, 63, 62))
        
        NBKAssertDivisionFullWidth(dividend, T(x64: X64( 4,  3,  2,  1)), T(x64: X64( 9,  7,  6,  5)), T(x64: X64(~1, ~1, ~0,  0)))
        NBKAssertDivisionFullWidth(dividend, T(x64: X64( 8,  7,  6,  5)), T(x64: X64( 4,  3,  2,  1)), T(x64: X64( 2,  2,  2,  2)))
        //=--------------------------------------=
        dividend.high = T(x64: X64(~0, ~0, ~0, ~0))
        dividend.low  = M(x64: X64(~1, ~0, ~0, ~0))
        
        NBKAssertDivisionFullWidth(dividend, T(x64: X64( 1,  0,  0,  0)), T(x64: X64(~1, ~0, ~0, ~0)), T(x64: X64( 0,  0,  0,  0)))
        NBKAssertDivisionFullWidth(dividend, T(x64: X64(~0, ~0, ~0, ~0)), T(x64: X64( 2,  0,  0,  0)), T(x64: X64( 0,  0,  0,  0)))
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

final class NBKDoubleWidthTestsOnDivisionAsUInt256: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividingLargeByLarge() {
        NBKAssertDivision(T(x64: X64(~2,  ~4,  ~6,  9)), T(x64: X64(~1, ~2, ~3, 4)), T(2), T(1))
        NBKAssertDivision(T(x64: X64(~3,  ~6,  ~9, 14)), T(x64: X64(~1, ~2, ~3, 4)), T(3), T(2))
        NBKAssertDivision(T(x64: X64(~4,  ~8, ~12, 19)), T(x64: X64(~1, ~2, ~3, 4)), T(4), T(3))
        NBKAssertDivision(T(x64: X64(~5, ~10, ~15, 24)), T(x64: X64(~1, ~2, ~3, 4)), T(5), T(4))
    }
    
    func testDividingLargeByLargeWithLargeRemainder() {
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64( 1,  2,  3,  4 &+ 1 << 63)), T(1), T(x64: X64(0, 0, 0, 0)))
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64( 0,  1,  2,  3 &+ 1 << 63)), T(1), T(x64: X64(1, 1, 1, 1)))
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64(~0, ~0,  0,  2 &+ 1 << 63)), T(1), T(x64: X64(2, 2, 2, 2)))
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64(~1, ~1, ~0,  0 &+ 1 << 63)), T(1), T(x64: X64(3, 3, 3, 3)))
        
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64(~2, ~2, ~1, ~0 &+ 1 << 63)), T(1), T(x64: X64(4, 4, 4, 4)))
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64(~3, ~3, ~2, ~1 &+ 1 << 63)), T(1), T(x64: X64(5, 5, 5, 5)))
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64(~4, ~4, ~3, ~2 &+ 1 << 63)), T(1), T(x64: X64(6, 6, 6, 6)))
        NBKAssertDivision(T(x64: X64(1, 2, 3, 4 + 1 << 63)), T(x64: X64(~5, ~5, ~4, ~3 &+ 1 << 63)), T(1), T(x64: X64(7, 7, 7, 7)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit (and Self)
    //=------------------------------------------------------------------------=
    
    func testDividingSmallBySmall() {
        NBKAssertDivisionByDigit(T( ), UInt(1), T( ), UInt( ))
        NBKAssertDivisionByDigit(T( ), UInt(2), T( ), UInt( ))
        NBKAssertDivisionByDigit(T(7), UInt(1), T(7), UInt( ))
        NBKAssertDivisionByDigit(T(7), UInt(2), T(3), UInt(1))
    }
    
    func testDividingLargeBySmall() {
        NBKAssertDivisionByDigit(T(x64: X64(~2,  ~4,  ~6,  9)), UInt(2), T(x64: X64(~1, ~2, ~3, 4)), UInt(1))
        NBKAssertDivisionByDigit(T(x64: X64(~3,  ~6,  ~9, 14)), UInt(3), T(x64: X64(~1, ~2, ~3, 4)), UInt(2))
        NBKAssertDivisionByDigit(T(x64: X64(~4,  ~8, ~12, 19)), UInt(4), T(x64: X64(~1, ~2, ~3, 4)), UInt(3))
        NBKAssertDivisionByDigit(T(x64: X64(~5, ~10, ~15, 24)), UInt(5), T(x64: X64(~1, ~2, ~3, 4)), UInt(4))
    }
    
    func testDividingBySmallReportingOverflow() {
        NBKAssertDivisionByDigit(T( ), UInt( ), T( ), UInt( ), true)
        NBKAssertDivisionByDigit(T(1), UInt( ), T(1), UInt(1), true)
        NBKAssertDivisionByDigit(T(2), UInt( ), T(2), UInt(2), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Full Width
    //=------------------------------------------------------------------------=
    
    func testDividingFullWidth() {
        var dividend: (high: T, low: M)
        //=--------------------------------------=
        dividend.high = T(x64: X64(61, 52, 32,  0))
        dividend.low  = M(x64: X64( 6, 17, 35, 61))
        
        NBKAssertDivisionFullWidth(dividend, T(x64: X64(1, 2, 3, 4)), T(x64: X64(5, 6, 7, 8)), T(x64: X64( 1,  1,  1,  1)))
        NBKAssertDivisionFullWidth(dividend, T(x64: X64(5, 6, 7, 8)), T(x64: X64(1, 2, 3, 4)), T(x64: X64( 1,  1,  1,  1)))
        //=--------------------------------------=
        dividend.high = T(x64: X64(34, 16,  5,  0))
        dividend.low  = M(x64: X64(34, 54, 63, 62))
        
        NBKAssertDivisionFullWidth(dividend, T(x64: X64(4, 3, 2, 1)), T(x64: X64(9, 7, 6, 5)), T(x64: X64(~1, ~1, ~0,  0)))
        NBKAssertDivisionFullWidth(dividend, T(x64: X64(8, 7, 6, 5)), T(x64: X64(4, 3, 2, 1)), T(x64: X64( 2,  2,  2,  2)))
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

//=----------------------------------------------------------------------------=
// MARK: + Code Coverage
//=----------------------------------------------------------------------------=

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
// MARK: * NBK x Double Width x Division x Open Source Issues
//*============================================================================*

final class NBKDoubleWidthTestsOnDivisionOpenSourceIssues: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// https://github.com/oscbyspro/Numberick/issues/101
    ///
    /// - Note: Checks whether the 3212-path knows when the quotient fits.
    ///
    func testNumberickIssues101() {
        NBKAssertDivision(
        UInt256("000000000000000000003360506852691063560493141264855294697309369118818719524903"),
        UInt256("000000000000000000000000000000000000000038792928317726192474768301090870907748"),
        UInt256("000000000000000000000000000000000000000000000000000000000086626789943967710436"),
        UInt256("000000000000000000000000000000000000000016136758413064865246015978698186666775"))
    }
    
    /// https://github.com/apple/swift-numerics/issues/272
    ///
    /// - Note: Said to crash and/or return incorrect results.
    ///
    func testSwiftNumericsIssues272() {
        NBKAssertDivision(
        UInt128(3) << 96,
        UInt128(2) << 96,
        UInt128(1) << 00,
        UInt128(1) << 96)
        
        NBKAssertDivision(
        UInt128("311758830729407788314878278112166161571"),
        UInt128("259735543268722398904715765931073125012"),
        UInt128("000000000000000000000000000000000000001"),
        UInt128("052023287460685389410162512181093036559"))
        
        NBKAssertDivision(
        UInt128("213714108890282186096522258117935109183"),
        UInt128("205716886996038887182342392781884393270"),
        UInt128("000000000000000000000000000000000000001"),
        UInt128("007997221894243298914179865336050715913"))
        
        NBKAssertDivision(
        UInt256("000000000000000000002369676578372158364766242369061213561181961479062237766620"),
        UInt256("000000000000000000000000000000000000000102797312405202436815976773795958969482"),
        UInt256("000000000000000000000000000000000000000000000000000000000023051931251193218442"),
        UInt256("000000000000000000000000000000000000000001953953567802622125048779101000179576"))
        
        NBKAssertDivision(
        UInt256("096467201117289166187766181030232879447148862859323917044548749804018359008044"),
        UInt256("000000000000000000004646260627574879223760172113656436161581617773435991717024"),
        UInt256("000000000000000000000000000000000000000000000000000000000020762331011904583253"),
        UInt256("000000000000000000002933245778855346947389808606934720764144871598087733608972"))
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Division x Assertions
//*============================================================================*

private func NBKAssertDivision<H: NBKFixedWidthInteger>(
_ dividend: NBKDoubleWidth<H>, _ divisor:   NBKDoubleWidth<H>,
_ quotient: NBKDoubleWidth<H>, _ remainder: NBKDoubleWidth<H>, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(dividend, quotient * divisor + remainder, "dividend != divisor * quotient + remainder", file: file, line: line)
    }
    
    if !overflow {
        XCTAssertEqual(dividend / divisor, quotient,  file: file, line: line)
        XCTAssertEqual(dividend % divisor, remainder, file: file, line: line)
    }
    
    if !overflow {
        XCTAssertEqual({ var x = dividend; x /= divisor; return x }(), quotient,  file: file, line: line)
        XCTAssertEqual({ var x = dividend; x %= divisor; return x }(), remainder, file: file, line: line)
    }
    
    if !overflow {
        let o = dividend.quotientAndRemainder(dividingBy: divisor)
        XCTAssertEqual(o.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(o.remainder, remainder, file: file, line: line)
    }
    
    brr: do {
        let o = dividend.dividedReportingOverflow(by: divisor)
        XCTAssertEqual(o.partialValue, quotient, file: file, line: line)
        XCTAssertEqual(o.overflow,     overflow, file: file, line: line)
    }
    
    brr: do {
        var i = dividend; let o = i.divideReportingOverflow(by: divisor)
        XCTAssertEqual(i, quotient, file: file, line: line)
        XCTAssertEqual(o, overflow, file: file, line: line)
    }

    brr: do {
        let o = dividend.remainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(o.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(o.overflow,     overflow,  file: file, line: line)
    }

    brr: do {
        var i = dividend; let o = i.formRemainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(i, remainder, file: file, line: line)
        XCTAssertEqual(o, overflow,  file: file, line: line)
    }
    
    brr: do {
        let o = dividend.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(o.partialValue.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(o.partialValue.remainder, remainder, file: file, line: line)
        XCTAssertEqual(o.overflow,               overflow,  file: file, line: line)
    }
}

private func NBKAssertDivisionByDigit<H: NBKFixedWidthInteger>(
_ dividend: NBKDoubleWidth<H>, _ divisor:   H.Digit,
_ quotient: NBKDoubleWidth<H>, _ remainder: H.Digit, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    NBKAssertDivision(dividend, T(digit: divisor), quotient, T(digit: remainder), overflow, file: file, line: line)
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(dividend, quotient * divisor + remainder, "dividend != divisor * quotient + remainder", file: file, line: line)
    }
    
    if !overflow {
        XCTAssertEqual(dividend / divisor, quotient,  file: file, line: line)
        XCTAssertEqual(dividend % divisor, remainder, file: file, line: line)
    }
    
    if !overflow {
        XCTAssertEqual({ var x = dividend; x /= divisor; return x }(), quotient,            file: file, line: line)
        XCTAssertEqual({ var x = dividend; x %= divisor; return x }(), T(digit: remainder), file: file, line: line)
    }
    
    if !overflow {
        let o = dividend.quotientAndRemainder(dividingBy: divisor)
        XCTAssertEqual(o.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(o.remainder, remainder, file: file, line: line)
    }
    
    brr: do {
        let o = dividend.dividedReportingOverflow(by: divisor)
        XCTAssertEqual(o.partialValue, quotient, file: file, line: line)
        XCTAssertEqual(o.overflow,     overflow, file: file, line: line)
    }
    
    brr: do {
        var i = dividend; let o = i.divideReportingOverflow(by: divisor)
        XCTAssertEqual(i, quotient, file: file, line: line)
        XCTAssertEqual(o, overflow, file: file, line: line)
    }
    
    brr: do {
        let o = dividend.remainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(o.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(o.overflow,     overflow,  file: file, line: line)
    }
    
    brr: do {
        var i = dividend; let o = i.formRemainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(i, T(digit: remainder), file: file, line: line)
        XCTAssertEqual(o, overflow,            file: file, line: line)
    }
    
    brr: do {
        let o = dividend.quotientAndRemainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(o.partialValue.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(o.partialValue.remainder, remainder, file: file, line: line)
        XCTAssertEqual(o.overflow,               overflow,  file: file, line: line)
    }
    
    brr: do {
        var i = dividend; let o = i.formQuotientWithRemainderReportingOverflow(dividingBy: divisor)
        XCTAssertEqual(i,              quotient,  file: file, line: line)
        XCTAssertEqual(o.partialValue, remainder, file: file, line: line)
        XCTAssertEqual(o.overflow,     overflow,  file: file, line: line)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Full Width
//=----------------------------------------------------------------------------=

private func NBKAssertDivisionFullWidth<H: NBKFixedWidthInteger>(
_ dividend: NBK.Wide2<NBKDoubleWidth<H>>, _ divisor: NBKDoubleWidth<H>,
_ quotient: NBKDoubleWidth<H>, _ remainder: NBKDoubleWidth<H>, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T  = NBKDoubleWidth<H>
    typealias T2 = NBKDoubleWidth<T>
    //=------------------------------------------=
    if !overflow {
        let composite = T2(descending: divisor.multipliedFullWidth(by: quotient)) + T2(remainder)
        XCTAssertEqual( T2(descending: dividend), composite, "dividend != divisor * quotient + remainder", file: file, line: line)
    }
    
    if !overflow {
        let o = divisor.dividingFullWidth(dividend)
        XCTAssertEqual(o.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(o.remainder, remainder, file: file, line: line)
    }
    
    brr: do {
        let o = divisor.dividingFullWidthReportingOverflow(dividend)
        XCTAssertEqual(o.partialValue.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(o.partialValue.remainder, remainder, file: file, line: line)
        XCTAssertEqual(o.overflow,               overflow,  file: file, line: line)
    }
}
