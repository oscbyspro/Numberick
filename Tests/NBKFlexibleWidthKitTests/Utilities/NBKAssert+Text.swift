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

//*============================================================================*
// MARK: * NBK x Assert x Text
//*============================================================================*

func NBKAssertDecodeText<T: NBKBinaryInteger> (
_ integer: T?, _ radix: Int, _ text: String,
file: StaticString = #file, line: UInt = #line) where T: LosslessStringConvertible {
    //=------------------------------------------=
    if  radix == 10 {
        XCTAssertEqual(T(text), integer, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(T(text, radix: radix), integer, file: file, line: line)
}

func NBKAssertEncodeText<T: NBKBinaryInteger>(
_ integer: T, _ radix: Int, _ uppercase: Bool, _ text: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  radix == 10, uppercase == false {
        XCTAssertEqual(String(integer),       text, file: file, line: line)
        XCTAssertEqual(integer.description,   text, file: file, line: line)
        XCTAssertEqual(integer.description(), text, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(String(integer,     radix: radix, uppercase: uppercase), text, file: file, line: line)
    XCTAssertEqual(integer.description(radix: radix, uppercase: uppercase), text, file: file, line: line)
}