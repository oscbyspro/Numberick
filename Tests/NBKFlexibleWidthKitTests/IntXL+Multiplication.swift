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

private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x UIntXL x Multiplication
//*============================================================================*

final class UIntXLTestsOnMultiplication: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplying() {
        NBKAssertMultiplication(T(words:[ 1,  2,  3,  4] as [UInt]), T(words:[2, 0, 0, 0] as [UInt]), T(words:[ 2,  4,  6,  8,  0,  0,  0,  0] as [UInt]))
        NBKAssertMultiplication(T(words:[ 1,  2,  3,  4] as [UInt]), T(words:[0, 2, 0, 0] as [UInt]), T(words:[ 0,  2,  4,  6,  8,  0,  0,  0] as [UInt]))
        NBKAssertMultiplication(T(words:[ 1,  2,  3,  4] as [UInt]), T(words:[0, 0, 2, 0] as [UInt]), T(words:[ 0,  0,  2,  4,  6,  8,  0,  0] as [UInt]))
        NBKAssertMultiplication(T(words:[ 1,  2,  3,  4] as [UInt]), T(words:[0, 0, 0, 2] as [UInt]), T(words:[ 0,  0,  0,  2,  4,  6,  8,  0] as [UInt]))
        
        NBKAssertMultiplication(T(words:[~1, ~2, ~3, ~4] as [UInt]), T(words:[2, 0, 0, 0] as [UInt]), T(words:[~3, ~4, ~6, ~8,  1,  0,  0,  0] as [UInt]))
        NBKAssertMultiplication(T(words:[~1, ~2, ~3, ~4] as [UInt]), T(words:[0, 2, 0, 0] as [UInt]), T(words:[ 0, ~3, ~4, ~6, ~8,  1,  0,  0] as [UInt]))
        NBKAssertMultiplication(T(words:[~1, ~2, ~3, ~4] as [UInt]), T(words:[0, 0, 2, 0] as [UInt]), T(words:[ 0,  0, ~3, ~4, ~6, ~8,  1,  0] as [UInt]))
        NBKAssertMultiplication(T(words:[~1, ~2, ~3, ~4] as [UInt]), T(words:[0, 0, 0, 2] as [UInt]), T(words:[ 0,  0,  0, ~3, ~4, ~6, ~8,  1] as [UInt]))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testMultipliedByDigit() {
        NBKAssertMultiplicationByDigit(T(words:[1, 2, 3, 4] as [UInt]),  UInt(0),  T(words:[0, 0, 0, 0,  0] as [UInt]))
        NBKAssertMultiplicationByDigit(T(words:[1, 2, 3, 4] as [UInt]),  UInt(1),  T(words:[1, 2, 3, 4,  0] as [UInt]))
        NBKAssertMultiplicationByDigit(T(words:[1, 2, 3, 4] as [UInt]),  UInt(2),  T(words:[2, 4, 6, 8,  0] as [UInt]))
        
        NBKAssertMultiplicationByDigit(T(words:[1, 2, 3, 4] as [UInt]), ~UInt(0), ~T(words:[0, 1, 1, 1, ~3] as [UInt]))
        NBKAssertMultiplicationByDigit(T(words:[1, 2, 3, 4] as [UInt]), ~UInt(1), ~T(words:[1, 3, 4, 5, ~3] as [UInt]))
        NBKAssertMultiplicationByDigit(T(words:[1, 2, 3, 4] as [UInt]), ~UInt(2), ~T(words:[2, 5, 7, 9, ~3] as [UInt]))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  *= 0)
            XCTAssertNotNil(x  *  0)
        }
    }
}

#endif
