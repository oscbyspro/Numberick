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
// MARK: * NBK x Text
//*============================================================================*

final class NBKTestsOnText: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIntegerComponents() {
        NBKAssertIntegerComponents(    "", .plus,      "")
        NBKAssertIntegerComponents(   "+", .plus,      "")
        NBKAssertIntegerComponents(   "-", .minus,     "")
        NBKAssertIntegerComponents(   "~", .plus,     "~")
        NBKAssertIntegerComponents("+123", .plus,   "123")
        NBKAssertIntegerComponents("-123", .minus,  "123")
        NBKAssertIntegerComponents("~123", .plus,  "~123")
    }
    
    func testRemoveSignPrefix() {
        NBKAssertRemoveSignPrefix(    "",  nil,       "")
        NBKAssertRemoveSignPrefix(   "+", .plus,      "")
        NBKAssertRemoveSignPrefix(   "-", .minus,     "")
        NBKAssertRemoveSignPrefix(   "~",  nil,      "~")
        NBKAssertRemoveSignPrefix("+123", .plus,   "123")
        NBKAssertRemoveSignPrefix("-123", .minus,  "123")
        NBKAssertRemoveSignPrefix("~123",  nil,   "~123")
    }
}

//*============================================================================*
// MARK: * NBK x Text x Assertions
//*============================================================================*

private func NBKAssertIntegerComponents(
_ text: String, _ sign: FloatingPointSign?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    let components = NBK.integerComponents(utf8: text.utf8)
    XCTAssertEqual(components.sign, sign)
    XCTAssertEqual(Array(components.body), Array(body.utf8))
}

private func NBKAssertRemoveSignPrefix(
_ text: String, _ sign: FloatingPointSign?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    var componentsBody = text.utf8[...]
    let componentsSign = NBK.removeSignPrefix(utf8: &componentsBody)
    XCTAssertEqual(componentsSign, sign)
    XCTAssertEqual(Array(componentsBody), Array(body.utf8))
}

#endif
