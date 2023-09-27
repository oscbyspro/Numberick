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
// MARK: * NBK x Integer Description x Decoding
//*============================================================================*

final class NBKIntegerDescriptionTestsOnDecoding: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testDecodingInt32() {
        NBKAssertDecoding(Int32?(nil), 16, "-80000001")
        NBKAssertDecoding(Int32 .min,  16, "-80000000")
        NBKAssertDecoding(Int32 .max,  16, "+7fffffff")
        NBKAssertDecoding(Int32?(nil), 16, "+80000000")
        
        NBKAssertDecoding(Int32?(nil), 10, "-2147483649")
        NBKAssertDecoding(Int32 .min,  10, "-2147483648")
        NBKAssertDecoding(Int32 .max,  10, "+2147483647")
        NBKAssertDecoding(Int32?(nil), 10, "+2147483648")
    }
    
    func testDecodingInt64() {
        NBKAssertDecoding(Int64?(nil), 16, "-8000000000000001")
        NBKAssertDecoding(Int64 .min,  16, "-8000000000000000")
        NBKAssertDecoding(Int64 .max,  16, "+7fffffffffffffff")
        NBKAssertDecoding(Int64?(nil), 16, "+8000000000000000")
        
        NBKAssertDecoding(Int64?(nil), 10, "-9223372036854775809")
        NBKAssertDecoding(Int64 .min,  10, "-9223372036854775808")
        NBKAssertDecoding(Int64 .max,  10, "+9223372036854775807")
        NBKAssertDecoding(Int64?(nil), 10, "+9223372036854775808")
    }
    
    func testDecodingUInt32() {
        NBKAssertDecoding(UInt32?(nil), 16, "-00000001")
        NBKAssertDecoding(UInt32 .min,  16, "000000000")
        NBKAssertDecoding(UInt32 .max,  16, "0ffffffff")
        NBKAssertDecoding(UInt32?(nil), 16, "100000000")

        NBKAssertDecoding(UInt32?(nil), 10, "-000000001")
        NBKAssertDecoding(UInt32 .min,  10, "0000000000")
        NBKAssertDecoding(UInt32 .max,  10, "4294967295")
        NBKAssertDecoding(UInt32?(nil), 10, "4294967296")
    }
    
    func testDecodingUInt64() {
        NBKAssertDecoding(UInt64?(nil), 16, "-0000000000000001")
        NBKAssertDecoding(UInt64 .min,  16, "00000000000000000")
        NBKAssertDecoding(UInt64 .max,  16, "0ffffffffffffffff")
        NBKAssertDecoding(UInt64?(nil), 16, "10000000000000000")

        NBKAssertDecoding(UInt64?(nil), 10, "-0000000000000000001")
        NBKAssertDecoding(UInt64 .min,  10, "00000000000000000000")
        NBKAssertDecoding(UInt64 .max,  10, "18446744073709551615")
        NBKAssertDecoding(UInt64?(nil), 10, "18446744073709551616")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testDecodingStringWithoutDigitsReturnsNil() {
        NBKAssertDecoding( Int32?(nil), 10, "+")
        NBKAssertDecoding( Int64?(nil), 16, "+")
        NBKAssertDecoding(UInt32?(nil), 10, "+")
        NBKAssertDecoding(UInt64?(nil), 16, "+")
    }
}

//*============================================================================*
// MARK: * NBK x Integer Description x Decoding x Digit
//*============================================================================*

