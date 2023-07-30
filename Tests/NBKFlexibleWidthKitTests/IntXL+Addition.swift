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
@testable import NBKFlexibleWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x IntXL x Addition
//*============================================================================*

final class IntXLTestsOnAddition: XCTestCase {
    
    typealias T = IntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAdding() {
        NBKAssertAddition(T( 1), T( 2), Int(0), T( 3))
        NBKAssertAddition(T( 1), T( 1), Int(0), T( 2))
        NBKAssertAddition(T( 1), T( 0), Int(0), T( 1))
        NBKAssertAddition(T( 1), T(-1), Int(0), T( 0))
        NBKAssertAddition(T( 1), T(-2), Int(0), T(-1))
        
        NBKAssertAddition(T( 0), T( 2), Int(0), T( 2))
        NBKAssertAddition(T( 0), T( 1), Int(0), T( 1))
        NBKAssertAddition(T( 0), T( 0), Int(0), T( 0))
        NBKAssertAddition(T( 0), T(-1), Int(0), T(-1))
        NBKAssertAddition(T( 0), T(-2), Int(0), T(-2))
        
        NBKAssertAddition(T(-1), T( 2), Int(0), T( 1))
        NBKAssertAddition(T(-1), T( 1), Int(0), T( 0))
        NBKAssertAddition(T(-1), T( 0), Int(0), T(-1))
        NBKAssertAddition(T(-1), T(-1), Int(0), T(-2))
        NBKAssertAddition(T(-1), T(-2), Int(0), T(-3))
    }
    
