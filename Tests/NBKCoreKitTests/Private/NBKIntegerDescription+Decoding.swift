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
// MARK: * NBK x Integer Description x Decoding x Binary Integer
//*============================================================================*

final class NBKIntegerDescriptionTestsOnDecodingAsBinaryInteger: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testDecodingInt32() {
        NBKAssertDecodingAsBinaryInteger(Int32?(nil), 10, "-2147483649")
        NBKAssertDecodingAsBinaryInteger(Int32 .min,  10, "-2147483648")
        NBKAssertDecodingAsBinaryInteger(Int32 .max,  10, "+2147483647")
        NBKAssertDecodingAsBinaryInteger(Int32?(nil), 10, "+2147483648")
        
        NBKAssertDecodingAsBinaryInteger(Int32?(nil), 16, "-0080000001")
        NBKAssertDecodingAsBinaryInteger(Int32 .min,  16, "-0080000000")
        NBKAssertDecodingAsBinaryInteger(Int32 .max,  16, "+007fffffff")
        NBKAssertDecodingAsBinaryInteger(Int32?(nil), 16, "+0080000000")
        
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int32?(nil), 10, "-2147483649")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int32 .min,  10, "-2147483648")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int32 .max,  10, "+2147483647")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int32?(nil), 10, "+2147483648")
        
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int32?(nil), 16, "-0x80000001")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int32 .min,  16, "-0x80000000")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int32 .max,  16, "+0x7fffffff")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int32?(nil), 16, "+0x80000000")
    }
    
    func testDecodingInt64() {
        NBKAssertDecodingAsBinaryInteger(Int64?(nil), 10, "-9223372036854775809")
        NBKAssertDecodingAsBinaryInteger(Int64 .min,  10, "-9223372036854775808")
        NBKAssertDecodingAsBinaryInteger(Int64 .max,  10, "+9223372036854775807")
        NBKAssertDecodingAsBinaryInteger(Int64?(nil), 10, "+9223372036854775808")
        
        NBKAssertDecodingAsBinaryInteger(Int64?(nil), 16, "-0008000000000000001")
        NBKAssertDecodingAsBinaryInteger(Int64 .min,  16, "-0008000000000000000")
        NBKAssertDecodingAsBinaryInteger(Int64 .max,  16, "+0007fffffffffffffff")
        NBKAssertDecodingAsBinaryInteger(Int64?(nil), 16, "+0008000000000000000")
        
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int64?(nil), 10, "-9223372036854775809")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int64 .min,  10, "-9223372036854775808")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int64 .max,  10, "+9223372036854775807")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int64?(nil), 10, "+9223372036854775808")
        
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int64?(nil), 16, "-0x08000000000000001")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int64 .min,  16, "-0x08000000000000000")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int64 .max,  16, "+0x07fffffffffffffff")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(Int64?(nil), 16, "+0x08000000000000000")
    }
    
    func testDecodingUInt32() {
        NBKAssertDecodingAsBinaryInteger(UInt32?(nil), 10, "-0000000001")
        NBKAssertDecodingAsBinaryInteger(UInt32 .min,  10, "-0000000000")
        NBKAssertDecodingAsBinaryInteger(UInt32 .max,  10, "+4294967295")
        NBKAssertDecodingAsBinaryInteger(UInt32?(nil), 10, "+4294967296")
        
        NBKAssertDecodingAsBinaryInteger(UInt32?(nil), 16, "-0000000001")
        NBKAssertDecodingAsBinaryInteger(UInt32 .min,  16, "-0000000000")
        NBKAssertDecodingAsBinaryInteger(UInt32 .max,  16, "+00ffffffff")
        NBKAssertDecodingAsBinaryInteger(UInt32?(nil), 16, "+0100000000")
        
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt32?(nil), 10, "-00000000001")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt32 .min,  10, "-00000000000")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt32 .max,  10, "+04294967295")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt32?(nil), 10, "+04294967296")
        
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt32?(nil), 16, "-0x000000001")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt32 .min,  16, "-0x000000000")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt32 .max,  16, "+0x0ffffffff")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt32?(nil), 16, "+0x100000000")
    }
    
    func testDecodingUInt64() {
        NBKAssertDecodingAsBinaryInteger(UInt64?(nil), 10, "-00000000000000000001")
        NBKAssertDecodingAsBinaryInteger(UInt64 .min,  10, "-00000000000000000000")
        NBKAssertDecodingAsBinaryInteger(UInt64 .max,  10, "+18446744073709551615")
        NBKAssertDecodingAsBinaryInteger(UInt64?(nil), 10, "+18446744073709551616")
        
        NBKAssertDecodingAsBinaryInteger(UInt64?(nil), 16, "-00000000000000000001")
        NBKAssertDecodingAsBinaryInteger(UInt64 .min,  16, "-00000000000000000000")
        NBKAssertDecodingAsBinaryInteger(UInt64 .max,  16, "+0000ffffffffffffffff")
        NBKAssertDecodingAsBinaryInteger(UInt64?(nil), 16, "+00010000000000000000")
        
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt64?(nil), 10, "-00000000000000000001")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt64 .min,  10, "-00000000000000000000")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt64 .max,  10, "+18446744073709551615")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt64?(nil), 10, "+18446744073709551616")
        
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt64?(nil), 16, "-0x000000000000000001")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt64 .min,  16, "-0x000000000000000000")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt64 .max,  16, "+0x00ffffffffffffffff")
        NBKAssertDecodingByDecodingRadixAsBinaryInteger(UInt64?(nil), 16, "+0x010000000000000000")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testDecodingStringWithoutDigitsReturnsNil() {
        NBKAssertDecodingAsBinaryInteger( Int32?(nil), 10, "+")
        NBKAssertDecodingAsBinaryInteger( Int64?(nil), 16, "+")
        NBKAssertDecodingAsBinaryInteger(UInt32?(nil), 10, "+")
        NBKAssertDecodingAsBinaryInteger(UInt64?(nil), 16, "+")
    }
}

