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
import NBKTextKit
import XCTest

//*============================================================================*
// MARK: * NBK x Integer Description x Components
//*============================================================================*

final class NBKIntegerDescriptionTestsOnComponents: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMakeSignBody() {
        NBKAssertMakeSignBody(    "", .plus,      "")
        NBKAssertMakeSignBody(   "+", .plus,      "")
        NBKAssertMakeSignBody(   "-", .minus,     "")
        NBKAssertMakeSignBody(   "~", .plus,     "~")
        NBKAssertMakeSignBody("+123", .plus,   "123")
        NBKAssertMakeSignBody("-123", .minus,  "123")
        NBKAssertMakeSignBody("~123", .plus,  "~123")
    }
    
    func testMakeSignRadixBody() {
        NBKAssertMakeSignRadixBody(      "", .plus,  10,       "")
        NBKAssertMakeSignRadixBody(     "+", .plus,  10,       "")
        NBKAssertMakeSignRadixBody(     "-", .minus, 10,       "")
        NBKAssertMakeSignRadixBody(     "~", .plus,  10,      "~")
        NBKAssertMakeSignRadixBody(    "0b", .plus,  02,       "")
        NBKAssertMakeSignRadixBody(    "0o", .plus,  08,       "")
        NBKAssertMakeSignRadixBody(    "0x", .plus,  16,       "")
        NBKAssertMakeSignRadixBody(    "Ox", .plus,  10,     "Ox")
        NBKAssertMakeSignRadixBody(    "0X", .plus,  10,     "0X")
        NBKAssertMakeSignRadixBody(   "123", .plus,  10,    "123")
        NBKAssertMakeSignRadixBody("+0b123", .plus,  02,    "123")
        NBKAssertMakeSignRadixBody("+0o123", .plus,  08,    "123")
        NBKAssertMakeSignRadixBody("+0x123", .plus,  16,    "123")
        NBKAssertMakeSignRadixBody("-0b123", .minus, 02,    "123")
        NBKAssertMakeSignRadixBody("-0o123", .minus, 08,    "123")
        NBKAssertMakeSignRadixBody("-0x123", .minus, 16,    "123")
        NBKAssertMakeSignRadixBody("~Ox123", .plus,  10, "~Ox123")
        NBKAssertMakeSignRadixBody("~0X123", .plus,  10, "~0X123")
    }
    
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
}

//*============================================================================*
// MARK: * NBK x Text x Components x Assertions
//*============================================================================*

private func NBKAssertRemoveLeadingSign(
_ text: String, _ sign: FloatingPointSign?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    var componentsBody = text.utf8[...]
    let componentsSign = NBK.IntegerDescription.removeLeadingSign(from: &componentsBody)
    XCTAssertEqual(componentsSign, sign,  file: file, line: line)
    XCTAssertEqual(Array(componentsBody), Array(body.utf8), file: file, line: line)
}

private func NBKAssertRemoveLeadingRadix(
_ text: String, _ radix: Int?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    var componentsBody = text.utf8[...]
    let componentsSign = NBK.IntegerDescription.removeLeadingRadix(from: &componentsBody)
    XCTAssertEqual(componentsSign, radix, file: file, line: line)
    XCTAssertEqual(Array(componentsBody), Array(body.utf8), file: file, line: line)
}

private func NBKAssertMakeSignBody(
_ text: String, _ sign: FloatingPointSign?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    let components = NBK.IntegerDescription.makeSignBody(from: text.utf8)
    XCTAssertEqual(components.sign, sign,  file: file, line: line)
    XCTAssertEqual(Array(components.body), Array(body.utf8), file: file, line: line)
}

private func NBKAssertMakeSignRadixBody(
_ text: String, _ sign: FloatingPointSign?, _ radix: Int?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    let components = NBK.IntegerDescription.makeSignRadixBody(from: text.utf8)
    XCTAssertEqual(components.sign,  sign,  file: file, line: line)
    XCTAssertEqual(components.radix, radix, file: file, line: line)
    XCTAssertEqual(Array(components.body),  Array(body.utf8), file: file, line: line)
}

#endif
