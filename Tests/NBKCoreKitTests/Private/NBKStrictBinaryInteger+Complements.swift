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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Complements x Sub Sequence
//*============================================================================*

final class NBKStrictBinaryIntegerTestsOnComplementsAsSubSequence: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testOnesComplement() {
        NBKAssertOnesComplement([ 0,  0,  0,  0], [~0, ~0, ~0, ~0])
        NBKAssertOnesComplement([~0, ~0, ~0, ~0], [ 0,  0,  0,  0])
        NBKAssertOnesComplement([ 1,  2,  3,  4], [~1, ~2, ~3, ~4])
        NBKAssertOnesComplement([~1, ~2, ~3, ~4], [ 1,  2,  3,  4])
    }
    
    func testTwosComplement() {
        NBKAssertTwosComplement([ 0,  0,  0,  0], [ 0,  0,  0,  0])
        NBKAssertTwosComplement([~0, ~0, ~0, ~0], [ 1,  0,  0,  0])
        NBKAssertTwosComplement([ 1,  2,  3,  4], [~0, ~2, ~3, ~4])
        NBKAssertTwosComplement([~1, ~2, ~3, ~4], [ 2,  2,  3,  4])
    }
}

//*============================================================================*
// MARK: * NBK x Strict Binary Integer x Complements x Assertions
//*============================================================================*

private func NBKAssertOnesComplement(
_ operand: [UInt], _ result: [UInt],
file: StaticString = #file, line: UInt  = #line) {
    //=------------------------------------------=
    typealias SBI = NBK.SBISS
    //=------------------------------------------=
    brr: do {
        var operand = operand
        SBI.formOnesComplement(&operand)
        XCTAssertEqual(operand, result, file: file, line: line)
    }
}

private func NBKAssertTwosComplement(
_ operand: [UInt], _ result: [UInt],
file: StaticString = #file, line: UInt  = #line) {
    //=------------------------------------------=
    typealias SBI = NBK.SBISS
    //=------------------------------------------=
    brr: do {
        var operand = operand
        SBI.formTwosComplement(&operand)
        XCTAssertEqual(operand, result, file: file, line: line)
    }
}