//*============================================================================*
// MARK: * NBK x Integer Description x Decoding x Sign & Magnitude
//*============================================================================*

final class NBKIntegerDescriptionTestsOnDecodingAsSignMagnitude: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecodingUInt32() {
        NBKAssertDecodingAsSignMagnitude( nil,   UInt32?(nil), 10, "-4294967296")
        NBKAssertDecodingAsSignMagnitude(.minus, UInt32 .max,  10, "-4294967295")
        NBKAssertDecodingAsSignMagnitude(.plus,  UInt32 .max,  10, "+4294967295")
        NBKAssertDecodingAsSignMagnitude( nil,   UInt32?(nil), 10, "+4294967296")
        
        NBKAssertDecodingAsSignMagnitude( nil,   UInt32?(nil), 16, "-0100000000")
        NBKAssertDecodingAsSignMagnitude(.minus, UInt32 .max,  16, "-00ffffffff")
        NBKAssertDecodingAsSignMagnitude(.plus,  UInt32 .max,  16, "+00ffffffff")
        NBKAssertDecodingAsSignMagnitude( nil,   UInt32?(nil), 16, "+0100000000")
        
        NBKAssertDecodingByDecodingRadixAsSignMagnitude( nil,   UInt32?(nil), "-004294967296")
        NBKAssertDecodingByDecodingRadixAsSignMagnitude(.minus, UInt32 .max,  "-004294967295")
        NBKAssertDecodingByDecodingRadixAsSignMagnitude(.plus,  UInt32 .max,  "+004294967295")
        NBKAssertDecodingByDecodingRadixAsSignMagnitude( nil,   UInt32?(nil), "+004294967296")
        
