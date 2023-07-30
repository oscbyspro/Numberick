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
// MARK: * NBK x UIntXL x Text
//*============================================================================*

final class UIntXLTestsOnText: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let bit256 = 256 as Int
    let min256 = T(x64: X(repeating: UInt64.min, count: 4))
    let max256 = T(x64: X(repeating: UInt64.max, count: 4))
    
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

#endif
