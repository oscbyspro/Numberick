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
    
    func testDecodingUInt32() {
        NBKAssertDecoding( nil,   UInt32?(nil),  010, "-4294967296")
        NBKAssertDecoding(.minus, UInt32 .max,   010, "-4294967295")
        NBKAssertDecoding(.plus,  UInt32 .max,   010, "+4294967295")
        NBKAssertDecoding( nil,   UInt32?(nil),  010, "+4294967296")
        
        NBKAssertDecoding( nil,   UInt32?(nil),  016, "-0100000000")
        NBKAssertDecoding(.minus, UInt32 .max,   016, "-00ffffffff")
        NBKAssertDecoding(.plus,  UInt32 .max,   016, "+00ffffffff")
        NBKAssertDecoding( nil,   UInt32?(nil),  016, "+0100000000")
        
        NBKAssertDecodingByDecodingRadix( nil,   UInt32?(nil), "-004294967296")
        NBKAssertDecodingByDecodingRadix(.minus, UInt32 .max,  "-004294967295")
        NBKAssertDecodingByDecodingRadix(.plus,  UInt32 .max,  "+004294967295")
        NBKAssertDecodingByDecodingRadix( nil,   UInt32?(nil), "+004294967296")
        
        NBKAssertDecodingByDecodingRadix( nil,   UInt32?(nil), "-0x0100000000")
        NBKAssertDecodingByDecodingRadix(.minus, UInt32 .max,  "-0x00ffffffff")
        NBKAssertDecodingByDecodingRadix(.plus,  UInt32 .max,  "+0x00ffffffff")
        NBKAssertDecodingByDecodingRadix( nil,   UInt32?(nil), "+0x0100000000")
    }
    
    func testDecodingUInt64() {
        NBKAssertDecoding( nil,   UInt64?(nil),  010, "-18446744073709551616")
        NBKAssertDecoding(.minus, UInt64 .max,   010, "-18446744073709551615")
        NBKAssertDecoding(.plus,  UInt64 .max,   010, "+18446744073709551615")
        NBKAssertDecoding( nil,   UInt64?(nil),  010, "+18446744073709551616")
        
        NBKAssertDecoding( nil,   UInt64?(nil),  016, "-00010000000000000000")
        NBKAssertDecoding(.minus, UInt64 .max,   016, "-0000ffffffffffffffff")
        NBKAssertDecoding(.plus,  UInt64 .max,   016, "+0000ffffffffffffffff")
        NBKAssertDecoding( nil,   UInt64?(nil),  016, "+00010000000000000000")
        
        NBKAssertDecodingByDecodingRadix( nil,   UInt64?(nil), "-0018446744073709551616")
        NBKAssertDecodingByDecodingRadix(.minus, UInt64 .max,  "-0018446744073709551615")
        NBKAssertDecodingByDecodingRadix(.plus,  UInt64 .max,  "+0018446744073709551615")
        NBKAssertDecodingByDecodingRadix( nil,   UInt64?(nil), "+0018446744073709551616")
        
        NBKAssertDecodingByDecodingRadix( nil,   UInt64?(nil), "-0x00010000000000000000")
        NBKAssertDecodingByDecodingRadix(.minus, UInt64 .max,  "-0x0000ffffffffffffffff")
        NBKAssertDecodingByDecodingRadix(.plus,  UInt64 .max,  "+0x0000ffffffffffffffff")
        NBKAssertDecodingByDecodingRadix( nil,   UInt64?(nil), "+0x00010000000000000000")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testDecodingInvalidInputsReturnsNil() {
        NBKAssertDecoding(nil, UInt64?(nil), 010, "!0000000000000000001")
        NBKAssertDecoding(nil, UInt64?(nil), 010, "1000000000000000000!")
        NBKAssertDecoding(nil, UInt64?(nil), 016, "!0000000000000000001")
        NBKAssertDecoding(nil, UInt64?(nil), 016, "1000000000000000000!")
    }
    
    func testDecodingStringWithoutDigitsReturnsNil() {
        NBKAssertDecoding(nil, UInt32?(nil), 010, "+")
        NBKAssertDecoding(nil, UInt32?(nil), 016, "+")
        NBKAssertDecoding(nil, UInt64?(nil), 010, "+")
        NBKAssertDecoding(nil, UInt64?(nil), 016, "+")
    }
}

//*============================================================================*
// MARK: * NBK x Integer Description x Decoding x Core Integer
//*============================================================================*

