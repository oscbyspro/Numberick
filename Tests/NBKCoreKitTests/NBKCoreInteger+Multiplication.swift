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
// MARK: * NBK x Core Integer x Multiplication
//*============================================================================*

final class NBKCoreIntegerTestsOnMultiplication: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplying() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertMultiplication(T( 3), T( 0), T( 0))
            NBKAssertMultiplication(T( 3), T(-0), T(-0))
            NBKAssertMultiplication(T(-3), T( 0), T(-0))
            NBKAssertMultiplication(T(-3), T(-0), T( 0))
            
            NBKAssertMultiplication(T( 3), T( 1), T( 3))
            NBKAssertMultiplication(T( 3), T(-1), T(-3))
            NBKAssertMultiplication(T(-3), T( 1), T(-3))
            NBKAssertMultiplication(T(-3), T(-1), T( 3))
            
            NBKAssertMultiplication(T( 3), T( 2), T( 6))
            NBKAssertMultiplication(T( 3), T(-2), T(-6))
            NBKAssertMultiplication(T(-3), T( 2), T(-6))
            NBKAssertMultiplication(T(-3), T(-2), T( 6))
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertMultiplication(T( 3), T( 0), T( 0))
            NBKAssertMultiplication(T( 3), T( 1), T( 3))
            NBKAssertMultiplication(T( 3), T( 2), T( 6))
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }

    func testMultiplyingReportingOverflow() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertMultiplication(T.max, T( 1), T.max,        T( 0), false)
            NBKAssertMultiplication(T.max, T(-1), T.min + T(1), T(-1), false)
            NBKAssertMultiplication(T.min, T( 1), T.min,        T(-1), false)
            NBKAssertMultiplication(T.min, T(-1), T.min,        T( 0), true )
            
            NBKAssertMultiplication(T.max, T( 2), T(-2),        T( 0), true )
            NBKAssertMultiplication(T.max, T(-2), T( 2),        T(-1), true )
            NBKAssertMultiplication(T.min, T( 2), T( 0),        T(-1), true )
            NBKAssertMultiplication(T.min, T(-2), T( 0),        T( 1), true )
            
            NBKAssertMultiplication(T.max, T.max, T( 1), T.max >> (1),              true)
            NBKAssertMultiplication(T.max, T.min, T.min, T(-1) << (T.bitWidth - 2), true)
            NBKAssertMultiplication(T.min, T.max, T.min, T(-1) << (T.bitWidth - 2), true)
            NBKAssertMultiplication(T.min, T.min, T( 0), T( 1) << (T.bitWidth - 2), true)
        }

        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertMultiplication(T.max, T( 2), ~T(1),  T(1), true)
            NBKAssertMultiplication(T.max, T.max,  T(1), ~T(1), true)
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
            XCTAssertNotNil(x  *= 0)
            XCTAssertNotNil(x &*= 0)
            XCTAssertNotNil(x.multiplyReportingOverflow(by: 0))
            XCTAssertNotNil(x.multiplyFullWidth(by: 0))
            
            XCTAssertNotNil(x  *  0)
            XCTAssertNotNil(x &*  0)
            XCTAssertNotNil(x.multipliedReportingOverflow(by: 0))
            XCTAssertNotNil(x.multipliedFullWidth(by: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Core Integer x Multiplication x Assertions
//*============================================================================*

private func NBKAssertMultiplication<T: NBKCoreInteger>(
_ lhs: T, _ rhs: T, _ low: T, _ high: T? = nil, _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    let high = high ?? T(repeating: low.isLessThanZero)
    //=------------------------------------------=
    if !overflow {
        XCTAssertEqual(                 lhs *  rhs,                 low, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs *= rhs; return lhs }(), low, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(                 lhs &*  rhs,                 low, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs &*= rhs; return lhs }(), low, file: file, line: line)
        
    XCTAssertEqual(lhs.multipliedReportingOverflow(by: rhs).partialValue, low,      file: file, line: line)
    XCTAssertEqual(lhs.multipliedReportingOverflow(by: rhs).overflow,     overflow, file: file, line: line)
    
    XCTAssertEqual({ var x = lhs; let _ = x.multiplyReportingOverflow(by: rhs); return x }(), low,      file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.multiplyReportingOverflow(by: rhs); return o }(), overflow, file: file, line: line)
    
    XCTAssertEqual(T(bitPattern: lhs.multipliedFullWidth(by: rhs).low), low,  file: file, line: line)
    XCTAssertEqual(/*---------*/ lhs.multipliedFullWidth(by: rhs).high, high, file: file, line: line)

    XCTAssertEqual({ var x = lhs; let _ = x.multiplyFullWidth(by: rhs); return x }(), low,  file: file, line: line)
    XCTAssertEqual({ var x = lhs; let o = x.multiplyFullWidth(by: rhs); return o }(), high, file: file, line: line)
}
