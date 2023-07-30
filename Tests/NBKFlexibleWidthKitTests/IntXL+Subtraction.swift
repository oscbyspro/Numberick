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
import NBKFlexibleWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x IntXL x Subtraction
//*============================================================================*

final class IntXLTestsOnSubtraction: XCTestCase {
    
    typealias T = IntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
        NBKAssertSubtraction(T( 1), T( 2), Int(0), T(-1))
        NBKAssertSubtraction(T( 1), T( 1), Int(0), T( 0))
        NBKAssertSubtraction(T( 1), T( 0), Int(0), T( 1))
        NBKAssertSubtraction(T( 1), T(-1), Int(0), T( 2))
        NBKAssertSubtraction(T( 1), T(-2), Int(0), T( 3))
        
        NBKAssertSubtraction(T( 0), T( 2), Int(0), T(-2))
        NBKAssertSubtraction(T( 0), T( 1), Int(0), T(-1))
        NBKAssertSubtraction(T( 0), T( 0), Int(0), T( 0))
        NBKAssertSubtraction(T( 0), T(-1), Int(0), T( 1))
        NBKAssertSubtraction(T( 0), T(-2), Int(0), T( 2))
        
        NBKAssertSubtraction(T(-1), T( 2), Int(0), T(-3))
        NBKAssertSubtraction(T(-1), T( 1), Int(0), T(-2))
        NBKAssertSubtraction(T(-1), T( 0), Int(0), T(-1))
        NBKAssertSubtraction(T(-1), T(-1), Int(0), T( 0))
        NBKAssertSubtraction(T(-1), T(-2), Int(0), T( 1))
    }
    
    func testSubtractingAtIndex() {
        NBKAssertSubtraction(T(words:[~0, ~0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[~1, ~2, ~3, ~0] as W))
        NBKAssertSubtraction(T(words:[ 0, ~0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[~0, ~3, ~3, ~0] as W))
        NBKAssertSubtraction(T(words:[ 0,  0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[~0, ~2, ~4, ~0] as W))
        NBKAssertSubtraction(T(words:[ 0,  0,  0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[~0, ~2, ~3, ~1] as W))
        
        NBKAssertSubtraction(T(words:[~0, ~0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[~0, ~1, ~2, ~3] as W))
        NBKAssertSubtraction(T(words:[ 0, ~0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[ 0, ~1, ~2, ~3] as W))
        NBKAssertSubtraction(T(words:[ 0,  0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[ 0, ~0, ~3, ~3] as W))
        NBKAssertSubtraction(T(words:[ 0,  0,  0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[ 0, ~0, ~2, ~4] as W))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigit() {
        NBKAssertSubtractionByDigit(T( 1), Int( 2), Int(0), T(-1))
        NBKAssertSubtractionByDigit(T( 1), Int( 1), Int(0), T( 0))
        NBKAssertSubtractionByDigit(T( 1), Int( 0), Int(0), T( 1))
        NBKAssertSubtractionByDigit(T( 1), Int(-1), Int(0), T( 2))
        NBKAssertSubtractionByDigit(T( 1), Int(-2), Int(0), T( 3))
        
        NBKAssertSubtractionByDigit(T( 0), Int( 2), Int(0), T(-2))
        NBKAssertSubtractionByDigit(T( 0), Int( 1), Int(0), T(-1))
        NBKAssertSubtractionByDigit(T( 0), Int( 0), Int(0), T( 0))
        NBKAssertSubtractionByDigit(T( 0), Int(-1), Int(0), T( 1))
        NBKAssertSubtractionByDigit(T( 0), Int(-2), Int(0), T( 2))
        
        NBKAssertSubtractionByDigit(T(-1), Int( 2), Int(0), T(-3))
        NBKAssertSubtractionByDigit(T(-1), Int( 1), Int(0), T(-2))
        NBKAssertSubtractionByDigit(T(-1), Int( 0), Int(0), T(-1))
        NBKAssertSubtractionByDigit(T(-1), Int(-1), Int(0), T( 0))
        NBKAssertSubtractionByDigit(T(-1), Int(-2), Int(0), T( 1))
    }
    
    func testSubtractingDigitAtIndex() {
        NBKAssertSubtractionByDigit(T(words:[~0, ~0, ~0, ~0] as W), Int(3), Int(0), T(words:[~3, ~0, ~0, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0, ~0, ~0, ~0] as W), Int(3), Int(0), T(words:[~2, ~1, ~0, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0,  0, ~0, ~0] as W), Int(3), Int(0), T(words:[~2, ~0, ~1, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0,  0,  0, ~0] as W), Int(3), Int(0), T(words:[~2, ~0, ~0, ~1] as W))
        
        NBKAssertSubtractionByDigit(T(words:[~0, ~0, ~0, ~0] as W), Int(3), Int(1), T(words:[~0, ~3, ~0, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0, ~0, ~0, ~0] as W), Int(3), Int(1), T(words:[ 0, ~3, ~0, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0,  0, ~0, ~0] as W), Int(3), Int(1), T(words:[ 0, ~2, ~1, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0,  0,  0, ~0] as W), Int(3), Int(1), T(words:[ 0, ~2, ~0, ~1] as W))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  -= 0)
            XCTAssertNotNil(x.subtract(0, at: 0))
            
            XCTAssertNotNil(x  -  0)
            XCTAssertNotNil(x.subtracting(0, at: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x UIntXL x Subtraction
//*============================================================================*

final class UIntXLTestsOnSubtraction: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
        NBKAssertSubtraction(T(3), T(0), Int(0),  T(3))
        NBKAssertSubtraction(T(3), T(1), Int(0),  T(2))
        NBKAssertSubtraction(T(3), T(2), Int(0),  T(1))
        NBKAssertSubtraction(T(3), T(3), Int(0),  T(0))
    }
    
    func testSubtractingReportingOverflow() {
        NBKAssertSubtraction(T(1), T(0), Int(0), T(words:[ 1] as W))
        NBKAssertSubtraction(T(1), T(1), Int(0), T(words:[ 0] as W))
        NBKAssertSubtraction(T(1), T(2), Int(0), T(words:[~0] as W), true)
        NBKAssertSubtraction(T(1), T(3), Int(0), T(words:[~1] as W), true)
    }
    
    func testSubtractingAtIndex() {
        NBKAssertSubtraction(T(words:[~0, ~0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[~1, ~2, ~3, ~0] as W))
        NBKAssertSubtraction(T(words:[ 0, ~0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[~0, ~3, ~3, ~0] as W))
        NBKAssertSubtraction(T(words:[ 0,  0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[~0, ~2, ~4, ~0] as W))
        NBKAssertSubtraction(T(words:[ 0,  0,  0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[~0, ~2, ~3, ~1] as W))
        
        NBKAssertSubtraction(T(words:[~0, ~0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[~0, ~1, ~2, ~3] as W))
        NBKAssertSubtraction(T(words:[ 0, ~0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[ 0, ~1, ~2, ~3] as W))
        NBKAssertSubtraction(T(words:[ 0,  0, ~0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[ 0, ~0, ~3, ~3] as W))
        NBKAssertSubtraction(T(words:[ 0,  0,  0, ~0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[ 0, ~0, ~2, ~4] as W))
    }
    
    func testSubtractingAtIndexReportingOverflow() {
        NBKAssertSubtraction(T(words:[ 1,  2,  3,  0] as W), T(words:[ 4,  5,  0,  0] as W), Int(0), T(words:[~2, ~3,  2,  0] as W))
        NBKAssertSubtraction(T(words:[ 1,  2,  3,  0] as W), T(words:[ 4,  5,  0,  0] as W), Int(1), T(words:[ 1, ~1, ~2,  0] as W), true)
        NBKAssertSubtraction(T(words:[ 1,  2,  3,  0] as W), T(words:[ 4,  5,  0,  0] as W), Int(2), T(words:[ 1,  2, ~0, ~5] as W), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigit() {
        NBKAssertSubtractionByDigit(T(3), UInt(0), Int(0),  T(3))
        NBKAssertSubtractionByDigit(T(3), UInt(1), Int(0),  T(2))
        NBKAssertSubtractionByDigit(T(3), UInt(2), Int(0),  T(1))
        NBKAssertSubtractionByDigit(T(3), UInt(3), Int(0),  T(0))
    }
    
    func testSubtractingDigitReportingOverflow() {
        NBKAssertSubtractionByDigit(T(1), UInt(0), Int(0), T(words:[ 1] as W))
        NBKAssertSubtractionByDigit(T(1), UInt(1), Int(0), T(words:[ 0] as W))
        NBKAssertSubtractionByDigit(T(1), UInt(2), Int(0), T(words:[~0] as W), true)
        NBKAssertSubtractionByDigit(T(1), UInt(3), Int(0), T(words:[~1] as W), true)
    }
    
    func testSubtractingDigitAtIndex() {
        NBKAssertSubtractionByDigit(T(words:[~0, ~0, ~0, ~0] as W), UInt(3), Int(0), T(words:[~3, ~0, ~0, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0, ~0, ~0, ~0] as W), UInt(3), Int(0), T(words:[~2, ~1, ~0, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0,  0, ~0, ~0] as W), UInt(3), Int(0), T(words:[~2, ~0, ~1, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0,  0,  0, ~0] as W), UInt(3), Int(0), T(words:[~2, ~0, ~0, ~1] as W))
        
        NBKAssertSubtractionByDigit(T(words:[~0, ~0, ~0, ~0] as W), UInt(3), Int(1), T(words:[~0, ~3, ~0, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0, ~0, ~0, ~0] as W), UInt(3), Int(1), T(words:[ 0, ~3, ~0, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0,  0, ~0, ~0] as W), UInt(3), Int(1), T(words:[ 0, ~2, ~1, ~0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 0,  0,  0, ~0] as W), UInt(3), Int(1), T(words:[ 0, ~2, ~0, ~1] as W))
    }
    
    func testSubtractingDigitAtIndexReportingOverflow() {
        NBKAssertSubtractionByDigit(T(words:[ 1,  2,  3,  0] as W), UInt(5), Int(0), T(words:[~3,  1,  3,  0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 1,  2,  3,  0] as W), UInt(5), Int(1), T(words:[ 1, ~2,  2,  0] as W))
        NBKAssertSubtractionByDigit(T(words:[ 1,  2,  3,  0] as W), UInt(5), Int(2), T(words:[ 1,  2, ~1,  0] as W), true)
        NBKAssertSubtractionByDigit(T(words:[ 1,  2,  3,  0] as W), UInt(5), Int(3), T(words:[ 1,  2,  3, ~4] as W), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  -= 0)
            XCTAssertNotNil(x.subtract(0, at: 0))
            XCTAssertNotNil(x.subtractReportingOverflow(0, at: 0))
            
            XCTAssertNotNil(x  -  0)
            XCTAssertNotNil(x.subtracting(0, at: 0))
            XCTAssertNotNil(x.subtractingReportingOverflow(0, at: 0))
        }
    }
}

#endif
