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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

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
    
    func testMagnitude() {
        XCTAssertEqual(T(sign: .plus , magnitude: 0).magnitude, 0 as M)
        XCTAssertEqual(T(sign: .plus , magnitude: 1).magnitude, 1 as M)
        XCTAssertEqual(T(sign: .minus, magnitude: 0).magnitude, 0 as M)
        XCTAssertEqual(T(sign: .minus, magnitude: 1).magnitude, 1 as M)
    }
    
    func testNormalized() {
        NBKAssertNormalization(T(sign: .plus , magnitude: 0), true,  .plus,  0 as M)
        NBKAssertNormalization(T(sign: .plus , magnitude: 1), true,  .plus,  1 as M)
        NBKAssertNormalization(T(sign: .minus, magnitude: 0), false, .plus,  0 as M)
        NBKAssertNormalization(T(sign: .minus, magnitude: 1), true,  .minus, 1 as M)
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Assertions
//*============================================================================*

private func NBKAssertNormalization<M>(
_ integer: NBKSigned<M>, _ isNormal: Bool, _ sign: NBKSigned<M>.Sign, _ magnitude: M,
file: StaticString = #file, line: UInt = #line) {
    
    brr: do {
        XCTAssertEqual(integer.isNormal,   isNormal, file: file, line: line)
        XCTAssertEqual(integer.normalizedSign, sign, file: file, line: line)
        XCTAssertEqual(integer.magnitude, magnitude, file: file, line: line)
    }

    brr: do {
        XCTAssertEqual(integer.normalized().isNormal,  true,      file: file, line: line)
        XCTAssertEqual(integer.normalized().sign,      sign,      file: file, line: line)
        XCTAssertEqual(integer.normalized().magnitude, magnitude, file: file, line: line)
    }
    
    brr: do {
        var integer = integer; integer.normalize()
        XCTAssertEqual(integer.isNormal,  true,      file: file, line: line)
        XCTAssertEqual(integer.sign,      sign,      file: file, line: line)
        XCTAssertEqual(integer.magnitude, magnitude, file: file, line: line)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Shared
//=----------------------------------------------------------------------------=

func NBKAssertIdentical<M>(_ lhs: NBKSigned<M>?, _ rhs: NBKSigned<M>?, file: StaticString = #file, line: UInt = #line) {
    func description(of  integer: NBKSigned<M>?) -> String {
        integer.map({ "\($0.sign)\($0.magnitude)" }) ?? "nil"
    }
    
    let success: Bool = lhs?.sign == rhs?.sign && lhs?.magnitude == rhs?.magnitude
    XCTAssert(success, "(\(description(of: lhs)) is not identical to \(description(of: rhs))", file: file, line: line)
}

#endif
