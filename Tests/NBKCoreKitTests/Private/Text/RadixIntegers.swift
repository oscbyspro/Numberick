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
// MARK: * NBK x Radix Integers x Decode Digits By Truncating
//*============================================================================*

final class NBKRadixIntegersTestsOnDecodeDigitsByTruncating: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt32
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10AsUInt32() throws {
        typealias T = UInt32
        
        NBKAssertDecodeDigitsByTruncating(T(1234567890), 10, "1234567890")
        NBKAssertDecodeDigitsByTruncating(T(4294967295), 10, "4294967295")
        
        NBKAssertDecodeDigitsByTruncating(T(0000000000), 10, "4294967296" ) // + 01
        NBKAssertDecodeDigitsByTruncating(T(4294967286), 10, "42949672950") // * 10
    }
    
    func testDecodingRadix16AsUInt32() throws {
        typealias T = UInt32
        
        NBKAssertDecodeDigitsByTruncating(T(0x12345678), 16, "12345678")
        NBKAssertDecodeDigitsByTruncating(T(0xffffffff), 16, "ffffffff")
        
        NBKAssertDecodeDigitsByTruncating(T(0x00000000), 16, "100000000") // + 01
        NBKAssertDecodeDigitsByTruncating(T(0xfffffff0), 16, "ffffffff0") // * 16
    }
    
    func testDecodingStringWithoutDigitsReturnsNilAsUInt32() {
        typealias T = UInt32
        
        NBKAssertDecodeDigitsByTruncating(T?.none, 10,  "")
        NBKAssertDecodeDigitsByTruncating(T?.none, 10, "+")
        NBKAssertDecodeDigitsByTruncating(T?.none, 10, "-")
        NBKAssertDecodeDigitsByTruncating(T?.none, 10, "~")
        
        NBKAssertDecodeDigitsByTruncating(T?.none, 16,  "")
        NBKAssertDecodeDigitsByTruncating(T?.none, 16, "+")
        NBKAssertDecodeDigitsByTruncating(T?.none, 16, "-")
        NBKAssertDecodeDigitsByTruncating(T?.none, 16, "~")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt64
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10AsUInt64() throws {
        typealias T = UInt64
        
        NBKAssertDecodeDigitsByTruncating(T(12345678901234567890), 10, "12345678901234567890")
        NBKAssertDecodeDigitsByTruncating(T(18446744073709551615), 10, "18446744073709551615")
        
        NBKAssertDecodeDigitsByTruncating(T(00000000000000000000), 10, "18446744073709551616" ) // + 01
        NBKAssertDecodeDigitsByTruncating(T(18446744073709551606), 10, "184467440737095516150") // * 10
    }
    
    func testDecodingRadix16AsUInt64() throws {
        typealias T = UInt64
        
        NBKAssertDecodeDigitsByTruncating(T(0x123456789abcdef0), 16, "123456789abcdef0")
        NBKAssertDecodeDigitsByTruncating(T(0xffffffffffffffff), 16, "ffffffffffffffff")
        
        NBKAssertDecodeDigitsByTruncating(T(0x0000000000000000), 16, "10000000000000000") // + 01
        NBKAssertDecodeDigitsByTruncating(T(0xfffffffffffffff0), 16, "ffffffffffffffff0") // * 16
    }
    
    func testDecodingStringWithoutDigitsReturnsNilAsUInt64() {
        typealias T = UInt64
        
        NBKAssertDecodeDigitsByTruncating(T?.none, 10,  "")
        NBKAssertDecodeDigitsByTruncating(T?.none, 10, "+")
        NBKAssertDecodeDigitsByTruncating(T?.none, 10, "-")
        NBKAssertDecodeDigitsByTruncating(T?.none, 10, "~")
        
        NBKAssertDecodeDigitsByTruncating(T?.none, 16,  "")
        NBKAssertDecodeDigitsByTruncating(T?.none, 16, "+")
        NBKAssertDecodeDigitsByTruncating(T?.none, 16, "-")
        NBKAssertDecodeDigitsByTruncating(T?.none, 16, "~")
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

private func NBKAssertDecodeDigitsByTruncating<T: NBKCoreInteger>(
_ result: T?, _ radix: Int, _ digits: String,
file: StaticString = #file, line: UInt = #line) {
    var digits = digits; digits.withUTF8 {
        XCTAssertEqual(NBK.truncating(digits: $0, radix: radix), result, file: file, line: line)
    }
}

#endif
