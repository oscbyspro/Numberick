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
        func whereIsSigned<T: NBKCoreInteger>(_ type: T.Type) {
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

        func whereIsUnsigned<T: NBKCoreInteger>(_ type: T.Type) {
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
        func whereIsSigned<T: NBKCoreInteger>(_ type: T.Type) {
            NBKAssertSubtraction(T.min, T( 2), T.max - T(1), true )
            NBKAssertSubtraction(T.max, T( 2), T.max - T(2), false)
            
            NBKAssertSubtraction(T.min, T(-2), T.min + T(2), false)
            NBKAssertSubtraction(T.max, T(-2), T.min + T(1), true )
        }

        func whereIsUnsigned<T: NBKCoreInteger>(_ type: T.Type) {
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

#endif
