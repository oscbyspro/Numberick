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
    
    func testQuotientAndRemainderReportingOverflow() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            var x: PVO<QR<T, T>>
            //=----------------------------------=
            // Divisor: 0, -1
            //=----------------------------------=
            x = T(7).quotientAndRemainderReportingOverflow(dividingBy: T( 0))
            XCTAssertEqual(x.partialValue.quotient,  T( 7))
            XCTAssertEqual(x.partialValue.remainder, T( 7))
            XCTAssertEqual(x.overflow, true)
            //=----------------------------------=
            x = T.min.quotientAndRemainderReportingOverflow(dividingBy: T(-1))
            XCTAssertEqual(x.partialValue.quotient,  T.min)
            XCTAssertEqual(x.partialValue.remainder, T( 0))
            XCTAssertEqual(x.overflow, true)
            //=----------------------------------=
            // Standard
            //=----------------------------------=
            x = T( 7).quotientAndRemainderReportingOverflow(dividingBy: T( 3))
            XCTAssertEqual(x.partialValue.quotient,  T( 2))
            XCTAssertEqual(x.partialValue.remainder, T( 1))
            XCTAssertEqual(x.overflow, false)
            //=----------------------------------=
            x = T( 7).quotientAndRemainderReportingOverflow(dividingBy: T(-3))
            XCTAssertEqual(x.partialValue.quotient,  T(-2))
            XCTAssertEqual(x.partialValue.remainder, T( 1))
            XCTAssertEqual(x.overflow, false)
            //=----------------------------------=
            x = T(-7).quotientAndRemainderReportingOverflow(dividingBy: T( 3))
            XCTAssertEqual(x.partialValue.quotient,  T(-2))
            XCTAssertEqual(x.partialValue.remainder, T(-1))
            XCTAssertEqual(x.overflow, false)
            //=----------------------------------=
            x = T(-7).quotientAndRemainderReportingOverflow(dividingBy: T(-3))
            XCTAssertEqual(x.partialValue.quotient,  T( 2))
            XCTAssertEqual(x.partialValue.remainder, T(-1))
            XCTAssertEqual(x.overflow, false)
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            var x: PVO<QR<T, T>>
            //=----------------------------------=
            x = T(7).quotientAndRemainderReportingOverflow(dividingBy: T(0))
            XCTAssertEqual(x.partialValue.quotient,  T(7))
            XCTAssertEqual(x.partialValue.remainder, T(7))
            XCTAssertEqual(x.overflow, true)
            //=----------------------------------=
            x = T(7).quotientAndRemainderReportingOverflow(dividingBy: T(1))
            XCTAssertEqual(x.partialValue.quotient,  T(7))
            XCTAssertEqual(x.partialValue.remainder, T(0))
            XCTAssertEqual(x.overflow, false)
            //=----------------------------------=
            x = T(7).quotientAndRemainderReportingOverflow(dividingBy: T(2))
            XCTAssertEqual(x.partialValue.quotient,  T(3))
            XCTAssertEqual(x.partialValue.remainder, T(1))
            XCTAssertEqual(x.overflow, false)
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
