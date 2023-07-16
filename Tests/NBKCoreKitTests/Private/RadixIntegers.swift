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
// MARK: * NBK x Radix Integers
//*============================================================================*

final class NBKRadixIntegersTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Components
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

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

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

//*============================================================================*
// MARK: * NBK x Radix Integers x UInt
//*============================================================================*

final class NBKRadixIntegersTestsOnUInt: XCTestCase {
    
    typealias T = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertDecodeDigitsAsUIntByTruncating(T(12345678901234567890), 10, "12345678901234567890")
        NBKAssertDecodeDigitsAsUIntByTruncating(T(18446744073709551615), 10, "18446744073709551615")
        
        NBKAssertDecodeDigitsAsUIntByTruncating(T(00000000000000000000), 10, "18446744073709551616" ) // + 01
        NBKAssertDecodeDigitsAsUIntByTruncating(T(18446744073709551606), 10, "184467440737095516150") // * 10
    }
    
    func testDecodingRadix16() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertDecodeDigitsAsUIntByTruncating(T(0x123456789abcdef0), 16, "123456789abcdef0")
        NBKAssertDecodeDigitsAsUIntByTruncating(T(0xffffffffffffffff), 16, "ffffffffffffffff")
        
        NBKAssertDecodeDigitsAsUIntByTruncating(T(0x0000000000000000), 16, "10000000000000000") // + 01
        NBKAssertDecodeDigitsAsUIntByTruncating(T(0xfffffffffffffff0), 16, "ffffffffffffffff0") // * 16
    }
    
    func testDecodingStringWithoutDigitsReturnsNil() {
        NBKAssertDecodeDigitsAsUIntByTruncating(T?.none, 10,  "")
        NBKAssertDecodeDigitsAsUIntByTruncating(T?.none, 10, "+")
        NBKAssertDecodeDigitsAsUIntByTruncating(T?.none, 10, "-")
        NBKAssertDecodeDigitsAsUIntByTruncating(T?.none, 10, "~")
        
        NBKAssertDecodeDigitsAsUIntByTruncating(T?.none, 16,  "")
        NBKAssertDecodeDigitsAsUIntByTruncating(T?.none, 16, "+")
        NBKAssertDecodeDigitsAsUIntByTruncating(T?.none, 16, "-")
        NBKAssertDecodeDigitsAsUIntByTruncating(T?.none, 16, "~")
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

private func NBKAssertDecodeDigitsAsUIntByTruncating(
_ result: UInt?, _ radix: Int, _ digits: String,
file: StaticString = #file, line: UInt = #line) {
    var digits = digits; digits.withUTF8 { utf8 in
        let value = NBK.truncatingAsUInt(digits: utf8, radix: radix)
        XCTAssertEqual(value, result, file: file, line: line)
    }
}

#endif
