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
import XCTest

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
            NBKAssertDivision(T( 0), T( 1), T( 0), T( 0))
            NBKAssertDivision(T( 0), T( 2), T( 0), T( 0))
            NBKAssertDivision(T( 7), T( 1), T( 7), T( 0))
            NBKAssertDivision(T( 7), T( 2), T( 3), T( 1))

            NBKAssertDivision(T( 7), T( 3), T( 2), T( 1))
            NBKAssertDivision(T( 7), T(-3), T(-2), T( 1))
            NBKAssertDivision(T(-7), T( 3), T(-2), T(-1))
            NBKAssertDivision(T(-7), T(-3), T( 2), T(-1))
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDivision(T( 0), T( 1), T( 0), T( 0))
            NBKAssertDivision(T( 0), T( 2), T( 0), T( 0))
            NBKAssertDivision(T( 7), T( 1), T( 7), T( 0))
            NBKAssertDivision(T( 7), T( 2), T( 3), T( 1))
        }

        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }

    func testDividingReportingOverflow() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDivision(T( 0), T( 0), T( 0),     T( 0), true )
            NBKAssertDivision(T( 1), T( 0), T( 1),     T( 1), true )
            NBKAssertDivision(T( 2), T( 0), T( 2),     T( 2), true )
            NBKAssertDivision(T.min, T(-1), T.min,     T( 0), true )
            NBKAssertDivision(T.max, T(-1), T.min + 1, T( 0), false)
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDivision(T( 0), T( 0), T( 0),     T( 0), true)
            NBKAssertDivision(T( 1), T( 0), T( 1),     T( 1), true)
            NBKAssertDivision(T( 2), T( 0), T( 2),     T( 2), true)
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
            dividend.high = T.max / T(2)
            dividend.low  = M( 1)

            NBKAssertDivisionFullWidth(dividend, T.max, T.max, T(  ) - T( ))
            //=----------------------------------=
            dividend.high = T.max / T(2)
            dividend.low  = M.max / M(2)

            NBKAssertDivisionFullWidth(dividend, T.max, T.max, T.max - T(1))
            //=----------------------------------=
            dividend.high = T.max / T(2) + T(1)
            dividend.low  = M(  )

            NBKAssertDivisionFullWidth(dividend, T.min, T.min, T(  ) - T( ))
            //=----------------------------------=
            dividend.high = T.max / T(2) + T(1)
            dividend.low  = M.max / M(2)

            NBKAssertDivisionFullWidth(dividend, T.min, T.min, T.max - T( ))
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            //=----------------------------------=
            var dividend: (high: T, low: M)
            //=----------------------------------=
            dividend.high = T.max - T(1)
            dividend.low  = M( 1)

            NBKAssertDivisionFullWidth(dividend, T.max, T.max, T(  ) - T( ))
            //=----------------------------------=
            dividend.high = T.max - T(1)
            dividend.low  = M.max

            NBKAssertDivisionFullWidth(dividend, T.max, T.max, T.max - T(1))
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

            NBKAssertDivisionFullWidth(dividend, T( 0),  T( 7), T( 7), true )
            //=----------------------------------=
            dividend.high = T(-1)
            dividend.low  = M( 7)
            
            NBKAssertDivisionFullWidth(dividend, T( 0),  T( 7), T( 7), true )
            //=----------------------------------=
            dividend.high = T(  )
            dividend.low  = M(bitPattern: T.max)

            NBKAssertDivisionFullWidth(dividend, T(-1), T.min + T(1), T(0), false)
            //=----------------------------------=
            dividend.high = T(-1)
            dividend.low  = M(bitPattern: T.min)
            
            NBKAssertDivisionFullWidth(dividend, T(-1), T.min + T(0), T(0), true )
            //=----------------------------------=
            dividend.high = T.max >> 1 + T(0)
            dividend.low  = M.max >> 1 + M(0)
            
            NBKAssertDivisionFullWidth(dividend, T.max, T.max, T.max - T(1), false)
            //=----------------------------------=
            dividend.high = T.max >> 1 + T(0)
            dividend.low  = M.max >> 1 + M(1)
            
            NBKAssertDivisionFullWidth(dividend, T.max, T.min, T(  ) - T(0), true )
            //=----------------------------------=
            dividend.high = T.max >> 1 + T(1)
            dividend.low  = M.max >> 1 + M(0)
            
            NBKAssertDivisionFullWidth(dividend, T.min, T.min, T.max - T(0), false)
            //=----------------------------------=
            dividend.high = T.max >> 1 + T(1)
            dividend.low  = M.max >> 1 + M(1)
            
            NBKAssertDivisionFullWidth(dividend, T.min, T.max, T(  ) - T(0), true )
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            //=----------------------------------=
            var dividend: (high: T, low: M)
            //=----------------------------------=
            dividend.high = T(  )
            dividend.low  = M( 7)
            
            NBKAssertDivisionFullWidth(dividend, T( 0), T( 7), T( 7), true)
            //=----------------------------------=
            dividend.high = T.max
            dividend.low  = M( 7)
            
            NBKAssertDivisionFullWidth(dividend, T( 0), T( 7), T( 7), true)
            //=----------------------------------=
            dividend.high = T.max - T(1)
            dividend.low  = M.max
            
            NBKAssertDivisionFullWidth(dividend, T.max, T.max, T.max - T(1), false)
            //=----------------------------------=
            dividend.high = T.max - T(0)
            dividend.low  = M.min
            
            NBKAssertDivisionFullWidth(dividend, T.max, T.min, T.min - T(0), true )
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
            
            NBKAssertDivisionFullWidth(dividend, T(0), ~T(0) << (T.bitWidth - 0), T(0), true )
            NBKAssertDivisionFullWidth(dividend, T(1), ~T(0) << (T.bitWidth - 0), T(0), true )
            NBKAssertDivisionFullWidth(dividend, T(2), ~T(0) << (T.bitWidth - 1), T(0), false)
            NBKAssertDivisionFullWidth(dividend, T(4), ~T(0) << (T.bitWidth - 2), T(0), false)
            NBKAssertDivisionFullWidth(dividend, T(8), ~T(0) << (T.bitWidth - 3), T(0), false)
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            //=----------------------------------=
            let dividend: (high: T, low: M)
            //=----------------------------------=
            dividend.high = T(repeating: true )
            dividend.low  = M(repeating: false)
            
            NBKAssertDivisionFullWidth(dividend, T(0), ~T(0) << (T.bitWidth - 0), T(0), true)
            NBKAssertDivisionFullWidth(dividend, T(1), ~T(0) << (T.bitWidth - 0), T(0), true)
            NBKAssertDivisionFullWidth(dividend, T(2), ~T(0) << (T.bitWidth - 1), T(0), true)
            NBKAssertDivisionFullWidth(dividend, T(4), ~T(0) << (T.bitWidth - 2), T(0), true)
            NBKAssertDivisionFullWidth(dividend, T(8), ~T(0) << (T.bitWidth - 3), T(0), true)
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

#endif
