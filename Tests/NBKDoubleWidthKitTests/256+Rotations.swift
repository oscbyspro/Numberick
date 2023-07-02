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
// MARK: * NBK x Int256 x Rotations
//*============================================================================*

final class Int256TestsOnRotations: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=

    func testBitrotatingLeftByWords() {
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),  64, T(x64: X( 4,  1,  2,  3)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)), 128, T(x64: X( 3,  4,  1,  2)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)), 192, T(x64: X( 2,  3,  4,  1)))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=

    func testBitrotatingRightByWords() {
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)),  64, T(x64: X( 2,  3,  4,  1)))
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)), 128, T(x64: X( 3,  4,  1,  2)))
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)), 192, T(x64: X( 4,  1,  2,  3)))
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Rotations
//*============================================================================*

final class UInt256TestsOnRotations: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitrotatingLeftByWords() {
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)),  64, T(x64: X( 4,  1,  2,  3)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)), 128, T(x64: X( 3,  4,  1,  2)))
        NBKAssertRotateLeft(T(x64: X( 1,  2,  3,  4)), 192, T(x64: X( 2,  3,  4,  1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitrotatingRightByWords() {
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)),   0, T(x64: X( 1,  2,  3,  4)))
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)),  64, T(x64: X( 2,  3,  4,  1)))
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)), 128, T(x64: X( 3,  4,  1,  2)))
        NBKAssertRotateRight(T(x64: X( 1,  2,  3,  4)), 192, T(x64: X( 4,  1,  2,  3)))
    }
}

#endif
