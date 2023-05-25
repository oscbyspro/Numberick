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

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * NBK x Int256 x Text
//*============================================================================*

final class Int256TestsOnText: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitDescription() {
        XCTAssertEqual(T(   "10"),  10)
        XCTAssertEqual(T(  "+10"),  10)
        XCTAssertEqual(T(  "-10"), -10)
        XCTAssertEqual(T(  " 10"), nil)
        
        XCTAssertEqual(T( "0x10"), nil)
        XCTAssertEqual(T("+0x10"), nil)
        XCTAssertEqual(T("-0x10"), nil)
        XCTAssertEqual(T(" 0x10"), nil)
    }
    
    func testInstanceDescriptionUsesRadix10() {
        XCTAssertEqual( "10", T( 10).description)
        XCTAssertEqual("-10", T(-10).description)
        
        XCTAssertEqual( "10", String(describing: T( 10)))
        XCTAssertEqual("-10", String(describing: T(-10)))
    }
    
    func testMetaTypeDescriptionIsSimple() {
        XCTAssertEqual("Int256", T.description)
        XCTAssertEqual("Int512", T.DoubleWidth.description)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decode
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix02() {
        NBKAssertDecodeText(T.min, 2, "-1" + String(repeating: "0", count: T.bitWidth / 1 - 1))
        NBKAssertDecodeText(T.max, 2,        String(repeating: "1", count: T.bitWidth / 1 - 1))
    }
    
    func testDecodingRadix04() {
        NBKAssertDecodeText(T.min, 4, "-2" + String(repeating: "0", count: T.bitWidth / 2 - 1))
        NBKAssertDecodeText(T.max, 4,  "1" + String(repeating: "3", count: T.bitWidth / 2 - 1))
    }

    func testDecodingRadix08() {
        NBKAssertDecodeText(T.min, 8, "-1" + String(repeating: "0", count: 85))
        NBKAssertDecodeText(T.max, 8,        String(repeating: "7", count: 85))
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
    
    func testDecodingStringsWithOrWithoutSign() {
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
        
        for radix in 2 ... 36 {
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
    
    func testDecodingValueOutsideOfRepresentableRangeReturnsNil() {
        let positive = "+" + String(repeating: "1", count: T.bitWidth)
        let negative = "-" + String(repeating: "1", count: T.bitWidth)
        
        for radix in 2 ... 36 {
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
        NBKAssertEncodeText(T.min, 2, false, "-1" + String(repeating: "0", count: T.bitWidth / 1 - 1))
        NBKAssertEncodeText(T.max, 2, false,        String(repeating: "1", count: T.bitWidth / 1 - 1))
    }
    
    func testEncodingRadix04() {
        NBKAssertEncodeText(T.min, 4, false, "-2" + String(repeating: "0", count: T.bitWidth / 2 - 1))
        NBKAssertEncodeText(T.max, 4, false,  "1" + String(repeating: "3", count: T.bitWidth / 2 - 1))
    }
    
    func testEncodingRadix08() {
        NBKAssertEncodeText(T.min, 8, false, "-1" + String(repeating: "0", count: 85))
        NBKAssertEncodeText(T.max, 8, false,        String(repeating: "7", count: 85))
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
// MARK: * NBK x UInt256 x Text
//*============================================================================*

final class UInt256TestsOnText: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitDescription() {
        XCTAssertEqual(T(   "10"),  10)
        XCTAssertEqual(T(  "+10"),  10)
        XCTAssertEqual(T(  "-10"), nil)
        XCTAssertEqual(T(  " 10"), nil)
        
        XCTAssertEqual(T( "0x10"), nil)
        XCTAssertEqual(T("+0x10"), nil)
        XCTAssertEqual(T("-0x10"), nil)
        XCTAssertEqual(T(" 0x10"), nil)
    }
    
    func testInstanceDescriptionUsesRadix10() {
        XCTAssertEqual("10", T(10).description)
        XCTAssertEqual("10", String(describing: T(10)))
    }
    
    func testMetaTypeDescriptionIsSimple() {
        XCTAssertEqual("UInt256", T.description)
        XCTAssertEqual("UInt512", T.DoubleWidth.description)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decode
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix02() {
        NBKAssertDecodeText(T.min, 2, "0")
        NBKAssertDecodeText(T.max, 2, String(repeating: "1", count: T.bitWidth / 1))
    }
    
    func testDecodingRadix04() {
        NBKAssertDecodeText(T.min, 4, "0")
        NBKAssertDecodeText(T.max, 4, String(repeating: "3", count: T.bitWidth / 2))
    }
    
    func testDecodingRadix08() {
        NBKAssertDecodeText(T.min, 8, "0")
        NBKAssertDecodeText(T.max, 8, "1" + String(repeating: "7", count: 85))
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
    
    func testDecodingStringsWithOrWithoutSign() {
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
        
        for radix in 2 ... 36 {
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
    
    func testDecodingValueOutsideOfRepresentableRangeReturnsNil() {
        let positive = "+" + String(repeating: "1", count: T.bitWidth + 1)
        let negative = "-" + String(repeating: "1", count: 1)
        
        for radix in 2 ... 36 {
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
        NBKAssertEncodeText(T.min, 2, false, "0")
        NBKAssertEncodeText(T.max, 2, false, String(repeating: "1", count: T.bitWidth / 1))
    }
    
    func testEncodingRadix04() {
        NBKAssertEncodeText(T.min, 4, false, "0")
        NBKAssertEncodeText(T.max, 4, false, String(repeating: "3", count: T.bitWidth / 2))
    }
    
    func testEncodingRadix08() {
        NBKAssertEncodeText(T.min, 8, false, "0")
        NBKAssertEncodeText(T.max, 8, false, "1" + String(repeating: "7", count: 85))
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

#endif
