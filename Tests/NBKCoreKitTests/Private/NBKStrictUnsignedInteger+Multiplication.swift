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
// MARK: * NBK x Strict Unsigned Integer x Multiplication
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnMultiplication: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Small
    //=------------------------------------------------------------------------=
    
    func testMultiplicationByDigitWithAddition() {
        NBKAssertMultiplicationByDigitWithAdditionAsUnsigned([~0, ~0, ~0, ~0] as W,  0,  0, [ 0,  0,  0,  0,  0] as W)
        NBKAssertMultiplicationByDigitWithAdditionAsUnsigned([~0, ~0, ~0, ~0] as W,  0, ~0, [~0,  0,  0,  0,  0] as W)
        NBKAssertMultiplicationByDigitWithAdditionAsUnsigned([~0, ~0, ~0, ~0] as W, ~0,  0, [ 1, ~0, ~0, ~0, ~1] as W, true)
        NBKAssertMultiplicationByDigitWithAdditionAsUnsigned([~0, ~0, ~0, ~0] as W, ~0, ~0, [ 0,  0,  0,  0, ~0] as W, true)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Multiplication x Assertions
//*============================================================================*

private func NBKAssertMultiplicationByDigitWithAdditionAsUnsigned(
_ lhs: [UInt], _ rhs: UInt, _ addend: UInt, _ product: [UInt], _ overflow: Bool = false,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let lhs = NBK.StrictUnsignedInteger(lhs)
    //=------------------------------------------=
    // multiplication: digit + digit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let top = lhs.multiplyFullWidth(by: rhs, add: addend)
        XCTAssertEqual(top > 00 as UInt, overflow, file: file, line: line)
        XCTAssertEqual(lhs.base + [top], product,  file: file, line: line)
    }
    
    brr: do {
        var lhs = lhs
        let top = lhs.multiplyReportingOverflow(by: rhs, add: addend)
        XCTAssertEqual(top, overflow, file: file, line: line)
        XCTAssertEqual(lhs.base, Array(product.dropLast()), file: file, line: line)
    }
}

#endif
