//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Update x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnUpdateAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUpdate() {
        NBKAssertUpdate(T(words:[ 0,  0,  0,  0      ] as W))
        NBKAssertUpdate(T(words:[~0, ~0, ~0, ~0/2 + 0] as W))
        NBKAssertUpdate(T(words:[ 0,  0,  0, ~0/2 + 1] as W))
        NBKAssertUpdate(T(words:[~0, ~0, ~0, ~0      ] as W))
    }
    
    func testUpdateAsDigit() {
        NBKAssertUpdateAsDigit(T.self, UInt.min)
        NBKAssertUpdateAsDigit(T.self, UInt.max/2 + 0)
        NBKAssertUpdateAsDigit(T.self, UInt.max/2 + 1)
        NBKAssertUpdateAsDigit(T.self, UInt.max)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Update x Assertions
//*============================================================================*

private func NBKAssertUpdate<T: IntXLOrUIntXL>(_ value: T, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual({ var x = T(words:[0, 0, 0, 0] as W); x.update(value); return x }(), value, file: file, line: line)
    XCTAssertEqual({ var x = T(words:[1, 2, 3, 4] as W); x.update(value); return x }(), value, file: file, line: line)
}

private func NBKAssertUpdateAsDigit<T: IntXLOrUIntXL>(_ type: T.Type, _ value: T.Digit, file: StaticString = #file, line: UInt = #line) {
    NBKAssertUpdate(T(digit: value), file: file, line: line)
    XCTAssertEqual({ var x = T(words:[0, 0, 0, 0] as W); x.update(value); return x }(), T(digit: value), file: file, line: line)
    XCTAssertEqual({ var x = T(words:[1, 2, 3, 4] as W); x.update(value); return x }(), T(digit: value), file: file, line: line)
}
