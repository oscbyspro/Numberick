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
    // MARK: Tests x UInt32
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10AsUInt32() {
        typealias T = UInt32
        
        NBKAssertDecodeDigitsByTruncating(T(1234567890), 10, "1234567890")
        NBKAssertDecodeDigitsByTruncating(T(4294967295), 10, "4294967295")
        
        NBKAssertDecodeDigitsByTruncating(T(0000000000), 10, "4294967296" ) // + 01
        NBKAssertDecodeDigitsByTruncating(T(4294967286), 10, "42949672950") // * 10
    }
    
    func testDecodingRadix16AsUInt32() {
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
    
    func testDecodingRadix10AsUInt64() {
        typealias T = UInt64
        
        NBKAssertDecodeDigitsByTruncating(T(12345678901234567890), 10, "12345678901234567890")
        NBKAssertDecodeDigitsByTruncating(T(18446744073709551615), 10, "18446744073709551615")
        
        NBKAssertDecodeDigitsByTruncating(T(00000000000000000000), 10, "18446744073709551616" ) // + 01
        NBKAssertDecodeDigitsByTruncating(T(18446744073709551606), 10, "184467440737095516150") // * 10
    }
    
    func testDecodingRadix16AsUInt64() {
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

//*============================================================================*
// MARK: * NBK x Text x Assertions
//*============================================================================*

private func NBKAssertDecodeDigitsByTruncating<T: NBKCoreInteger>(
_ result: T?, _ radix: Int, _ digits: String,
file: StaticString = #file, line: UInt = #line) {
    var digits = digits; digits.withUTF8 {
        XCTAssertEqual(NBK.truncating(digits: $0, radix: radix), result, file: file, line: line)
    }
}

#endif
