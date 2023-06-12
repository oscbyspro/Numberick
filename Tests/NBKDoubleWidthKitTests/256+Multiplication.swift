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

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Int256 x Multiplication
//*============================================================================*

final class Int256TestsOnMultiplication: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplying() {
        NBKAssertMultiplication( T(x64: X(1, 2, 3, 4)),  T(0),  T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplication( T(x64: X(1, 2, 3, 4)), -T(0), -T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplication(-T(x64: X(1, 2, 3, 4)),  T(0), -T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplication(-T(x64: X(1, 2, 3, 4)), -T(0),  T(x64: X(0, 0, 0, 0)))
        
        NBKAssertMultiplication( T(x64: X(1, 2, 3, 4)),  T(1),  T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplication( T(x64: X(1, 2, 3, 4)), -T(1), -T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplication(-T(x64: X(1, 2, 3, 4)),  T(1), -T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplication(-T(x64: X(1, 2, 3, 4)), -T(1),  T(x64: X(1, 2, 3, 4)))
        
        NBKAssertMultiplication( T(x64: X(1, 2, 3, 4)),  T(2),  T(x64: X(2, 4, 6, 8)))
        NBKAssertMultiplication( T(x64: X(1, 2, 3, 4)), -T(2), -T(x64: X(2, 4, 6, 8)))
        NBKAssertMultiplication(-T(x64: X(1, 2, 3, 4)),  T(2), -T(x64: X(2, 4, 6, 8)))
        NBKAssertMultiplication(-T(x64: X(1, 2, 3, 4)), -T(2),  T(x64: X(2, 4, 6, 8)))
    }
    
    func testMultiplyingUsingLargeValues() {
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(2, 0, 0, 0)), T(x64: X( 2,  4,  6,  8)), T(x64: X( 0,  0,  0,  0)))
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(0, 2, 0, 0)), T(x64: X( 0,  2,  4,  6)), T(x64: X( 8,  0,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(0, 0, 2, 0)), T(x64: X( 0,  0,  2,  4)), T(x64: X( 6,  8,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(0, 0, 0, 2)), T(x64: X( 0,  0,  0,  2)), T(x64: X( 4,  6,  8,  0)), true)
        
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)), -T(x64: X(2, 0, 0, 0)), T(x64: X(~1, ~4, ~6, ~8)), T(x64: X(~0, ~0, ~0, ~0)))
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)), -T(x64: X(0, 2, 0, 0)), T(x64: X( 0, ~1, ~4, ~6)), T(x64: X(~8, ~0, ~0, ~0)), true)
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)), -T(x64: X(0, 0, 2, 0)), T(x64: X( 0,  0, ~1, ~4)), T(x64: X(~6, ~8, ~0, ~0)), true)
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)), -T(x64: X(0, 0, 0, 2)), T(x64: X( 0,  0,  0, ~1)), T(x64: X(~4, ~6, ~8, ~0)), true)
        
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(2, 0, 0, 0)), T(x64: X(~3, ~4, ~6, ~8)), T(x64: X(~0, ~0, ~0, ~0)))
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(0, 2, 0, 0)), T(x64: X( 0, ~3, ~4, ~6)), T(x64: X(~8, ~0, ~0, ~0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(0, 0, 2, 0)), T(x64: X( 0,  0, ~3, ~4)), T(x64: X(~6, ~8, ~0, ~0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(0, 0, 0, 2)), T(x64: X( 0,  0,  0, ~3)), T(x64: X(~4, ~6, ~8, ~0)), true)
        
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)), -T(x64: X(2, 0, 0, 0)), T(x64: X( 4,  4,  6,  8)), T(x64: X( 0,  0,  0,  0)))
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)), -T(x64: X(0, 2, 0, 0)), T(x64: X( 0,  4,  4,  6)), T(x64: X( 8,  0,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)), -T(x64: X(0, 0, 2, 0)), T(x64: X( 0,  0,  4,  4)), T(x64: X( 6,  8,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)), -T(x64: X(0, 0, 0, 2)), T(x64: X( 0,  0,  0,  4)), T(x64: X( 4,  6,  8,  0)), true)
    }
    
    func testMultiplyingReportingOverflow() {
        NBKAssertMultiplication(T(  ), T(-1),  T(  ), T(  ), false)
        NBKAssertMultiplication(T(-1), T(  ),  T(  ), T(  ), false)
        
        NBKAssertMultiplication(T.max, T( 1),  T.max, T(  ), false)
        NBKAssertMultiplication(T.max, T(-1), -T.max, T(-1), false)
        NBKAssertMultiplication(T.min, T( 1),  T.min, T(-1), false)
        NBKAssertMultiplication(T.min, T(-1),  T.min, T(  ), true )
        
        NBKAssertMultiplication(T.max, T( 2),  T(-2), T(  ), true )
        NBKAssertMultiplication(T.max, T(-2),  T( 2), T(-1), true )
        NBKAssertMultiplication(T.min, T( 2),  T(  ), T(-1), true )
        NBKAssertMultiplication(T.min, T(-2),  T(  ), T( 1), true )
        
        NBKAssertMultiplication(T.max, T.max,  T( 1), T(x64: X(~0, ~0, ~0, ~0 >>  2)), true)
        NBKAssertMultiplication(T.max, T.min,  T.min, T(x64: X( 0,  0,  0, ~0 << 62)), true)
        NBKAssertMultiplication(T.min, T.max,  T.min, T(x64: X( 0,  0,  0, ~0 << 62)), true)
        NBKAssertMultiplication(T.min, T.min,  T(  ), T(x64: X( 0,  0,  0,  1 << 62)), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testMultiplyingByDigit() {
        NBKAssertMultiplicationByDigit( T(x64: X(1, 2, 3, 4)),  Int(0),  T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplicationByDigit( T(x64: X(1, 2, 3, 4)), -Int(0), -T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplicationByDigit(-T(x64: X(1, 2, 3, 4)),  Int(0), -T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplicationByDigit(-T(x64: X(1, 2, 3, 4)), -Int(0),  T(x64: X(0, 0, 0, 0)))
        
        NBKAssertMultiplicationByDigit( T(x64: X(1, 2, 3, 4)),  Int(1),  T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplicationByDigit( T(x64: X(1, 2, 3, 4)), -Int(1), -T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplicationByDigit(-T(x64: X(1, 2, 3, 4)),  Int(1), -T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplicationByDigit(-T(x64: X(1, 2, 3, 4)), -Int(1),  T(x64: X(1, 2, 3, 4)))
        
        NBKAssertMultiplicationByDigit( T(x64: X(1, 2, 3, 4)),  Int(2),  T(x64: X(2, 4, 6, 8)))
        NBKAssertMultiplicationByDigit( T(x64: X(1, 2, 3, 4)), -Int(2), -T(x64: X(2, 4, 6, 8)))
        NBKAssertMultiplicationByDigit(-T(x64: X(1, 2, 3, 4)),  Int(2), -T(x64: X(2, 4, 6, 8)))
        NBKAssertMultiplicationByDigit(-T(x64: X(1, 2, 3, 4)), -Int(2),  T(x64: X(2, 4, 6, 8)))
    }
    
    func testMultiplyingByDigitUsingLargeValues() {
        NBKAssertMultiplicationByDigit(T(x64: X( 1,  2,  3,  4)),  Int(2), T(x64: X( 2,  4,  6,  8)),  Int(0))
        NBKAssertMultiplicationByDigit(T(x64: X( 1,  2,  3,  4)), -Int(2), T(x64: X(~1, ~4, ~6, ~8)), -Int(1))
        NBKAssertMultiplicationByDigit(T(x64: X(~1, ~2, ~3, ~4)),  Int(2), T(x64: X(~3, ~4, ~6, ~8)), -Int(1))
        NBKAssertMultiplicationByDigit(T(x64: X(~1, ~2, ~3, ~4)), -Int(2), T(x64: X( 4,  4,  6,  8)),  Int(0))
    }
    
    func testMultiplyingByDigitReportingOverflow() {
        NBKAssertMultiplicationByDigit(T(  ), Int(-1),  T(  ), Int(  ), false)
        NBKAssertMultiplicationByDigit(T(-1), Int(  ),  T(  ), Int(  ), false)
        
        NBKAssertMultiplicationByDigit(T.max, Int( 1),  T.max, Int(  ), false)
        NBKAssertMultiplicationByDigit(T.max, Int(-1), -T.max, Int(-1), false)
        NBKAssertMultiplicationByDigit(T.min, Int( 1),  T.min, Int(-1), false)
        NBKAssertMultiplicationByDigit(T.min, Int(-1),  T.min, Int(  ), true )
        
        NBKAssertMultiplicationByDigit(T.max, Int( 2),  T(-2), Int(  ), true )
        NBKAssertMultiplicationByDigit(T.max, Int(-2),  T( 2), Int(-1), true )
        NBKAssertMultiplicationByDigit(T.min, Int( 2),  T(  ), Int(-1), true )
        NBKAssertMultiplicationByDigit(T.min, Int(-2),  T(  ), Int( 1), true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  *= 0)
            XCTAssertNotNil(x &*= 0)
            XCTAssertNotNil(x.multiplyReportingOverflow(by: 0))
            XCTAssertNotNil(x.multiplyFullWidth(by: 0))
            
            XCTAssertNotNil(x  *  0)
            XCTAssertNotNil(x &*  0)
            XCTAssertNotNil(x.multipliedReportingOverflow(by: 0))
            XCTAssertNotNil(x.multipliedFullWidth(by: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Multiplication
//*============================================================================*

final class UInt256TestsOnMultiplication: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplying() {
        NBKAssertMultiplication(T(x64: X(1, 2, 3, 4)), T(0), T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplication(T(x64: X(1, 2, 3, 4)), T(1), T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplication(T(x64: X(1, 2, 3, 4)), T(2), T(x64: X(2, 4, 6, 8)))
    }
    
    func testMultiplyingUsingLargeValues() {
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(2, 0, 0, 0)), T(x64: X( 2,  4,  6,  8)), T(x64: X( 0,  0,  0,  0)))
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(0, 2, 0, 0)), T(x64: X( 0,  2,  4,  6)), T(x64: X( 8,  0,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(0, 0, 2, 0)), T(x64: X( 0,  0,  2,  4)), T(x64: X( 6,  8,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X( 1,  2,  3,  4)),  T(x64: X(0, 0, 0, 2)), T(x64: X( 0,  0,  0,  2)), T(x64: X( 4,  6,  8,  0)), true)
        
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(2, 0, 0, 0)), T(x64: X(~3, ~4, ~6, ~8)), T(x64: X( 1,  0,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(0, 2, 0, 0)), T(x64: X( 0, ~3, ~4, ~6)), T(x64: X(~8,  1,  0,  0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(0, 0, 2, 0)), T(x64: X( 0,  0, ~3, ~4)), T(x64: X(~6, ~8,  1,  0)), true)
        NBKAssertMultiplication(T(x64: X(~1, ~2, ~3, ~4)),  T(x64: X(0, 0, 0, 2)), T(x64: X( 0,  0,  0, ~3)), T(x64: X(~4, ~6, ~8,  1)), true)
    }

    func testMultiplyingReportingOverflow() {
        NBKAssertMultiplication(T.max, T( 2), ~T(1),  T(1), true)
        NBKAssertMultiplication(T.max, T.max,  T(1), ~T(1), true)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testMultipliedByDigit() {
        NBKAssertMultiplicationByDigit(T(x64: X(1, 2, 3, 4)), UInt(0), T(x64: X(0, 0, 0, 0)))
        NBKAssertMultiplicationByDigit(T(x64: X(1, 2, 3, 4)), UInt(1), T(x64: X(1, 2, 3, 4)))
        NBKAssertMultiplicationByDigit(T(x64: X(1, 2, 3, 4)), UInt(2), T(x64: X(2, 4, 6, 8)))
    }
    
    func testMultiplyingByDigitUsingLargeValues() {
        NBKAssertMultiplicationByDigit(T(x64: X(~1, ~2, ~3, ~4)), UInt(2), T(x64: X(~3, ~4, ~6, ~8)), UInt(1), true )
        NBKAssertMultiplicationByDigit(T(x64: X( 1,  2,  3,  4)), UInt(2), T(x64: X( 2,  4,  6,  8)), UInt(0), false)
    }
    
    func testMultipliedByDigitReportingOverflow() {
        NBKAssertMultiplicationByDigit(T.min, UInt(2),  T(0), UInt(0), false)
        NBKAssertMultiplicationByDigit(T.max, UInt(2), ~T(1), UInt(1), true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  *= 0)
            XCTAssertNotNil(x &*= 0)
            XCTAssertNotNil(x.multiplyReportingOverflow(by: 0))
            XCTAssertNotNil(x.multiplyFullWidth(by: 0))
            
            XCTAssertNotNil(x  *  0)
            XCTAssertNotNil(x &*  0)
            XCTAssertNotNil(x.multipliedReportingOverflow(by: 0))
            XCTAssertNotNil(x.multipliedFullWidth(by: 0))
        }
    }
}

#endif
