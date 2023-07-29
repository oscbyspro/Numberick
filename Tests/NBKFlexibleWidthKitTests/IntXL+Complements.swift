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
// MARK: * NBK x IntXL x Complements
//*============================================================================*

final class IntXLTestsOnComplements: XCTestCase {

    typealias T =  IntXL
    typealias M = UIntXL

    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        XCTAssertEqual(T(words:[ 1,  0,  0,  0] as [UInt]).magnitude, M(words:[ 1,  0,  0,  0] as [UInt]))
        XCTAssertEqual(T(words:[~0,  0,  0,  0] as [UInt]).magnitude, M(words:[~0,  0,  0,  0] as [UInt]))
        XCTAssertEqual(T(words:[ 1,  1,  1,  1] as [UInt]).magnitude, M(words:[ 1,  1,  1,  1] as [UInt]))
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as [UInt]).magnitude, M(words:[ 1,  0,  0,  0] as [UInt]))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        // TODO: (!)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Additive Inverse
    //=------------------------------------------------------------------------=
    
    func testAdditiveInverse() {
        NBKAssertAdditiveInverse(T(sign: .plus,  magnitude: M( )), T(sign: .minus, magnitude: M( )))
        NBKAssertAdditiveInverse(T(sign: .minus, magnitude: M( )), T(sign: .plus,  magnitude: M( )))
        NBKAssertAdditiveInverse(T(sign: .plus,  magnitude: M(1)), T(sign: .minus, magnitude: M(1)))
        NBKAssertAdditiveInverse(T(sign: .minus, magnitude: M(1)), T(sign: .plus,  magnitude: M(1)))
    }
}

//*============================================================================*
// MARK: * NBK x UIntXL x Complements
//*============================================================================*

final class UIntXLTestsOnComplements: XCTestCase {

    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        XCTAssertEqual(T(words:[ 1,  0,  0,  0] as [UInt]).magnitude, M(words:[ 1,  0,  0,  0] as [UInt]))
        XCTAssertEqual(T(words:[~0,  0,  0,  0] as [UInt]).magnitude, M(words:[~0,  0,  0,  0] as [UInt]))
        XCTAssertEqual(T(words:[ 1,  1,  1,  1] as [UInt]).magnitude, M(words:[ 1,  1,  1,  1] as [UInt]))
        XCTAssertEqual(T(words:[~0, ~0, ~0, ~0] as [UInt]).magnitude, M(words:[~0, ~0, ~0, ~0] as [UInt]))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        // TODO: (!)
    }
}

#endif
