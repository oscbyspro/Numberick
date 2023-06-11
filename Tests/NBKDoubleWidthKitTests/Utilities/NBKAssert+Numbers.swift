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
// MARK: * NBK x Assert x Numbers
//*============================================================================*

func NBKAssertNumbers<I: NBKBinaryInteger, O: NBKBinaryInteger>(
from value: I, default: O,
file: StaticString = #file, line: UInt = #line) {
    NBKAssertNumbers(from: value, exactly: `default`, clamping: `default`, truncating: `default`, file: file, line: line)
}

func NBKAssertNumbers<I: NBKBinaryInteger, O: NBKBinaryInteger>(
from value: I, default: O, exactly: O?,
file: StaticString = #file, line: UInt = #line) {
    NBKAssertNumbers(from: value, exactly: exactly, clamping: `default`, truncating: `default`, file: file, line: line)
}

func NBKAssertNumbers<I: NBKBinaryInteger, O: NBKBinaryInteger>(
from value: I, default: O, clamping: O,
file: StaticString = #file, line: UInt = #line) {
    NBKAssertNumbers(from: value, exactly: `default`, clamping: clamping, truncating: `default`, file: file, line: line)
}

func NBKAssertNumbers<I: NBKBinaryInteger, O: NBKBinaryInteger>(
from value: I, default: O, truncating: O,
file: StaticString = #file, line: UInt = #line) {
    NBKAssertNumbers(from: value, exactly: `default`, clamping: `default`, truncating: truncating, file: file, line: line)
}

func NBKAssertNumbers<I: NBKBinaryInteger, O: NBKBinaryInteger>(
from value: I, exactly: O?, clamping: O, truncating: O,
file: StaticString = #file, line: UInt = #line) {
    //=--------------------------------------=
    if  let exactly = exactly {
        XCTAssertEqual(O(value), exactly, file: file, line: line)
    }
    //=--------------------------------------=
    XCTAssertEqual(O(exactly:            value), exactly,    file: file, line: line)
    XCTAssertEqual(O(clamping:           value), clamping,   file: file, line: line)
    XCTAssertEqual(O(truncatingIfNeeded: value), truncating, file: file, line: line)
}
