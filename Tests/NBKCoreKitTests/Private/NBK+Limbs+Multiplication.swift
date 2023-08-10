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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Limbs x Multiplication x Unsigned
//*============================================================================*

final class NBKTestsOnLimbsByMultiplicationAsUnsigned: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testMultiplicationByDigitWithAddition() {
        NBKAssertMultiplicationByDigitWithAdditionAsUnsigned([~0, ~0, ~0, ~0] as W,  0,  0, [ 0,  0,  0,  0,  0] as W)
        NBKAssertMultiplicationByDigitWithAdditionAsUnsigned([~0, ~0, ~0, ~0] as W,  0, ~0, [~0,  0,  0,  0,  0] as W)
        NBKAssertMultiplicationByDigitWithAdditionAsUnsigned([~0, ~0, ~0, ~0] as W, ~0,  0, [ 1, ~0, ~0, ~0, ~1] as W)
        NBKAssertMultiplicationByDigitWithAdditionAsUnsigned([~0, ~0, ~0, ~0] as W, ~0, ~0, [ 0,  0,  0,  0, ~0] as W)
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Multiplication x Assertions
//*============================================================================*

private func NBKAssertMultiplicationByDigitWithAdditionAsUnsigned(
_ limbs: [UInt], _ multiplicand: UInt, _ addend: UInt, _ product: [UInt],
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    var result = limbs; result.append(NBK.multiplyFullWidthLenientUnsignedInteger(&result, by: multiplicand, add: addend))
    //=------------------------------------------=
    XCTAssertEqual(result, product, file: file, line: line)
}

#endif