        NBKAssertDecodingByDecodingRadixAsSignMagnitude( nil,   UInt32?(nil), "-0x0100000000")
        NBKAssertDecodingByDecodingRadixAsSignMagnitude(.minus, UInt32 .max,  "-0x00ffffffff")
        NBKAssertDecodingByDecodingRadixAsSignMagnitude(.plus,  UInt32 .max,  "+0x00ffffffff")
        NBKAssertDecodingByDecodingRadixAsSignMagnitude( nil,   UInt32?(nil), "+0x0100000000")
    }
    
    func testDecodingUInt64() {
        NBKAssertDecodingAsSignMagnitude( nil,   UInt64?(nil), 10, "-18446744073709551616")
        NBKAssertDecodingAsSignMagnitude(.minus, UInt64 .max,  10, "-18446744073709551615")
        NBKAssertDecodingAsSignMagnitude(.plus,  UInt64 .max,  10, "+18446744073709551615")
        NBKAssertDecodingAsSignMagnitude( nil,   UInt64?(nil), 10, "+18446744073709551616")
        
        NBKAssertDecodingAsSignMagnitude( nil,   UInt64?(nil), 16, "-00010000000000000000")
        NBKAssertDecodingAsSignMagnitude(.minus, UInt64 .max,  16, "-0000ffffffffffffffff")
        NBKAssertDecodingAsSignMagnitude(.plus,  UInt64 .max,  16, "+0000ffffffffffffffff")
        NBKAssertDecodingAsSignMagnitude( nil,   UInt64?(nil), 16, "+00010000000000000000")
        
        NBKAssertDecodingByDecodingRadixAsSignMagnitude( nil,   UInt64?(nil), "-0018446744073709551616")
        NBKAssertDecodingByDecodingRadixAsSignMagnitude(.minus, UInt64 .max,  "-0018446744073709551615")
        NBKAssertDecodingByDecodingRadixAsSignMagnitude(.plus,  UInt64 .max,  "+0018446744073709551615")
        NBKAssertDecodingByDecodingRadixAsSignMagnitude( nil,   UInt64?(nil), "+0018446744073709551616")
        
        NBKAssertDecodingByDecodingRadixAsSignMagnitude( nil,   UInt64?(nil), "-0x00010000000000000000")
        NBKAssertDecodingByDecodingRadixAsSignMagnitude(.minus, UInt64 .max,  "-0x0000ffffffffffffffff")
        NBKAssertDecodingByDecodingRadixAsSignMagnitude(.plus,  UInt64 .max,  "+0x0000ffffffffffffffff")
        NBKAssertDecodingByDecodingRadixAsSignMagnitude( nil,   UInt64?(nil), "+0x00010000000000000000")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testDecodingStringWithoutDigitsReturnsNil() {
        NBKAssertDecodingAsSignMagnitude(nil, UInt32?(nil), 10, "+")
        NBKAssertDecodingAsSignMagnitude(nil, UInt32?(nil), 16, "+")
        NBKAssertDecodingAsSignMagnitude(nil, UInt64?(nil), 10, "+")
        NBKAssertDecodingAsSignMagnitude(nil, UInt64?(nil), 16, "+")
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

private func NBKAssertDecodingAsBinaryInteger<T: NBKCoreInteger>(
_ result: T?, _ radix: Int, _ description: StaticString,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let decoder = NBK.IntegerDescription.Decoder(radix: radix)
    //=------------------------------------------=
    XCTAssertEqual(result, decoder.decode(description), file: file, line: line)
    XCTAssertEqual(result, decoder.decode(description.description), file: file, line: line)
    //=------------------------------------------=
}

private func NBKAssertDecodingAsSignMagnitude<M: NBKUnsignedInteger>(
_ sign: FloatingPointSign?, _ magnitude: M?, _ radix: Int, _ description: StaticString,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let decoder = NBK.IntegerDescription.Decoder(radix: radix)
    //=------------------------------------------=
    brr: do {
        let decoded: SM<M>? = decoder.decode(description)
        XCTAssertEqual(sign,      decoded?.sign,      file: file, line: line)
        XCTAssertEqual(magnitude, decoded?.magnitude, file: file, line: line)
    }
    
    brr: do {
        let decoded: SM<M>? = decoder.decode(description.description)
        XCTAssertEqual(sign,      decoded?.sign,      file: file, line: line)
        XCTAssertEqual(magnitude, decoded?.magnitude, file: file, line: line)
    }
}

private func NBKAssertDecodingByDecodingRadixAsBinaryInteger<T: NBKCoreInteger>(
_ result: T?, _ radix: Int, _ description: StaticString,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let decoder = NBK.IntegerDescription.DecoderDecodingRadix()
    //=------------------------------------------=
    XCTAssertEqual(result, decoder.decode(description), file: file, line: line)
    XCTAssertEqual(result, decoder.decode(description.description), file: file, line: line)
}

private func NBKAssertDecodingByDecodingRadixAsSignMagnitude<M: NBKUnsignedInteger>(
_ sign: FloatingPointSign?, _ magnitude: M?, _ description: StaticString,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let decoder = NBK.IntegerDescription.DecoderDecodingRadix()
    //=------------------------------------------=
    brr: do {
        let decoded: SM<M>? = decoder.decode(description)
        XCTAssertEqual(sign,      decoded?.sign,      file: file, line: line)
        XCTAssertEqual(magnitude, decoded?.magnitude, file: file, line: line)
    }
    
    brr: do {
        let decoded: SM<M>? = decoder.decode(description.description)
        XCTAssertEqual(sign,      decoded?.sign,      file: file, line: line)
        XCTAssertEqual(magnitude, decoded?.magnitude, file: file, line: line)
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
