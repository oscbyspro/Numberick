//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Core Integer x Subtraction
//*============================================================================*

final class NBKCoreIntegerTestsOnSubtraction: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
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

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertSubtraction(T(3), T(0), T(3))
            NBKAssertSubtraction(T(3), T(1), T(2))
            NBKAssertSubtraction(T(3), T(2), T(1))
            NBKAssertSubtraction(T(3), T(3), T(0))
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testSubtractingReportingOverflow() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertSubtraction(T.min, T( 2), T.max - T(1), true )
            NBKAssertSubtraction(T.max, T( 2), T.max - T(2), false)
            
            NBKAssertSubtraction(T.min, T(-2), T.min + T(2), false)
            NBKAssertSubtraction(T.max, T(-2), T.min + T(1), true )
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertSubtraction(T.min, T(2), T.max - T(1), true )
            NBKAssertSubtraction(T.max, T(2), T.max - T(2), false)
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
// MARK: * NBK x Core Integer x Subtraction x Assertions
//*============================================================================*

private func NBKAssertSubtraction<T: NBKCoreInteger>(
_ lhs: T, _ rhs: T, _ partialValue: T, _ overflow: Bool = false,
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
