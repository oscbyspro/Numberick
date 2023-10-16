//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKSignedKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Signed x Text
//*============================================================================*

final class NBKSignedTestsOnText: XCTestCase {
    
    typealias T = NBKSigned<UInt64>
    typealias M = UInt64
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromDescription() {
        NBKAssertFromDescription(T?( 10),    "10")
        NBKAssertFromDescription(T?( 10),   "+10")
        NBKAssertFromDescription(T?(-10),   "-10")
        NBKAssertFromDescription(T?(nil),   " 10")
        NBKAssertFromDescription(T?(nil),  "0x10")
        NBKAssertFromDescription(T?(nil), "+0x10")
        NBKAssertFromDescription(T?(nil), "-0x10")
        NBKAssertFromDescription(T?(nil), " 0x10")
    }
    
    func testInstanceDescriptionUsesRadix10() {
        XCTAssertEqual("10", T(10).description)
        XCTAssertEqual("10", String(describing: T(10)))
    }
    
    func testMetaTypeDescriptionCouldUseSomeLove() {
        XCTAssertEqual("NBKSigned<UInt>",   NBKSigned<UInt>  .description)
        XCTAssertEqual("NBKSigned<UInt64>", NBKSigned<UInt64>.description)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decode
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix02() {
        NBKAssertDecodeText(T.min, 02, "-" + String(repeating: "1", count: M.bitWidth / 1))
        NBKAssertDecodeText(T.max, 02,       String(repeating: "1", count: M.bitWidth / 1))
    }
    
    func testDecodingRadix03() {
        NBKAssertDecodeText(T.min, 03, "-11112220022122120101211020120210210211220")
        NBKAssertDecodeText(T.max, 03,  "11112220022122120101211020120210210211220")
    }
    
    func testDecodingRadix04() {
        NBKAssertDecodeText(T.min, 04, "-" + String(repeating: "3", count: M.bitWidth / 2))
        NBKAssertDecodeText(T.max, 04,       String(repeating: "3", count: M.bitWidth / 2))
    }
    
    func testDecodingRadix08() {
        NBKAssertDecodeText(T.min, 08, "-1" + String(repeating: "7", count: 21))
        NBKAssertDecodeText(T.max, 08,  "1" + String(repeating: "7", count: 21))
    }
    
    func testDecodingRadix10() {
        NBKAssertDecodeText(T.min, 10, "-18446744073709551615")
        NBKAssertDecodeText(T.max, 10,  "18446744073709551615")
    }

    func testDecodingRadix16() {
        NBKAssertDecodeText(T.min, 16, "-" + String(repeating: "f", count: M.bitWidth / 4))
        NBKAssertDecodeText(T.max, 16,       String(repeating: "f", count: M.bitWidth / 4))
    }
    
    func testDecodingRadix32() {
        NBKAssertDecodeText(T.min, 32, "-f" + String(repeating: "v", count: 12))
        NBKAssertDecodeText(T.max, 32,  "f" + String(repeating: "v", count: 12))
    }
    
    func testDecodingRadix36() {
        NBKAssertDecodeText(T.min, 36, "-3w5e11264sgsf")
        NBKAssertDecodeText(T.max, 36,  "3w5e11264sgsf")
    }
    
    func testDecodingRadixLiteralAsNumber() {
        NBKAssertDecodeText(T( 33), 36,  "0x")
        NBKAssertDecodeText(T( 24), 36,  "0o")
        NBKAssertDecodeText(T( 11), 36,  "0b")
        
        NBKAssertDecodeText(T( 33), 36, "+0x")
        NBKAssertDecodeText(T( 24), 36, "+0o")
        NBKAssertDecodeText(T( 11), 36, "+0b")
        
        NBKAssertDecodeText(T(-33), 36, "-0x")
        NBKAssertDecodeText(T(-24), 36, "-0o")
        NBKAssertDecodeText(T(-11), 36, "-0b")
    }
    
    func testDecodingRadixLiteralAsRadixReturnsNil() {
        NBKAssertDecodeText(T?.none, 10,  "0x10")
        NBKAssertDecodeText(T?.none, 10,  "0o10")
        NBKAssertDecodeText(T?.none, 10,  "0b10")
        
        NBKAssertDecodeText(T?.none, 10, "+0x10")
        NBKAssertDecodeText(T?.none, 10, "+0o10")
        NBKAssertDecodeText(T?.none, 10, "+0b10")
        
        NBKAssertDecodeText(T?.none, 10, "-0x10")
        NBKAssertDecodeText(T?.none, 10, "-0o10")
        NBKAssertDecodeText(T?.none, 10, "-0b10")
    }
    
    func testDecodingStringsWithAndWithoutSign() {
        NBKAssertDecodeText(T( 1234567890), 10,  "1234567890")
        NBKAssertDecodeText(T( 1234567890), 10, "+1234567890")
        NBKAssertDecodeText(T(-1234567890), 10, "-1234567890")
    }
    
    func testDecodingStrategyIsCaseInsensitive() {
        NBKAssertDecodeText(T(0xabcdef), 16, "abcdef")
        NBKAssertDecodeText(T(0xABCDEF), 16, "ABCDEF")
        NBKAssertDecodeText(T(0xaBcDeF), 16, "aBcDeF")
        NBKAssertDecodeText(T(0xAbCdEf), 16, "AbCdEf")
    }
    
    func testDecodingUnalignedStringsIsOK() {
        NBKAssertDecodeText(T(1), 10, "1")
        NBKAssertDecodeText(T(1), 16, "1")
    }
    
    func testDecodingPrefixingZerosHasNoEffect() {
        let zero = String(repeating: "0", count: M.bitWidth) + "0"
        let one  = String(repeating: "0", count: M.bitWidth) + "1"
        
        for radix in 02 ... 36 {
            NBKAssertDecodeText(T(0), radix, zero)
            NBKAssertDecodeText(T(1), radix, one )
        }
    }
        
    func testDecodingInvalidCharactersReturnsNil() {
        NBKAssertDecodeText(T?.none, 16, "/")
        NBKAssertDecodeText(T?.none, 16, "G")

        NBKAssertDecodeText(T?.none, 10, "/")
        NBKAssertDecodeText(T?.none, 10, ":")

        NBKAssertDecodeText(T?.none, 10, String(repeating: "1", count: 19) + "/")
        NBKAssertDecodeText(T?.none, 10, String(repeating: "1", count: 19) + ":")
    }
    
    func testDecodingStringsWithoutDigitsReturnsNil() {
        NBKAssertDecodeText(T?.none, 10,  "")
        NBKAssertDecodeText(T?.none, 10, "+")
        NBKAssertDecodeText(T?.none, 10, "-")
        NBKAssertDecodeText(T?.none, 10, "~")
        
        NBKAssertDecodeText(T?.none, 16,  "")
        NBKAssertDecodeText(T?.none, 16, "+")
        NBKAssertDecodeText(T?.none, 16, "-")
        NBKAssertDecodeText(T?.none, 16, "~")
    }
    
    func testDecodingValuesOutsideOfRepresentableRangeReturnsNil() {
        let positive = "+" + String(repeating: "1", count: M.bitWidth + 1)
        let negative = "-" + String(repeating: "1", count: M.bitWidth + 1)
        
        for radix in 02 ... 36 {
            NBKAssertDecodeText(T?.none, radix, positive)
            NBKAssertDecodeText(T?.none, radix, negative)
        }
        
        NBKAssertDecodeText(T?.none, 36, "-3w5e11264sgsg" ) // - 01
        NBKAssertDecodeText(T?.none, 36, "-3w5e11264sgsf0") // * 36
        NBKAssertDecodeText(T?.none, 36,  "3w5e11264sgsg" ) // + 01
        NBKAssertDecodeText(T?.none, 36,  "3w5e11264sgsf0") // * 36
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encode
    //=------------------------------------------------------------------------=
    
    func testEncodingRadix02() {
        NBKAssertEncodeText(T.min, 02, false, "-" + String(repeating: "1", count: M.bitWidth / 1))
        NBKAssertEncodeText(T.max, 02, false,       String(repeating: "1", count: M.bitWidth / 1))
    }
    
    func testEncodingRadix03() {
        NBKAssertEncodeText(T.min, 03, false, "-11112220022122120101211020120210210211220")
        NBKAssertEncodeText(T.max, 03, false,  "11112220022122120101211020120210210211220")
    }
    
    func testEncodingRadix04() {
        NBKAssertEncodeText(T.min, 04, false, "-" + String(repeating: "3", count: M.bitWidth / 2))
        NBKAssertEncodeText(T.max, 04, false,       String(repeating: "3", count: M.bitWidth / 2))
    }
    
    func testEncodingRadix08() {
        NBKAssertEncodeText(T.min, 08, false, "-1" + String(repeating: "7", count: 21))
        NBKAssertEncodeText(T.max, 08, false,  "1" + String(repeating: "7", count: 21))
    }
    
    func testEncodingRadix10() {
        NBKAssertEncodeText(T.min, 10, false, "-18446744073709551615")
        NBKAssertEncodeText(T.max, 10, false,  "18446744073709551615")
    }
    
    func testEncodingRadix16() {
        NBKAssertEncodeText(T.min, 16, false, "-" + String(repeating: "f", count: M.bitWidth / 4))
        NBKAssertEncodeText(T.min, 16, true , "-" + String(repeating: "F", count: M.bitWidth / 4))
        NBKAssertEncodeText(T.max, 16, false,       String(repeating: "f", count: M.bitWidth / 4))
        NBKAssertEncodeText(T.max, 16, true ,       String(repeating: "F", count: M.bitWidth / 4))
    }
    
    func testEncodingRadix32() {
        NBKAssertEncodeText(T.min, 32, false, "-f" + String(repeating: "v", count: 12))
        NBKAssertEncodeText(T.min, 32, true , "-F" + String(repeating: "V", count: 12))
        NBKAssertEncodeText(T.max, 32, false,  "f" + String(repeating: "v", count: 12))
        NBKAssertEncodeText(T.max, 32, true ,  "F" + String(repeating: "V", count: 12))
    }
    
    func testEncodingRadix36() {
        NBKAssertEncodeText(T.min, 36, false, "-3w5e11264sgsf")
        NBKAssertEncodeText(T.min, 36, true , "-3W5E11264SGSF")
        NBKAssertEncodeText(T.max, 36, false,  "3w5e11264sgsf")
        NBKAssertEncodeText(T.max, 36, true ,  "3W5E11264SGSF")
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Text x Assertions
//*============================================================================*

private func NBKAssertFromDescription<M>(
_ integer: NBKSigned<M>?,  _ description: String,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKSigned<M>
    //=------------------------------------------=
    NBKAssertIdentical(T.init(description),            integer, file: file, line: line)
    NBKAssertIdentical(T.init(description, radix: 10), integer, file: file, line: line)
}

private func NBKAssertDecodeText<M>(
_ integer: NBKSigned<M>?, _ radix: Int, _ text: String,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKSigned<M>
    //=------------------------------------------=
    if  radix == 10 {
        NBKAssertIdentical(T.init(text), integer, file: file, line: line)
    }
    //=------------------------------------------=
    NBKAssertIdentical(T.init(text, radix: radix), integer, file: file, line: line)
}

private func NBKAssertEncodeText<M>(
_ integer: NBKSigned<M>, _ radix: Int, _ uppercase: Bool, _ text: String,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKSigned<M>
    //=------------------------------------------=
    if  radix == 10 {
        XCTAssertEqual(String.init(integer), text, file: file, line: line)
        XCTAssertEqual(integer.description,  text, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(String.init(integer,radix: radix, uppercase: uppercase), text, file: file, line: line)
    XCTAssertEqual(integer.description(radix: radix, uppercase: uppercase), text, file: file, line: line)
}

#endif
