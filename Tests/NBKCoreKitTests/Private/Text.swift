//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

@testable import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Text
//*============================================================================*

final class NBKTextTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUnsafeIntegerTextComponents() {
        NBKAssertUnsafeIntegerTextComponents(    "", .plus,      "")
        NBKAssertUnsafeIntegerTextComponents(   "+", .plus,      "")
        NBKAssertUnsafeIntegerTextComponents(   "-", .minus,     "")
        NBKAssertUnsafeIntegerTextComponents(   "~", .plus,     "~")
        NBKAssertUnsafeIntegerTextComponents("+123", .plus,   "123")
        NBKAssertUnsafeIntegerTextComponents("-123", .minus,  "123")
        NBKAssertUnsafeIntegerTextComponents("~123", .plus,  "~123")
    }
    
    func testUnsafeIntegerTextRemoveSign() {
        NBKAssertUnsafeIntegerTextRemoveSign(    "",  nil,       "")
        NBKAssertUnsafeIntegerTextRemoveSign(   "+", .plus,      "")
        NBKAssertUnsafeIntegerTextRemoveSign(   "-", .minus,     "")
        NBKAssertUnsafeIntegerTextRemoveSign(   "~",  nil,      "~")
        NBKAssertUnsafeIntegerTextRemoveSign("+123", .plus,   "123")
        NBKAssertUnsafeIntegerTextRemoveSign("-123", .minus,  "123")
        NBKAssertUnsafeIntegerTextRemoveSign("~123",  nil,   "~123")
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

private func NBKAssertUnsafeIntegerTextComponents(
_ text: String, _ sign: FloatingPointSign?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    var text = text
    var body = body
    
    text.withUTF8 { text in
    body.withUTF8 { body in
        
        let (componentsSign, componentsBody) = NBK.unsafeIntegerTextComponents(utf8: text)
        
        XCTAssertEqual(/*--*/componentsSign,  /*--*/sign,  file: file, line: line)
        XCTAssertEqual(Array(componentsBody), Array(body), file: file, line: line)
    }}
}

private func NBKAssertUnsafeIntegerTextRemoveSign(
_ text: String, _ sign: FloatingPointSign?, _ body: String,
file: StaticString = #file, line: UInt = #line) {
    var text = text
    var body = body
    
    text.withUTF8 { text in
    body.withUTF8 { body in
        
        var componentsBody = text[...]
        let componentsSign = componentsBody.removeSignPrefix()
        
        XCTAssertEqual(/*--*/componentsSign,  /*--*/sign,  file: file, line: line)
        XCTAssertEqual(Array(componentsBody), Array(body), file: file, line: line)
    }}
}

#endif
