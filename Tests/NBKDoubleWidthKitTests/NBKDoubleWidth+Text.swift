//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

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
    // MARK: Tests x Decoding
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix02() {
        NBKAssertDecodingText(T.min, 02, "-1" + String(repeating: "0", count: T.bitWidth / 1 - 1))
        NBKAssertDecodingText(T.max, 02,        String(repeating: "1", count: T.bitWidth / 1 - 1))
    }
    
    func testDecodingRadix03() {
        NBKAssertDecodingText(T.min, 03,       
        /*--------------------------*/"-212211221201222221221111021020222" +
        "0000022211002111211122012220121222021011210212200122010001000121" +
        "0120212210102020010111121211022111102111220220201211121011101022" )
        NBKAssertDecodingText(T.max, 03,         
        /*---------------------------*/"212211221201222221221111021020222" +
        "0000022211002111211122012220121222021011210212200122010001000121" +
        "0120212210102020010111121211022111102111220220201211121011101021" )
    }
    
    func testDecodingRadix04() {
        NBKAssertDecodingText(T.min, 04, "-2" + String(repeating: "0", count: T.bitWidth / 2 - 1))
        NBKAssertDecodingText(T.max, 04,  "1" + String(repeating: "3", count: T.bitWidth / 2 - 1))
    }

    func testDecodingRadix08() {
        NBKAssertDecodingText(T.min, 08, "-1" + String(repeating: "0", count: 85))
        NBKAssertDecodingText(T.max, 08,        String(repeating: "7", count: 85))
    }
    
    func testDecodingRadix10() {
        NBKAssertDecodingText(T.min, 10, "-57896044618658097711785492504343953926634992332820282019728792003956564819968")
        NBKAssertDecodingText(T.max, 10,  "57896044618658097711785492504343953926634992332820282019728792003956564819967")
    }
    
    func testDecodingRadix16() {
        NBKAssertDecodingText(T.min, 16, "-8" + String(repeating: "0", count: T.bitWidth / 4 - 1))
        NBKAssertDecodingText(T.max, 16,  "7" + String(repeating: "f", count: T.bitWidth / 4 - 1))
    }
    
    func testDecodingRadix32() {
        NBKAssertDecodingText(T.min, 32, "-1" + String(repeating: "0", count: 51))
        NBKAssertDecodingText(T.max, 32,        String(repeating: "v", count: 51))
    }
    
    func testDecodingRadix36() {
        NBKAssertDecodingText(T.min, 36, "-36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu8")
        NBKAssertDecodingText(T.max, 36,  "36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu7")
    }
    
    func testDecodingRadixLiteralAsNumber() {
        NBKAssertDecodingText(T( 33), 36,  "0x")
        NBKAssertDecodingText(T( 24), 36,  "0o")
        NBKAssertDecodingText(T( 11), 36,  "0b")
        
        NBKAssertDecodingText(T( 33), 36, "+0x")
        NBKAssertDecodingText(T( 24), 36, "+0o")
        NBKAssertDecodingText(T( 11), 36, "+0b")
        
        NBKAssertDecodingText(T(-33), 36, "-0x")
        NBKAssertDecodingText(T(-24), 36, "-0o")
        NBKAssertDecodingText(T(-11), 36, "-0b")
    }
    
    func testDecodingRadixLiteralAsRadixReturnsNil() {
        NBKAssertDecodingText(T?.none, 10,  "0x10")
        NBKAssertDecodingText(T?.none, 10,  "0o10")
        NBKAssertDecodingText(T?.none, 10,  "0b10")
        
        NBKAssertDecodingText(T?.none, 10, "+0x10")
        NBKAssertDecodingText(T?.none, 10, "+0o10")
        NBKAssertDecodingText(T?.none, 10, "+0b10")
        
        NBKAssertDecodingText(T?.none, 10, "-0x10")
        NBKAssertDecodingText(T?.none, 10, "-0o10")
        NBKAssertDecodingText(T?.none, 10, "-0b10")
    }
    
    func testDecodingStringsWithAndWithoutSign() {
        NBKAssertDecodingText(T( 1234567890), 10,  "1234567890")
        NBKAssertDecodingText(T( 1234567890), 10, "+1234567890")
        NBKAssertDecodingText(T(-1234567890), 10, "-1234567890")
    }
    
    func testDecodingStrategyIsCaseInsensitive() {
        NBKAssertDecodingText(T(0xabcdef), 16, "abcdef")
        NBKAssertDecodingText(T(0xABCDEF), 16, "ABCDEF")
        NBKAssertDecodingText(T(0xaBcDeF), 16, "aBcDeF")
        NBKAssertDecodingText(T(0xAbCdEf), 16, "AbCdEf")
    }
    
    func testDecodingUnalignedStringsIsOK() {
        NBKAssertDecodingText(T(1), 10, "1")
        NBKAssertDecodingText(T(1), 16, "1")
    }
    
    func testDecodingPrefixingZerosHasNoEffect() {
        let zero = String(repeating: "0", count: T.bitWidth) + "0"
        let one  = String(repeating: "0", count: T.bitWidth) + "1"
        
        for radix in 02 ... 36 {
            NBKAssertDecodingText(T(0), radix, zero)
            NBKAssertDecodingText(T(1), radix, one )
        }
    }
    
    func testDecodingInvalidCharactersReturnsNil() {
        NBKAssertDecodingText(T?.none, 16, "/")
        NBKAssertDecodingText(T?.none, 16, "G")
        
        NBKAssertDecodingText(T?.none, 10, "/")
        NBKAssertDecodingText(T?.none, 10, ":")
        
        NBKAssertDecodingText(T?.none, 10, String(repeating: "1", count: 19) + "/")
        NBKAssertDecodingText(T?.none, 10, String(repeating: "1", count: 19) + ":")
    }
    
    func testDecodingStringsWithoutDigitsReturnsNil() {
        NBKAssertDecodingText(T?.none, 10,  "")
        NBKAssertDecodingText(T?.none, 10, "+")
        NBKAssertDecodingText(T?.none, 10, "-")
        NBKAssertDecodingText(T?.none, 10, "~")
        
        NBKAssertDecodingText(T?.none, 16,  "")
        NBKAssertDecodingText(T?.none, 16, "+")
        NBKAssertDecodingText(T?.none, 16, "-")
        NBKAssertDecodingText(T?.none, 16, "~")
    }
    
    func testDecodingValuesOutsideOfRepresentableRangeReturnsNil() {
        let positive = "+" + String(repeating: "1", count: T.bitWidth)
        let negative = "-" + String(repeating: "1", count: T.bitWidth)
        
        for radix in 02 ... 36 {
            NBKAssertDecodingText(T?.none, radix, positive)
            NBKAssertDecodingText(T?.none, radix, negative)
        }
        
        NBKAssertDecodingText(T?.none, 36, "-36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu9" ) // - 01
        NBKAssertDecodingText(T?.none, 36, "-36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu80") // * 36
        NBKAssertDecodingText(T?.none, 36,  "36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu8" ) // + 01
        NBKAssertDecodingText(T?.none, 36,  "36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu70") // * 36
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encoding
    //=------------------------------------------------------------------------=
    
    func testEncodingRadix02() {
        NBKAssertEncodingText(T.min, 02, false, "-1" + String(repeating: "0", count: T.bitWidth / 1 - 1))
        NBKAssertEncodingText(T.max, 02, false,        String(repeating: "1", count: T.bitWidth / 1 - 1))
    }
    
    func testEncodingRadix03() {
        NBKAssertEncodingText(T.min, 03, false,
        /*--------------------------*/"-212211221201222221221111021020222" +
        "0000022211002111211122012220121222021011210212200122010001000121" +
        "0120212210102020010111121211022111102111220220201211121011101022" )
        NBKAssertEncodingText(T.max, 03, false,
        /*---------------------------*/"212211221201222221221111021020222" +
        "0000022211002111211122012220121222021011210212200122010001000121" +
        "0120212210102020010111121211022111102111220220201211121011101021" )
    }
    
    func testEncodingRadix04() {
        NBKAssertEncodingText(T.min, 04, false, "-2" + String(repeating: "0", count: T.bitWidth / 2 - 1))
        NBKAssertEncodingText(T.max, 04, false,  "1" + String(repeating: "3", count: T.bitWidth / 2 - 1))
    }
    
    func testEncodingRadix08() {
        NBKAssertEncodingText(T.min, 08, false, "-1" + String(repeating: "0", count: 85))
        NBKAssertEncodingText(T.max, 08, false,        String(repeating: "7", count: 85))
    }
    
    func testEncodingRadix10() {
        NBKAssertEncodingText(T.min, 10, false, "-57896044618658097711785492504343953926634992332820282019728792003956564819968")
        NBKAssertEncodingText(T.max, 10, false,  "57896044618658097711785492504343953926634992332820282019728792003956564819967")
    }
    
    func testEncodingRadix16() {
        NBKAssertEncodingText(T.min, 16, false, "-8" + String(repeating: "0", count: T.bitWidth / 4 - 1))
        NBKAssertEncodingText(T.min, 16, true , "-8" + String(repeating: "0", count: T.bitWidth / 4 - 1))
        NBKAssertEncodingText(T.max, 16, false,  "7" + String(repeating: "f", count: T.bitWidth / 4 - 1))
        NBKAssertEncodingText(T.max, 16, true ,  "7" + String(repeating: "F", count: T.bitWidth / 4 - 1))
    }
    
    func testEncodingRadix32() {
        NBKAssertEncodingText(T.min, 32, false, "-1" + String(repeating: "0", count: 51))
        NBKAssertEncodingText(T.min, 32, true , "-1" + String(repeating: "0", count: 51))
        NBKAssertEncodingText(T.max, 32, false,        String(repeating: "v", count: 51))
        NBKAssertEncodingText(T.max, 32, true ,        String(repeating: "V", count: 51))
    }
    
    func testEncodingRadix36() {
        NBKAssertEncodingText(T.min, 36, false, "-36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu8")
        NBKAssertEncodingText(T.min, 36, true , "-36UKV65J19B11MBVJYFUI963V4MY01KRTH19G3R3BK1OJLRWU8")
        NBKAssertEncodingText(T.max, 36, false,  "36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu7")
        NBKAssertEncodingText(T.max, 36, true ,  "36UKV65J19B11MBVJYFUI963V4MY01KRTH19G3R3BK1OJLRWU7")
    }
    
    func testEncodingNearRadixPowers() {
        self.continueAfterFailure = false
        let alphabet = Array("0123456789abcdefghijklmnopqrstuvwxyz")
        for radix in 2 ... 36 {
            
            var power = T(radix)
            let top: Character = alphabet[radix - 1]
            
            for exponent in 1 ... Int.max {
                NBKAssertEncodingText(power - 1, radix, false,       String(repeating: top, count: exponent))
                NBKAssertEncodingText(power,     radix, false, "1" + String(repeating: "0", count: exponent))
                NBKAssertEncodingText(power + 1, radix, false, "1" + String(repeating: "0", count: exponent - 1) + "1")
                
                guard !power.multiplyReportingOverflow(by: T.Digit(radix)) else { break }
            }
        }
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
    // MARK: Tests x Decoding
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix02() {
        NBKAssertDecodingText(T.min, 02, "0")
        NBKAssertDecodingText(T.max, 02, String(repeating: "1", count: T.bitWidth / 1))
    }
    
    func testDecodingRadix03() {
        NBKAssertDecodingText(T.min, 03, "0")
        NBKAssertDecodingText(T.max, 03,
        /*--------------------------*/"1202200220110222220212222112111221" +
        "0000122122012000200021102211020221112100121202101021020002001012" +
        "1011202120211110021000020122121222212000211211110200012022202120" )
    }
    
    func testDecodingRadix04() {
        NBKAssertDecodingText(T.min, 04, "0")
        NBKAssertDecodingText(T.max, 04, String(repeating: "3", count: T.bitWidth / 2))
    }
    
    func testDecodingRadix08() {
        NBKAssertDecodingText(T.min, 08, "0")
        NBKAssertDecodingText(T.max, 08, "1" + String(repeating: "7", count: 85))
    }
    
    func testDecodingRadix10() {
        NBKAssertDecodingText(T.min, 10, "0")
        NBKAssertDecodingText(T.max, 10, "115792089237316195423570985008687907853269984665640564039457584007913129639935")
    }
    
    func testDecodingRadix16() {
        NBKAssertDecodingText(T.min, 16, "0")
        NBKAssertDecodingText(T.max, 16, String(repeating: "f", count: T.bitWidth / 4))
    }
    
    func testDecodingRadix32() {
        NBKAssertDecodingText(T.min, 32, "0")
        NBKAssertDecodingText(T.max, 32, "1" + String(repeating: "v", count: 51))
    }
    
    func testDecodingRadix36() {
        NBKAssertDecodingText(T.min, 36, "0")
        NBKAssertDecodingText(T.max, 36, "6dp5qcb22im238nr3wvp0ic7q99w035jmy2iw7i6n43d37jtof")
    }
    
    func testDecodingRadixLiteralAsNumber() {
        NBKAssertDecodingText(T(33), 36,  "0x")
        NBKAssertDecodingText(T(24), 36,  "0o")
        NBKAssertDecodingText(T(11), 36,  "0b")
        
        NBKAssertDecodingText(T(33), 36, "+0x")
        NBKAssertDecodingText(T(24), 36, "+0o")
        NBKAssertDecodingText(T(11), 36, "+0b")
    }
    
    func testDecodingRadixLiteralAsRadixReturnsNil() {
        NBKAssertDecodingText(T?.none, 10,  "0x10")
        NBKAssertDecodingText(T?.none, 10,  "0o10")
        NBKAssertDecodingText(T?.none, 10,  "0b10")
        
        NBKAssertDecodingText(T?.none, 10, "+0x10")
        NBKAssertDecodingText(T?.none, 10, "+0o10")
        NBKAssertDecodingText(T?.none, 10, "+0b10")
    }
    
    func testDecodingStringsWithAndWithoutSign() {
        NBKAssertDecodingText(T(1234567890), 10,  "1234567890")
        NBKAssertDecodingText(T(1234567890), 10, "+1234567890")
    }
    
    func testDecodingStrategyIsCaseInsensitive() {
        NBKAssertDecodingText(T(0xabcdef), 16, "abcdef")
        NBKAssertDecodingText(T(0xABCDEF), 16, "ABCDEF")
        NBKAssertDecodingText(T(0xaBcDeF), 16, "aBcDeF")
        NBKAssertDecodingText(T(0xAbCdEf), 16, "AbCdEf")
    }
    
    func testDecodingUnalignedStringsIsOK() {
        NBKAssertDecodingText(T(1), 10, "1")
        NBKAssertDecodingText(T(1), 16, "1")
    }
    
    func testDecodingPrefixingZerosHasNoEffect() {
        let zero = String(repeating: "0", count: T.bitWidth) + "0"
        let one  = String(repeating: "0", count: T.bitWidth) + "1"
        
        for radix in 02 ... 36 {
            NBKAssertDecodingText(T(0), radix, zero)
            NBKAssertDecodingText(T(1), radix, one )
        }
    }
    
    func testDecodingInvalidCharactersReturnsNil() {
        NBKAssertDecodingText(T?.none, 16, "/")
        NBKAssertDecodingText(T?.none, 16, "G")

        NBKAssertDecodingText(T?.none, 10, "/")
        NBKAssertDecodingText(T?.none, 10, ":")

        NBKAssertDecodingText(T?.none, 10, String(repeating: "1", count: 19) + "/")
        NBKAssertDecodingText(T?.none, 10, String(repeating: "1", count: 19) + ":")
    }
    
    func testDecodingStringsWithoutDigitsReturnsNil() {
        NBKAssertDecodingText(T?.none, 10,  "")
        NBKAssertDecodingText(T?.none, 10, "+")
        NBKAssertDecodingText(T?.none, 10, "-")
        NBKAssertDecodingText(T?.none, 10, "~")
        
        NBKAssertDecodingText(T?.none, 16,  "")
        NBKAssertDecodingText(T?.none, 16, "+")
        NBKAssertDecodingText(T?.none, 16, "-")
        NBKAssertDecodingText(T?.none, 16, "~")
    }
    
    func testDecodingValuesOutsideOfRepresentableRangeReturnsNil() {
        let positive = "+" + String(repeating: "1", count: T.bitWidth + 1)
        let negative = "-" + String(repeating: "1", count: 1)
        
        for radix in 02 ... 36 {
            NBKAssertDecodingText(T?.none, radix, positive)
            NBKAssertDecodingText(T?.none, radix, negative)
        }
        
        NBKAssertDecodingText(T?.none, 36, "6dp5qcb22im238nr3wvp0ic7q99w035jmy2iw7i6n43d37jtog" ) // + 01
        NBKAssertDecodingText(T?.none, 36, "6dp5qcb22im238nr3wvp0ic7q99w035jmy2iw7i6n43d37jtof0") // * 36
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encoding
    //=------------------------------------------------------------------------=
    
    func testEncodingRadix02() {
        NBKAssertEncodingText(T.min, 02, false, "0")
        NBKAssertEncodingText(T.max, 02, false, String(repeating: "1", count: T.bitWidth / 1))
    }
    
    func testEncodingRadix03() {
        NBKAssertEncodingText(T.min, 03, false, "0")
        NBKAssertEncodingText(T.max, 03, false,
        /*--------------------------*/"1202200220110222220212222112111221" +
        "0000122122012000200021102211020221112100121202101021020002001012" +
        "1011202120211110021000020122121222212000211211110200012022202120" )
    }
    
    func testEncodingRadix04() {
        NBKAssertEncodingText(T.min, 04, false, "0")
        NBKAssertEncodingText(T.max, 04, false, String(repeating: "3", count: T.bitWidth / 2))
    }
    
    func testEncodingRadix08() {
        NBKAssertEncodingText(T.min, 08, false, "0")
        NBKAssertEncodingText(T.max, 08, false, "1" + String(repeating: "7", count: 85))
    }
    
    func testEncodingRadix10() {
        NBKAssertEncodingText(T.min, 10, false, "0")
        NBKAssertEncodingText(T.max, 10, false, "115792089237316195423570985008687907853269984665640564039457584007913129639935")
    }
    
    func testEncodingRadix16() {
        NBKAssertEncodingText(T.min, 16, false, "0")
        NBKAssertEncodingText(T.min, 16, true , "0")
        NBKAssertEncodingText(T.max, 16, false, String(repeating: "f", count: T.bitWidth / 4))
        NBKAssertEncodingText(T.max, 16, true , String(repeating: "F", count: T.bitWidth / 4))
    }
    
    func testEncodingRadix32() {
        NBKAssertEncodingText(T.min, 32, false, "0")
        NBKAssertEncodingText(T.min, 32, true , "0")
        NBKAssertEncodingText(T.max, 32, false, "1" + String(repeating: "v", count: 51))
        NBKAssertEncodingText(T.max, 32, true , "1" + String(repeating: "V", count: 51))
    }
    
    func testEncodingRadix36() {
        NBKAssertEncodingText(T.min, 36, false, "0")
        NBKAssertEncodingText(T.min, 36, true , "0")
        NBKAssertEncodingText(T.max, 36, false, "6dp5qcb22im238nr3wvp0ic7q99w035jmy2iw7i6n43d37jtof")
        NBKAssertEncodingText(T.max, 36, true , "6DP5QCB22IM238NR3WVP0IC7Q99W035JMY2IW7I6N43D37JTOF")
    }
    
    func testEncodingNearRadixPowers() {
        self.continueAfterFailure = false
        let alphabet = Array("0123456789abcdefghijklmnopqrstuvwxyz")
        for radix in 2 ... 36 {
            
            var power = T(radix)
            let top: Character = alphabet[radix - 1]
            
            for exponent in 1 ... Int.max {
                NBKAssertEncodingText(power - 1, radix, false,       String(repeating: top, count: exponent))
                NBKAssertEncodingText(power,     radix, false, "1" + String(repeating: "0", count: exponent))
                NBKAssertEncodingText(power + 1, radix, false, "1" + String(repeating: "0", count: exponent - 1) + "1")
                
                guard !power.multiplyReportingOverflow(by: T.Digit(radix)) else { break }
            }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Text x For Each Radix x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnTextForEachRadixAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let Ox0000000000000000000000000000000000000000000000000000000000000000 =
    T(x64: X(0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000))
    
    static let Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100 =
    T(x64: X(0x0706050403020100, 0x0f0e0d0c0b0a0908, 0x1716151413121110, 0x1f1e1d1c1b1a1918))
    
    static let Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170 =
    T(x64: X(0x7776757473727170, 0x7f7e7d7c7b7a7978, 0x8786858483828180, 0x8f8e8d8c8b8a8988))
    
    static let Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0 =
    T(x64: X(0xe7e6e5e4e3e2e1e0, 0xefeeedecebeae9e8, 0xf7f6f5f4f3f2f1f0, 0xfffefdfcfbfaf9f8))
    
    static let Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff =
    T(x64: X(0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff))
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func check(_ integer: T, radix: Int, ascii: String, file: StaticString = #file, line: UInt = #line) {
        var encoded = String(ascii.drop(while:{ $0 == "0" }))
        if  encoded.isEmpty {
            encoded.append(contentsOf: ascii.suffix(1))
        }
        
        NBKAssertDecodingText(integer, radix,          ascii, file: file,  line: line)
        NBKAssertDecodingText(integer, radix,        encoded, file: file,  line: line)
        NBKAssertEncodingText(integer, radix, true,  encoded.uppercased(), file: file, line: line)
        NBKAssertEncodingText(integer, radix, false, encoded.lowercased(), file: file, line: line)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func test02() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 02, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 02, ascii: """
        0001111100011110000111010001110000011011000110100001100100011000\
        0001011100010110000101010001010000010011000100100001000100010000\
        0000111100001110000011010000110000001011000010100000100100001000\
        0000011100000110000001010000010000000011000000100000000100000000
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 02, ascii: """
        1000111110001110100011011000110010001011100010101000100110001000\
        1000011110000110100001011000010010000011100000101000000110000000\
        0111111101111110011111010111110001111011011110100111100101111000\
        0111011101110110011101010111010001110011011100100111000101110000
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 02, ascii: """
        1111111111111110111111011111110011111011111110101111100111111000\
        1111011111110110111101011111010011110011111100101111000111110000\
        1110111111101110111011011110110011101011111010101110100111101000\
        1110011111100110111001011110010011100011111000101110000111100000
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 02, ascii: """
        1111111111111111111111111111111111111111111111111111111111111111\
        1111111111111111111111111111111111111111111111111111111111111111\
        1111111111111111111111111111111111111111111111111111111111111111\
        1111111111111111111111111111111111111111111111111111111111111111
        """)
    }
    
    func test03() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 03, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 03, ascii: """
        0000000000000000000000000000000012210112211101210122010202201212\
        2200112221212101221211222010022020100210220200100011100100222021\
        2000121220012212111000111110212212201000011111112211120210102101
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 03, ascii: """
        0000000000000000000000000000000222202012212222102210221210121100\
        2200012112212220210210210020221100221202022112101001220112100212\
        1110200002210110010201010200201111001101021112122000101211022020
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 03, ascii: """
        0000000000000000000000000000001202200212221120001222202211110211\
        2122212010220102122202121101120111112200201101101222110200202110\
        0220201022101000210101202220120002101202101120201012012212012002
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 03, ascii: """
        0000000000000000000000000000001202200220110222220212222112111221\
        0000122122012000200021102211020221112100121202101021020002001012\
        1011202120211110021000020122121222212000211211110200012022202120
        """)
    }
        
    func test04() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 04, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 04, ascii: """
        0133013201310130012301220121012001130112011101100103010201010100\
        0033003200310030002300220021002000130012001100100003000200010000
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 04, ascii: """
        2033203220312030202320222021202020132012201120102003200220012000\
        1333133213311330132313221321132013131312131113101303130213011300
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 04, ascii: """
        3333333233313330332333223321332033133312331133103303330233013300\
        3233323232313230322332223221322032133212321132103203320232013200
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 04, ascii: """
        3333333333333333333333333333333333333333333333333333333333333333\
        3333333333333333333333333333333333333333333333333333333333333333
        """)
    }
        
    func test05() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 05, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 05, ascii: """
        0000000000000000000424043311031102404011202312202132022104340041\
        4431003121344314114341012313341313423214420311244321214230031301
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 05, ascii: """
        0000000000000000004101344220341022000230122330222233434441134411\
        1042024043111210122431110130241443432144233431241122301101210140
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 05, ascii: """
        0000000000000000012224200130200441041444042343242340402322434230\
        2203100014323101131021202442142123441124102101232423332422334024
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 05, ascii: """
        0000000000000000012224202031032344000421332023432000421134220310\
        1012040131322434122131220223214420024222201102041122042141434220
        """)
    }
        
    func test06() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 06, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 06, ascii: """
        0000000000000000000000000000004353050531332542114015530141512113\
        1210015440102001011522210020211244125255022541512055450000200144
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 06, ascii: """
        0000000000000000000000000000033245030531204435442254324354520421\
        5321443304315210123425351422255425114311421424544134255023311440
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 06, ascii: """
        0000000000000000000000000000102141010531040333210533123011525130\
        3433311132532415235332533224344010103324220312020213104050423132
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 06, ascii: """
        0000000000000000000000000000102141054220150202303402031235430352\
        5141003020114213135200030531345402305211301035040321031131454023
        """)
    }
        
    func test07() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 07, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 07, ascii: """
        0000000000000000000000000000000000000114142063044505436351120634\
        3333263503132100565010106005630324255134635601621240633030645403
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 07, ascii: """
        0000000000000000000000000000000000000544603005663566662204602220\
        2453441422411244456440445340616462632364434300636600431145353033
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 07, ascii: """
        0000000000000000000000000000000000001305333621612661215031353503\
        1603616341660421351201115002605631306624232666655230226263060363
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 07, ascii: """
        0000000000000000000000000000000000001305336342255552261600605300\
        0312142162322155056411166110152261216161436542422120223503121321
        """)
    }
        
    func test08() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 08, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 08, ascii: """
        0000000000000000000000000000000000000000000174360721603306414430\
        0561302505011422042100170340641402605011020034060120200300400400
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 08, ascii: """
        0000000000000000000000000000000000000000001076164330621342504610\
        4170320541101602403001773747657436675171360735663527216334470560
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 08, ascii: """
        0000000000000000000000000000000000000000001777767737637376574770\
        7577336575171762743703577356675472765351721637467136234370560740
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 08, ascii: """
        0000000000000000000000000000000000000000001777777777777777777777\
        7777777777777777777777777777777777777777777777777777777777777777
        """)
    }
        
    func test09() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 09, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 09, ascii: """
        0000000000000000000000000000000000000000000000005715741718122655\
        8048777185486326632382030431086760556185430443785630144484523371
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 09, ascii: """
        0000000000000000000000000000000000000000000000028665788383853540\
        8017578672370684085227533181532543602713121120644041245560354266
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 09, ascii: """
        0000000000000000000000000000000000000000000000052625846058684424\
        7876381258254151448064135842067326638330711686502352346635185162
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 09, ascii: """
        0000000000000000000000000000000000000000000000052626428825875457\
        0057816060738422747055233720203534676743230218558760754420168676
        """)
    }
        
    func test10() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 10, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 10, ascii: """
        0000000000000000000000000000000000000000000000000001407490462640\
        1341155369551180448584754667373453244490859944217516317499064576
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 10, ascii: """
        0000000000000000000000000000000000000000000000000006493260656592\
        8454439447787733284058007868307894623875849823626962930324631920
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 10, ascii: """
        0000000000000000000000000000000000000000000000000011579030850545\
        5567723526024286119531261069242336003260839703036409543150199264
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 10, ascii: """
        0000000000000000000000000000000000000000000000000011579208923731\
        6195423570985008687907853269984665640564039457584007913129639935
        """)
    }
    
    func test11() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 11, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 11, ascii: """
        0000000000000000000000000000000000000000000000000000001380227a9a\
        3a453071005401517000a3500756239a46834284766655651370a28295109a06
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 11, ascii: """
        00000000000000000000000000000000000000000000000000000061a4a50630\
        a8a2a5054850a65619483743057a748700a74254a65374126721253852529313
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 11, ascii: """
        0000000000000000000000000000000000000000000000000000010019774172\
        675069499548a05a7794803603a4157366204225264092700a8157a30a948720
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 11, ascii: """
        0000000000000000000000000000000000000000000000000000010019a172a2\
        57928338136918a0879a501318791a398a4442a134074498897160a992314188
        """)
    }
        
    func test12() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 12, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 12, ascii: """
        000000000000000000000000000000000000000000000000000000000404b13b\
        22595a847521b8ab337490660a0b7439b1495399a8b2918a9521301732309054
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 12, ascii: """
        00000000000000000000000000000000000000000000000000000000167402b3\
        92280067bb9ab82b5485b0a597370ba7410534635591304712ab43681744b580
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 12, ascii: """
        0000000000000000000000000000000000000000000000000000000029231468\
        41b6624b4657b76b759711256462675490811529026b8b03507956b900591aa8
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 12, ascii: """
        0000000000000000000000000000000000000000000000000000000029232318\
        48b3961a5916a592b74b679ab5ba4431609480132970774a58171a3101bb7313
        """)
    }
        
    func test13() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 13, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 13, ascii: """
        00000000000000000000000000000000000000000000000000000000000268a5\
        1c5770b549c51487a17526804a0a14c0c44bbc981573456a275580297a4a7834
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 13, ascii: """
        00000000000000000000000000000000000000000000000000000000000b799a\
        5a30a10403764525c2625c35c5a1607b5c2bc8377574234165478118bc414a56
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 13, ascii: """
        0000000000000000000000000000000000000000000000000000000000178a92\
        980701228a277594134c94bb7165a938c70c03a705750115a339820831351c78
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 13, ascii: """
        0000000000000000000000000000000000000000000000000000000000178a9b\
        a9084cca3920ab3b79654bc161214488ab1952946001b873686b852c35486582
        """)
    }
        
    func test14() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 14, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 14, ascii: """
        0000000000000000000000000000000000000000000000000000000000000329\
        76a45325cd6dda6ac91cb8c9bccbbc61488833c2225a774c2da97ab4d4565d3a
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 14, ascii: """
        00000000000000000000000000000000000000000000000000000000000010a1\
        b5b8233ba74dd349940127b174432ad9445d48b39c9d0915c800ac61ad91301a
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 14, ascii: """
        0000000000000000000000000000000000000000000000000000000000001c38\
        14cbd353812dca285cc376972998797340345da539017abd8236000c88ca00da
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 14, ascii: """
        0000000000000000000000000000000000000000000000000000000000001c38\
        266036168d3994a19662bd4a5a5543b340d6d9c15a472d88dd5603115b2c5611
        """)
    }
        
    func test15() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 15, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 15, ascii: """
        0000000000000000000000000000000000000000000000000000000000000007\
        864d3605e05bd91d94b651ccc4e3078d6edc902745e03953a310b0de5c602701
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 15, ascii: """
        0000000000000000000000000000000000000000000000000000000000000024\
        d3c62414986de8676572ab6b9062c4d29268417cca4a59752e596a0e0dbc46d0
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 15, ascii: """
        0000000000000000000000000000000000000000000000000000000000000042\
        314e1223518107b1362e160a5ad29226b4e3e2d35ea57996aaa3242db02966ae
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 15, ascii: """
        0000000000000000000000000000000000000000000000000000000000000042\
        3182791a2872248a8025e2a5dd9b280362194759e6d4cd299338e9a1e0128a40
        """)
    }
        
    func test16() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 16, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 16, ascii: """
        1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 16, ascii: """
        8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 16, ascii: """
        fffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 16, ascii: """
        ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
        """)
    }
        
    func test17() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 17, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 17, ascii: """
        00c5b2gcge3c140g4d527274dgd5cg7g58babg3e21bg76739a559151527ce653
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 17, ascii: """
        035f3e0ee72c77ga395c5be9c4fc81de475c2751f6e170g890d3a5g47e334030
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 17, ascii: """
        05g7d81gc01cdbf42565444eaa12342c35gd9f66bbg36c8d8841baa7a8faab0e
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 17, ascii: """
        05g7dfd526bf1c9b3c3cea92b2cc972cf7c094c59d8549f406b75304a6652640
        """)
    }
        
    func test18() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 18, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 18, ascii: """
        0006e51f0da7284a3bb14747c33cgb1hfa3120c549aec7hh58g39hg075a02c3a
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 18, ascii: """
        001d628a74389385c2da5608ec4699e4b3eb7g626ac9g835dbd15c9c3hd0g536
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 18, ascii: """
        0031fhf5dce9fgc12bg164e9h35028896f83ddhh8be5286c3e9h17360bg1bg32
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 18, ascii: """
        0031g025he891652fc25eed6dg159ahb8a4ha2cbd9a3g69a667ehf83g9cceacf
        """)
    }
        
    func test19() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 19, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 19, ascii: """
        000050cae6cb5210060eg1g2iicc8e689a04g25829g2f5bc8c84ea4a8a1348f4
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 19, ascii: """
        00014461c902adcb001h697538d24251dci659hc924dei0480ei07i7g5h85g65
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 19, ascii: """
        000237ibab6cg652id30fgh76hdai93dhfh7dhagfdc5eb7f782c55d551ed74g6
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 19, ascii: """
        000237ifhbbce5diac835ehhg793c6bcdd6739hffgbfcefdedd0fg72b1hd4d7f
        """)
    }
        
    func test20() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 20, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 20, ascii: """
        000004hd5e33e5189jajhc248c2a513ae74fba267d1b3d1743i8ebgb30i9318g
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 20, ascii: """
        000012ab43eh37754g6157g68c461e7aafg9jggc3j9d4jggh5h68abj9668ijg0
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 20, ascii: """
        000020392d6ac9d1jd12d3a88c61i7ba748483ai05hf66c6a7g42977fbe8ei34
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 20, ascii: """
        000020397c3ag5f1a4463ja2f76ieaf6eeaj8c8c3831gjac344j485922d04jgf
        """)
    }
        
    func test21() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 21, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 21, ascii: """
        0000006124cec92463a07f87dgg069g06715hcg4j03fha2f1gafce80g895g09a
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 21, ascii: """
        0000016j819kah11b220kaac1ad685f0k6832f13fhi64ahihbbf5hhh54gkd713
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 21, ascii: """
        0000027gdj7593kjg0f1c5cga4aca1e1d5f08h72cebhcbc1c6cek06cf13eaddh
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 21, ascii: """
        0000027ge593j7g7c3cgc024cie1e1225bc9c4d76e8ba0igkahgibh891627c0f
        """)
    }
    
    func test22() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 22, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 22, ascii: """
        000000098djlg8ll6ge66j798kd129gf43e7c6586a31h5a25adg2l78kj3a82b6
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 22, ascii: """
        0000001l75k2ac0f94gca5kb27dhe1g2e61c39k7gdg3i1bi2gfl8ff38a3khebe
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 22, ascii: """
        0000003b5jk54f19beiidebchgec3ffc28aggdd74h75ijdc00i4ea0ji14954c0
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 22, ascii: """
        0000003b5kajch2e68a6c0jkl31jklhc6ffik3a74j41f5089jld39k8c087e5kj
        """)
    }
        
    func test23() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 23, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 23, ascii: """
        00000000hl580j6lii99g9c5137ji22ab5i41mba3lh6091cakd4h6llil689h12
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 23, ascii: """
        00000003dfhk63blfim02fc1324aei38b60ldgkleib7ejf84a6635858c4j3j13
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 23, ascii: """
        000000069a79baglcjbdblbk5111bb46b66g2b7a2f596763kmm7c3hbl336kl14
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 23, ascii: """
        000000069a8e20im6hk55k9fc0k4a35hj2j1fakdi8489l5mg2j2cc42417dhm07
        """)
    }
        
    func test24() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 24, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 24, ascii: """
        000000001h9gbi9kc8ig99kj5lil4in9d6e81la5d0h872fff899ebj57j88732g
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 24, ascii: """
        000000007n05g7189jj5kdnh8mcjn7dgemehhiaeikieh1bn3372n1n800767aa0
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 24, ascii: """
        00000000e4eikjgk76jj7i2fbn6ihk3ngef39fb00gjl3086em4k7g3ag5647hh8
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 24, ascii: """
        00000000e4ell5fddm7bj57c5eidm0jgcdn4kc1cb8e0g5c984gb0bgfcb6hn9if
        """)
    }
        
    func test25() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 25, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 25, ascii: """
        0000000004e4i6362kk6ad7abh2b4j0log0gbjn96nl1d8j88mh9m36enbbmf381
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 25, ascii: """
        000000000l1jmaj5c02f7dfccinol8o65m2kn6757eg61fe9nnbodjge6cf61b1k
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 25, ascii: """
        000000001cea1fa4l49o4dnedkkdcnmfc3509hg185baem9bdo6e5b1dediecike
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 25, ascii: """
        000000001ceaag3do04biadna0m6jc355741ghej7bgc2dboa2mca6246c4blnma
        """)
    }
        
    func test26() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 26, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 26, ascii: """
        0000000000e7a4822n1867n87cpm330nai4o7gj05b5j013bb0in29cncoodh584
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 26, ascii: """
        0000000002dn99hfdj4jjl72icln3on6j80ea5bhp1d0binfi7iigba2ldfeic96
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 26, ascii: """
        0000000004dd8f12of8578gn3cho4kjg1nm4ck49ihk7nahjpeie4d78426fjja8
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 26, ascii: """
        0000000004dd9kkp5ba44dp7ipn0clbhdkil2fad0l16pbbkapbbhal0jip8h1af
        """)
    }
        
    func test27() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 27, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 27, ascii: """
        00000000001p4pcg5j6ogq1hng5neo9oj2bk10d12on0go5nd0dcnnj04demflba
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 27, ascii: """
        00000000008ojpqlp8g5c80ghhkbb9km2n6pg35jg2gci2lc3j3ijd1a7eh0am86
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 27, ascii: """
        0000000000fo7qe0hopd7gqfbj7q7m4jdh2445pb279oj8a0lakof2akafj55n52
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 27, ascii: """
        0000000000fo848q7qmmh91pof20m8ckmg1n73li63g4kfmc706hgqn0mmci58kf
        """)
    }
        
    func test28() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 28, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 28, ascii: """
        000000000007odiqi7ipkbell34qeml609e642lhrao5n03422ik497coam17kmo
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 28, ascii: """
        00000000001895b29gmqerfklnlo2pra313erbf7k8cqb8b32l135g9bjojr5heo
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 28, ascii: """
        000000000028lp360pqr9fgjmgalj15e5kknmk8pd61irgj23bbe6nbafahp3e6o
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 28, ascii: """
        000000000028lpp2b71pnb05eppe6c96n44io2674a7no2o3lkn4i2njnrqllj0f
        """)
    }
        
    func test29() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 29, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 29, ascii: """
        0000000000017nr4pcg1heg13dh8cgggmn4q34frqm65gn8ec0j45591bmqfhffb
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 29, ascii: """
        000000000005opmfnbkke4s44oi3lfk204gb439adikf6kqqslpn4c6p9j3jd10l
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 29, ascii: """
        00000000000acrhqlapaaob766is1eng6erp522m0f5opigage3d3j4k7f9n8ff2
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 29, ascii: """
        00000000000acrloaj1mn6j7s7eh8796ss9gjf9gd34bpdf15dies8me9q9g7hsf
        """)
    }
        
    func test30() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 30, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 30, ascii: """
        0000000000006g1ldfsednredtimcop3b5l3q70e4kitjnhrn4eql74ecaf5j1mg
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 30, ascii: """
        00000000000104ee3l1et12e66qnnlcm1mt8a5qjfgi3p0ooktk3a1a8gfrgl5e0
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 30, ascii: """
        000000000001nmr6nq4fe87dse4p4i0ama7co4moqch8081liop9spg2kl9rn95e
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 30, ascii: """
        000000000001nmrt3i179ffbdsa0clsq63sttjbrm9pap9ms2pd6nft8iimg2sof
        """)
    }
        
    func test31() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 31, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 31, ascii: """
        000000000000171hhf8063e3r4a99sra00a157pihstia75dmk5kfae5nnn9ab6l
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 31, ascii: """
        0000000000005kgnmq0ofjtltlh6glmhk03fp5aub63se9rdc5pd6r305mcmsem6
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 31, ascii: """
        000000000000a30ts5ohp5e917o3nehp8urue2rb4e97icid1me5tcmpil25fi6m
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 31, ascii: """
        000000000000a313gilnoeiiekt9559bqu7h8pbh49n65lt9ek54eo1c67n06b91
        """)
    }
        
    func test32() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 32, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 32, ascii: """
        00000000000007ou3ke1m6gp30bhc58k2c91240f1o6go2oa1440e1g50g1g4080
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 32, ascii: """
        00000000000013sehm68n2k9h23od1c4ge18303vfpunourqf5s7etjlehpn4sbg
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 32, ascii: """
        0000000000001vvuvnufnunpv3rvdtfkufpf3s7ftrmupqvat7kefpn5sjhu5of0
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 32, ascii: """
        0000000000001vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
        """)
    }
        
    func test33() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 33, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 33, ascii: """
        00000000000001m3p6weqc5jk0wsb37sv08ileepww3jad5cr0cfhd0g1aq8in3s
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 33, ascii: """
        00000000000007n8k87oh3ecmwwftg4og46nj2cu0v5895bgesatqspmp5acqdq3
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 33, ascii: """
        0000000000000dodf9g17rn5pvw3et1k184sgnb11u6u7uhk2n9b3bhtfwrh14fb
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 33, ascii: """
        0000000000000dodmt2cn3cv3qsjwoca6g1mdp9itk7khqn1g7lpf363qsfnpr2u
        """)
    }
        
    func test34() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 34, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 34, ascii: """
        00000000000000cpwunuqgcm028uqxuqmjst7gk65egpsowcgixwuci6x899aa2k
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 34, ascii: """
        00000000000001ou1n8x1f83gs1t1pve4d8c59xv12qmkf1bq51xeshcciinjla0
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 34, ascii: """
        00000000000003304fs1ae3ixjsrahw1k6lt33dlup2jc54b1p3xxaghpss3swhe
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 34, ascii: """
        00000000000003306ba0ke3vb4ndw3cx2uh2ep1rqsk453iarkg4991oohlf6mrh
        """)
    }
        
    func test35() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 35, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 35, ascii: """
        0000000000000032wujn2mg481jyhidxmv5271ucr21qfj9jdvqm429mwneu6b2v
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 35, ascii: """
        00000000000000e7xo5l5b0ljve9b29f1knysf27c69fkalt1sel45ivbr7w3r6a
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 35, ascii: """
        00000000000000pcyhqj7yk3vq8j4l4vfa7wes91wah4p1y3op2k48s4pv0y189o
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 35, ascii: """
        00000000000000pcyyh26dx4rlcw17xq2fjnau1i9jl90hs95vfptvha2f7lv37f
        """)
    }
        
    func test36() {
        self.check(Self.Ox0000000000000000000000000000000000000000000000000000000000000000, radix: 36, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.Ox1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100, radix: 36, ascii: """
        000000000000000rx55jlhq7obx1pvd9861yo6c11bed0cd8s8wz2hpvczt00c1s
        """)
        
        self.check(Self.Ox8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170, radix: 36, ascii: """
        000000000000003kt35jcsnseykryw4dxdsl4jw68mhnaehyh7r7qagypmhufjao
        """)
        
        self.check(Self.Oxfffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0, radix: 36, ascii: """
        000000000000006dp15j43ld5l8i7wvimlj7kxgbfxkxkgmo66lge382296ouqjk
        """)
        
        self.check(Self.Oxffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, radix: 36, ascii: """
        000000000000006dp5qcb22im238nr3wvp0ic7q99w035jmy2iw7i6n43d37jtof
        """)
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

private func NBKAssertDecodingText<H: NBKFixedWidthInteger>(
_ integer: NBKDoubleWidth<H>?, _ radix: Int, _ text: String,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    if  radix == 10 {
        XCTAssertEqual(T.init(text), integer, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(T.init(text, radix: radix), integer, file: file, line: line)
}

private func NBKAssertEncodingText<H: NBKFixedWidthInteger>(
_ integer: NBKDoubleWidth<H>, _ radix: Int, _ uppercase: Bool, _ text: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  radix == 10 {
        XCTAssertEqual(String.init(integer), text, file: file, line: line)
        XCTAssertEqual(integer.description,  text, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(String.init(integer,radix: radix, uppercase: uppercase), text, file: file, line: line)
    XCTAssertEqual(integer.description(radix: radix, uppercase: uppercase), text, file: file, line: line)
}
