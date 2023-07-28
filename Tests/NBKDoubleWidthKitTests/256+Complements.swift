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
// MARK: * NBK x Int256 x Complements
//*============================================================================*

final class Int256TestsOnComplements: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Pattern
    //=------------------------------------------------------------------------=
    
    func testBitPattern() {
        NBKAssertBitPattern(T(  ),  (M.min))
        NBKAssertBitPattern(T(-1),  (M.max))
        
        NBKAssertBitPattern(T.min,  (M(1) << (M.bitWidth - 1)))
        NBKAssertBitPattern(T.max, ~(M(1) << (M.bitWidth - 1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        XCTAssertEqual(T(-1).magnitude, M(1))
        XCTAssertEqual(T( 0).magnitude, M(0))
        XCTAssertEqual(T( 1).magnitude, M(1))
        
        XCTAssertEqual(T.min.magnitude,  (M(1) << (M.bitWidth - 1)))
        XCTAssertEqual(T.max.magnitude, ~(M(1) << (M.bitWidth - 1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        NBKAssertTwosComplement(T(-1), T( 1))
        NBKAssertTwosComplement(T( 0), T( 0))
        NBKAssertTwosComplement(T( 1), T(-1))
        
        NBKAssertTwosComplement(T.min, T.min + 0, true)
        NBKAssertTwosComplement(T.max, T.min + 1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Additive Inverse
    //=------------------------------------------------------------------------=
    
    func testAdditiveInverse() {
        NBKAssertAdditiveInverse( T(1), -T(1))
        NBKAssertAdditiveInverse( T( ),  T( ))
        NBKAssertAdditiveInverse(-T(1),  T(1))
    }
    
    func testAdditiveInverseReportingOverflow() {
        NBKAssertAdditiveInverse(T.max - T( ), T.min + T(1))
        NBKAssertAdditiveInverse(T.max - T(1), T.min + T(2))
        NBKAssertAdditiveInverse(T.min + T(1), T.max - T( ))
        NBKAssertAdditiveInverse(T.min + T( ), T.min,  true)
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Complements
//*============================================================================*

final class UInt256TestsOnComplements: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Pattern
    //=------------------------------------------------------------------------=
    
    func testBitPattern() {
        NBKAssertBitPattern(T.min, M.min)
        NBKAssertBitPattern(T.max, M.max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        XCTAssertEqual(T( 0).magnitude, M( 0))
        XCTAssertEqual(T( 1).magnitude, M( 1))
        
        XCTAssertEqual(T.min.magnitude, M.min)
        XCTAssertEqual(T.max.magnitude, M.max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        NBKAssertTwosComplement(T( 1), T.max - 0)
        NBKAssertTwosComplement(T( 2), T.max - 1)
        NBKAssertTwosComplement(T( 3), T.max - 2)
        
        NBKAssertTwosComplement(T.min, T.min + 0, true)
        NBKAssertTwosComplement(T.max, T.min + 1)
    }
}

#endif
