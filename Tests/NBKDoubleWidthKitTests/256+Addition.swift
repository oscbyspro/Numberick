//=----------------------------------------------------------------------------=
// This source file is part of the AwesomeNumbersKit open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK256X64

//*============================================================================*
// MARK: * Int256 x Addition
//*============================================================================*

final class Int256TestsOnAddition: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAdding() {
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
    
    func testAddingUsingLargeValues() {
        NBKAssertAddition(T(x64: X(~0, ~0, ~0,  0)),  T(x64: X(3, 0, 0, 0)), T(x64: X( 2,  0,  0,  1)))
        NBKAssertAddition(T(x64: X(~0, ~0, ~0,  0)),  T(x64: X(0, 3, 0, 0)), T(x64: X(~0,  2,  0,  1)))
        NBKAssertAddition(T(x64: X(~0, ~0, ~0,  0)),  T(x64: X(0, 0, 3, 0)), T(x64: X(~0, ~0,  2,  1)))
        NBKAssertAddition(T(x64: X(~0, ~0, ~0,  0)),  T(x64: X(0, 0, 0, 3)), T(x64: X(~0, ~0, ~0,  3)))
        
        NBKAssertAddition(T(x64: X(~0, ~0, ~0,  0)), -T(x64: X(3, 0, 0, 0)), T(x64: X(~3, ~0, ~0,  0)))
        NBKAssertAddition(T(x64: X(~0, ~0, ~0,  0)), -T(x64: X(0, 3, 0, 0)), T(x64: X(~0, ~3, ~0,  0)))
        NBKAssertAddition(T(x64: X(~0, ~0, ~0,  0)), -T(x64: X(0, 0, 3, 0)), T(x64: X(~0, ~0, ~3,  0)))
        NBKAssertAddition(T(x64: X(~0, ~0, ~0,  0)), -T(x64: X(0, 0, 0, 3)), T(x64: X(~0, ~0, ~0, ~2)))
        
        NBKAssertAddition(T(x64: X( 0,  0,  0, ~0)),  T(x64: X(3, 0, 0, 0)), T(x64: X( 3,  0,  0, ~0)))
        NBKAssertAddition(T(x64: X( 0,  0,  0, ~0)),  T(x64: X(0, 3, 0, 0)), T(x64: X( 0,  3,  0, ~0)))
        NBKAssertAddition(T(x64: X( 0,  0,  0, ~0)),  T(x64: X(0, 0, 3, 0)), T(x64: X( 0,  0,  3, ~0)))
        NBKAssertAddition(T(x64: X( 0,  0,  0, ~0)),  T(x64: X(0, 0, 0, 3)), T(x64: X( 0,  0,  0,  2)))
        
        NBKAssertAddition(T(x64: X( 0,  0,  0, ~0)), -T(x64: X(3, 0, 0, 0)), T(x64: X(~2, ~0, ~0, ~1)))
        NBKAssertAddition(T(x64: X( 0,  0,  0, ~0)), -T(x64: X(0, 3, 0, 0)), T(x64: X( 0, ~2, ~0, ~1)))
        NBKAssertAddition(T(x64: X( 0,  0,  0, ~0)), -T(x64: X(0, 0, 3, 0)), T(x64: X( 0,  0, ~2, ~1)))
        NBKAssertAddition(T(x64: X( 0,  0,  0, ~0)), -T(x64: X(0, 0, 0, 3)), T(x64: X( 0,  0,  0, ~3)))
    }
    
    func testAddingReportingOverflow() {
        NBKAssertAddition(T.min, T( 1), T.min + T(1))
        NBKAssertAddition(T.min, T(-1), T.max,  true)
        
        NBKAssertAddition(T.max, T( 1), T.min,  true)
        NBKAssertAddition(T.max, T(-1), T.max - T(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
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
// MARK: * UInt256 x Addition
//*============================================================================*

final class UInt256TestsOnAddition: XCTestCase {

    typealias T = UInt256

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testAdding() {
        NBKAssertAddition(T(0), T(0), T(0))
        NBKAssertAddition(T(0), T(1), T(1))
        NBKAssertAddition(T(0), T(2), T(2))
        
        NBKAssertAddition(T(1), T(0), T(1))
        NBKAssertAddition(T(1), T(1), T(2))
        NBKAssertAddition(T(1), T(2), T(3))
    }
    
    func testAddingUsingLargeValues() {
        NBKAssertAddition(T(x64: X(~0, ~0, ~0,  0)), T(x64: X(3, 0, 0, 0)), T(x64: X( 2,  0,  0,  1)))
        NBKAssertAddition(T(x64: X(~0, ~0, ~0,  0)), T(x64: X(0, 3, 0, 0)), T(x64: X(~0,  2,  0,  1)))
        NBKAssertAddition(T(x64: X(~0, ~0, ~0,  0)), T(x64: X(0, 0, 3, 0)), T(x64: X(~0, ~0,  2,  1)))
        NBKAssertAddition(T(x64: X(~0, ~0, ~0,  0)), T(x64: X(0, 0, 0, 3)), T(x64: X(~0, ~0, ~0,  3)))
    }
    
    func testAddingReportingOverflow() {
        NBKAssertAddition(T.min, T(1), T.min + T(1))
        NBKAssertAddition(T.max, T(1), T.min,  true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  += 0)
            XCTAssertNotNil(x &+= 0)
            XCTAssertNotNil(x.addReportingOverflow(0))
            
            XCTAssertNotNil(x  +  0)
            XCTAssertNotNil(x &+  0)
            XCTAssertNotNil(x.addingReportingOverflow(0))
        }
    }
}

#endif
