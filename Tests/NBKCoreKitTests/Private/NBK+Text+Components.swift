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

//*============================================================================*
// MARK: * NBK x Text x Components
//*============================================================================*

final class NBKTestsOnTextByComponents: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testRemoveLeadingSign() {
        NBKAssertRemoveLeadingSign(    "",  nil,       "")
        NBKAssertRemoveLeadingSign(   "+", .plus,      "")
        NBKAssertRemoveLeadingSign(   "-", .minus,     "")
        NBKAssertRemoveLeadingSign(   "~",  nil,      "~")
        NBKAssertRemoveLeadingSign("+123", .plus,   "123")
        NBKAssertRemoveLeadingSign("-123", .minus,  "123")
        NBKAssertRemoveLeadingSign("~123",  nil,   "~123")
    }
    
    func testRemoveLeadingRadix() {
        NBKAssertRemoveLeadingRadix(     "",  nil,      "")
        NBKAssertRemoveLeadingRadix(   "0b",  002,      "")
        NBKAssertRemoveLeadingRadix(   "0o",  008,      "")
        NBKAssertRemoveLeadingRadix(   "0x",  016,      "")
        NBKAssertRemoveLeadingRadix(   "Ox",  nil,    "Ox")
        NBKAssertRemoveLeadingRadix(   "0X",  nil,    "0X")
        NBKAssertRemoveLeadingRadix("0b123",  002,   "123")
        NBKAssertRemoveLeadingRadix("0o123",  008,   "123")
        NBKAssertRemoveLeadingRadix("0x123",  016,   "123")
        NBKAssertRemoveLeadingRadix("Ox123",  nil, "Ox123")
        NBKAssertRemoveLeadingRadix("0X123",  nil, "0X123")
    }
    
    func testMakeIntegerComponents() {
        NBKAssertMakeIntegerComponents(    "", .plus,      "")
        NBKAssertMakeIntegerComponents(   "+", .plus,      "")
        NBKAssertMakeIntegerComponents(   "-", .minus,     "")
        NBKAssertMakeIntegerComponents(   "~", .plus,     "~")
        NBKAssertMakeIntegerComponents("+123", .plus,   "123")
        NBKAssertMakeIntegerComponents("-123", .minus,  "123")
        NBKAssertMakeIntegerComponents("~123", .plus,  "~123")
    }
    
    func testMakeIntegerComponentsByDecodingRadix() {
        NBKAssertMakeIntegerComponentsByDecodingRadix(      "", .plus,  10,       "")
        NBKAssertMakeIntegerComponentsByDecodingRadix(     "+", .plus,  10,       "")
        NBKAssertMakeIntegerComponentsByDecodingRadix(     "-", .minus, 10,       "")
        NBKAssertMakeIntegerComponentsByDecodingRadix(     "~", .plus,  10,      "~")
        NBKAssertMakeIntegerComponentsByDecodingRadix(    "0b", .plus,  02,       "")
        NBKAssertMakeIntegerComponentsByDecodingRadix(    "0o", .plus,  08,       "")
        NBKAssertMakeIntegerComponentsByDecodingRadix(    "0x", .plus,  16,       "")
        NBKAssertMakeIntegerComponentsByDecodingRadix(    "Ox", .plus,  10,     "Ox")
        NBKAssertMakeIntegerComponentsByDecodingRadix(    "0X", .plus,  10,     "0X")
        NBKAssertMakeIntegerComponentsByDecodingRadix(   "123", .plus,  10,    "123")
        NBKAssertMakeIntegerComponentsByDecodingRadix("+0b123", .plus,  02,    "123")
        NBKAssertMakeIntegerComponentsByDecodingRadix("+0o123", .plus,  08,    "123")
        NBKAssertMakeIntegerComponentsByDecodingRadix("+0x123", .plus,  16,    "123")
        NBKAssertMakeIntegerComponentsByDecodingRadix("-0b123", .minus, 02,    "123")
        NBKAssertMakeIntegerComponentsByDecodingRadix("-0o123", .minus, 08,    "123")
        NBKAssertMakeIntegerComponentsByDecodingRadix("-0x123", .minus, 16,    "123")
        NBKAssertMakeIntegerComponentsByDecodingRadix("~Ox123", .plus,  10, "~Ox123")
        NBKAssertMakeIntegerComponentsByDecodingRadix("~0X123", .plus,  10, "~0X123")
    }
}

//*============================================================================*
// MARK: * NBK x Text x Components x Assertions
//*============================================================================*

private func NBKAssertRemoveLeadingSign(
_ text: String, _ sign: FloatingPointSign?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    var componentsBody = text.utf8[...]
    let componentsSign = NBK.removeLeadingSign(utf8: &componentsBody)
    XCTAssertEqual(componentsSign, sign,  file: file, line: line)
    XCTAssertEqual(Array(componentsBody), Array(body.utf8), file: file, line: line)
}

private func NBKAssertRemoveLeadingRadix(
_ text: String, _ radix: Int?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    var componentsBody = text.utf8[...]
    let componentsSign = NBK.removeLeadingRadix(utf8: &componentsBody)
    XCTAssertEqual(componentsSign, radix, file: file, line: line)
    XCTAssertEqual(Array(componentsBody), Array(body.utf8), file: file, line: line)
}

private func NBKAssertMakeIntegerComponents(
_ text: String, _ sign: FloatingPointSign?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    let components = NBK.makeIntegerComponents(utf8: text.utf8)
    XCTAssertEqual(components.sign, sign,  file: file, line: line)
    XCTAssertEqual(Array(components.body), Array(body.utf8), file: file, line: line)
}

private func NBKAssertMakeIntegerComponentsByDecodingRadix(
_ text: String, _ sign: FloatingPointSign?, _ radix: Int?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    let components = NBK.makeIntegerComponentsByDecodingRadix(utf8: text.utf8)
    XCTAssertEqual(components.sign,  sign,  file: file, line: line)
    XCTAssertEqual(components.radix, radix, file: file, line: line)
    XCTAssertEqual(Array(components.body),  Array(body.utf8), file: file, line: line)
}

#endif
