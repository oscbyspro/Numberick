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
import NBKSignedKit
import XCTest

//*============================================================================*
// MARK: * NBK x Signed
//*============================================================================*

final class NBKSignedTests: XCTestCase {
    
    typealias T = NBKSigned<UInt>
    typealias M = NBKSigned<UInt>.Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSign() {
        XCTAssertEqual(T(sign: .plus , magnitude: 0).sign, .plus )
        XCTAssertEqual(T(sign: .plus , magnitude: 1).sign, .plus )
        XCTAssertEqual(T(sign: .minus, magnitude: 0).sign, .minus)
        XCTAssertEqual(T(sign: .minus, magnitude: 1).sign, .minus)
    }
    
    func testIsNormal() {
        XCTAssertEqual(T(sign: .plus , magnitude: 0).isNormal, true )
        XCTAssertEqual(T(sign: .plus , magnitude: 1).isNormal, true )
        XCTAssertEqual(T(sign: .minus, magnitude: 0).isNormal, false)
        XCTAssertEqual(T(sign: .minus, magnitude: 1).isNormal, true )
    }
    
    func testNormalizedSign() {
        XCTAssertEqual(T(sign: .plus , magnitude: 0).normalizedSign, .plus )
        XCTAssertEqual(T(sign: .plus , magnitude: 1).normalizedSign, .plus )
        XCTAssertEqual(T(sign: .minus, magnitude: 0).normalizedSign, .plus )
        XCTAssertEqual(T(sign: .minus, magnitude: 1).normalizedSign, .minus)
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Assertions
//*============================================================================*

func NBKAssertIdentical<M>(_ lhs: NBKSigned<M>?, _ rhs: NBKSigned<M>?, file: StaticString = #file, line: UInt = #line) {
    let  success: Bool = lhs?.sign == rhs?.sign && lhs?.magnitude == rhs?.magnitude
    func description(of x: NBKSigned<M>?) -> String { x.map({ "\($0.sign)\($0.magnitude)" }) ?? "nil" }
    XCTAssert(success, "(\(description(of: lhs)) is not identical to \(description(of: rhs))", file: file, line: line)
}

#endif
