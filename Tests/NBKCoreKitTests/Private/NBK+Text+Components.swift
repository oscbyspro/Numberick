//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import XCTest
#if !COCOAPODS
import NBKCoreKit
#else
import Numberick
#endif

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
    
    func testMakeIntegerComponents() {
        NBKAssertMakeIntegerComponents(    "", .plus,      "")
        NBKAssertMakeIntegerComponents(   "+", .plus,      "")
        NBKAssertMakeIntegerComponents(   "-", .minus,     "")
        NBKAssertMakeIntegerComponents(   "~", .plus,     "~")
        NBKAssertMakeIntegerComponents("+123", .plus,   "123")
        NBKAssertMakeIntegerComponents("-123", .minus,  "123")
        NBKAssertMakeIntegerComponents("~123", .plus,  "~123")
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
    XCTAssertEqual(componentsSign, sign)
    XCTAssertEqual(Array(componentsBody), Array(body.utf8))
}

private func NBKAssertMakeIntegerComponents(
_ text: String, _ sign: FloatingPointSign?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    let components = NBK.makeIntegerComponents(utf8: text.utf8)
    XCTAssertEqual(components.sign, sign)
    XCTAssertEqual(Array(components.body), Array(body.utf8))
}

#endif
