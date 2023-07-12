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
// MARK: * NBK x Int256 x Logic
//*============================================================================*

final class Int256TestsOnLogic: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNot() {
        NBKAssertNot(T(x64: X( 0,  1,  2,  3)), T(x64: X(~0, ~1, ~2, ~3)))
        NBKAssertNot(T(x64: X(~0, ~1, ~2, ~3)), T(x64: X( 0,  1,  2,  3)))
    }
    
    func testAnd() {
        NBKAssertAnd(T(x64: X(0, 1, 2, 3)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  0,  0,  0)))
        NBKAssertAnd(T(x64: X(3, 2, 1, 0)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  0,  0,  0)))
        
        NBKAssertAnd(T(x64: X(0, 1, 2, 3)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X( 0,  1,  2,  3)))
        NBKAssertAnd(T(x64: X(3, 2, 1, 0)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X( 3,  2,  1,  0)))
        
        NBKAssertAnd(T(x64: X(0, 1, 2, 3)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 0,  1,  0,  1)))
        NBKAssertAnd(T(x64: X(3, 2, 1, 0)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 1,  0,  1,  0)))
    }
    
    func testOr() {
        NBKAssertOr (T(x64: X(0, 1, 2, 3)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  1,  2,  3)))
        NBKAssertOr (T(x64: X(3, 2, 1, 0)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 3,  2,  1,  0)))
        
        NBKAssertOr (T(x64: X(0, 1, 2, 3)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~0, ~0, ~0, ~0)))
        NBKAssertOr (T(x64: X(3, 2, 1, 0)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~0, ~0, ~0, ~0)))
        
        NBKAssertOr (T(x64: X(0, 1, 2, 3)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 1,  1,  3,  3)))
        NBKAssertOr (T(x64: X(3, 2, 1, 0)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 3,  3,  1,  1)))
    }
    
    func testXor() {
        NBKAssertXor(T(x64: X(0, 1, 2, 3)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  1,  2,  3)))
        NBKAssertXor(T(x64: X(3, 2, 1, 0)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 3,  2,  1,  0)))
        
        NBKAssertXor(T(x64: X(0, 1, 2, 3)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~0, ~1, ~2, ~3)))
        NBKAssertXor(T(x64: X(3, 2, 1, 0)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~3, ~2, ~1, ~0)))
        
        NBKAssertXor(T(x64: X(0, 1, 2, 3)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 1,  0,  3,  2)))
        NBKAssertXor(T(x64: X(3, 2, 1, 0)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 2,  3,  0,  1)))
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Logic
//*============================================================================*

final class UInt256TestsOnLogic: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNot() {
        NBKAssertNot(T(x64: X( 0,  1,  2,  3)), T(x64: X(~0, ~1, ~2, ~3)))
        NBKAssertNot(T(x64: X(~0, ~1, ~2, ~3)), T(x64: X( 0,  1,  2,  3)))
    }
    
    func testAnd() {
        NBKAssertAnd(T(x64: X(0, 1, 2, 3)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  0,  0,  0)))
        NBKAssertAnd(T(x64: X(3, 2, 1, 0)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  0,  0,  0)))
        
        NBKAssertAnd(T(x64: X(0, 1, 2, 3)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X( 0,  1,  2,  3)))
        NBKAssertAnd(T(x64: X(3, 2, 1, 0)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X( 3,  2,  1,  0)))
        
        NBKAssertAnd(T(x64: X(0, 1, 2, 3)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 0,  1,  0,  1)))
        NBKAssertAnd(T(x64: X(3, 2, 1, 0)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 1,  0,  1,  0)))
    }
    
    func testOr() {
        NBKAssertOr (T(x64: X(0, 1, 2, 3)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  1,  2,  3)))
        NBKAssertOr (T(x64: X(3, 2, 1, 0)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 3,  2,  1,  0)))
        
        NBKAssertOr (T(x64: X(0, 1, 2, 3)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~0, ~0, ~0, ~0)))
        NBKAssertOr (T(x64: X(3, 2, 1, 0)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~0, ~0, ~0, ~0)))
        
        NBKAssertOr (T(x64: X(0, 1, 2, 3)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 1,  1,  3,  3)))
        NBKAssertOr (T(x64: X(3, 2, 1, 0)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 3,  3,  1,  1)))
    }
    
    func testXor() {
        NBKAssertXor(T(x64: X(0, 1, 2, 3)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 0,  1,  2,  3)))
        NBKAssertXor(T(x64: X(3, 2, 1, 0)), T(x64: X( 0,  0,  0,  0)), T(x64: X( 3,  2,  1,  0)))
        
        NBKAssertXor(T(x64: X(0, 1, 2, 3)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~0, ~1, ~2, ~3)))
        NBKAssertXor(T(x64: X(3, 2, 1, 0)), T(x64: X(~0, ~0, ~0, ~0)), T(x64: X(~3, ~2, ~1, ~0)))
        
        NBKAssertXor(T(x64: X(0, 1, 2, 3)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 1,  0,  3,  2)))
        NBKAssertXor(T(x64: X(3, 2, 1, 0)), T(x64: X( 1,  1,  1,  1)), T(x64: X( 2,  3,  0,  1)))
    }
}

#endif