final class NBKIntegerDescriptionTestsOnDecodingOneDigit: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt32
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10AsUInt32() {
        typealias T = UInt32
        
        NBKAssertDecodingDigitsByTruncating(T(1234567890), 10, "1234567890")
        NBKAssertDecodingDigitsByTruncating(T(4294967295), 10, "4294967295")
        
        NBKAssertDecodingDigitsByTruncating(T(0000000000), 10, "4294967296" ) // + 01
        NBKAssertDecodingDigitsByTruncating(T(4294967286), 10, "42949672950") // * 10
    }
    
    func testDecodingRadix16AsUInt32() {
        typealias T = UInt32
        
        NBKAssertDecodingDigitsByTruncating(T(0x12345678), 16, "12345678")
        NBKAssertDecodingDigitsByTruncating(T(0xffffffff), 16, "ffffffff")
        
        NBKAssertDecodingDigitsByTruncating(T(0x00000000), 16, "100000000") // + 01
        NBKAssertDecodingDigitsByTruncating(T(0xfffffff0), 16, "ffffffff0") // * 16
    }
    
    func testDecodingStringWithoutDigitsReturnsNilAsUInt32() {
        typealias T = UInt32
        
        NBKAssertDecodingDigitsByTruncating(T?.none, 10,  "")
        NBKAssertDecodingDigitsByTruncating(T?.none, 10, "+")
        NBKAssertDecodingDigitsByTruncating(T?.none, 10, "-")
        NBKAssertDecodingDigitsByTruncating(T?.none, 10, "~")
        
        NBKAssertDecodingDigitsByTruncating(T?.none, 16,  "")
        NBKAssertDecodingDigitsByTruncating(T?.none, 16, "+")
        NBKAssertDecodingDigitsByTruncating(T?.none, 16, "-")
        NBKAssertDecodingDigitsByTruncating(T?.none, 16, "~")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt64
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10AsUInt64() {
        typealias T = UInt64
        
        NBKAssertDecodingDigitsByTruncating(T(12345678901234567890), 10, "12345678901234567890")
        NBKAssertDecodingDigitsByTruncating(T(18446744073709551615), 10, "18446744073709551615")
        
        NBKAssertDecodingDigitsByTruncating(T(00000000000000000000), 10, "18446744073709551616" ) // + 01
        NBKAssertDecodingDigitsByTruncating(T(18446744073709551606), 10, "184467440737095516150") // * 10
    }
    
    func testDecodingRadix16AsUInt64() {
        typealias T = UInt64
        
        NBKAssertDecodingDigitsByTruncating(T(0x123456789abcdef0), 16, "123456789abcdef0")
        NBKAssertDecodingDigitsByTruncating(T(0xffffffffffffffff), 16, "ffffffffffffffff")
        
        NBKAssertDecodingDigitsByTruncating(T(0x0000000000000000), 16, "10000000000000000") // + 01
        NBKAssertDecodingDigitsByTruncating(T(0xfffffffffffffff0), 16, "ffffffffffffffff0") // * 16
    }
    
    func testDecodingStringWithoutDigitsReturnsNilAsUInt64() {
        typealias T = UInt64
        
        NBKAssertDecodingDigitsByTruncating(T?.none, 10,  "")
        NBKAssertDecodingDigitsByTruncating(T?.none, 10, "+")
        NBKAssertDecodingDigitsByTruncating(T?.none, 10, "-")
        NBKAssertDecodingDigitsByTruncating(T?.none, 10, "~")
        
        NBKAssertDecodingDigitsByTruncating(T?.none, 16,  "")
        NBKAssertDecodingDigitsByTruncating(T?.none, 16, "+")
        NBKAssertDecodingDigitsByTruncating(T?.none, 16, "-")
        NBKAssertDecodingDigitsByTruncating(T?.none, 16, "~")
    }
}

//*============================================================================*
// MARK: * NBK x Integer Description x Decoding x Assertions
//*============================================================================*

private func NBKAssertDecoding<T: NBKCoreInteger>(
_ result: T?, _ radix: Int, _ description: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let decoder = NBK.IntegerDescription.Decoder(radix: radix)
    //=------------------------------------------=
    XCTAssertEqual(result, decoder.decode(description), file: file, line: line)
}

private func NBKAssertDecodingDigitsByTruncating<T: NBKCoreInteger>(
_ result: T?, _ radix: Int, _ digits: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    var digits = digits; digits.withUTF8 {
        XCTAssertEqual(NBK.IntegerDescription.truncating(digits: $0, radix: radix), result, file: file, line: line)
    }
}

#endif
