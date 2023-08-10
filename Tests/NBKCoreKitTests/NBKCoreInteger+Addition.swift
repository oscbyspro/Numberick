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
// MARK: * NBK x Core Integer x Addition
//*============================================================================*

final class NBKCoreIntegerTestsOnAddition: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAdding() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertAddition(T( 1), T( 2), T( 3))
            NBKAssertAddition(T( 1), T( 1), T( 2))
            NBKAssertAddition(T( 1), T( 0), T( 1))
            NBKAssertAddition(T( 1), T(-1), T( 0))
            NBKAssertAddition(T( 1), T(-2), T(-1))
            
            NBKAssertAddition(T( 0), T( 2), T( 2))
            NBKAssertAddition(T( 0), T( 1), T( 1))
            NBKAssertAddition(T( 0), T( 0), T( 0))
            NBKAssertAddition(T( 0), T(-1), T(-1))
            NBKAssertAddition(T( 0), T(-2), T(-2))
            
            NBKAssertAddition(T(-1), T( 2), T( 1))
            NBKAssertAddition(T(-1), T( 1), T( 0))
            NBKAssertAddition(T(-1), T( 0), T(-1))
            NBKAssertAddition(T(-1), T(-1), T(-2))
            NBKAssertAddition(T(-1), T(-2), T(-3))
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertAddition(T(0), T(0), T(0))
            NBKAssertAddition(T(0), T(1), T(1))
            NBKAssertAddition(T(0), T(2), T(2))
            
            NBKAssertAddition(T(1), T(0), T(1))
            NBKAssertAddition(T(1), T(1), T(2))
            NBKAssertAddition(T(1), T(2), T(3))
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testAddingReportingOverflow() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertAddition(T.min, T( 1), T.min + T(1))
            NBKAssertAddition(T.min, T(-1), T.max,  true)
            
            NBKAssertAddition(T.max, T( 1), T.min,  true)
            NBKAssertAddition(T.max, T(-1), T.max - T(1))
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertAddition(T.min, T(1), T.min + T(1))
            NBKAssertAddition(T.max, T(1), T.min,  true)
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
// MARK: * NBK x Core Integer x Addition x Assertions
//*============================================================================*

private func NBKAssertAddition<T: NBKCoreInteger>(
_ lhs: T, _ rhs: T, _ partialValue: T, _ overflow: Bool = false,
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

#endif
