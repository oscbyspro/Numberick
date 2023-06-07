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
// MARK: * NBK x Int256 x Addition
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
        
        NBKAssertAddition(T(descending: HL(.max, .max)), T(-1), T(descending: HL(.max, .max - 1))) // carry 1st
        NBKAssertAddition(T(descending: HL(.min, .max)), T(-1), T(descending: HL(.min, .max - 1))) // carry 2nd
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testAddingDigit() {
        NBKAssertAdditionByDigit(T( 1), Int( 2), T( 3))
        NBKAssertAdditionByDigit(T( 1), Int( 1), T( 2))
        NBKAssertAdditionByDigit(T( 1), Int( 0), T( 1))
        NBKAssertAdditionByDigit(T( 1), Int(-1), T( 0))
        NBKAssertAdditionByDigit(T( 1), Int(-2), T(-1))
        
        NBKAssertAdditionByDigit(T( 0), Int( 2), T( 2))
        NBKAssertAdditionByDigit(T( 0), Int( 1), T( 1))
        NBKAssertAdditionByDigit(T( 0), Int( 0), T( 0))
        NBKAssertAdditionByDigit(T( 0), Int(-1), T(-1))
        NBKAssertAdditionByDigit(T( 0), Int(-2), T(-2))
        
        NBKAssertAdditionByDigit(T(-1), Int( 2), T( 1))
        NBKAssertAdditionByDigit(T(-1), Int( 1), T( 0))
        NBKAssertAdditionByDigit(T(-1), Int( 0), T(-1))
        NBKAssertAdditionByDigit(T(-1), Int(-1), T(-2))
        NBKAssertAdditionByDigit(T(-1), Int(-2), T(-3))
    }
    
    func testAddingDigitUsingLargeValues() {
        NBKAssertAdditionByDigit(T(x64: X(~0, ~0, ~0,  0)),  Int(3), T(x64: X( 2,  0,  0,  1)))
        NBKAssertAdditionByDigit(T(x64: X(~0, ~0, ~0,  0)), -Int(3), T(x64: X(~3, ~0, ~0,  0)))
        NBKAssertAdditionByDigit(T(x64: X( 0,  0,  0, ~0)),  Int(3), T(x64: X( 3,  0,  0, ~0)))
        NBKAssertAdditionByDigit(T(x64: X( 0,  0,  0, ~0)), -Int(3), T(x64: X(~2, ~0, ~0, ~1)))
    }
    
    func testAddingDigitReportingOverflow() {
        NBKAssertAdditionByDigit(T.min, Int( 1), T.min + T(1))
        NBKAssertAdditionByDigit(T.min, Int(-1), T.max,  true)
        NBKAssertAdditionByDigit(T.max, Int( 1), T.min,  true)
        NBKAssertAdditionByDigit(T.max, Int(-1), T.max - T(1))
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
// MARK: * NBK x UInt256 x Addition
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
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=

    func testAddingDigit() {
        NBKAssertAdditionByDigit(T(0), UInt(0), T(0))
        NBKAssertAdditionByDigit(T(0), UInt(1), T(1))
        NBKAssertAdditionByDigit(T(0), UInt(2), T(2))
        
        NBKAssertAdditionByDigit(T(1), UInt(0), T(1))
        NBKAssertAdditionByDigit(T(1), UInt(1), T(2))
        NBKAssertAdditionByDigit(T(1), UInt(2), T(3))
    }
    
    func testAddingDigitUsingLargeValues() {
        NBKAssertAdditionByDigit(T(x64: X( 0,  0,  0,  0)), UInt(3), T(x64: X(3, 0, 0, 0)))
        NBKAssertAdditionByDigit(T(x64: X(~0,  0,  0,  0)), UInt(3), T(x64: X(2, 1, 0, 0)))
        NBKAssertAdditionByDigit(T(x64: X(~0, ~0,  0,  0)), UInt(3), T(x64: X(2, 0, 1, 0)))
        NBKAssertAdditionByDigit(T(x64: X(~0, ~0, ~0,  0)), UInt(3), T(x64: X(2, 0, 0, 1)))
    }
    
    func testAddingDigitReportingOverflow() {
        NBKAssertAdditionByDigit(T.min, UInt(1), T.min + T(1))
        NBKAssertAdditionByDigit(T.max, UInt(1), T.min,  true)
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
