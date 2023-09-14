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
import NBKFlexibleWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Text x IntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnTextAsIntXL: XCTestCase {
    
    typealias T = IntXL
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let bit256 = 256
    let min256 = T.min256
    let max256 = T.max256
    
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
    
    func testMetaTypeDescriptionIsSimple() {
        XCTAssertEqual("IntXL", T.description)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decode
    //=------------------------------------------------------------------------=

    func testDecodingRadix02() {
        NBKAssertDecodeText(min256, 02, "-1" + String(repeating: "0", count: bit256 / 1 - 1))
        NBKAssertDecodeText(max256, 02,        String(repeating: "1", count: bit256 / 1 - 1))
    }
    
    func testDecodingRadix03() {
        NBKAssertDecodeText(min256, 03,       "-21221122120" +
        "12222212211110210202220000022211002111211122012220" +
        "12122202101121021220012201000100012101202122101020" +
        "20010111121211022111102111220220201211121011101022" )
        NBKAssertDecodeText(max256, 03,         "21221122120" +
        "12222212211110210202220000022211002111211122012220" +
        "12122202101121021220012201000100012101202122101020" +
        "20010111121211022111102111220220201211121011101021" )
    }
    
    func testDecodingRadix04() {
        NBKAssertDecodeText(min256, 04, "-2" + String(repeating: "0", count: bit256 / 2 - 1))
        NBKAssertDecodeText(max256, 04,  "1" + String(repeating: "3", count: bit256 / 2 - 1))
    }

    func testDecodingRadix08() {
        NBKAssertDecodeText(min256, 08, "-1" + String(repeating: "0", count: 85))
        NBKAssertDecodeText(max256, 08,        String(repeating: "7", count: 85))
    }
    
    func testDecodingRadix10() {
        NBKAssertDecodeText(min256, 10, "-57896044618658097711785492504343953926634992332820282019728792003956564819968")
        NBKAssertDecodeText(max256, 10,  "57896044618658097711785492504343953926634992332820282019728792003956564819967")
    }
    
    func testDecodingRadix16() {
        NBKAssertDecodeText(min256, 16, "-8" + String(repeating: "0", count: bit256 / 4 - 1))
        NBKAssertDecodeText(max256, 16,  "7" + String(repeating: "f", count: bit256 / 4 - 1))
    }
    
    func testDecodingRadix32() {
        NBKAssertDecodeText(min256, 32, "-1" + String(repeating: "0", count: 51))
        NBKAssertDecodeText(max256, 32,        String(repeating: "v", count: 51))
    }
    
    func testDecodingRadix36() {
        NBKAssertDecodeText(min256, 36, "-36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu8")
        NBKAssertDecodeText(max256, 36,  "36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu7")
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
        let zero = String(repeating: "0", count: bit256) + "0"
        let one  = String(repeating: "0", count: bit256) + "1"
        
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
        let positive = "+" + String(repeating: "1", count: bit256)
        let negative = "-" + String(repeating: "1", count: bit256)
        
        for radix in 02 ... 36 {
            XCTAssertNotNil(T(positive, radix: radix))
            XCTAssertNotNil(T(negative, radix: radix))
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encode
    //=------------------------------------------------------------------------=

    func testEncodingRadix02() {
        NBKAssertEncodeText(min256, 02, false, "-1" + String(repeating: "0", count: bit256 / 1 - 1))
        NBKAssertEncodeText(max256, 02, false,        String(repeating: "1", count: bit256 / 1 - 1))
    }
    
    func testEncodingRadix03() {
        NBKAssertEncodeText(min256, 03, false,"-21221122120" +
        "12222212211110210202220000022211002111211122012220" +
        "12122202101121021220012201000100012101202122101020" +
        "20010111121211022111102111220220201211121011101022" )
        NBKAssertEncodeText(max256, 03, false, "21221122120" +
        "12222212211110210202220000022211002111211122012220" +
        "12122202101121021220012201000100012101202122101020" +
        "20010111121211022111102111220220201211121011101021" )
    }
    
    func testEncodingRadix04() {
        NBKAssertEncodeText(min256, 04, false, "-2" + String(repeating: "0", count: bit256 / 2 - 1))
        NBKAssertEncodeText(max256, 04, false,  "1" + String(repeating: "3", count: bit256 / 2 - 1))
    }
    
    func testEncodingRadix08() {
        NBKAssertEncodeText(min256, 08, false, "-1" + String(repeating: "0", count: 85))
        NBKAssertEncodeText(max256, 08, false,        String(repeating: "7", count: 85))
    }
    
    func testEncodingRadix10() {
        NBKAssertEncodeText(min256, 10, false, "-57896044618658097711785492504343953926634992332820282019728792003956564819968")
        NBKAssertEncodeText(max256, 10, false,  "57896044618658097711785492504343953926634992332820282019728792003956564819967")
    }
    
    func testEncodingRadix16() {
        NBKAssertEncodeText(min256, 16, false, "-8" + String(repeating: "0", count: bit256 / 4 - 1))
        NBKAssertEncodeText(min256, 16, true , "-8" + String(repeating: "0", count: bit256 / 4 - 1))
        NBKAssertEncodeText(max256, 16, false,  "7" + String(repeating: "f", count: bit256 / 4 - 1))
        NBKAssertEncodeText(max256, 16, true ,  "7" + String(repeating: "F", count: bit256 / 4 - 1))
    }
    
    func testEncodingRadix32() {
        NBKAssertEncodeText(min256, 32, false, "-1" + String(repeating: "0", count: 51))
        NBKAssertEncodeText(min256, 32, true , "-1" + String(repeating: "0", count: 51))
        NBKAssertEncodeText(max256, 32, false,        String(repeating: "v", count: 51))
        NBKAssertEncodeText(max256, 32, true ,        String(repeating: "V", count: 51))
    }
    
    func testEncodingRadix36() {
        NBKAssertEncodeText(min256, 36, false, "-36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu8")
        NBKAssertEncodeText(min256, 36, true , "-36UKV65J19B11MBVJYFUI963V4MY01KRTH19G3R3BK1OJLRWU8")
        NBKAssertEncodeText(max256, 36, false,  "36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu7")
        NBKAssertEncodeText(max256, 36, true ,  "36UKV65J19B11MBVJYFUI963V4MY01KRTH19G3R3BK1OJLRWU7")
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Text x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnTextAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let bit256 = 256
    let min256 = T.min256
    let max256 = T.max256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromDescription() {
        NBKAssertFromDescription(T?( 10),    "10")
        NBKAssertFromDescription(T?( 10),   "+10")
        NBKAssertFromDescription(T?(nil),   "-10")
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
    
    func testMetaTypeDescriptionIsSimple() {
        XCTAssertEqual("UIntXL", T.description)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decode
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix02() {
        NBKAssertDecodeText(min256, 02, "0")
        NBKAssertDecodeText(max256, 02, String(repeating: "1", count: bit256 / 1))
    }
    
    func testDecodingRadix03() {
        NBKAssertDecodeText(min256, 03,                  "0" )
        NBKAssertDecodeText(max256, 03,       "120220022011" +
        "02222202122221121112210000122122012000200021102211" +
        "02022111210012120210102102000200101210112021202111" +
        "10021000020122121222212000211211110200012022202120" )
    }
    
    func testDecodingRadix04() {
        NBKAssertDecodeText(min256, 04, "0")
        NBKAssertDecodeText(max256, 04, String(repeating: "3", count: bit256 / 2))
    }
    
    func testDecodingRadix08() {
        NBKAssertDecodeText(min256, 08, "0")
        NBKAssertDecodeText(max256, 08, "1" + String(repeating: "7", count: 85))
    }
    
    func testDecodingRadix10() {
        NBKAssertDecodeText(min256, 10, "0")
        NBKAssertDecodeText(max256, 10, "115792089237316195423570985008687907853269984665640564039457584007913129639935")
    }
    
    func testDecodingRadix16() {
        NBKAssertDecodeText(min256, 16, "0")
        NBKAssertDecodeText(max256, 16, String(repeating: "f", count: bit256 / 4))
    }
    
    func testDecodingRadix32() {
        NBKAssertDecodeText(min256, 32, "0")
        NBKAssertDecodeText(max256, 32, "1" + String(repeating: "v", count: 51))
    }
    
    func testDecodingRadix36() {
        NBKAssertDecodeText(min256, 36, "0")
        NBKAssertDecodeText(max256, 36, "6dp5qcb22im238nr3wvp0ic7q99w035jmy2iw7i6n43d37jtof")
    }
    
    func testDecodingRadixLiteralAsNumber() {
        NBKAssertDecodeText(T(33), 36,  "0x")
        NBKAssertDecodeText(T(24), 36,  "0o")
        NBKAssertDecodeText(T(11), 36,  "0b")
        
        NBKAssertDecodeText(T(33), 36, "+0x")
        NBKAssertDecodeText(T(24), 36, "+0o")
        NBKAssertDecodeText(T(11), 36, "+0b")
    }
    
    func testDecodingRadixLiteralAsRadixReturnsNil() {
        NBKAssertDecodeText(T?.none, 10,  "0x10")
        NBKAssertDecodeText(T?.none, 10,  "0o10")
        NBKAssertDecodeText(T?.none, 10,  "0b10")
        
        NBKAssertDecodeText(T?.none, 10, "+0x10")
        NBKAssertDecodeText(T?.none, 10, "+0o10")
        NBKAssertDecodeText(T?.none, 10, "+0b10")
    }
    
    func testDecodingStringsWithAndWithoutSign() {
        NBKAssertDecodeText(T(1234567890), 10,  "1234567890")
        NBKAssertDecodeText(T(1234567890), 10, "+1234567890")
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
        let zero = String(repeating: "0", count: bit256) + "0"
        let one  = String(repeating: "0", count: bit256) + "1"
        
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
        let positive = "+" + String(repeating: "1", count: bit256 + 1)
        let negative = "-" + String(repeating: "1", count: 1)
        
        for radix in 02 ... 36 {
            XCTAssertNotNil(T(positive,  radix: radix))
            NBKAssertDecodeText(T?.none, radix, negative)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encode
    //=------------------------------------------------------------------------=
    
    func testEncodingRadix02() {
        NBKAssertEncodeText(min256, 02, false, "0")
        NBKAssertEncodeText(max256, 02, false, String(repeating: "1", count: bit256 / 1))
    }
    
    func testEncodingRadix03() {
        NBKAssertEncodeText(min256, 03, false,           "0" )
        NBKAssertEncodeText(max256, 03, false,"120220022011" +
        "02222202122221121112210000122122012000200021102211" +
        "02022111210012120210102102000200101210112021202111" +
        "10021000020122121222212000211211110200012022202120" )
    }
    
    func testEncodingRadix04() {
        NBKAssertEncodeText(min256, 04, false, "0")
        NBKAssertEncodeText(max256, 04, false, String(repeating: "3", count: bit256 / 2))
    }
    
    func testEncodingRadix08() {
        NBKAssertEncodeText(min256, 08, false, "0")
        NBKAssertEncodeText(max256, 08, false, "1" + String(repeating: "7", count: 85))
    }
    
    func testEncodingRadix10() {
        NBKAssertEncodeText(min256, 10, false, "0")
        NBKAssertEncodeText(max256, 10, false, "115792089237316195423570985008687907853269984665640564039457584007913129639935")
    }
    
    func testEncodingRadix16() {
        NBKAssertEncodeText(min256, 16, false, "0")
        NBKAssertEncodeText(min256, 16, true , "0")
        NBKAssertEncodeText(max256, 16, false, String(repeating: "f", count: bit256 / 4))
        NBKAssertEncodeText(max256, 16, true , String(repeating: "F", count: bit256 / 4))
    }
    
    func testEncodingRadix32() {
        NBKAssertEncodeText(min256, 32, false, "0")
        NBKAssertEncodeText(min256, 32, true , "0")
        NBKAssertEncodeText(max256, 32, false, "1" + String(repeating: "v", count: 51))
        NBKAssertEncodeText(max256, 32, true , "1" + String(repeating: "V", count: 51))
    }
    
    func testEncodingRadix36() {
        NBKAssertEncodeText(min256, 36, false, "0")
        NBKAssertEncodeText(min256, 36, true , "0")
        NBKAssertEncodeText(max256, 36, false, "6dp5qcb22im238nr3wvp0ic7q99w035jmy2iw7i6n43d37jtof")
        NBKAssertEncodeText(max256, 36, true , "6DP5QCB22IM238NR3WVP0IC7Q99W035JMY2IW7I6N43D37JTOF")
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Text x Assertions
//*============================================================================*

private func NBKAssertFromDescription<T: IntXLOrUIntXL>(
_ integer: T?,  _ description: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(T(description),            integer, file: file, line: line)
    XCTAssertEqual(T(description, radix: 10), integer, file: file, line: line)
}

private func NBKAssertDecodeText<T: NBKBinaryInteger> (
_ integer: T?, _ radix: Int, _ text: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  radix == 10 {
        XCTAssertEqual(T.init(text), integer, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(T.init(text, radix: radix), integer, file: file, line: line)
}

private func NBKAssertEncodeText<T: NBKBinaryInteger>(
_ integer: T, _ radix: Int, _ uppercase: Bool, _ text: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  radix == 10, uppercase == false {
        XCTAssertEqual(String.init(integer), text, file: file, line: line)
        XCTAssertEqual(integer.description,  text, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(String.init(integer,radix: radix, uppercase: uppercase), text, file: file, line: line)
    XCTAssertEqual(integer.description(radix: radix, uppercase: uppercase), text, file: file, line: line)
}

#endif