    func testAddingAtIndex() {
        NBKAssertAddition(T(words:[ 0,  0,  0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[ 1,  2,  3,  0] as W))
        NBKAssertAddition(T(words:[~0,  0,  0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[ 0,  3,  3,  0] as W))
        NBKAssertAddition(T(words:[~0, ~0,  0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[ 0,  2,  4,  0] as W))
        NBKAssertAddition(T(words:[~0, ~0, ~0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[ 0,  2,  3,  1] as W))

        NBKAssertAddition(T(words:[ 0,  0,  0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[ 0,  1,  2,  3] as W))
        NBKAssertAddition(T(words:[~0,  0,  0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[~0,  1,  2,  3] as W))
        NBKAssertAddition(T(words:[~0, ~0,  0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[~0,  0,  3,  3] as W))
        NBKAssertAddition(T(words:[~0, ~0, ~0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[~0,  0,  2,  4] as W))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=

    func testAddingDigit() {
        NBKAssertAdditionByDigit(T( 1), Int( 2), Int(0), T( 3))
        NBKAssertAdditionByDigit(T( 1), Int( 1), Int(0), T( 2))
        NBKAssertAdditionByDigit(T( 1), Int( 0), Int(0), T( 1))
        NBKAssertAdditionByDigit(T( 1), Int(-1), Int(0), T( 0))
        NBKAssertAdditionByDigit(T( 1), Int(-2), Int(0), T(-1))
        
        NBKAssertAdditionByDigit(T( 0), Int( 2), Int(0), T( 2))
        NBKAssertAdditionByDigit(T( 0), Int( 1), Int(0), T( 1))
        NBKAssertAdditionByDigit(T( 0), Int( 0), Int(0), T( 0))
        NBKAssertAdditionByDigit(T( 0), Int(-1), Int(0), T(-1))
        NBKAssertAdditionByDigit(T( 0), Int(-2), Int(0), T(-2))
        
        NBKAssertAdditionByDigit(T(-1), Int( 2), Int(0), T( 1))
        NBKAssertAdditionByDigit(T(-1), Int( 1), Int(0), T( 0))
        NBKAssertAdditionByDigit(T(-1), Int( 0), Int(0), T(-1))
        NBKAssertAdditionByDigit(T(-1), Int(-1), Int(0), T(-2))
        NBKAssertAdditionByDigit(T(-1), Int(-2), Int(0), T(-3))
    }
    
    func testAddingDigitAtIndex() {
        NBKAssertAdditionByDigit(T(words:[ 0,  0,  0,  0] as W), Int(3), Int(0), T(words:[ 3,  0,  0,  0] as W))
        NBKAssertAdditionByDigit(T(words:[~0,  0,  0,  0] as W), Int(3), Int(0), T(words:[ 2,  1,  0,  0] as W))
        NBKAssertAdditionByDigit(T(words:[~0, ~0,  0,  0] as W), Int(3), Int(0), T(words:[ 2,  0,  1,  0] as W))
        NBKAssertAdditionByDigit(T(words:[~0, ~0, ~0,  0] as W), Int(3), Int(0), T(words:[ 2,  0,  0,  1] as W))

        NBKAssertAdditionByDigit(T(words:[ 0,  0,  0,  0] as W), Int(3), Int(1), T(words:[ 0,  3,  0,  0] as W))
        NBKAssertAdditionByDigit(T(words:[~0,  0,  0,  0] as W), Int(3), Int(1), T(words:[~0,  3,  0,  0] as W))
        NBKAssertAdditionByDigit(T(words:[~0, ~0,  0,  0] as W), Int(3), Int(1), T(words:[~0,  2,  1,  0] as W))
        NBKAssertAdditionByDigit(T(words:[~0, ~0, ~0,  0] as W), Int(3), Int(1), T(words:[~0,  2,  0,  1] as W))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  += 0)
            XCTAssertNotNil(x.add(0, at: 0))
            
            XCTAssertNotNil(x  +  0)
            XCTAssertNotNil(x.adding(0, at: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x UIntXL x Addition
//*============================================================================*

final class UIntXLTestsOnAddition: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAdding() {
        NBKAssertAddition(T(0), T(0), Int(0), T(0))
        NBKAssertAddition(T(0), T(1), Int(0), T(1))
        NBKAssertAddition(T(0), T(2), Int(0), T(2))
        
        NBKAssertAddition(T(1), T(0), Int(0), T(1))
        NBKAssertAddition(T(1), T(1), Int(0), T(2))
        NBKAssertAddition(T(1), T(2), Int(0), T(3))
    }
    
    func testAddingAtIndex() {
        NBKAssertAddition(T(words:[ 0,  0,  0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[ 1,  2,  3,  0] as W))
        NBKAssertAddition(T(words:[~0,  0,  0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[ 0,  3,  3,  0] as W))
        NBKAssertAddition(T(words:[~0, ~0,  0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[ 0,  2,  4,  0] as W))
        NBKAssertAddition(T(words:[~0, ~0, ~0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(0), T(words:[ 0,  2,  3,  1] as W))
        
        NBKAssertAddition(T(words:[ 0,  0,  0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[ 0,  1,  2,  3] as W))
        NBKAssertAddition(T(words:[~0,  0,  0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[~0,  1,  2,  3] as W))
        NBKAssertAddition(T(words:[~0, ~0,  0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[~0,  0,  3,  3] as W))
        NBKAssertAddition(T(words:[~0, ~0, ~0,  0] as W), T(words:[ 1,  2,  3,  0] as W), Int(1), T(words:[~0,  0,  2,  4] as W))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=

    func testAddingDigit() {
        NBKAssertAdditionByDigit(T(0), UInt(0), Int(0), T(0))
        NBKAssertAdditionByDigit(T(0), UInt(1), Int(0), T(1))
        NBKAssertAdditionByDigit(T(0), UInt(2), Int(0), T(2))
        
        NBKAssertAdditionByDigit(T(1), UInt(0), Int(0), T(1))
        NBKAssertAdditionByDigit(T(1), UInt(1), Int(0), T(2))
        NBKAssertAdditionByDigit(T(1), UInt(2), Int(0), T(3))
    }
    
    func testAddingDigitAtIndex() {
        NBKAssertAdditionByDigit(T(words:[ 0,  0,  0,  0] as W), UInt(3), Int(0), T(words:[ 3,  0,  0,  0] as W))
        NBKAssertAdditionByDigit(T(words:[~0,  0,  0,  0] as W), UInt(3), Int(0), T(words:[ 2,  1,  0,  0] as W))
        NBKAssertAdditionByDigit(T(words:[~0, ~0,  0,  0] as W), UInt(3), Int(0), T(words:[ 2,  0,  1,  0] as W))
        NBKAssertAdditionByDigit(T(words:[~0, ~0, ~0,  0] as W), UInt(3), Int(0), T(words:[ 2,  0,  0,  1] as W))
        
        NBKAssertAdditionByDigit(T(words:[ 0,  0,  0,  0] as W), UInt(3), Int(1), T(words:[ 0,  3,  0,  0] as W))
        NBKAssertAdditionByDigit(T(words:[~0,  0,  0,  0] as W), UInt(3), Int(1), T(words:[~0,  3,  0,  0] as W))
        NBKAssertAdditionByDigit(T(words:[~0, ~0,  0,  0] as W), UInt(3), Int(1), T(words:[~0,  2,  1,  0] as W))
        NBKAssertAdditionByDigit(T(words:[~0, ~0, ~0,  0] as W), UInt(3), Int(1), T(words:[~0,  2,  0,  1] as W))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  += 0)
            XCTAssertNotNil(x.add(0, at: 0))
            
            XCTAssertNotNil(x  +  0)
            XCTAssertNotNil(x.adding(0, at: 0))
        }
    }
}

#endif
