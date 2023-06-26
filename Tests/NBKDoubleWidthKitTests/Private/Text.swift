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
@testable import NBKDoubleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x Text x UInt
//*============================================================================*

final class TextTestsOnUInt: XCTestCase {
    
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
    var digits = digits; digits.withUTF8 {  utf8 in
        let value = UInt.truncating(digits: utf8, radix: radix)
        XCTAssertEqual(value, result, file: file,  line:  line)
    }
}

#endif
