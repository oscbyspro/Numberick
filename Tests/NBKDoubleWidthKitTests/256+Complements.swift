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
// MARK: * NBK x Int256 x Complements
//*============================================================================*

final class Int256TestsOnComplements: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Pattern
    //=------------------------------------------------------------------------=
    
    func testInitBitPattern() {
        XCTAssertEqual(T(bitPattern: M.min), T( 0))
        XCTAssertEqual(T(bitPattern: M.max), T(-1))
        
        XCTAssertEqual(T(bitPattern:  (M(1) << (M.bitWidth - 1))), T.min)
        XCTAssertEqual(T(bitPattern: ~(M(1) << (M.bitWidth - 1))), T.max)
    }
    
    func testValueAsBitPattern() {
        XCTAssertEqual(T( 0).bitPattern, M.min)
        XCTAssertEqual(T(-1).bitPattern, M.max)
        
        XCTAssertEqual(T.min.bitPattern,  (M(1) << (M.bitWidth - 1)))
        XCTAssertEqual(T.max.bitPattern, ~(M(1) << (M.bitWidth - 1)))
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
        XCTAssertEqual(T.min.twosComplement(), T.min)
        XCTAssertEqual(T.max.twosComplement(), T.min + T(1))
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
    
    func testInitBitPattern() {
        XCTAssertEqual(T(bitPattern: M.min), T.min)
        XCTAssertEqual(T(bitPattern: M.max), T.max)
    }
    
    func testValueAsBitPattern() {
        XCTAssertEqual(T.min.bitPattern, M.min)
        XCTAssertEqual(T.max.bitPattern, M.max)
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
        XCTAssertEqual(T.min.twosComplement(), T.min)
        XCTAssertEqual(T.max.twosComplement(), T.min + T(1))
    }
}

#endif
