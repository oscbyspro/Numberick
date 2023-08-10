//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import XCTest
#if !COCOAPODS
import NBKCoreKit
#else
import Numberick
#endif

//*============================================================================*
// MARK: * NBK x Core Integer x Division
//*============================================================================*

final class NBKCoreIntegerTestsOnDivision: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividing() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDivision(T(  ), T( 1), T(  ), T(  ))
            NBKAssertDivision(T(  ), T( 2), T(  ), T(  ))
            NBKAssertDivision(T( 7), T( 1), T( 7), T(  ))
            NBKAssertDivision(T( 7), T( 2), T( 3), T( 1))

            NBKAssertDivision(T( 7), T( 3), T( 2), T( 1))
            NBKAssertDivision(T( 7), T(-3), T(-2), T( 1))
            NBKAssertDivision(T(-7), T( 3), T(-2), T(-1))
            NBKAssertDivision(T(-7), T(-3), T( 2), T(-1))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDivision(T(  ), T( 1), T(  ), T(  ))
            NBKAssertDivision(T(  ), T( 2), T(  ), T(  ))
            NBKAssertDivision(T( 7), T( 1), T( 7), T(  ))
            NBKAssertDivision(T( 7), T( 2), T( 3), T( 1))
        }

        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }

    func testDividingReportingOverflow() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDivision(T(  ), T(  ), T(  ),     T(  ), true)
            NBKAssertDivision(T( 1), T(  ), T( 1),     T( 1), true)
            NBKAssertDivision(T( 2), T(  ), T( 2),     T( 2), true)
            NBKAssertDivision(T.min, T(-1), T.min,     T(  ), true)
            NBKAssertDivision(T.max, T(-1), T.min + 1, T(  ))
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDivision(T(  ), T(  ), T(  ),     T(  ), true)
            NBKAssertDivision(T( 1), T(  ), T( 1),     T( 1), true)
            NBKAssertDivision(T( 2), T(  ), T( 2),     T( 2), true)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Full Width
    //=------------------------------------------------------------------------=
    
    func testDividingFullWidth() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            //=----------------------------------=
            var dividend: (high: T, low: M)
            //=----------------------------------=
            dividend.high = T.max / 2
            dividend.low  = M( 1)

            NBKAssertDivisionFullWidth(dividend, T.max, T.max, T(  ))
            //=----------------------------------=
            dividend.high = T.max / 2
            dividend.low  = M.max / 2

            NBKAssertDivisionFullWidth(dividend, T.max, T.max, T.max - 1)
            //=----------------------------------=
            dividend.high = T.max / 2 + 1
            dividend.low  = M(  )

            NBKAssertDivisionFullWidth(dividend, T.min, T.min, T(  ))
            //=----------------------------------=
            dividend.high = T.max / 2 + 1
            dividend.low  = M.max / 2

            NBKAssertDivisionFullWidth(dividend, T.min, T.min, T.max)
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            //=----------------------------------=
            var dividend: (high: T, low: M)
            //=----------------------------------=
            dividend.high = T.max - 1
            dividend.low  = M( 1)

            NBKAssertDivisionFullWidth(dividend, T.max, T.max, T(  ))
            //=----------------------------------=
            dividend.high = T.max - 1
            dividend.low  = M.max

            NBKAssertDivisionFullWidth(dividend, T.max, T.max, T.max - 1)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testDividingFullWidthReportingOverflow() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            //=----------------------------------=
            var dividend: (high: T, low: M)
            //=----------------------------------=
            dividend.high = T(  )
            dividend.low  = M( 7)

            NBKAssertDivisionFullWidth(dividend, T(  ), T( 7), T( 7), true)
            //=----------------------------------=
            dividend.high = T(-1)
            dividend.low  = M( 7)
            
            NBKAssertDivisionFullWidth(dividend, T(  ), T( 7), T( 7), true)
            //=--------------------------------------=
            dividend.high = T(-1)
            dividend.low  = M.max
            
            NBKAssertDivisionFullWidth(dividend, T( 2), T(  ), T(-1))
            //=--------------------------------------=
            dividend.high = T(  )
            dividend.low  = M( 1)
            
            NBKAssertDivisionFullWidth(dividend, T(-2), T(  ), T( 1))
            //=----------------------------------=
            dividend.high = T(  )
            dividend.low  = M(bitPattern: T.max)

            NBKAssertDivisionFullWidth(dividend, T(-1), T.min + 1, T(  ))
            //=----------------------------------=
            dividend.high = T(-1)
            dividend.low  = M(bitPattern: T.min)
            
            NBKAssertDivisionFullWidth(dividend, T(-1), T.min, T(  ), true)
            //=----------------------------------=
            dividend.high = T.max >> 1
            dividend.low  = M.max >> 1
            
            NBKAssertDivisionFullWidth(dividend, T.max, T.max, T.max - 1)
            //=----------------------------------=
            dividend.high = T.max >> 1
            dividend.low  = M.max >> 1 + 1
            
            NBKAssertDivisionFullWidth(dividend, T.max, T.min, T(  ), true)
            //=----------------------------------=
            dividend.high = T.max >> 1 + 1
            dividend.low  = M.max >> 1
            
            NBKAssertDivisionFullWidth(dividend, T.min, T.min, T.max)
            //=----------------------------------=
            dividend.high = T.max >> 1 + 1
            dividend.low  = M.max >> 1 + 1
            
            NBKAssertDivisionFullWidth(dividend, T.min, T.max, T(  ), true)
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            //=----------------------------------=
            var dividend: (high: T, low: M)
            //=----------------------------------=
            dividend.high = T(  )
            dividend.low  = M( 7)
            
            NBKAssertDivisionFullWidth(dividend, T(  ), T( 7), T( 7), true)
            //=----------------------------------=
            dividend.high = T.max
            dividend.low  = M( 7)
            
            NBKAssertDivisionFullWidth(dividend, T(  ), T( 7), T( 7), true)
            //=----------------------------------=
            dividend.high = T.max - 1
            dividend.low  = M.max
            
            NBKAssertDivisionFullWidth(dividend, T.max, T.max, T.max - 1)
            //=----------------------------------=
            dividend.high = T.max
            dividend.low  = M.min
            
            NBKAssertDivisionFullWidth(dividend, T.max, T.min, T.min, true)
        }
                
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testDividingFullWidthReportingOverflowTruncatesQuotient() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            //=----------------------------------=
            let dividend: (high: T, low: M)
            //=----------------------------------=
            dividend.high = T(repeating: true )
            dividend.low  = M(repeating: false)
            
            NBKAssertDivisionFullWidth(dividend, T( ), ~T( ) << (T.bitWidth - 0), T( ), true)
            NBKAssertDivisionFullWidth(dividend, T(1), ~T( ) << (T.bitWidth - 0), T( ), true)
            NBKAssertDivisionFullWidth(dividend, T(2), ~T( ) << (T.bitWidth - 1), T( ))
            NBKAssertDivisionFullWidth(dividend, T(4), ~T( ) << (T.bitWidth - 2), T( ))
            NBKAssertDivisionFullWidth(dividend, T(8), ~T( ) << (T.bitWidth - 3), T( ))
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            //=----------------------------------=
            let dividend: (high: T, low: M)
            //=----------------------------------=
            dividend.high = T(repeating: true )
            dividend.low  = M(repeating: false)
            
            NBKAssertDivisionFullWidth(dividend, T( ), ~T( ) << (T.bitWidth - 0), T( ), true)
            NBKAssertDivisionFullWidth(dividend, T(1), ~T( ) << (T.bitWidth - 0), T( ), true)
            NBKAssertDivisionFullWidth(dividend, T(2), ~T( ) << (T.bitWidth - 1), T( ), true)
            NBKAssertDivisionFullWidth(dividend, T(4), ~T( ) << (T.bitWidth - 2), T( ), true)
            NBKAssertDivisionFullWidth(dividend, T(8), ~T( ) << (T.bitWidth - 3), T( ), true)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout some NBKCoreInteger) {
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
// MARK: * NBK x Core Integer x Division x Assertions
//*============================================================================*

private func NBKAssertDivision<T: NBKCoreInteger>(
_ lhs: T, _ rhs: T, _ quotient: T, _ remainder: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
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

//=----------------------------------------------------------------------------=
// MARK: + Full Width
//=----------------------------------------------------------------------------=

private func NBKAssertDivisionFullWidth<T: NBKCoreInteger>(
_ lhs: HL<T, T.Magnitude>, _ rhs: T, _ quotient: T, _ remainder: T, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    if !overflow {
        let qr: QR<T, T> = rhs.dividingFullWidth(lhs)
        XCTAssertEqual(qr.quotient,  quotient,  file: file, line: line)
        XCTAssertEqual(qr.remainder, remainder, file: file, line: line)
    }
    
    let qro: PVO<QR<T, T>> = rhs.dividingFullWidthReportingOverflow(lhs)
    XCTAssertEqual(qro.partialValue.quotient,  quotient,  file: file, line: line)
    XCTAssertEqual(qro.partialValue.remainder, remainder, file: file, line: line)
    XCTAssertEqual(qro.overflow,               overflow,  file: file, line: line)
}

#endif
