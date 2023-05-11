//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * Int256 x Negation
//*============================================================================*

final class Int256TestsOnNegation: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNegating() {
        NBKAssertNegation( T(1), -T(1))
        NBKAssertNegation( T(0),  T(0))
        NBKAssertNegation(-T(1),  T(1))
    }
    
    func testNegatingReportingOverflow() {
        NBKAssertNegation(T.min, T.min,  true)
        NBKAssertNegation(T.max, T.min + T(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguous() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x.negate())
            XCTAssertNotNil(x.negateReportingOverflow())
            
            XCTAssertNotNil(-x)
            XCTAssertNotNil(x.negated())
            XCTAssertNotNil(x.negatedReportingOverflow())
        }
    }
}

#endif
