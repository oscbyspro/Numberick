//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import XCTest

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Multiplication x Sub Sequence
//*============================================================================*

final class NBKStrictUnsignedIntegerTestsOnMultiplicationAsSubSequence: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit + Digit
    //=------------------------------------------------------------------------=
    
    func testMultiplicationByDigitWithAddition() {
        NBKAssertMultiplicationByDigitWithAddition([~0, ~0, ~0, ~0] as X,  0,  0, [ 0,  0,  0,  0] as X,  0)
        NBKAssertMultiplicationByDigitWithAddition([~0, ~0, ~0, ~0] as X,  0, ~0, [~0,  0,  0,  0] as X,  0)
        NBKAssertMultiplicationByDigitWithAddition([~0, ~0, ~0, ~0] as X, ~0,  0, [ 1, ~0, ~0, ~0] as X, ~1)
        NBKAssertMultiplicationByDigitWithAddition([~0, ~0, ~0, ~0] as X, ~0, ~0, [ 0,  0,  0,  0] as X, ~0)
    }
}

//*============================================================================*
// MARK: * NBK x Strict Unsigned Integer x Multiplication x Assertions
//*============================================================================*

private func NBKAssertMultiplicationByDigitWithAddition(
    _ lhs: [UInt], _ rhs: UInt, _ addend: UInt, _ product: [UInt], _ high: UInt,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SUISS
    //=------------------------------------------=
    // multiplication: digit + digit
    //=------------------------------------------=
    brr: do {
        var lhs = lhs
        let top = T.multiply(&lhs, by: rhs, add: addend)
        XCTAssertEqual(lhs, product, file: file, line: line)
        XCTAssertEqual(top, high,    file: file, line: line)
    }
}
