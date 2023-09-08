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
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Text x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnTextAsInt256: XCTestCase {
    
    typealias T  = Int256
    typealias T2 = NBKDoubleWidth<T>
    
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
    
    func testDescriptionUsesRadix10() {
        XCTAssertEqual( "10", T( 10).description)
        XCTAssertEqual("-10", T(-10).description)
        
        XCTAssertEqual( "10", String(describing: T( 10)))
        XCTAssertEqual("-10", String(describing: T(-10)))
    }
    
    func testMetaTypeDescriptionIsSimple() {
        XCTAssertEqual("Int256", T .description)
        XCTAssertEqual("Int512", T2.description)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decode
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix02() {
        NBKAssertDecodeText(T.min, 02, "-1" + String(repeating: "0", count: T.bitWidth / 1 - 1))
        NBKAssertDecodeText(T.max, 02,        String(repeating: "1", count: T.bitWidth / 1 - 1))
    }
    
    func testDecodingRadix03() {
        NBKAssertDecodeText(T.min, 03,        "-21221122120" +
        "12222212211110210202220000022211002111211122012220" +
        "12122202101121021220012201000100012101202122101020" +
        "20010111121211022111102111220220201211121011101022" )
        NBKAssertDecodeText(T.max, 03,         "21221122120" +
        "12222212211110210202220000022211002111211122012220" +
        "12122202101121021220012201000100012101202122101020" +
        "20010111121211022111102111220220201211121011101021" )
    }
    
    func testDecodingRadix04() {
        NBKAssertDecodeText(T.min, 04, "-2" + String(repeating: "0", count: T.bitWidth / 2 - 1))
        NBKAssertDecodeText(T.max, 04,  "1" + String(repeating: "3", count: T.bitWidth / 2 - 1))
    }

    func testDecodingRadix08() {
        NBKAssertDecodeText(T.min, 08, "-1" + String(repeating: "0", count: 85))
        NBKAssertDecodeText(T.max, 08,        String(repeating: "7", count: 85))
    }
    
    func testDecodingRadix10() {
        NBKAssertDecodeText(T.min, 10, "-57896044618658097711785492504343953926634992332820282019728792003956564819968")
        NBKAssertDecodeText(T.max, 10,  "57896044618658097711785492504343953926634992332820282019728792003956564819967")
    }
    
    func testDecodingRadix16() {
        NBKAssertDecodeText(T.min, 16, "-8" + String(repeating: "0", count: T.bitWidth / 4 - 1))
        NBKAssertDecodeText(T.max, 16,  "7" + String(repeating: "f", count: T.bitWidth / 4 - 1))
    }
    
    func testDecodingRadix32() {
        NBKAssertDecodeText(T.min, 32, "-1" + String(repeating: "0", count: 51))
        NBKAssertDecodeText(T.max, 32,        String(repeating: "v", count: 51))
    }
    
    func testDecodingRadix36() {
        NBKAssertDecodeText(T.min, 36, "-36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu8")
        NBKAssertDecodeText(T.max, 36,  "36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu7")
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
        let zero = String(repeating: "0", count: T.bitWidth) + "0"
        let one  = String(repeating: "0", count: T.bitWidth) + "1"
        
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
        let positive = "+" + String(repeating: "1", count: T.bitWidth)
        let negative = "-" + String(repeating: "1", count: T.bitWidth)
        
        for radix in 02 ... 36 {
            NBKAssertDecodeText(T?.none, radix, positive)
            NBKAssertDecodeText(T?.none, radix, negative)
        }
        
        NBKAssertDecodeText(T?.none, 36, "-36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu9" ) // - 01
        NBKAssertDecodeText(T?.none, 36, "-36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu80") // * 36
        NBKAssertDecodeText(T?.none, 36,  "36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu8" ) // + 01
        NBKAssertDecodeText(T?.none, 36,  "36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu70") // * 36
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encode
    //=------------------------------------------------------------------------=
    
    func testEncodingRadix02() {
        NBKAssertEncodeText(T.min, 02, false, "-1" + String(repeating: "0", count: T.bitWidth / 1 - 1))
        NBKAssertEncodeText(T.max, 02, false,        String(repeating: "1", count: T.bitWidth / 1 - 1))
    }
    
    func testEncodingRadix03() {
        NBKAssertEncodeText(T.min, 03, false, "-21221122120" +
        "12222212211110210202220000022211002111211122012220" +
        "12122202101121021220012201000100012101202122101020" +
        "20010111121211022111102111220220201211121011101022" )
        NBKAssertEncodeText(T.max, 03, false,  "21221122120" +
        "12222212211110210202220000022211002111211122012220" +
        "12122202101121021220012201000100012101202122101020" +
        "20010111121211022111102111220220201211121011101021" )
    }
    
    func testEncodingRadix04() {
        NBKAssertEncodeText(T.min, 04, false, "-2" + String(repeating: "0", count: T.bitWidth / 2 - 1))
        NBKAssertEncodeText(T.max, 04, false,  "1" + String(repeating: "3", count: T.bitWidth / 2 - 1))
    }
    
    func testEncodingRadix08() {
        NBKAssertEncodeText(T.min, 08, false, "-1" + String(repeating: "0", count: 85))
        NBKAssertEncodeText(T.max, 08, false,        String(repeating: "7", count: 85))
    }
    
    func testEncodingRadix10() {
        NBKAssertEncodeText(T.min, 10, false, "-57896044618658097711785492504343953926634992332820282019728792003956564819968")
        NBKAssertEncodeText(T.max, 10, false,  "57896044618658097711785492504343953926634992332820282019728792003956564819967")
    }
    
    func testEncodingRadix16() {
        NBKAssertEncodeText(T.min, 16, false, "-8" + String(repeating: "0", count: T.bitWidth / 4 - 1))
        NBKAssertEncodeText(T.min, 16, true , "-8" + String(repeating: "0", count: T.bitWidth / 4 - 1))
        NBKAssertEncodeText(T.max, 16, false,  "7" + String(repeating: "f", count: T.bitWidth / 4 - 1))
        NBKAssertEncodeText(T.max, 16, true ,  "7" + String(repeating: "F", count: T.bitWidth / 4 - 1))
    }
    
    func testEncodingRadix32() {
        NBKAssertEncodeText(T.min, 32, false, "-1" + String(repeating: "0", count: 51))
        NBKAssertEncodeText(T.min, 32, true , "-1" + String(repeating: "0", count: 51))
        NBKAssertEncodeText(T.max, 32, false,        String(repeating: "v", count: 51))
        NBKAssertEncodeText(T.max, 32, true ,        String(repeating: "V", count: 51))
    }
    
    func testEncodingRadix36() {
        NBKAssertEncodeText(T.min, 36, false, "-36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu8")
        NBKAssertEncodeText(T.min, 36, true , "-36UKV65J19B11MBVJYFUI963V4MY01KRTH19G3R3BK1OJLRWU8")
        NBKAssertEncodeText(T.max, 36, false,  "36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu7")
        NBKAssertEncodeText(T.max, 36, true ,  "36UKV65J19B11MBVJYFUI963V4MY01KRTH19G3R3BK1OJLRWU7")
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Text x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnTextAsUInt256: XCTestCase {
    
    typealias T  = UInt256
    typealias T2 = NBKDoubleWidth<T>
    
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
        XCTAssertEqual("UInt256", T .description)
        XCTAssertEqual("UInt512", T2.description)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decode
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix02() {
        NBKAssertDecodeText(T.min, 02, "0")
        NBKAssertDecodeText(T.max, 02, String(repeating: "1", count: T.bitWidth / 1))
    }
    
    func testDecodingRadix03() {
        NBKAssertDecodeText(T.min, 03,                   "0" )
        NBKAssertDecodeText(T.max, 03,        "120220022011" +
        "02222202122221121112210000122122012000200021102211" +
        "02022111210012120210102102000200101210112021202111" +
        "10021000020122121222212000211211110200012022202120" )
    }
    
    func testDecodingRadix04() {
        NBKAssertDecodeText(T.min, 04, "0")
        NBKAssertDecodeText(T.max, 04, String(repeating: "3", count: T.bitWidth / 2))
    }
    
    func testDecodingRadix08() {
        NBKAssertDecodeText(T.min, 08, "0")
        NBKAssertDecodeText(T.max, 08, "1" + String(repeating: "7", count: 85))
    }
    
    func testDecodingRadix10() {
        NBKAssertDecodeText(T.min, 10, "0")
        NBKAssertDecodeText(T.max, 10, "115792089237316195423570985008687907853269984665640564039457584007913129639935")
    }
    
    func testDecodingRadix16() {
        NBKAssertDecodeText(T.min, 16, "0")
        NBKAssertDecodeText(T.max, 16, String(repeating: "f", count: T.bitWidth / 4))
    }
    
    func testDecodingRadix32() {
        NBKAssertDecodeText(T.min, 32, "0")
        NBKAssertDecodeText(T.max, 32, "1" + String(repeating: "v", count: 51))
    }
    
    func testDecodingRadix36() {
        NBKAssertDecodeText(T.min, 36, "0")
        NBKAssertDecodeText(T.max, 36, "6dp5qcb22im238nr3wvp0ic7q99w035jmy2iw7i6n43d37jtof")
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
        let zero = String(repeating: "0", count: T.bitWidth) + "0"
        let one  = String(repeating: "0", count: T.bitWidth) + "1"
        
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
        let positive = "+" + String(repeating: "1", count: T.bitWidth + 1)
        let negative = "-" + String(repeating: "1", count: 1)
        
        for radix in 02 ... 36 {
            NBKAssertDecodeText(T?.none, radix, positive)
            NBKAssertDecodeText(T?.none, radix, negative)
        }
        
        NBKAssertDecodeText(T?.none, 36, "6dp5qcb22im238nr3wvp0ic7q99w035jmy2iw7i6n43d37jtog" ) // + 01
        NBKAssertDecodeText(T?.none, 36, "6dp5qcb22im238nr3wvp0ic7q99w035jmy2iw7i6n43d37jtof0") // * 36
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encode
    //=------------------------------------------------------------------------=
    
    func testEncodingRadix02() {
        NBKAssertEncodeText(T.min, 02, false, "0")
        NBKAssertEncodeText(T.max, 02, false, String(repeating: "1", count: T.bitWidth / 1))
    }
    
    func testEncodingRadix03() {
        NBKAssertEncodeText(T.min, 03, false,            "0" )
        NBKAssertEncodeText(T.max, 03, false, "120220022011" +
        "02222202122221121112210000122122012000200021102211" +
        "02022111210012120210102102000200101210112021202111" +
        "10021000020122121222212000211211110200012022202120" )
    }
    
    func testEncodingRadix04() {
        NBKAssertEncodeText(T.min, 04, false, "0")
        NBKAssertEncodeText(T.max, 04, false, String(repeating: "3", count: T.bitWidth / 2))
    }
    
    func testEncodingRadix08() {
        NBKAssertEncodeText(T.min, 08, false, "0")
        NBKAssertEncodeText(T.max, 08, false, "1" + String(repeating: "7", count: 85))
    }
    
    func testEncodingRadix10() {
        NBKAssertEncodeText(T.min, 10, false, "0")
        NBKAssertEncodeText(T.max, 10, false, "115792089237316195423570985008687907853269984665640564039457584007913129639935")
    }
    
    func testEncodingRadix16() {
        NBKAssertEncodeText(T.min, 16, false, "0")
        NBKAssertEncodeText(T.min, 16, true , "0")
        NBKAssertEncodeText(T.max, 16, false, String(repeating: "f", count: T.bitWidth / 4))
        NBKAssertEncodeText(T.max, 16, true , String(repeating: "F", count: T.bitWidth / 4))
    }
    
    func testEncodingRadix32() {
        NBKAssertEncodeText(T.min, 32, false, "0")
        NBKAssertEncodeText(T.min, 32, true , "0")
        NBKAssertEncodeText(T.max, 32, false, "1" + String(repeating: "v", count: 51))
        NBKAssertEncodeText(T.max, 32, true , "1" + String(repeating: "V", count: 51))
    }
    
    func testEncodingRadix36() {
        NBKAssertEncodeText(T.min, 36, false, "0")
        NBKAssertEncodeText(T.min, 36, true , "0")
        NBKAssertEncodeText(T.max, 36, false, "6dp5qcb22im238nr3wvp0ic7q99w035jmy2iw7i6n43d37jtof")
        NBKAssertEncodeText(T.max, 36, true , "6DP5QCB22IM238NR3WVP0IC7Q99W035JMY2IW7I6N43D37JTOF")
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Text x Other Cases x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnTextByOtherCasesAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    var radix: Int = 10
    var x64 = (UInt64(), UInt64(), UInt64(), UInt64())
    var txt = (String())
    
    //=------------------------------------------------------------------------=
    // MARK: Set Up, Tear Down
    //=------------------------------------------------------------------------=
    
    override func setUp() {
        self.radix = 10
        self.x64.0 = UInt64()
        self.x64.1 = UInt64()
        self.x64.2 = UInt64()
        self.x64.3 = UInt64()
        self.txt   = String()
    }
    
    override func tearDown() {
        let decoded = T(x64: self.x64)
        var encoded = String(self.txt.drop(while:{ $0 == "0" }))
        if  encoded.isEmpty { encoded += "0" }
        
        NBKAssertDecodeText(decoded, self.radix,        encoded)
        NBKAssertEncodeText(decoded, self.radix, true,  encoded.uppercased())
        NBKAssertEncodeText(decoded, self.radix, false, encoded.lowercased())
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testRadix02TopToBottom() {
        self.radix = 02
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        1111111111111110111111011111110011111011111110101111100111111000\
        1111011111110110111101011111010011110011111100101111000111110000\
        1110111111101110111011011110110011101011111010101110100111101000\
        1110011111100110111001011110010011100011111000101110000111100000
        """
    }
    
    func testRadix02BottomToTop() {
        self.radix = 02
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0001111100011110000111010001110000011011000110100001100100011000\
        0001011100010110000101010001010000010011000100100001000100010000\
        0000111100001110000011010000110000001011000010100000100100001000\
        0000011100000110000001010000010000000011000000100000000100000000
        """
    }
    
    //=----= 03 =--------------------------------------------------------------=
    
    func testRadix03TopToBottom() {
        self.radix = 03
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000000000000000000001202200212221120001222202211110211\
        2122212010220102122202121101120111112200201101101222110200202110\
        0220201022101000210101202220120002101202101120201012012212012002
        """
    }
    
    func testRadix03BottomToTop() {
        self.radix = 03
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000000000000000000000000012210112211101210122010202201212\
        2200112221212101221211222010022020100210220200100011100100222021\
        2000121220012212111000111110212212201000011111112211120210102101
        """
    }
    
    //=----= 04 =--------------------------------------------------------------=
    
    func testRadix04TopToBottom() {
        self.radix = 04
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        3333333233313330332333223321332033133312331133103303330233013300\
        3233323232313230322332223221322032133212321132103203320232013200
        """
    }
    
    func testRadix04BottomToTop() {
        self.radix = 04
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0133013201310130012301220121012001130112011101100103010201010100\
        0033003200310030002300220021002000130012001100100003000200010000
        """
    }
    
    //=----= 05 =--------------------------------------------------------------=
    
    func testRadix05TopToBottom() {
        self.radix = 05
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000000012224200130200441041444042343242340402322434230\
        2203100014323101131021202442142123441124102101232423332422334024
        """
    }
    
    func testRadix05BottomToTop() {
        self.radix = 05
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000000000000424043311031102404011202312202132022104340041\
        4431003121344314114341012313341313423214420311244321214230031301
        """
    }
    
    //=----= 06 =--------------------------------------------------------------=
    
    func testRadix06TopToBottom() {
        self.radix = 06
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000000000000000000102141010531040333210533123011525130\
        3433311132532415235332533224344010103324220312020213104050423132
        """
    }
    
    func testRadix06BottomToTop() {
        self.radix = 06
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000000000000000000000004353050531332542114015530141512113\
        1210015440102001011522210020211244125255022541512055450000200144
        """
    }
    
    //=----= 07 =--------------------------------------------------------------=
    
    func testRadix07TopToBottom() {
        self.radix = 07
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000000000000000000000000001305333621612661215031353503\
        1603616341660421351201115002605631306624232666655230226263060363
        """
    }
    
    func testRadix07BottomToTop() {
        self.radix = 07
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000000000000000000000000000000114142063044505436351120634\
        3333263503132100565010106005630324255134635601621240633030645403
        """
    }
    
    //=----= 08 =--------------------------------------------------------------=
    
    func testRadix08TopToBottom() {
        self.radix = 08
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000000000000000000000000000000001777767737637376574770\
        7577336575171762743703577356675472765351721637467136234370560740
        """
    }
    
    func testRadix08BottomToTop() {
        self.radix = 08
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000000000000000000000000000000000000174360721603306414430\
        0561302505011422042100170340641402605011020034060120200300400400
        """
    }
    
    //=----= 09 =--------------------------------------------------------------=
    
    func testRadix09TopToBottom() {
        self.radix = 09
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000000000000000000000000000000000000052625846058684424\
        7876381258254151448064135842067326638330711686502352346635185162
        """
    }
    
    func testRadix09BottomToTop() {
        self.radix = 09
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000000000000000000000000000000000000000005715741718122655\
        8048777185486326632382030431086760556185430443785630144484523371
        """
    }
    
    //=----= 10 =--------------------------------------------------------------=
    
    func testRadix10TopToBottom() {
        self.radix = 10
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000000000000000000000000000000000000000011579030850545\
        5567723526024286119531261069242336003260839703036409543150199264
        """
    }
    
    func testRadix10BottomToTop() {
        self.radix = 10
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000000000000000000000000000000000000000000001407490462640\
        1341155369551180448584754667373453244490859944217516317499064576
        """
    }
    
    //=----= 11 =--------------------------------------------------------------=
    
    func testRadix11TopToBottom() {
        self.radix = 11
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000000000000000000000000000000000000000000010019774172\
        675069499548a05a7794803603a4157366204225264092700a8157a30a948720
        """
    }
    
    func testRadix11BottomToTop() {
        self.radix = 11
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000000000000000000000000000000000000000000000001380227a9a\
        3a453071005401517000a3500756239a46834284766655651370a28295109a06
        """
    }
    
    //=----= 12 =--------------------------------------------------------------=
    
    func testRadix12TopToBottom() {
        self.radix = 12
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000000000000000000000000000000000000000000000029231468\
        41b6624b4657b76b759711256462675490811529026b8b03507956b900591aa8
        """
    }
    
    func testRadix12BottomToTop() {
        self.radix = 12
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        000000000000000000000000000000000000000000000000000000000404b13b\
        22595a847521b8ab337490660a0b7439b1495399a8b2918a9521301732309054
        """
    }
    
    //=----= 13 =--------------------------------------------------------------=
    
    func testRadix13TopToBottom() {
        self.radix = 13
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000000000000000000000000000000000000000000000000178a92\
        980701228a277594134c94bb7165a938c70c03a705750115a339820831351c78
        """
    }
    
    func testRadix13BottomToTop() {
        self.radix = 13
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        00000000000000000000000000000000000000000000000000000000000268a5\
        1c5770b549c51487a17526804a0a14c0c44bbc981573456a275580297a4a7834
        """
    }
    
    //=----= 14 =--------------------------------------------------------------=
    
    func testRadix14TopToBottom() {
        self.radix = 14
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000000000000000000000000000000000000000000000000001c38\
        14cbd353812dca285cc376972998797340345da539017abd8236000c88ca00da
        """
    }
    
    func testRadix14BottomToTop() {
        self.radix = 14
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000000000000000000000000000000000000000000000000000000329\
        76a45325cd6dda6ac91cb8c9bccbbc61488833c2225a774c2da97ab4d4565d3a
        """
    }
    
    //=----= 15 =--------------------------------------------------------------=
    
    func testRadix15TopToBottom() {
        self.radix = 15
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000000000000000000000000000000000000000000000000000042\
        314e1223518107b1362e160a5ad29226b4e3e2d35ea57996aaa3242db02966ae
        """
    }
    
    func testRadix15BottomToTop() {
        self.radix = 15
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000000000000000000000000000000000000000000000000000000007\
        864d3605e05bd91d94b651ccc4e3078d6edc902745e03953a310b0de5c602701
        """
    }
    
    //=----= 16 =--------------------------------------------------------------=
    
    func testRadix16TopToBottom() {
        self.radix = 16
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        fffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0
        """
    }
    
    func testRadix16BottomToTop() {
        self.radix = 16
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100
        """
    }
    
    //=----= 17 =--------------------------------------------------------------=
    
    func testRadix17TopToBottom() {
        self.radix = 17
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        05g7d81gc01cdbf42565444eaa12342c35gd9f66bbg36c8d8841baa7a8faab0e
        """
    }
    
    func testRadix17BottomToTop() {
        self.radix = 17
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        00c5b2gcge3c140g4d527274dgd5cg7g58babg3e21bg76739a559151527ce653
        """
    }
    
    //=----= 18 =--------------------------------------------------------------=
    
    func testRadix18TopToBottom() {
        self.radix = 18
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0031fhf5dce9fgc12bg164e9h35028896f83ddhh8be5286c3e9h17360bg1bg32
        """
    }
    
    func testRadix18BottomToTop() {
        self.radix = 18
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0006e51f0da7284a3bb14747c33cgb1hfa3120c549aec7hh58g39hg075a02c3a
        """
    }
    
    //=----= 19 =--------------------------------------------------------------=
    
    func testRadix19TopToBottom() {
        self.radix = 19
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        000237ibab6cg652id30fgh76hdai93dhfh7dhagfdc5eb7f782c55d551ed74g6
        """
    }
    
    func testRadix19BottomToTop() {
        self.radix = 19
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        000050cae6cb5210060eg1g2iicc8e689a04g25829g2f5bc8c84ea4a8a1348f4
        """
    }
    
    //=----= 20 =--------------------------------------------------------------=
    
    func testRadix20TopToBottom() {
        self.radix = 20
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        000020392d6ac9d1jd12d3a88c61i7ba748483ai05hf66c6a7g42977fbe8ei34
        """
    }
    
    func testRadix20BottomToTop() {
        self.radix = 20
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        000004hd5e33e5189jajhc248c2a513ae74fba267d1b3d1743i8ebgb30i9318g
        """
    }
    
    //=----= 21 =--------------------------------------------------------------=
    
    func testRadix21TopToBottom() {
        self.radix = 21
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000027gdj7593kjg0f1c5cga4aca1e1d5f08h72cebhcbc1c6cek06cf13eaddh
        """
    }
    
    func testRadix21BottomToTop() {
        self.radix = 21
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000006124cec92463a07f87dgg069g06715hcg4j03fha2f1gafce80g895g09a
        """
    }
    
    //=----= 22 =--------------------------------------------------------------=
    
    func testRadix22TopToBottom() {
        self.radix = 22
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000003b5jk54f19beiidebchgec3ffc28aggdd74h75ijdc00i4ea0ji14954c0
        """
    }
    
    func testRadix22BottomToTop() {
        self.radix = 22
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        000000098djlg8ll6ge66j798kd129gf43e7c6586a31h5a25adg2l78kj3a82b6
        """
    }
    
    //=----= 23 =--------------------------------------------------------------=
    
    func testRadix23TopToBottom() {
        self.radix = 23
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        000000069a79baglcjbdblbk5111bb46b66g2b7a2f596763kmm7c3hbl336kl14
        """
    }
    
    func testRadix23BottomToTop() {
        self.radix = 23
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        00000000hl580j6lii99g9c5137ji22ab5i41mba3lh6091cakd4h6llil689h12
        """
    }
    
    //=----= 24 =--------------------------------------------------------------=
    
    func testRadix24TopToBottom() {
        self.radix = 24
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        00000000e4eikjgk76jj7i2fbn6ihk3ngef39fb00gjl3086em4k7g3ag5647hh8
        """
    }
    
    func testRadix24BottomToTop() {
        self.radix = 24
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        000000001h9gbi9kc8ig99kj5lil4in9d6e81la5d0h872fff899ebj57j88732g
        """
    }
    
    //=----= 25 =--------------------------------------------------------------=
    
    func testRadix25TopToBottom() {
        self.radix = 25
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        000000001cea1fa4l49o4dnedkkdcnmfc3509hg185baem9bdo6e5b1dediecike
        """
    }
    
    func testRadix25BottomToTop() {
        self.radix = 25
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000004e4i6362kk6ad7abh2b4j0log0gbjn96nl1d8j88mh9m36enbbmf381
        """
    }
    
    //=----= 26 =--------------------------------------------------------------=
    
    func testRadix26TopToBottom() {
        self.radix = 26
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000004dd8f12of8578gn3cho4kjg1nm4ck49ihk7nahjpeie4d78426fjja8
        """
    }
    
    func testRadix26BottomToTop() {
        self.radix = 26
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000e7a4822n1867n87cpm330nai4o7gj05b5j013bb0in29cncoodh584
        """
    }
    
    //=----= 27 =--------------------------------------------------------------=
    
    func testRadix27TopToBottom() {
        self.radix = 27
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000fo7qe0hopd7gqfbj7q7m4jdh2445pb279oj8a0lakof2akafj55n52
        """
    }
    
    func testRadix27BottomToTop() {
        self.radix = 27
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        00000000001p4pcg5j6ogq1hng5neo9oj2bk10d12on0go5nd0dcnnj04demflba
        """
    }
    
    //=----= 28 =--------------------------------------------------------------=
    
    func testRadix28TopToBottom() {
        self.radix = 28
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        000000000028lp360pqr9fgjmgalj15e5kknmk8pd61irgj23bbe6nbafahp3e6o
        """
    }
    
    func testRadix28BottomToTop() {
        self.radix = 28
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        000000000007odiqi7ipkbell34qeml609e642lhrao5n03422ik497coam17kmo
        """
    }
    
    //=----= 29 =--------------------------------------------------------------=
    
    func testRadix29TopToBottom() {
        self.radix = 29
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        00000000000acrhqlapaaob766is1eng6erp522m0f5opigage3d3j4k7f9n8ff2
        """
    }
    
    func testRadix29BottomToTop() {
        self.radix = 29
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000017nr4pcg1heg13dh8cgggmn4q34frqm65gn8ec0j45591bmqfhffb
        """
    }
    
    //=----= 30 =--------------------------------------------------------------=
    
    func testRadix30TopToBottom() {
        self.radix = 30
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        000000000001nmr6nq4fe87dse4p4i0ama7co4moqch8081liop9spg2kl9rn95e
        """
    }
    
    func testRadix30BottomToTop() {
        self.radix = 30
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000006g1ldfsednredtimcop3b5l3q70e4kitjnhrn4eql74ecaf5j1mg
        """
    }
    
    //=----= 31 =--------------------------------------------------------------=
    
    func testRadix31TopToBottom() {
        self.radix = 31
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        000000000000a30ts5ohp5e917o3nehp8urue2rb4e97icid1me5tcmpil25fi6m
        """
    }
    
    func testRadix31BottomToTop() {
        self.radix = 31
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        000000000000171hhf8063e3r4a99sra00a157pihstia75dmk5kfae5nnn9ab6l
        """
    }
    
    //=----= 32 =--------------------------------------------------------------=
    
    func testRadix32TopToBottom() {
        self.radix = 32
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000001vvuvnufnunpv3rvdtfkufpf3s7ftrmupqvat7kefpn5sjhu5of0
        """
    }
    
    func testRadix32BottomToTop() {
        self.radix = 32
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        00000000000007ou3ke1m6gp30bhc58k2c91240f1o6go2oa1440e1g50g1g4080
        """
    }
    
    //=----= 33 =--------------------------------------------------------------=
    
    func testRadix33TopToBottom() {
        self.radix = 33
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        0000000000000dodf9g17rn5pvw3et1k184sgnb11u6u7uhk2n9b3bhtfwrh14fb
        """
    }
    
    func testRadix33BottomToTop() {
        self.radix = 33
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        00000000000001m3p6weqc5jk0wsb37sv08ileepww3jad5cr0cfhd0g1aq8in3s
        """
    }
    
    //=----= 34 =--------------------------------------------------------------=
    
    func testRadix34TopToBottom() {
        self.radix = 34
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        00000000000003304fs1ae3ixjsrahw1k6lt33dlup2jc54b1p3xxaghpss3swhe
        """
    }
    
    func testRadix34BottomToTop() {
        self.radix = 34
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        00000000000000cpwunuqgcm028uqxuqmjst7gk65egpsowcgixwuci6x899aa2k
        """
    }
    
    //=----= 35 =--------------------------------------------------------------=
    
    func testRadix35TopToBottom() {
        self.radix = 35
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        00000000000000pcyhqj7yk3vq8j4l4vfa7wes91wah4p1y3op2k48s4pv0y189o
        """
    }
    
    func testRadix35BottomToTop() {
        self.radix = 35
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        0000000000000032wujn2mg481jyhidxmv5271ucr21qfj9jdvqm429mwneu6b2v
        """
    }
    
    //=----= 36 =--------------------------------------------------------------=
    
    func testRadix36TopToBottom() {
        self.radix = 36
        self.x64.3 = 0xfffefdfcfbfaf9f8
        self.x64.2 = 0xf7f6f5f4f3f2f1f0
        self.x64.1 = 0xefeeedecebeae9e8
        self.x64.0 = 0xe7e6e5e4e3e2e1e0
        self.txt = """
        000000000000006dp15j43ld5l8i7wvimlj7kxgbfxkxkgmo66lge382296ouqjk
        """
    }
    
    func testRadix36BottomToTop() {
        self.radix = 36
        self.x64.3 = 0x1f1e1d1c1b1a1918
        self.x64.2 = 0x1716151413121110
        self.x64.1 = 0x0f0e0d0c0b0a0908
        self.x64.0 = 0x0706050403020100
        self.txt = """
        000000000000000rx55jlhq7obx1pvd9861yo6c11bed0cd8s8wz2hpvczt00c1s
        """
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Text x Assertions
//*============================================================================*

private func NBKAssertFromDescription<H>(
_ integer: NBKDoubleWidth<H>?,  _ description: String,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    XCTAssertEqual(T(description),            integer, file: file, line: line)
    XCTAssertEqual(T(description, radix: 10), integer, file: file, line: line)
}

private func NBKAssertDecodeText<H: NBKFixedWidthInteger>(
_ integer: NBKDoubleWidth<H>?, _ radix: Int, _ text: String,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    if  radix == 10 {
        XCTAssertEqual(T(text), integer, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(T(text, radix: radix), integer, file: file, line: line)
}

private func NBKAssertEncodeText<H: NBKFixedWidthInteger>(
_ integer: NBKDoubleWidth<H>, _ radix: Int, _ uppercase: Bool, _ text: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  radix == 10, uppercase == false {
        XCTAssertEqual(String(integer),       text, file: file, line: line)
        XCTAssertEqual(integer.description,   text, file: file, line: line)
        XCTAssertEqual(integer.description(), text, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(String(integer,     radix: radix, uppercase: uppercase), text, file: file, line: line)
    XCTAssertEqual(integer.description(radix: radix, uppercase: uppercase), text, file: file, line: line)
}

#endif
