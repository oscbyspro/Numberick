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
        
        NBKAssertDecodingByDecodingRadix( nil,   nil, UInt32?(nil), "-004294967296")
        NBKAssertDecodingByDecodingRadix(.minus, 010, UInt32 .max,  "-004294967295")
        NBKAssertDecodingByDecodingRadix(.plus,  010, UInt32 .max,  "+004294967295")
        NBKAssertDecodingByDecodingRadix( nil,   nil, UInt32?(nil), "+004294967296")
        
        NBKAssertDecodingByDecodingRadix( nil,   nil, UInt32?(nil), "-0x0100000000")
        NBKAssertDecodingByDecodingRadix(.minus, 016, UInt32 .max,  "-0x00ffffffff")
        NBKAssertDecodingByDecodingRadix(.plus,  016, UInt32 .max,  "+0x00ffffffff")
        NBKAssertDecodingByDecodingRadix( nil,   nil, UInt32?(nil), "+0x0100000000")
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
        
        NBKAssertDecodingByDecodingRadix( nil,   nil, UInt64?(nil), "-0018446744073709551616")
        NBKAssertDecodingByDecodingRadix(.minus, 010, UInt64 .max,  "-0018446744073709551615")
        NBKAssertDecodingByDecodingRadix(.plus,  010, UInt64 .max,  "+0018446744073709551615")
        NBKAssertDecodingByDecodingRadix( nil,   nil, UInt64?(nil), "+0018446744073709551616")
        
        NBKAssertDecodingByDecodingRadix( nil,   nil, UInt64?(nil), "-0x00010000000000000000")
        NBKAssertDecodingByDecodingRadix(.minus, 016, UInt64 .max,  "-0x0000ffffffffffffffff")
        NBKAssertDecodingByDecodingRadix(.plus,  016, UInt64 .max,  "+0x0000ffffffffffffffff")
        NBKAssertDecodingByDecodingRadix( nil,   nil, UInt64?(nil), "+0x00010000000000000000")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
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
        typealias T = UInt32
        
        NBKAssertDecodingDigitsByTruncating(T(1234567890), 010, "1234567890")
        NBKAssertDecodingDigitsByTruncating(T(4294967295), 010, "4294967295")
        
        NBKAssertDecodingDigitsByTruncating(T(0000000000), 010, "4294967296" ) // + 01
        NBKAssertDecodingDigitsByTruncating(T(4294967286), 010, "42949672950") // * 10
    }
    
    func testDecodingRadix16AsUInt32() {
        typealias T = UInt32
        
        NBKAssertDecodingDigitsByTruncating(T(0x12345678), 016, "12345678")
        NBKAssertDecodingDigitsByTruncating(T(0xffffffff), 016, "ffffffff")
        
        NBKAssertDecodingDigitsByTruncating(T(0x00000000), 016, "100000000") // + 01
        NBKAssertDecodingDigitsByTruncating(T(0xfffffff0), 016, "ffffffff0") // * 16
    }
    
    func testDecodingStringWithoutDigitsReturnsNilAsUInt32() {
        typealias T = UInt32
        
        NBKAssertDecodingDigitsByTruncating(T?.none, 010,  "")
        NBKAssertDecodingDigitsByTruncating(T?.none, 010, "+")
        NBKAssertDecodingDigitsByTruncating(T?.none, 010, "-")
        NBKAssertDecodingDigitsByTruncating(T?.none, 010, "~")
        
        NBKAssertDecodingDigitsByTruncating(T?.none, 016,  "")
        NBKAssertDecodingDigitsByTruncating(T?.none, 016, "+")
        NBKAssertDecodingDigitsByTruncating(T?.none, 016, "-")
        NBKAssertDecodingDigitsByTruncating(T?.none, 016, "~")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt64
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix10AsUInt64() {
        typealias T = UInt64
        
        NBKAssertDecodingDigitsByTruncating(T(12345678901234567890), 010, "12345678901234567890")
        NBKAssertDecodingDigitsByTruncating(T(18446744073709551615), 010, "18446744073709551615")
        
        NBKAssertDecodingDigitsByTruncating(T(00000000000000000000), 010, "18446744073709551616" ) // + 01
        NBKAssertDecodingDigitsByTruncating(T(18446744073709551606), 010, "184467440737095516150") // * 10
    }
    
    func testDecodingRadix16AsUInt64() {
        typealias T = UInt64
        
        NBKAssertDecodingDigitsByTruncating(T(0x123456789abcdef0), 016, "123456789abcdef0")
        NBKAssertDecodingDigitsByTruncating(T(0xffffffffffffffff), 016, "ffffffffffffffff")
        
        NBKAssertDecodingDigitsByTruncating(T(0x0000000000000000), 016, "10000000000000000") // + 01
        NBKAssertDecodingDigitsByTruncating(T(0xfffffffffffffff0), 016, "ffffffffffffffff0") // * 16
    }
    
    func testDecodingStringWithoutDigitsReturnsNilAsUInt64() {
        typealias T = UInt64
        
        NBKAssertDecodingDigitsByTruncating(T?.none, 010,  "")
        NBKAssertDecodingDigitsByTruncating(T?.none, 010, "+")
        NBKAssertDecodingDigitsByTruncating(T?.none, 010, "-")
        NBKAssertDecodingDigitsByTruncating(T?.none, 010, "~")
        
        NBKAssertDecodingDigitsByTruncating(T?.none, 016,  "")
        NBKAssertDecodingDigitsByTruncating(T?.none, 016, "+")
        NBKAssertDecodingDigitsByTruncating(T?.none, 016, "-")
        NBKAssertDecodingDigitsByTruncating(T?.none, 016, "~")
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
_ sign: FloatingPointSign?, _ radix: Int?, _ magnitude: Magnitude?, _ description: StaticString,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let decoder = NBK.IntegerDescription.DecoderDecodingRadix<Magnitude>()
    //=------------------------------------------=
    brr: do {
        let components = decoder.decode(description)
        XCTAssertEqual(sign,      components?.sign,      file: file, line: line)
        XCTAssertEqual(radix,     components?.radix,     file: file, line: line)
        XCTAssertEqual(magnitude, components?.magnitude, file: file, line: line)
    }
    
    brr: do {
        let components = decoder.decode(description.description)
        XCTAssertEqual(sign,      components?.sign,      file: file, line: line)
        XCTAssertEqual(radix,     components?.radix,     file: file, line: line)
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
