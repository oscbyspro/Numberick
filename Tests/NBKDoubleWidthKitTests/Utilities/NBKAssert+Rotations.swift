//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x Assert x Rotations
//*============================================================================*

func NBKAssertRotateLeft<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  Int, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let (words, bits) = rhs.quotientAndRemainder(dividingBy: UInt.bitWidth)
    //=------------------------------------------=
    XCTAssert(0 ..< lhs.bitWidth ~= rhs, file: file, line: line)
    //=------------------------------------------=
    if (0 ..< lhs.bitWidth) ~= rhs, bits.isZero {
        XCTAssertEqual(lhs.bitrotatedLeft(words: words), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitrotateLeft(words: words); return lhs }(), result, file: file, line: line)
    }
}

func NBKAssertRotateRight<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs:  Int, _ result: NBKDoubleWidth<H>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let (words, bits) = rhs.quotientAndRemainder(dividingBy: UInt.bitWidth)
    //=------------------------------------------=
    XCTAssert(0 ..< lhs.bitWidth ~= rhs, file: file, line: line)
    //=------------------------------------------=
    if (0 ..< lhs.bitWidth) ~= rhs, bits.isZero {
        XCTAssertEqual(lhs.bitrotatedRight(words: words), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitrotateRight(words: words); return lhs }(), result, file: file, line: line)
    }
}
