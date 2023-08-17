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
    
    func testRemoveSignPrefix() {
        NBKAssertRemoveSignPrefix(    "",  nil,       "")
        NBKAssertRemoveSignPrefix(   "+", .plus,      "")
        NBKAssertRemoveSignPrefix(   "-", .minus,     "")
        NBKAssertRemoveSignPrefix(   "~",  nil,      "~")
        NBKAssertRemoveSignPrefix("+123", .plus,   "123")
        NBKAssertRemoveSignPrefix("-123", .minus,  "123")
        NBKAssertRemoveSignPrefix("~123",  nil,   "~123")
    }
    
    func testRemoveRadixPrefix() {
        NBKAssertRemoveRadixPrefix(     "",  nil,      "")
        NBKAssertRemoveRadixPrefix(   "0b",  002,      "")
        NBKAssertRemoveRadixPrefix(   "0o",  008,      "")
        NBKAssertRemoveRadixPrefix(   "0x",  016,      "")
        NBKAssertRemoveRadixPrefix(   "1x",  nil,    "1x")
        NBKAssertRemoveRadixPrefix(   "0X",  nil,    "0X")
        NBKAssertRemoveRadixPrefix("0b123",  002,   "123")
        NBKAssertRemoveRadixPrefix("0o123",  008,   "123")
        NBKAssertRemoveRadixPrefix("0x123",  016,   "123")
        NBKAssertRemoveRadixPrefix("1x123",  nil, "1x123")
        NBKAssertRemoveRadixPrefix("0X123",  nil, "0X123")
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
    
    func testMakeIntegerComponentsWithRadix() {
        NBKAssertMakeIntegerComponentsWithRadix(      "", .plus,  10,       "")
        NBKAssertMakeIntegerComponentsWithRadix(     "+", .plus,  10,       "")
        NBKAssertMakeIntegerComponentsWithRadix(     "-", .minus, 10,       "")
        NBKAssertMakeIntegerComponentsWithRadix(     "~", .plus,  10,      "~")
        NBKAssertMakeIntegerComponentsWithRadix(    "0b", .plus,  02,       "")
        NBKAssertMakeIntegerComponentsWithRadix(    "0o", .plus,  08,       "")
        NBKAssertMakeIntegerComponentsWithRadix(    "0x", .plus,  16,       "")
        NBKAssertMakeIntegerComponentsWithRadix(    "1x", .plus,  10,     "1x")
        NBKAssertMakeIntegerComponentsWithRadix(    "0X", .plus,  10,     "0X")
        NBKAssertMakeIntegerComponentsWithRadix(   "123", .plus,  10,    "123")
        NBKAssertMakeIntegerComponentsWithRadix("+0b123", .plus,  02,    "123")
        NBKAssertMakeIntegerComponentsWithRadix("+0o123", .plus,  08,    "123")
        NBKAssertMakeIntegerComponentsWithRadix("+0x123", .plus,  16,    "123")
        NBKAssertMakeIntegerComponentsWithRadix("-0b123", .minus, 02,    "123")
        NBKAssertMakeIntegerComponentsWithRadix("-0o123", .minus, 08,    "123")
        NBKAssertMakeIntegerComponentsWithRadix("-0x123", .minus, 16,    "123")
        NBKAssertMakeIntegerComponentsWithRadix("~1x123", .plus,  10, "~1x123")
        NBKAssertMakeIntegerComponentsWithRadix("~0X123", .plus,  10, "~0X123")
    }
}

//*============================================================================*
// MARK: * NBK x Text x Components x Assertions
//*============================================================================*

private func NBKAssertRemoveSignPrefix(
_ text: String, _ sign: FloatingPointSign?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    var componentsBody = text.utf8[...]
    let componentsSign = NBK.removeSignPrefix(utf8: &componentsBody)
    XCTAssertEqual(componentsSign, sign,  file: file, line: line)
    XCTAssertEqual(Array(componentsBody), Array(body.utf8), file: file, line: line)
}

private func NBKAssertRemoveRadixPrefix(
_ text: String, _ radix: Int?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    var componentsBody = text.utf8[...]
    let componentsSign = NBK.removeRadixPrefix(utf8: &componentsBody)
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

private func NBKAssertMakeIntegerComponentsWithRadix(
_ text: String, _ sign: FloatingPointSign?, _ radix: Int?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    let components = NBK.makeIntegerComponentsWithRadix(utf8: text.utf8)
    XCTAssertEqual(components.sign,  sign,  file: file, line: line)
    XCTAssertEqual(components.radix, radix, file: file, line: line)
    XCTAssertEqual(Array(components.body),  Array(body.utf8), file: file, line: line)
}

#endif
