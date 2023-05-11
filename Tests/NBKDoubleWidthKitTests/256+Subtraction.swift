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
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK256X64

//*============================================================================*
// MARK: * Int256 x Subtraction
//*============================================================================*

final class Int256TestsOnSubtraction: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
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
    
    func testSubtractingUsingLargeValues() {
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)), -T(x64: X(3, 0, 0, 0)), T(x64: X( 2,  0,  0,  1)))
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)), -T(x64: X(0, 3, 0, 0)), T(x64: X(~0,  2,  0,  1)))
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)), -T(x64: X(0, 0, 3, 0)), T(x64: X(~0, ~0,  2,  1)))
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)), -T(x64: X(0, 0, 0, 3)), T(x64: X(~0, ~0, ~0,  3)))
        
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)),  T(x64: X(3, 0, 0, 0)), T(x64: X(~3, ~0, ~0,  0)))
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)),  T(x64: X(0, 3, 0, 0)), T(x64: X(~0, ~3, ~0,  0)))
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)),  T(x64: X(0, 0, 3, 0)), T(x64: X(~0, ~0, ~3,  0)))
        NBKAssertSubtraction(T(x64: X(~0, ~0, ~0,  0)),  T(x64: X(0, 0, 0, 3)), T(x64: X(~0, ~0, ~0, ~2)))
        
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)), -T(x64: X(3, 0, 0, 0)), T(x64: X( 3,  0,  0, ~0)))
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)), -T(x64: X(0, 3, 0, 0)), T(x64: X( 0,  3,  0, ~0)))
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)), -T(x64: X(0, 0, 3, 0)), T(x64: X( 0,  0,  3, ~0)))
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)), -T(x64: X(0, 0, 0, 3)), T(x64: X( 0,  0,  0,  2)))
        
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)),  T(x64: X(3, 0, 0, 0)), T(x64: X(~2, ~0, ~0, ~1)))
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)),  T(x64: X(0, 3, 0, 0)), T(x64: X( 0, ~2, ~0, ~1)))
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)),  T(x64: X(0, 0, 3, 0)), T(x64: X( 0,  0, ~2, ~1)))
        NBKAssertSubtraction(T(x64: X( 0,  0,  0, ~0)),  T(x64: X(0, 0, 0, 3)), T(x64: X( 0,  0,  0, ~3)))
    }
    
    func testSubtractingReportingOverflow() {
        NBKAssertSubtraction(T.min, T( 2), T.max - T(1), true )
        NBKAssertSubtraction(T.max, T( 2), T.max - T(2), false)
        
        NBKAssertSubtraction(T.min, T(-2), T.min + T(2), false)
        NBKAssertSubtraction(T.max, T(-2), T.min + T(1), true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
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
// MARK: * UInt256 x Subtraction
//*============================================================================*

final class UInt256TestsOnSubtraction: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
        NBKAssertSubtraction(T(3), T(0), T(3))
        NBKAssertSubtraction(T(3), T(1), T(2))
        NBKAssertSubtraction(T(3), T(2), T(1))
        NBKAssertSubtraction(T(3), T(3), T(0))
    }
    
    func testSubtractingUsingLargeValues() {
        NBKAssertSubtraction(T(x64: X(0, ~0, ~0, ~0)), T(x64: X(3, 0, 0, 0)), T(x64: X(~2, ~1, ~0, ~0)))
        NBKAssertSubtraction(T(x64: X(0, ~0, ~0, ~0)), T(x64: X(0, 3, 0, 0)), T(x64: X( 0, ~3, ~0, ~0)))
        NBKAssertSubtraction(T(x64: X(0, ~0, ~0, ~0)), T(x64: X(0, 0, 3, 0)), T(x64: X( 0, ~0, ~3, ~0)))
        NBKAssertSubtraction(T(x64: X(0, ~0, ~0, ~0)), T(x64: X(0, 0, 0, 3)), T(x64: X( 0, ~0, ~0, ~3)))
    }
    
    func testSubtractingReportingOverflow() {
        NBKAssertSubtraction(T.min, T(2), T.max - T(1), true )
        NBKAssertSubtraction(T.max, T(2), T.max - T(2), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
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
