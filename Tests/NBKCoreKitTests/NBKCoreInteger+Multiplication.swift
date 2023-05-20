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
            
            print(T.max.multipliedFullWidth(by: T.max))
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

#endif
