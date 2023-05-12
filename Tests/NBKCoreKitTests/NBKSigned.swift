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
import XCTest

//*============================================================================*
// MARK: * NBK x Signed
//*============================================================================*

final class NBKSignedTests: XCTestCase {
    
    typealias T = NBKSigned<UInt64>
    typealias D = NBKSigned<UInt64>
    typealias M = UInt64
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInit() {
        XCTAssertEqual(T().sign, NBKSign.plus)
        XCTAssertEqual(T().magnitude, M())
    }
    
    func testInitConstants() {
        NBKAssertIdentical(T.zero, T(M.zero, as: NBKSign.plus ))
        NBKAssertIdentical(T.max,  T(M.max,  as: NBKSign.plus ))
        NBKAssertIdentical(T.min,  T(M.max,  as: NBKSign.minus))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Constants
    //=------------------------------------------------------------------------=
    
    func testInitMin() {
        XCTAssertEqual(T.min.sign, NBKSign.minus)
        XCTAssertEqual(T.min.magnitude, M.max)
    }
    
    func testInitMax() {
        XCTAssertEqual(T.max.sign, NBKSign.plus)
        XCTAssertEqual(T.max.magnitude, M.max)
    }
    
    func testInitZero() {
        XCTAssertEqual(T.zero.sign, NBKSign.plus)
        XCTAssertEqual(T.zero.magnitude, M())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Normalization
    //=------------------------------------------------------------------------=
    
    func testSign() {
        XCTAssertEqual(T(0, as: .plus ).sign, NBKSign.plus )
        XCTAssertEqual(T(0, as: .minus).sign, NBKSign.minus)
        XCTAssertEqual(T(1, as: .plus ).sign, NBKSign.plus )
        XCTAssertEqual(T(1, as: .minus).sign, NBKSign.minus)
    }
    
    func testIsNormal() {
        XCTAssertEqual(T(0, as: .plus ).isNormal, true )
        XCTAssertEqual(T(0, as: .minus).isNormal, false)
        XCTAssertEqual(T(1, as: .plus ).isNormal, true )
        XCTAssertEqual(T(1, as: .minus).isNormal, true )
    }
    
    func testNormalizedSign() {
        XCTAssertEqual(T(0, as: .plus ).normalizedSign, NBKSign.plus )
        XCTAssertEqual(T(0, as: .minus).normalizedSign, NBKSign.plus )
        XCTAssertEqual(T(1, as: .plus ).normalizedSign, NBKSign.plus )
        XCTAssertEqual(T(1, as: .minus).normalizedSign, NBKSign.minus)
    }
}

#endif
