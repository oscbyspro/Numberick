//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Integer Description x Encoding
//*============================================================================*

final class NBKIntegerDescriptionTestsOnEncoding: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEncodingEmptyCollectionsReturnsZero() {
        let words = [] as [UInt]
        for radix in 2 ... 36 {
            NBKAssertSignMagnitude(.plus,  words, radix, "0")
            NBKAssertSignMagnitude(.minus, words, radix, "0")
        }
    }
    
    func testSignExtendingDoesNotChangeTheResult() {
        let words = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0] as [UInt]
        for radix in 2 ... 36 {
            NBKAssertSignMagnitude(.plus,  words, radix,  "1")
            NBKAssertSignMagnitude(.minus, words, radix, "-1")
        }
    }
}

//*============================================================================*
// MARK: * NBK x Integer Description x Encoding x Core Integer
//*============================================================================*

final class NBKIntegerDescriptionTestsOnEncodingCoreIntegers: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int32
    //=------------------------------------------------------------------------=
    
    func testEncodingInt32AsRadix10() {
        NBKAssertBinaryInteger( Int32(bitPattern: 0x00000000 as UInt32), 10,           "0")
        NBKAssertBinaryInteger( Int32(bitPattern: 0x03020100 as UInt32), 10,    "50462976")
        NBKAssertBinaryInteger( Int32(bitPattern: 0x7fffffff as UInt32), 10,  "2147483647")
        NBKAssertBinaryInteger( Int32(bitPattern: 0x80000000 as UInt32), 10, "-2147483648")
        NBKAssertBinaryInteger( Int32(bitPattern: 0xfffefdfc as UInt32), 10,      "-66052")
        NBKAssertBinaryInteger( Int32(bitPattern: 0xffffffff as UInt32), 10,          "-1")
    }
    
    func testEncodingInt32AsRadix16() {
        NBKAssertBinaryInteger( Int32(bitPattern: 0x00000000 as UInt32), 16,           "0")
        NBKAssertBinaryInteger( Int32(bitPattern: 0x03020100 as UInt32), 16,     "3020100")
        NBKAssertBinaryInteger( Int32(bitPattern: 0x7fffffff as UInt32), 16,    "7fffffff")
        NBKAssertBinaryInteger( Int32(bitPattern: 0x80000000 as UInt32), 16,   "-80000000")
        NBKAssertBinaryInteger( Int32(bitPattern: 0xfffefdfc as UInt32), 16,      "-10204")
        NBKAssertBinaryInteger( Int32(bitPattern: 0xffffffff as UInt32), 16,          "-1")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt32
    //=------------------------------------------------------------------------=
    
    func testEncodingUInt32AsRadix10() {
        NBKAssertBinaryInteger(UInt32(bitPattern: 0x00000000 as UInt32), 10,           "0")
        NBKAssertBinaryInteger(UInt32(bitPattern: 0x03020100 as UInt32), 10,    "50462976")
        NBKAssertBinaryInteger(UInt32(bitPattern: 0x7fffffff as UInt32), 10,  "2147483647")
        NBKAssertBinaryInteger(UInt32(bitPattern: 0x80000000 as UInt32), 10,  "2147483648")
        NBKAssertBinaryInteger(UInt32(bitPattern: 0xfffefdfc as UInt32), 10,  "4294901244")
        NBKAssertBinaryInteger(UInt32(bitPattern: 0xffffffff as UInt32), 10,  "4294967295")
    }
    
    func testEncodingUInt32AsRadix16() {
        NBKAssertBinaryInteger(UInt32(bitPattern: 0x00000000 as UInt32), 16,           "0")
        NBKAssertBinaryInteger(UInt32(bitPattern: 0x03020100 as UInt32), 16,     "3020100")
        NBKAssertBinaryInteger(UInt32(bitPattern: 0x7fffffff as UInt32), 16,    "7fffffff")
        NBKAssertBinaryInteger(UInt32(bitPattern: 0x80000000 as UInt32), 16,    "80000000")
        NBKAssertBinaryInteger(UInt32(bitPattern: 0xfffefdfc as UInt32), 16,    "fffefdfc")
        NBKAssertBinaryInteger(UInt32(bitPattern: 0xffffffff as UInt32), 16,    "ffffffff")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Int64
    //=------------------------------------------------------------------------=
    
    func testEncodingInt64AsRadix10() {
        NBKAssertBinaryInteger( Int64(bitPattern: 0x0000000000000000 as UInt64), 10,                    "0")
        NBKAssertBinaryInteger( Int64(bitPattern: 0x0706050403020100 as UInt64), 10,   "506097522914230528")
        NBKAssertBinaryInteger( Int64(bitPattern: 0x7fffffffffffffff as UInt64), 10,  "9223372036854775807")
        NBKAssertBinaryInteger( Int64(bitPattern: 0x8000000000000000 as UInt64), 10, "-9223372036854775808")
        NBKAssertBinaryInteger( Int64(bitPattern: 0xfffefdfcfbfaf9f8 as UInt64), 10,     "-283686952306184")
        NBKAssertBinaryInteger( Int64(bitPattern: 0xffffffffffffffff as UInt64), 10,                   "-1")
    }
    
    func testEncodingInt64AsRadix16() {
        NBKAssertBinaryInteger( Int64(bitPattern: 0x0000000000000000 as UInt64), 16,                    "0")
        NBKAssertBinaryInteger( Int64(bitPattern: 0x0706050403020100 as UInt64), 16,      "706050403020100")
        NBKAssertBinaryInteger( Int64(bitPattern: 0x7fffffffffffffff as UInt64), 16,     "7fffffffffffffff")
        NBKAssertBinaryInteger( Int64(bitPattern: 0x8000000000000000 as UInt64), 16,    "-8000000000000000")
        NBKAssertBinaryInteger( Int64(bitPattern: 0xfffefdfcfbfaf9f8 as UInt64), 16,       "-1020304050608")
        NBKAssertBinaryInteger( Int64(bitPattern: 0xffffffffffffffff as UInt64), 16,                   "-1")
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x UInt64
    //=------------------------------------------------------------------------=
    
    func testEncodingUInt64AsRadix10() {
        NBKAssertBinaryInteger(UInt64(bitPattern: 0x0000000000000000 as UInt64), 10,                    "0")
        NBKAssertBinaryInteger(UInt64(bitPattern: 0x0706050403020100 as UInt64), 10,   "506097522914230528")
        NBKAssertBinaryInteger(UInt64(bitPattern: 0x7fffffffffffffff as UInt64), 10,  "9223372036854775807")
        NBKAssertBinaryInteger(UInt64(bitPattern: 0x8000000000000000 as UInt64), 10,  "9223372036854775808")
        NBKAssertBinaryInteger(UInt64(bitPattern: 0xfffefdfcfbfaf9f8 as UInt64), 10, "18446460386757245432")
        NBKAssertBinaryInteger(UInt64(bitPattern: 0xffffffffffffffff as UInt64), 10, "18446744073709551615")
    }
    
    func testEncodingUInt64AsRadix16() {
        NBKAssertBinaryInteger(UInt64(bitPattern: 0x0000000000000000 as UInt64), 16,                    "0")
        NBKAssertBinaryInteger(UInt64(bitPattern: 0x0706050403020100 as UInt64), 16,      "706050403020100")
        NBKAssertBinaryInteger(UInt64(bitPattern: 0x7fffffffffffffff as UInt64), 16,     "7fffffffffffffff")
        NBKAssertBinaryInteger(UInt64(bitPattern: 0x8000000000000000 as UInt64), 16,     "8000000000000000")
        NBKAssertBinaryInteger(UInt64(bitPattern: 0xfffefdfcfbfaf9f8 as UInt64), 16,     "fffefdfcfbfaf9f8")
        NBKAssertBinaryInteger(UInt64(bitPattern: 0xffffffffffffffff as UInt64), 16,     "ffffffffffffffff")
    }
}

//*============================================================================*
// MARK: * NBK x Integer Description x Encoding x Assertions
//*============================================================================*

private func NBKAssertBinaryInteger(
_ integer: some NBKBinaryInteger, _ radix: Int, _ expectation: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let lowercase = NBK.IntegerDescription.Encoder(radix: radix, uppercase: false)
    let uppercase = NBK.IntegerDescription.Encoder(radix: radix, uppercase: true )
    //=------------------------------------------=
    brr: do {
        XCTAssertEqual(lowercase.encode(integer), expectation.lowercased(), file: file, line: line)
        XCTAssertEqual(uppercase.encode(integer), expectation.uppercased(), file: file, line: line)
    }
    
    asSignMagnitude: do {
        let sign = NBK.sign(integer.isLessThanZero), magnitude = Array(integer.magnitude.words)
        NBKAssertSignMagnitude(sign, magnitude, radix, expectation, file: file, line: line)
        NBKAssertSignMagnitude(sign, magnitude, radix, expectation, file: file, line: line)
    }
}

private func NBKAssertSignMagnitude(
_ sign: FloatingPointSign, _ magnitude: [UInt], _ radix: Int, _ expectation: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let lowercase = NBK.IntegerDescription.Encoder(radix: radix, uppercase: false)
    let uppercase = NBK.IntegerDescription.Encoder(radix: radix, uppercase: true )
    //=------------------------------------------=
    brr: do {
        XCTAssertEqual(lowercase.encode((sign: sign, magnitude: magnitude)), expectation.lowercased(), file: file, line: line)
        XCTAssertEqual(uppercase.encode((sign: sign, magnitude: magnitude)), expectation.uppercased(), file: file, line: line)
    }
    
    if  magnitude.count <= 1 {
        XCTAssertEqual(lowercase.encode((sign: sign, magnitude: magnitude.first ?? 0)), expectation.lowercased(), file: file, line: line)
        XCTAssertEqual(uppercase.encode((sign: sign, magnitude: magnitude.first ?? 0)), expectation.uppercased(), file: file, line: line)
    }
}