final class NBKIntegerDescriptionTestsOnDecodingAsCoreInteger: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt32
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10AsUInt32() {
        NBKAssertDecodingDigitsByTruncating(UInt32(1234567890), 010, "1234567890")
        NBKAssertDecodingDigitsByTruncating(UInt32(4294967295), 010, "4294967295")
        
        NBKAssertDecodingDigitsByTruncating(UInt32(0000000000), 010, "4294967296" ) // + 01
        NBKAssertDecodingDigitsByTruncating(UInt32(4294967286), 010, "42949672950") // * 10
    }
    
    func testDecodingRadix16AsUInt32() {
        NBKAssertDecodingDigitsByTruncating(UInt32(0x12345678), 016, "12345678")
        NBKAssertDecodingDigitsByTruncating(UInt32(0xffffffff), 016, "ffffffff")
        
        NBKAssertDecodingDigitsByTruncating(UInt32(0x00000000), 016, "100000000") // + 01
        NBKAssertDecodingDigitsByTruncating(UInt32(0xfffffff0), 016, "ffffffff0") // * 16
    }
    
    func testDecodingStringWithoutDigitsReturnsNilAsUInt32() {
        NBKAssertDecodingDigitsByTruncating(UInt32?.none, 010,  "")
        NBKAssertDecodingDigitsByTruncating(UInt32?.none, 010, "+")
        NBKAssertDecodingDigitsByTruncating(UInt32?.none, 010, "-")
        NBKAssertDecodingDigitsByTruncating(UInt32?.none, 010, "~")
        
        NBKAssertDecodingDigitsByTruncating(UInt32?.none, 016,  "")
        NBKAssertDecodingDigitsByTruncating(UInt32?.none, 016, "+")
        NBKAssertDecodingDigitsByTruncating(UInt32?.none, 016, "-")
        NBKAssertDecodingDigitsByTruncating(UInt32?.none, 016, "~")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt64
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10AsUInt64() {
        NBKAssertDecodingDigitsByTruncating(UInt64(12345678901234567890), 010, "12345678901234567890")
        NBKAssertDecodingDigitsByTruncating(UInt64(18446744073709551615), 010, "18446744073709551615")
        
        NBKAssertDecodingDigitsByTruncating(UInt64(00000000000000000000), 010, "18446744073709551616" ) // + 01
        NBKAssertDecodingDigitsByTruncating(UInt64(18446744073709551606), 010, "184467440737095516150") // * 10
    }
    
    func testDecodingRadix16AsUInt64() {
        NBKAssertDecodingDigitsByTruncating(UInt64(0x123456789abcdef0), 016, "123456789abcdef0")
        NBKAssertDecodingDigitsByTruncating(UInt64(0xffffffffffffffff), 016, "ffffffffffffffff")
        
        NBKAssertDecodingDigitsByTruncating(UInt64(0x0000000000000000), 016, "10000000000000000") // + 01
        NBKAssertDecodingDigitsByTruncating(UInt64(0xfffffffffffffff0), 016, "ffffffffffffffff0") // * 16
    }
    
    func testDecodingStringWithoutDigitsReturnsNilAsUInt64() {
        NBKAssertDecodingDigitsByTruncating(UInt64?.none, 010,  "")
        NBKAssertDecodingDigitsByTruncating(UInt64?.none, 010, "+")
        NBKAssertDecodingDigitsByTruncating(UInt64?.none, 010, "-")
        NBKAssertDecodingDigitsByTruncating(UInt64?.none, 010, "~")
        
        NBKAssertDecodingDigitsByTruncating(UInt64?.none, 016,  "")
        NBKAssertDecodingDigitsByTruncating(UInt64?.none, 016, "+")
        NBKAssertDecodingDigitsByTruncating(UInt64?.none, 016, "-")
        NBKAssertDecodingDigitsByTruncating(UInt64?.none, 016, "~")
    }
}

//*============================================================================*
// MARK: * NBK x Integer Description x Decoding x Assertions
//*============================================================================*

private func NBKAssertDecoding<Magnitude: NBKUnsignedInteger>(
_ sign: FloatingPointSign?, _ magnitude: Magnitude?, _ radix: Int, _ description: StaticString,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let decoder = NBK.IntegerDescription.Decoder<Magnitude>(radix: radix)
    //=------------------------------------------=
    brr: do {
        let components = decoder.decode(description)
        XCTAssertEqual(sign,      components?.sign,      file: file, line: line)
        XCTAssertEqual(magnitude, components?.magnitude, file: file, line: line)
    }
    
    brr: do {
        let components = decoder.decode(description.description)
        XCTAssertEqual(sign,      components?.sign,      file: file, line: line)
        XCTAssertEqual(magnitude, components?.magnitude, file: file, line: line)
    }
}

private func NBKAssertDecodingByDecodingRadix<Magnitude: NBKUnsignedInteger>(
_ sign: FloatingPointSign?, _ magnitude: Magnitude?, _ description: StaticString,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let decoder = NBK.IntegerDescription.DecoderDecodingRadix<Magnitude>()
    //=------------------------------------------=
    brr: do {
        let components = decoder.decode(description)
        XCTAssertEqual(sign,      components?.sign,      file: file, line: line)
        XCTAssertEqual(magnitude, components?.magnitude, file: file, line: line)
    }
    
    brr: do {
        let components = decoder.decode(description.description)
        XCTAssertEqual(sign,      components?.sign,      file: file, line: line)
        XCTAssertEqual(magnitude, components?.magnitude, file: file, line: line)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Digit
//=----------------------------------------------------------------------------=

private func NBKAssertDecodingDigitsByTruncating<T: NBKCoreInteger>(
_ result: T?, _ radix: Int, _ digits: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    var digits = digits; digits.withUTF8 {
        XCTAssertEqual(NBK.IntegerDescription.truncating(digits: $0, radix: radix), result, file: file, line: line)
    }
}

#endif
