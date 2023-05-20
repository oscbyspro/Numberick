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
// MARK: * NBK x Core Integer x Negation
//*============================================================================*

final class NBKCoreIntegerTestsOnNegation: XCTestCase {
    
    typealias T = any (NBKCoreInteger).Type
    typealias S = any (NBKCoreInteger & NBKSignedInteger).Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNegating() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger & NBKSignedInteger {
            NBKAssertNegation( T(1), -T(1))
            NBKAssertNegation( T(0),  T(0))
            NBKAssertNegation(-T(1),  T(1))
        }
        
        for case let type as S in types {
            whereIsSigned(type)
        }
    }
    
    func testNegatingReportingOverflow() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger & NBKSignedInteger {
            NBKAssertNegation(T.min, T.min,  true)
            NBKAssertNegation(T.max, T.min + T(1))
        }
        
        for case let type as S in types {
            whereIsSigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguous() {
        func becauseThisCompilesSuccessfully(_ x: inout some NBKCoreInteger & NBKSignedInteger) {
            XCTAssertNotNil(x.negate())
            XCTAssertNotNil(x.negateReportingOverflow())
            
            XCTAssertNotNil(-x)
            XCTAssertNotNil(x.negated())
            XCTAssertNotNil(x.negatedReportingOverflow())
        }
    }
}

#endif
