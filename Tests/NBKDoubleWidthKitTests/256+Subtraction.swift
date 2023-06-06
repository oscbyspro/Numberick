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
// MARK: * NBK x Int256 x Subtraction
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
        
        NBKAssertSubtraction(T(descending: HL(.min, .min)), T(-1), T(descending: HL(.min, .min + 1)), false) // carry 1st
        NBKAssertSubtraction(T(descending: HL(.max, .min)), T(-1), T(descending: HL(.max, .min + 1)), false) // carry 2nd
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigit() {
        NBKAssertSubtractionByDigit(T( 1), Int( 2), T(-1))
        NBKAssertSubtractionByDigit(T( 1), Int( 1), T( 0))
        NBKAssertSubtractionByDigit(T( 1), Int( 0), T( 1))
        NBKAssertSubtractionByDigit(T( 1), Int(-1), T( 2))
        NBKAssertSubtractionByDigit(T( 1), Int(-2), T( 3))
        
        NBKAssertSubtractionByDigit(T( 0), Int( 2), T(-2))
        NBKAssertSubtractionByDigit(T( 0), Int( 1), T(-1))
        NBKAssertSubtractionByDigit(T( 0), Int( 0), T( 0))
        NBKAssertSubtractionByDigit(T( 0), Int(-1), T( 1))
        NBKAssertSubtractionByDigit(T( 0), Int(-2), T( 2))
        
        NBKAssertSubtractionByDigit(T(-1), Int( 2), T(-3))
        NBKAssertSubtractionByDigit(T(-1), Int( 1), T(-2))
        NBKAssertSubtractionByDigit(T(-1), Int( 0), T(-1))
        NBKAssertSubtractionByDigit(T(-1), Int(-1), T( 0))
        NBKAssertSubtractionByDigit(T(-1), Int(-2), T( 1))
    }
    
    func testSubtractingDigitUsingLargeValues() {
        NBKAssertSubtractionByDigit(T(x64: X(~0, ~0, ~0,  0)), -Int(3), T(x64: X( 2,  0,  0,  1)))
        NBKAssertSubtractionByDigit(T(x64: X(~0, ~0, ~0,  0)),  Int(3), T(x64: X(~3, ~0, ~0,  0)))
        NBKAssertSubtractionByDigit(T(x64: X( 0,  0,  0, ~0)), -Int(3), T(x64: X( 3,  0,  0, ~0)))
        NBKAssertSubtractionByDigit(T(x64: X( 0,  0,  0, ~0)),  Int(3), T(x64: X(~2, ~0, ~0, ~1)))
    }
    
    func testSubtractingDigitReportingOverflow() {
        NBKAssertSubtractionByDigit(T.min, Int( 2), T.max - T(1), true )
        NBKAssertSubtractionByDigit(T.min, Int(-2), T.min + T(2), false)
        NBKAssertSubtractionByDigit(T.max, Int( 2), T.max - T(2), false)
        NBKAssertSubtractionByDigit(T.max, Int(-2), T.min + T(1), true )
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
// MARK: * NBK x UInt256 x Subtraction
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
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigit() {
        NBKAssertSubtractionByDigit(T(3), UInt(0), T(3))
        NBKAssertSubtractionByDigit(T(3), UInt(1), T(2))
        NBKAssertSubtractionByDigit(T(3), UInt(2), T(1))
        NBKAssertSubtractionByDigit(T(3), UInt(3), T(0))
    }
    
    func testSubtractingDigitUsingLargeValues() {
        NBKAssertSubtractionByDigit(T(x64: X(~0, ~0, ~0, ~0)), UInt(3), T(x64: X(~3, ~0, ~0, ~0)))
        NBKAssertSubtractionByDigit(T(x64: X( 0, ~0, ~0, ~0)), UInt(3), T(x64: X(~2, ~1, ~0, ~0)))
        NBKAssertSubtractionByDigit(T(x64: X( 0,  0, ~0, ~0)), UInt(3), T(x64: X(~2, ~0, ~1, ~0)))
        NBKAssertSubtractionByDigit(T(x64: X( 0,  0,  0, ~0)), UInt(3), T(x64: X(~2, ~0, ~0, ~1)))
    }
    
    func testSubtractingDigitReportingOverflow() {
        NBKAssertSubtractionByDigit(T.min, UInt(2), T.max - T(1), true )
        NBKAssertSubtractionByDigit(T.max, UInt(2), T.max - T(2), false)
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
