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

private typealias X64 = NBK.U256X64
private typealias X32 = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Text x Int256
//*============================================================================*
//=----------------------------------------------------------------------------=
// NOTE: See the for-each-radix section for more encoding tests.
//=----------------------------------------------------------------------------=

final class NBKDoubleWidthTestsOnTextAsInt256: XCTestCase {
    
    typealias T  = Int256
    typealias T2 = NBKDoubleWidth<T>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - Note: Its description is not as lenient as its string literal.
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
    
    func testDecodingUnalignedStringsIsOK() {
        NBKAssertDecodingText(T(1), 10, "1")
        NBKAssertDecodingText(T(1), 16, "1")
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
}

//*============================================================================*
// MARK: * NBK x Double Width x Text x UInt256
//*============================================================================*
//=----------------------------------------------------------------------------=
// NOTE: See the for-each-radix section for more encoding tests.
//=----------------------------------------------------------------------------=

final class NBKDoubleWidthTestsOnTextAsUInt256: XCTestCase {
    
    typealias T  = UInt256
    typealias T2 = NBKDoubleWidth<T>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// - Note: Its description is not as lenient as its string literal.
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
    
    func testDecodingUnalignedStringsIsOK() {
        NBKAssertDecodingText(T(1), 10, "1")
        NBKAssertDecodingText(T(1), 16, "1")
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
}

//*============================================================================*
// MARK: * NBK x Double Width x Text x For Each Radix x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnTextForEachRadixAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    static let min = T(x64: X64(0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x8000000000000000))
    static let max = T(x64: X64(0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0x7fffffffffffffff))
    
    static let bot = T(x64: X64(0x0706050403020100, 0x0f0e0d0c0b0a0908, 0x1716151413121110, 0x1f1e1d1c1b1a1918))
    static let mid = T(x64: X64(0x7776757473727170, 0x7f7e7d7c7b7a7978, 0x8786858483828180, 0x8f8e8d8c8b8a8988))
    static let top = T(x64: X64(0xe7e6e5e4e3e2e1e0, 0xefeeedecebeae9e8, 0xf7f6f5f4f3f2f1f0, 0xfffefdfcfbfaf9f8))
    
    //=------------------------------------------------------------------------=
    // MARK: Assertions
    //=------------------------------------------------------------------------=
    
    func check(_ integer: T, radix: Int, ascii: String, file: StaticString = #file, line: UInt = #line) {
        let (ascii) = String(ascii.drop(while:{ $0 == ">" }))
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
    
    func testImportantValues() {
        for radix in 02 ... 36 {
            self.check(T(-1), radix: radix, ascii: "-1")
            self.check(T( 0), radix: radix, ascii:  "0")
            self.check(T( 1), radix: radix, ascii:  "1")
        }
        
        for radix in 02 ... 36 {
            NBKAssertDecodingText(T( 0), radix,  "0")
            NBKAssertDecodingText(T( 0), radix, "+0")
            NBKAssertDecodingText(T( 0), radix, "-0")
            NBKAssertDecodingText(T( 1), radix,  "1")
            NBKAssertDecodingText(T( 1), radix, "+1")
            NBKAssertDecodingText(T(-1), radix, "-1")
        }
    }
    
    func testNearRadixPowers() {
        self.continueAfterFailure = false
        let alphabet = Array("0123456789abcdefghijklmnopqrstuvwxyz")
        for radix in 2 ... 36 {
            
            var power = T(radix)
            let top: Character = alphabet[radix - 1]
            
            for exponent in 1 ... Int.max {
                self.check(power - 1, radix: radix, ascii:       String(repeating: top, count: exponent))
                self.check(power,     radix: radix, ascii: "1" + String(repeating: "0", count: exponent))
                self.check(power + 1, radix: radix, ascii: "1" + String(repeating: "0", count: exponent - 1) + "1")
                
                guard !power.multiplyReportingOverflow(by: T.Digit(radix)) else { break }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Min, Max, Bot, Mid, Top
    //=------------------------------------------------------------------------=
    
    func test02() {
        //=--------------------------------------=
        self.check(Self.min, radix: 02, ascii: "-" + """
        1000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 02, ascii: """
        0111111111111111111111111111111111111111111111111111111111111111\
        1111111111111111111111111111111111111111111111111111111111111111\
        1111111111111111111111111111111111111111111111111111111111111111\
        1111111111111111111111111111111111111111111111111111111111111111
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 02, ascii: """
        0001111100011110000111010001110000011011000110100001100100011000\
        0001011100010110000101010001010000010011000100100001000100010000\
        0000111100001110000011010000110000001011000010100000100100001000\
        0000011100000110000001010000010000000011000000100000000100000000
        """)
        
        self.check(Self.mid, radix: 02, ascii: """
        -111000001110001011100100111001101110100011101010111011001110111\
        0111100001111001011110100111101101111100011111010111111001111111\
        1000000010000001100000101000001110000100100001011000011010000111\
        1000100010001001100010101000101110001100100011011000111010010000
        """)
        
        self.check(Self.top, radix: 02, ascii: """
        >>>>>>>>>>>>>>-1000000100000001100000100000001010000011000000111\
        0000100000001001000010100000101100001100000011010000111000001111\
        0001000000010001000100100001001100010100000101010001011000010111\
        0001100000011001000110100001101100011100000111010001111000100000
        """)
    }
    
    func test03() {
        //=--------------------------------------=
        self.check(Self.min, radix: 03, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-212211221201222221221111021020222\
        0000022211002111211122012220121222021011210212200122010001000121\
        0120212210102020010111121211022111102111220220201211121011101022
        """)
        
        self.check(Self.max, radix: 03, ascii: """
        0000000000000000000000000000000212211221201222221221111021020222\
        0000022211002111211122012220121222021011210212200122010001000121\
        0120212210102020010111121211022111102111220220201211121011101021
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 03, ascii: """
        0000000000000000000000000000000012210112211101210122010202201212\
        2200112221212101221211222010022020100210220200100011100100222021\
        2000121220012212111000111110212212201000011111112211120210102101
        """)
        
        self.check(Self.mid, radix: 03, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-202221200121000111002000201220120\
        0100110002022002212110122120022120120121022020000012022112200022\
        2201002111001000010022002221220111210122120021211122210111110101
        """)
        
        self.check(Self.top, radix: 03, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-112102211220012201001002\
        0100210111021121000111211102200102222122220100222021202101021202\
        0021001021110102110121110202001220110021110020202110222110120112
        """)
    }
        
    func test04() {
        //=--------------------------------------=
        self.check(Self.min, radix: 04, ascii: "-" + """
        2000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 04, ascii: """
        1333333333333333333333333333333333333333333333333333333333333333\
        3333333333333333333333333333333333333333333333333333333333333333
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 04, ascii: """
        0133013201310130012301220121012001130112011101100103010201010100\
        0033003200310030002300220021002000130012001100100003000200010000
        """)
        
        self.check(Self.mid, radix: 04, ascii: "-" + """
        1300130113021303131013111312131313201321132213231330133113321333\
        2000200120022003201020112012201320202021202220232030203120322100
        """)
        
        self.check(Self.top, radix: 04, ascii: """
        >>>>>>-100020003001000110012001300200021002200230030003100320033\
        0100010101020103011001110112011301200121012201230130013101320200
        """)
    }
        
    func test05() {
        //=--------------------------------------=
        self.check(Self.min, radix: 05, ascii: """
        >>>>>>>>>>>>>>>>>-3334323240241144222433141011441000210314332402\
        3003242313133442033313110111332210012111100301020311021043214333
        """)
        
        self.check(Self.max, radix: 05, ascii: """
        0000000000000000003334323240241144222433141011441000210314332402\
        3003242313133442033313110111332210012111100301020311021043214332
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 05, ascii: """
        0000000000000000000424043311031102404011202312202132022104340041\
        4431003121344314114341012313341313423214420311244321214230031301
        """)
        
        self.check(Self.mid, radix: 05, ascii: """
        >>>>>>>>>>>>>>>>>-3122302310141322000141204143204211431143030343\
        4420011033211223444200110042422421042022412120244444241040224031
        """)
        
        self.check(Self.top, radix: 05, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>-1400331402403422234130134110013311231024\
        3303440111444332441110012231022241033043044000303143204214100142
        """)
    }
        
    func test06() {
        //=--------------------------------------=
        self.check(Self.min, radix: 06, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>-31050325110053101131501013415513154\
        2350301310035104345400013243452501132403430315320140313343525012
        """)
        
        self.check(Self.max, radix: 06, ascii: """
        0000000000000000000000000000031050325110053101131501013415513154\
        2350301310035104345400013243452501132403430315320140313343525011
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 06, ascii: """
        0000000000000000000000000000004353050531332542114015530141512113\
        1210015440102001011522210020211244125255022541512055450000200144
        """)
        
        self.check(Self.mid, radix: 06, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>-24452023244541322421103302440505530\
        5415115311355003011330235105045533150455435210052142332104142144
        """)
        
        self.check(Self.top, radix: 06, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-43245105425052424504223501222\
        1303251443141353455423053303001352201443040323020103523041030452
        """)
    }
        
    func test07() {
        //=--------------------------------------=
        self.check(Self.min, radix: 07, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-502516521126261130633636133\
        3504421064511062363204066403424464106430553254544410111601410511
        """)
        
        self.check(Self.max, radix: 07, ascii: """
        0000000000000000000000000000000000000502516521126261130633636133\
        3504421064511062363204066403424464106430553254544410111601410510
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 07, ascii: """
        0000000000000000000000000000000000000114142063044505436351120634\
        3333263503132100565010106005630324255134635601621240633030645403
        """)
        
        self.check(Self.mid, radix: 07, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-430433333261652266363003046\
        4525400436610610266640420436232465253464002241452216462324435256
        """)
        
        self.check(Self.top, radix: 07, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-2420342561043536221463\
        5405222520331433405210051104243326606234203542433556664210030626
        """)
    }
        
    func test08() {
        //=--------------------------------------=
        self.check(Self.min, radix: 08, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-1000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 08, ascii: """
        0000000000000000000000000000000000000000000777777777777777777777\
        7777777777777777777777777777777777777777777777777777777777777777
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 08, ascii: """
        0000000000000000000000000000000000000000000174360721603306414430\
        0561302505011422042100170340641402605011020034060120200300400400
        """)
        
        self.check(Self.mid, radix: 08, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-701613447156435273167\
        3607457236676175374776004030120341102606417042114250561443307220
        """)
        
        self.check(Self.top, radix: 08, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-10040140401203007\
        0200441202606015034074200421102305012426056140310641543407217040
        """)
    }
    
    func test09() {
        //=--------------------------------------=
        self.check(Self.min, radix: 09, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-25757658857437228\
        0028407474818655823472561810101716783366114554274374826654534338
        """)
        
        self.check(Self.max, radix: 09, ascii: """
        0000000000000000000000000000000000000000000000025757658857437228\
        0028407474818655823472561810101716783366114554274374826654534337
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 09, ascii: """
        0000000000000000000000000000000000000000000000005715741718122655\
        8048777185486326632382030431086760556185430443785630144484523371
        """)
        
        self.check(Self.mid, radix: 09, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-22850530432021816\
        1040226277357627651726600527560881074030108087814718507748714411
        """)
        
        self.check(Self.top, radix: 09, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-472756181032\
        1071424701474261287881086767125207037412417422056407406673873515
        """)
    }
        
    func test10() {
        //=--------------------------------------=
        self.check(Self.min, radix: 10, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-5789604461865\
        8097711785492504343953926634992332820282019728792003956564819968
        """)
        
        self.check(Self.max, radix: 10, ascii: """
        0000000000000000000000000000000000000000000000000005789604461865\
        8097711785492504343953926634992332820282019728792003956564819967
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 10, ascii: """
        0000000000000000000000000000000000000000000000000001407490462640\
        1341155369551180448584754667373453244490859944217516317499064576
        """)
        
        self.check(Self.mid, radix: 10, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-5085948267138\
        7740984123197275403849845401676771016688189633957044982805008016
        """)
        
        self.check(Self.top, radix: 10, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-178073186\
        0627700044960722568376592200742329637303199754547598369979440672
        """)
    }
    
    func test11() {
        //=--------------------------------------=
        self.check(Self.min, radix: 11, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-5564a636a6\
        83a141740734645043a52561643a0a749a7776a6175922499a363054a116209a
        """)
        
        self.check(Self.max, radix: 11, ascii: """
        0000000000000000000000000000000000000000000000000000005564a636a6\
        83a141740734645043a52561643a0a749a7776a6175922499a363054a1162099
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 11, ascii: """
        0000000000000000000000000000000000000000000000000000001380227a9a\
        3a453071005401517000a3500756239a46834284766655651370a28295109a06
        """)
        
        self.check(Self.mid, radix: 11, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-4924a76771\
        599a8932761822456952138012a955628948004738638086225036713a895976
        """)
        
        self.check(Self.top, radix: 11, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-25312a\
        a04214992920284110057a8814850476242400770876622879a0040682476569
        """)
    }
        
    func test12() {
        //=--------------------------------------=
        self.check(Self.min, radix: 12, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-1471716a\
        2457a90b2a6952a7598593ab58bb221690484007749639852a096b1660bb9768
        """)
        
        self.check(Self.max, radix: 12, ascii: """
        000000000000000000000000000000000000000000000000000000001471716a\
        2457a90b2a6952a7598593ab58bb221690484007749639852a096b1660bb9767
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 12, ascii: """
        000000000000000000000000000000000000000000000000000000000404b13b\
        22595a847521b8ab337490660a0b7439b1495399a8b2918a9521301732309054
        """)
        
        self.check(Self.mid, radix: 12, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-126b2024\
        768795725937a963628576b51a8334461b8b476b939b470345279684a6767954
        """)
        
        self.check(Self.top, radix: 12, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-a70\
        06b9338b127aaa234174567551579898901366a62700a8470759833401625428
        """)
    }
        
    func test13() {
        //=--------------------------------------=
        self.check(Self.min, radix: 13, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-a454c\
        546a8ccb8476bc1c3b328c60971088aabc0b27b23000c4383435a916192432a8
        """)
        
        self.check(Self.max, radix: 13, ascii: """
        00000000000000000000000000000000000000000000000000000000000a454c\
        546a8ccb8476bc1c3b328c60971088aabc0b27b23000c4383435a916192432a7
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 13, ascii: """
        00000000000000000000000000000000000000000000000000000000000268a5\
        1c5770b549c51487a17526804a0a14c0c44bbc981573456a275580297a4a7834
        """)
        
        self.check(Self.mid, radix: 13, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-91101\
        4ba77bc6357766158702bc88684cb40a4bba5759b75a9532032404134607182a
        """)
        
        self.check(Self.top, radix: 13, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-9\
        11014ba77bc6357766158702bc88684cb40a4bba5759b75a9532032404134608
        """)
    }
        
    func test14() {
        //=--------------------------------------=
        self.check(Self.min, radix: 14, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-d1b\
        13301a0a468bb950ba315d952c2991c8906a6bd09c2386b46d9a01779c862a08
        """)
        
        self.check(Self.max, radix: 14, ascii: """
        0000000000000000000000000000000000000000000000000000000000000d1b\
        13301a0a468bb950ba315d952c2991c8906a6bd09c2386b46d9a01779c862a07
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 14, ascii: """
        0000000000000000000000000000000000000000000000000000000000000329\
        76a45325cd6dda6ac91cb8c9bccbbc61488833c2225a774c2da97ab4d4565d3a
        """)
        
        self.check(Self.mid, radix: 14, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-b76\
        508612b8c5c9a15602619578c61216b7da77910b9b8824731555348d8b7b25d6
        """)
        
        self.check(Self.top, radix: 14, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-\
        117242a30c09a877377d4693309aa84000a27a1a214592a95b200302b2425516
        """)
    }
        
    func test15() {
        //=--------------------------------------=
        self.check(Self.min, radix: 15, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-21\
        18413c0c8bb112454012e8ca6e4d1401a8849b2c7369de14c19474c87008bc98
        """)
        
        self.check(Self.max, radix: 15, ascii: """
        0000000000000000000000000000000000000000000000000000000000000021\
        18413c0c8bb112454012e8ca6e4d1401a8849b2c7369de14c19474c87008bc97
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 15, ascii: """
        0000000000000000000000000000000000000000000000000000000000000007\
        864d3605e05bd91d94b651ccc4e3078d6edc902745e03953a310b0de5c602701
        """)
        
        self.check(Self.mid, radix: 15, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>-1c\
        4cab550580032b2319a336394d385320bea105cc1b8973a463ce7e92d1454361
        """)
        
        self.check(Self.top, radix: 15, ascii: """
        >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\
        >-3366e6c6e11bc948e6cb9a82b885cb9c255476872e5382d785c5732ed82382
        """)
    }
        
    func test16() {
        //=--------------------------------------=
        self.check(Self.min, radix: 16, ascii: "-" + """
        8000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 16, ascii: """
        7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 16, ascii: """
        1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100
        """)
        
        self.check(Self.mid, radix: 16, ascii: "-" + """
        707172737475767778797a7b7c7d7e7f808182838485868788898a8b8c8d8e90
        """)
        
        self.check(Self.top, radix: 16, ascii: """
        >>-102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e20
        """)
    }
        
    func test17() {
        //=--------------------------------------=
        self.check(Self.min, radix: 17, ascii: """
        -2gc6g6b135g0ed5a61efdd159eed39eg3e8d262d6cb24g2035c2a0253329ba9
        """)
        
        self.check(Self.max, radix: 17, ascii: """
        02gc6g6b135g0ed5a61efdd159eed39eg3e8d262d6cb24g2035c2a0253329ba8
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 17, ascii: """
        00c5b2gcge3c140g4d527274dgd5cg7g58babg3e21bg76739a559151527ce653
        """)
        
        self.check(Self.mid, radix: 17, ascii: """
        -2a9a1c74g92b4a102f08fb9fee0155fb0656e73b6b3e8fc85f3be102931f611
        """)
        
        self.check(Self.top, radix: 17, ascii: """
        >>>>-7b576a250b716e7a64509ba6300c1c3g65ff191ee678f75a96dge7b8c34
        """)
    }
        
    func test18() {
        //=--------------------------------------=
        self.check(Self.min, radix: 18, ascii: """
        >-19h012hg449c2a7f12g76c6h0bde8ed528e165fde1h34e333g8gd1h4f67568
        """)
        
        self.check(Self.max, radix: 18, ascii: """
        0019h012hg449c2a7f12g76c6h0bde8ed528e165fde1h34e333g8gd1h4f67567
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 18, ascii: """
        0006e51f0da7284a3bb14747c33cgb1hfa3120c549aec7hh58g39hg075a02c3a
        """)
        
        self.check(Self.mid, radix: 18, ascii: """
        >-169fbdaa50a2ef396d98cfh3eh0136f68624696gfbhg64accdc2g9c9hbg59a
        """)
        
        self.check(Self.top, radix: 18, ascii: """
        >>>>>-5041bh37b1d04489geece572921cede6cc4fdgdg2g29ffg84fffeb2c9e
        """)
    }
        
    func test19() {
        //=--------------------------------------=
        self.check(Self.min, radix: 19, ascii: """
        >>-11d97i5f672g95641c78i83e1fcf66g33b4i7h85h677g76g07hd15a8g26d8
        """)
        
        self.check(Self.max, radix: 19, ascii: """
        00011d97i5f672g95641c78i83e1fcf66g33b4i7h85h677g76g07hd15a8g26d7
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 19, ascii: """
        000050cae6cb5210060eg1g2iicc8e689a04g25829g2f5bc8c84ea4a8a1348f4
        """)
        
        self.check(Self.mid, radix: 19, ascii: """
        >>>-i3ce52ba3b17ac64i5acchf1846b0070h0036e71gff96ch1f87ddf04hg1b
        """)
        
        self.check(Self.top, radix: 19, ascii: """
        >>>>>>-4704igi8fai528h0a98ebcg7heg7i8b6i02i9h37h75a7aacg602ig8aa
        """)
    }
        
    func test20() {
        //=--------------------------------------=
        self.check(Self.min, radix: 20, ascii: """
        >>>-101edg1f82haf2231jf17dd9757d7759e6461e1ai9f61c29c42eb16a29i8
        """)
        
        self.check(Self.max, radix: 20, ascii: """
        0000101edg1f82haf2231jf17dd9757d7759e6461e1ai9f61c29c42eb16a29i7
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 20, ascii: """
        000004hd5e33e5189jajhc248c2a513ae74fba267d1b3d1743i8ebgb30i9318g
        """)
        
        self.check(Self.mid, radix: 20, ascii: """
        >>>>-hci388dci7g57i4ibdg6f2ccg7g3ie98fbjj8d8bjdf5i7cfhd9cg6b600g
        """)
        
        self.check(Self.top, radix: 20, ascii: """
        >>>>>>>-4ih03g1jab33afje6f0gg33g7a2f08he3256aci5cg8f1ii16aiba1dc
        """)
    }
    
    func test21() {
        //=--------------------------------------=
        self.check(Self.min, radix: 21, ascii: """
        >>>>-13ihd4c9e83gc6860126970hb112g64gch3dheg5098a58ijg8ef0dbe608
        """)
        
        self.check(Self.max, radix: 21, ascii: """
        0000013ihd4c9e83gc6860126970hb112g64gch3dheg5098a58ijg8ef0dbe607
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 21, ascii: """
        0000006124cec92463a07f87dgg069g06715hcg4j03fha2f1gafce80g895g09a
        """)
        
        self.check(Self.mid, radix: 21, ascii: """
        >>>>-10i63k48bf611afcacdb80g5g8165469ac3bhb55b0j2k61cekc3ha2f4kd
        """)
        
        self.check(Self.top, radix: 21, ascii: """
        >>>>>>>>-71ja3g8h2iekfa92e3a3k90d5i93864ekheia6f8451jbagf028hj7k
        """)
    }
    
    func test22() {
        //=--------------------------------------=
        self.check(Self.min, radix: 22, ascii: """
        >>>>>-1gdl59h8c73453609lacbklajh37ika1g3d9d0idb44klhcfl46043i2la
        """)
        
        self.check(Self.max, radix: 22, ascii: """
        0000001gdl59h8c73453609lacbklajh37ika1g3d9d0idb44klhcfl46043i2l9
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 22, ascii: """
        000000098djlg8ll6ge66j798kd129gf43e7c6586a31h5a25adg2l78kj3a82b6
        """)
        
        self.check(Self.mid, radix: 22, ascii: """
        >>>>>-1bkech251kj3fg1gl9iha26k19e9e6gfbla59jj3ac735dgg553c48id96
        """)
        
        self.check(Self.top, radix: 22, ascii: """
        >>>>>>>>>-ce8214gfd9k8883897h62047523bj001ihi78i9j38aljafl3k918k
        """)
    }
        
    func test23() {
        //=--------------------------------------=
        self.check(Self.min, radix: 23, ascii: """
        >>>>>>-34gficbkmeka2ea4j60a251e8l19c7gli94244m2mjcl1662120f6kb04
        """)
        
        self.check(Self.max, radix: 23, ascii: """
        000000034gficbkmeka2ea4j60a251e8l19c7gli94244m2mjcl1662120f6kb03
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 23, ascii: """
        00000000hl580j6lii99g9c5137ji22ab5i41mba3lh6091cakd4h6llil689h12
        """)
        
        self.check(Self.mid, radix: 23, ascii: """
        >>>>>>-2ihdgik70dll534ke8lfgi8297ji31gmf3cg0i1debfcj96ijic2he2m5
        """)
        
        self.check(Self.top, radix: 23, ascii: """
        >>>>>>>>>-14dd20gl8eglki6mj2lf1b7jc8cmd3fflm3dmii2ji089d5l46k0m4
        """)
    }
        
    func test24() {
        //=--------------------------------------=
        self.check(Self.min, radix: 24, ascii: """
        >>>>>>>-727amejiin3hlefi2j96n09k66nea60i5g7082i4g285c5k7i5f8ngl8
        """)
        
        self.check(Self.max, radix: 24, ascii: """
        00000000727amejiin3hlefi2j96n09k66nea60i5g7082i4g285c5k7i5f8ngl7
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 24, ascii: """
        000000001h9gbi9kc8ig99kj5lil4in9d6e81la5d0h872fff899ebj57j88732g
        """)
        
        self.check(Self.mid, radix: 24, ascii: """
        >>>>>>>-65eg4me542c5mf7ikg5hmh5nlf8b2helgbj9n40a519819h7canbfn8g
        """)
        
        self.check(Self.top, radix: 24, ascii: """
        >>>>>>>>>>-309mh6fbgbb4khfbj44fgjn81akecafi3d542h6begjd4k60dfg18
        """)
    }
        
    func test25() {
        //=--------------------------------------=
        self.check(Self.min, radix: 25, ascii: """
        >>>>>>>>-ijhhke6ocei956o50b39ie2f3ed88jm3i8616ic51b653123625nbni
        """)
        
        self.check(Self.max, radix: 25, ascii: """
        000000000ijhhke6ocei956o50b39ie2f3ed88jm3i8616ic51b653123625nbnh
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 25, ascii: """
        0000000004e4i6362kk6ad7abh2b4j0log0gbjn96nl1d8j88mh9m36enbbmf381
        """)
        
        self.check(Self.mid, radix: 25, ascii: """
        >>>>>>>>-gcfd598c01lalnam6n6n33noa15ib7dom060mmeb4aclbaeooe5kckg
        """)
        
        self.check(Self.top, radix: 25, ascii: """
        >>>>>>>>>>>-90i92kjcdlf8l51i6d5ei3o16onho651cg2cl3fn4k0fgnam951m
        """)
    }
        
    func test26() {
        //=--------------------------------------=
        self.check(Self.min, radix: 26, ascii: """
        >>>>>>>>-26jhnacfii226pgmcod6ailjn9ae7i6dadgciin5ciiliad9mch8di8
        """)
        
        self.check(Self.max, radix: 26, ascii: """
        00000000026jhnacfii226pgmcod6ailjn9ae7i6dadgciin5ciiliad9mch8di7
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 26, ascii: """
        0000000000e7a4822n1867n87cpm330nai4o7gj05b5j013bb0in29cncoodh584
        """)
        
        self.check(Self.mid, radix: 26, ascii: """
        >>>>>>>>-1pg0b39hi5aaii50d138meakci6i9ol1je6die4ihij0pano59jof1a
        """)
        
        self.check(Self.top, radix: 26, ascii: """
        >>>>>>>>>>>-15jm6m1on58afd5280i1bmmgfl63836p20k0baincndifgiin808
        """)
    }
        
    func test27() {
        //=--------------------------------------=
        self.check(Self.min, radix: 27, ascii: """
        >>>>>>>>>-7phfhqhdbb8i0qc7edohjnolebh1o931lfnlb63dgm8dbdoojmg4a8
        """)
        
        self.check(Self.max, radix: 27, ascii: """
        00000000007phfhqhdbb8i0qc7edohjnolebh1o931lfnlb63dgm8dbdoojmg4a7
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 27, ascii: """
        00000000001p4pcg5j6ogq1hng5neo9oj2bk10d12on0go5nd0dcnnj04demflba
        """)
        
        self.check(Self.mid, radix: 27, ascii: """
        >>>>>>>>>-6qf5949i6h51196o8gapipjjloi0fph0qj2d10382podlhf7mhldca
        """)
        
        self.check(Self.top, radix: 27, ascii: """
        >>>>>>>>>>>>-4lph1o99j2acml1ed818pqj2on73n6717cbcgck1oc7c6kcqcfe
        """)
    }
        
    func test28() {
        //=--------------------------------------=
        self.check(Self.min, radix: 28, ascii: """
        >>>>>>>>>-14aqqf5heqpje2lcql364hbg29c133g53pq1c1oobg91bnprraone8
        """)
        
        self.check(Self.max, radix: 28, ascii: """
        000000000014aqqf5heqpje2lcql364hbg29c133g53pq1c1oobg91bnprraone7
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 28, ascii: """
        000000000007odiqi7ipkbell34qeml609e642lhrao5n03422ik497coam17kmo
        """)
        
        self.check(Self.mid, radix: 28, ascii: """
        >>>>>>>>>-10cke01i6r8bccl23i3e9ok313oiirc1mpcmd0irm1cee8436mg1dk
        """)
        
        self.check(Self.top, radix: 28, ascii: """
        >>>>>>>>>>>>>-loa92qdnbdk9ekfb3khbbn19p9j464oe51i9bib7c98h8oi4lk
        """)
    }
        
    func test29() {
        //=--------------------------------------=
        self.check(Self.min, radix: 29, ascii: """
        >>>>>>>>>>-56dpc59fbbho3si78ii4hssj89m4ml1gkcl7f2l97e4b74rj83ne8
        """)
        
        self.check(Self.max, radix: 29, ascii: """
        0000000000056dpc59fbbho3si78ii4hssj89m4ml1gkcl7f2l97e4b74rj83ne7
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 29, ascii: """
        0000000000017nr4pcg1heg13dh8cgggmn4q34frqm65gn8ec0j45591bmqfhffb
        """)
        
        self.check(Self.mid, radix: 29, ascii: """
        >>>>>>>>>>-4h1s8g7a291k3nbpdfki4snm5fc05sdcpilh35klknpfi075pngro
        """)
        
        self.check(Self.top, radix: 29, ascii: """
        >>>>>>>>>>>>>-3qi85ccb80m0oi6lejmdaked6ncgrfsnrjhsf1oihn2asls2de
        """)
    }
        
    func test30() {
        //=--------------------------------------=
        self.check(Self.min, radix: 30, ascii: """
        >>>>>>>>>>>-qqdtgo0ijmmklt506atd31tetoksq4rkcjqe1clibmtj99b81ec8
        """)
        
        self.check(Self.max, radix: 30, ascii: """
        000000000000qqdtgo0ijmmklt506atd31tetoksq4rkcjqe1clibmtj99b81ec7
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 30, ascii: """
        0000000000006g1ldfsednredtimcop3b5l3q70e4kitjnhrn4eql74ecaf5j1mg
        """)
        
        self.check(Self.mid, radix: 30, ascii: """
        >>>>>>>>>>>-nidetqtmaecr7ld6j0g44atljdf86n7708s3bpn3dej022otbnag
        """)
        
        self.check(Self.top, radix: 30, ascii: """
        >>>>>>>>>>>>>>-m9lqlp77rfe5583sfdnlh5ej2pr82p1l6e0hqokd5rrci9jj2
        """)
    }
        
    func test31() {
        //=--------------------------------------=
        self.check(Self.min, radix: 31, ascii: """
        >>>>>>>>>>>-51g1noqbrmoompu4i2k5suj8js5o24r32qek7a2hmrg633r035k1
        """)
        
        self.check(Self.max, radix: 31, ascii: """
        00000000000051g1noqbrmoompu4i2k5suj8js5o24r32qek7a2hmrg633r035k0
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 31, ascii: """
        000000000000171hhf8063e3r4a99sra00a157pihstia75dmk5kfae5nnn9ab6l
        """)
        
        self.check(Self.mid, radix: 31, ascii: """
        >>>>>>>>>>>-4dfaonku8pjrfuc2jehp6u41ek0ho3j8mc1r2eam7rtc0ga88rhr
        """)
        
        self.check(Self.top, radix: 31, ascii: """
        >>>>>>>>>>>>>>-4jcs5u949dd55clmhhuahpmf5uqdti9arcsltgb9hihkplo2b
        """)
    }
        
    func test32() {
        //=--------------------------------------=
        self.check(Self.min, radix: 32, ascii: """
        >>>>>>>>>>>-1000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 32, ascii: """
        0000000000000vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 32, ascii: """
        00000000000007ou3ke1m6gp30bhc58k2c91240f1o6go2oa1440e1g50g1g4080
        """)
        
        self.check(Self.mid, radix: 32, ascii: """
        >>>>>>>>>>>>-s3he9pn8tbmets7iujrfhunsvs0g6187145gq3oh2cahe68r3kg
        """)
        
        self.check(Self.top, radix: 32, ascii: """
        >>>>>>>>>>>>>>-1081g81860s40i2gb1g6gs3og2491650l2obhg68q3ce1q7h0
        """)
    }
    func test33() {
        //=--------------------------------------=
        self.check(Self.min, radix: 33, ascii: """
        >>>>>>>>>>>>-6snbehms1mw1tuqgc65380rncl9eqka8ts0okat7i31tuobtdhw
        """)
        
        self.check(Self.max, radix: 33, ascii: """
        00000000000006snbehms1mw1tuqgc65380rncl9eqka8ts0okat7i31tuobtdhv
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 33, ascii: """
        00000000000001m3p6weqc5jk0wsb37sv08ileepww3jad5cr0cfhd0g1aq8in3s
        """)
        
        self.check(Self.mid, radix: 33, ascii: """
        >>>>>>>>>>>>-6152krl5wvidqt4387inbrvrmtlsm2c8lbi1casl7de1n5awd9s
        """)
        
        self.check(Self.top, radix: 33, ascii: """
        >>>>>>>>>>>>>>>-7jjbf8mpartghsan57tqu1vhrn0n9t5edhcebol7asl6omkk
        """)
    }
    
    func test34() {
        //=--------------------------------------=
        self.check(Self.min, radix: 34, ascii: """
        >>>>>>>>>>>>-1ih35m0a71wmjbnx1ngif8i7chuuea22iq5dr824lhtc8rokbdq
        """)
        
        self.check(Self.max, radix: 34, ascii: """
        00000000000001ih35m0a71wmjbnx1ngif8i7chuuea22iq5dr824lhtc8rokbdp
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 34, ascii: """
        00000000000000cpwunuqgcm028uqxuqmjst7gk65egpsowcgixwuci6x899aa2k
        """)
        
        self.check(Self.mid, radix: 34, ascii: """
        >>>>>>>>>>>>-1c44m11iwtrsaliubfiwh8o9f1upprfimgx1fe4seicbx2pl1hi
        """)
        
        self.check(Self.top, radix: 34, ascii: """
        >>>>>>>>>>>>>>>-1tfxa00cbiskljevgnt7blm5u3hiqwdxptc49wj6wmrbboa4
        """)
    }
        
    func test35() {
        //=--------------------------------------=
        self.check(Self.min, radix: 35, ascii: """
        >>>>>>>>>>>>>-cnyyq136y2ds6g0lguip9t5f0qm9s4hqe4kfpcwfq517lax1l8
        """)
        
        self.check(Self.max, radix: 35, ascii: """
        00000000000000cnyyq136y2ds6g0lguip9t5f0qm9s4hqe4kfpcwfq517lax1l7
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 35, ascii: """
        0000000000000032wujn2mg481jyhidxmv5271ucr21qfj9jdvqm429mwneu6b2v
        """)
        
        self.check(Self.mid, radix: 35, ascii: """
        >>>>>>>>>>>>>-b51abg12wi7oxmp5ob0tunheyawdbsf76f4314ppxdpmyorb16
        """)
        
        self.check(Self.top, radix: 35, ascii: """
        >>>>>>>>>>>>>>>>-gphxed0uu4cvlstm5bpv1rgc944aft5g6d5pmo5bj6mttwr
        """)
    }
        
    func test36() {
        //=--------------------------------------=
        self.check(Self.min, radix: 36, ascii: """
        >>>>>>>>>>>>>-36ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu8
        """)
        
        self.check(Self.max, radix: 36, ascii: """
        0000000000000036ukv65j19b11mbvjyfui963v4my01krth19g3r3bk1ojlrwu7
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 36, ascii: """
        000000000000000rx55jlhq7obx1pvd9861yo6c11bed0cd8s8wz2hpvczt00c1s
        """)
        
        self.check(Self.mid, radix: 36, ascii: """
        >>>>>>>>>>>>>-2sw2ksy9eq73igouziyb7x7nu319ifv54zlb4zrw65dqld4ads
        """)
        
        self.check(Self.top, radix: 36, ascii: """
        >>>>>>>>>>>>>>>>-4kt6yh5gguqfu8e93hara9xtyf5l309wcar43f213wip34w
        """)
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
    
    static let min = T(x64: X64(0x0000000000000000, 0x0000000000000000, 0x0000000000000000, 0x0000000000000000))
    static let max = T(x64: X64(0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff, 0xffffffffffffffff))
    
    static let bot = T(x64: X64(0x0706050403020100, 0x0f0e0d0c0b0a0908, 0x1716151413121110, 0x1f1e1d1c1b1a1918))
    static let mid = T(x64: X64(0x7776757473727170, 0x7f7e7d7c7b7a7978, 0x8786858483828180, 0x8f8e8d8c8b8a8988))
    static let top = T(x64: X64(0xe7e6e5e4e3e2e1e0, 0xefeeedecebeae9e8, 0xf7f6f5f4f3f2f1f0, 0xfffefdfcfbfaf9f8))
    
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
    
    func testImportantValues() {
        for radix in 02 ... 36 {
            self.check(T(0), radix: radix, ascii:  "0")
            self.check(T(1), radix: radix, ascii:  "1")
        }
        
        for radix in 02 ... 36 {
            NBKAssertDecodingText(T?(  0), radix,  "0")
            NBKAssertDecodingText(T?(  0), radix, "+0")
            NBKAssertDecodingText(T?(  0), radix, "-0")
            NBKAssertDecodingText(T?(  1), radix,  "1")
            NBKAssertDecodingText(T?(  1), radix, "+1")
            NBKAssertDecodingText(T?(nil), radix, "-1")
        }
    }
    
    func testNearRadixPowers() {
        self.continueAfterFailure = false
        let alphabet = Array("0123456789abcdefghijklmnopqrstuvwxyz")
        for radix in 2 ... 36 {
            
            var power = T(radix)
            let top: Character = alphabet[radix - 1]
            
            for exponent in 1 ... Int.max {
                self.check(power - 1, radix: radix, ascii:       String(repeating: top, count: exponent))
                self.check(power,     radix: radix, ascii: "1" + String(repeating: "0", count: exponent))
                self.check(power + 1, radix: radix, ascii: "1" + String(repeating: "0", count: exponent - 1) + "1")

                guard !power.multiplyReportingOverflow(by: T.Digit(radix)) else { break }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Min, Max, Bot, Mid, Top
    //=------------------------------------------------------------------------=
    
    func test02() {
        //=--------------------------------------=
        self.check(Self.min, radix: 02, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 02, ascii: """
        1111111111111111111111111111111111111111111111111111111111111111\
        1111111111111111111111111111111111111111111111111111111111111111\
        1111111111111111111111111111111111111111111111111111111111111111\
        1111111111111111111111111111111111111111111111111111111111111111
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 02, ascii: """
        0001111100011110000111010001110000011011000110100001100100011000\
        0001011100010110000101010001010000010011000100100001000100010000\
        0000111100001110000011010000110000001011000010100000100100001000\
        0000011100000110000001010000010000000011000000100000000100000000
        """)
        
        self.check(Self.mid, radix: 02, ascii: """
        1000111110001110100011011000110010001011100010101000100110001000\
        1000011110000110100001011000010010000011100000101000000110000000\
        0111111101111110011111010111110001111011011110100111100101111000\
        0111011101110110011101010111010001110011011100100111000101110000
        """)
        
        self.check(Self.top, radix: 02, ascii: """
        1111111111111110111111011111110011111011111110101111100111111000\
        1111011111110110111101011111010011110011111100101111000111110000\
        1110111111101110111011011110110011101011111010101110100111101000\
        1110011111100110111001011110010011100011111000101110000111100000
        """)
    }
    
    func test03() {
        //=--------------------------------------=
        self.check(Self.min, radix: 03, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 03, ascii: """
        0000000000000000000000000000001202200220110222220212222112111221\
        0000122122012000200021102211020221112100121202101021020002001012\
        1011202120211110021000020122121222212000211211110200012022202120
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 03, ascii: """
        0000000000000000000000000000000012210112211101210122010202201212\
        2200112221212101221211222010022020100210220200100011100100222021\
        2000121220012212111000111110212212201000011111112211120210102101
        """)
        
        self.check(Self.mid, radix: 03, ascii: """
        0000000000000000000000000000000222202012212222102210221210121100\
        2200012112212220210210210020221100221202022112101001220112100212\
        1110200002210110010201010200201111001101021112122000101211022020
        """)
        
        self.check(Self.top, radix: 03, ascii: """
        0000000000000000000000000000001202200212221120001222202211110211\
        2122212010220102122202121101120111112200201101101222110200202110\
        0220201022101000210101202220120002101202101120201012012212012002
        """)
    }
        
    func test04() {
        //=--------------------------------------=
        self.check(Self.min, radix: 04, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 04, ascii: """
        3333333333333333333333333333333333333333333333333333333333333333\
        3333333333333333333333333333333333333333333333333333333333333333
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 04, ascii: """
        0133013201310130012301220121012001130112011101100103010201010100\
        0033003200310030002300220021002000130012001100100003000200010000
        """)
        
        self.check(Self.mid, radix: 04, ascii: """
        2033203220312030202320222021202020132012201120102003200220012000\
        1333133213311330132313221321132013131312131113101303130213011300
        """)
        
        self.check(Self.top, radix: 04, ascii: """
        3333333233313330332333223321332033133312331133103303330233013300\
        3233323232313230322332223221322032133212321132103203320232013200
        """)
    }
        
    func test05() {
        //=--------------------------------------=
        self.check(Self.min, radix: 05, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 05, ascii: """
        0000000000000000012224202031032344000421332023432000421134220310\
        1012040131322434122131220223214420024222201102041122042141434220
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 05, ascii: """
        0000000000000000000424043311031102404011202312202132022104340041\
        4431003121344314114341012313341313423214420311244321214230031301
        """)
        
        self.check(Self.mid, radix: 05, ascii: """
        0000000000000000004101344220341022000230122330222233434441134411\
        1042024043111210122431110130241443432144233431241122301101210140
        """)
        
        self.check(Self.top, radix: 05, ascii: """
        0000000000000000012224200130200441041444042343242340402322434230\
        2203100014323101131021202442142123441124102101232423332422334024
        """)
    }
        
    func test06() {
        //=--------------------------------------=
        self.check(Self.min, radix: 06, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 06, ascii: """
        0000000000000000000000000000102141054220150202303402031235430352\
        5141003020114213135200030531345402305211301035040321031131454023
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 06, ascii: """
        0000000000000000000000000000004353050531332542114015530141512113\
        1210015440102001011522210020211244125255022541512055450000200144
        """)
        
        self.check(Self.mid, radix: 06, ascii: """
        0000000000000000000000000000033245030531204435442254324354520421\
        5321443304315210123425351422255425114311421424544134255023311440
        """)
        
        self.check(Self.top, radix: 06, ascii: """
        0000000000000000000000000000102141010531040333210533123011525130\
        3433311132532415235332533224344010103324220312020213104050423132
        """)
    }
        
    func test07() {
        //=--------------------------------------=
        self.check(Self.min, radix: 07, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 07, ascii: """
        0000000000000000000000000000000000001305336342255552261600605300\
        0312142162322155056411166110152261216161436542422120223503121321
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 07, ascii: """
        0000000000000000000000000000000000000114142063044505436351120634\
        3333263503132100565010106005630324255134635601621240633030645403
        """)
        
        self.check(Self.mid, radix: 07, ascii: """
        0000000000000000000000000000000000000544603005663566662204602220\
        2453441422411244456440445340616462632364434300636600431145353033
        """)
        
        self.check(Self.top, radix: 07, ascii: """
        0000000000000000000000000000000000001305333621612661215031353503\
        1603616341660421351201115002605631306624232666655230226263060363
        """)
    }
        
    func test08() {
        //=--------------------------------------=
        self.check(Self.min, radix: 08, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 08, ascii: """
        0000000000000000000000000000000000000000001777777777777777777777\
        7777777777777777777777777777777777777777777777777777777777777777
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 08, ascii: """
        0000000000000000000000000000000000000000000174360721603306414430\
        0561302505011422042100170340641402605011020034060120200300400400
        """)
        
        self.check(Self.mid, radix: 08, ascii: """
        0000000000000000000000000000000000000000001076164330621342504610\
        4170320541101602403001773747657436675171360735663527216334470560
        """)
        
        self.check(Self.top, radix: 08, ascii: """
        0000000000000000000000000000000000000000001777767737637376574770\
        7577336575171762743703577356675472765351721637467136234370560740
        """)
    }
        
    func test09() {
        //=--------------------------------------=
        self.check(Self.min, radix: 09, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 09, ascii: """
        0000000000000000000000000000000000000000000000052626428825875457\
        0057816060738422747055233720203534676743230218558760754420168676
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 09, ascii: """
        0000000000000000000000000000000000000000000000005715741718122655\
        8048777185486326632382030431086760556185430443785630144484523371
        """)
        
        self.check(Self.mid, radix: 09, ascii: """
        0000000000000000000000000000000000000000000000028665788383853540\
        8017578672370684085227533181532543602713121120644041245560354266
        """)
        
        self.check(Self.top, radix: 09, ascii: """
        0000000000000000000000000000000000000000000000052625846058684424\
        7876381258254151448064135842067326638330711686502352346635185162
        """)
    }
        
    func test10() {
        //=--------------------------------------=
        self.check(Self.min, radix: 10, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 10, ascii: """
        0000000000000000000000000000000000000000000000000011579208923731\
        6195423570985008687907853269984665640564039457584007913129639935
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 10, ascii: """
        0000000000000000000000000000000000000000000000000001407490462640\
        1341155369551180448584754667373453244490859944217516317499064576
        """)
        
        self.check(Self.mid, radix: 10, ascii: """
        0000000000000000000000000000000000000000000000000006493260656592\
        8454439447787733284058007868307894623875849823626962930324631920
        """)
        
        self.check(Self.top, radix: 10, ascii: """
        0000000000000000000000000000000000000000000000000011579030850545\
        5567723526024286119531261069242336003260839703036409543150199264
        """)
    }
    
    func test11() {
        //=--------------------------------------=
        self.check(Self.min, radix: 11, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 11, ascii: """
        0000000000000000000000000000000000000000000000000000010019a172a2\
        57928338136918a0879a501318791a398a4442a134074498897160a992314188
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 11, ascii: """
        0000000000000000000000000000000000000000000000000000001380227a9a\
        3a453071005401517000a3500756239a46834284766655651370a28295109a06
        """)
        
        self.check(Self.mid, radix: 11, ascii: """
        00000000000000000000000000000000000000000000000000000061a4a50630\
        a8a2a5054850a65619483743057a748700a74254a65374126721253852529313
        """)
        
        self.check(Self.top, radix: 11, ascii: """
        0000000000000000000000000000000000000000000000000000010019774172\
        675069499548a05a7794803603a4157366204225264092700a8157a30a948720
        """)
    }
        
    func test12() {
        //=--------------------------------------=
        self.check(Self.min, radix: 12, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 12, ascii: """
        0000000000000000000000000000000000000000000000000000000029232318\
        48b3961a5916a592b74b679ab5ba4431609480132970774a58171a3101bb7313
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 12, ascii: """
        000000000000000000000000000000000000000000000000000000000404b13b\
        22595a847521b8ab337490660a0b7439b1495399a8b2918a9521301732309054
        """)
        
        self.check(Self.mid, radix: 12, ascii: """
        00000000000000000000000000000000000000000000000000000000167402b3\
        92280067bb9ab82b5485b0a597370ba7410534635591304712ab43681744b580
        """)
        
        self.check(Self.top, radix: 12, ascii: """
        0000000000000000000000000000000000000000000000000000000029231468\
        41b6624b4657b76b759711256462675490811529026b8b03507956b900591aa8
        """)
    }
        
    func test13() {
        //=--------------------------------------=
        self.check(Self.min, radix: 13, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 13, ascii: """
        0000000000000000000000000000000000000000000000000000000000178a9b\
        a9084cca3920ab3b79654bc161214488ab1952946001b873686b852c35486582
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 13, ascii: """
        00000000000000000000000000000000000000000000000000000000000268a5\
        1c5770b549c51487a17526804a0a14c0c44bbc981573456a275580297a4a7834
        """)
        
        self.check(Self.mid, radix: 13, ascii: """
        00000000000000000000000000000000000000000000000000000000000b799a\
        5a30a10403764525c2625c35c5a1607b5c2bc8377574234165478118bc414a56
        """)
        
        self.check(Self.top, radix: 13, ascii: """
        0000000000000000000000000000000000000000000000000000000000178a92\
        980701228a277594134c94bb7165a938c70c03a705750115a339820831351c78
        """)
    }
        
    func test14() {
        //=--------------------------------------=
        self.check(Self.min, radix: 14, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 14, ascii: """
        0000000000000000000000000000000000000000000000000000000000001c38\
        266036168d3994a19662bd4a5a5543b340d6d9c15a472d88dd5603115b2c5611
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 14, ascii: """
        0000000000000000000000000000000000000000000000000000000000000329\
        76a45325cd6dda6ac91cb8c9bccbbc61488833c2225a774c2da97ab4d4565d3a
        """)
        
        self.check(Self.mid, radix: 14, ascii: """
        00000000000000000000000000000000000000000000000000000000000010a1\
        b5b8233ba74dd349940127b174432ad9445d48b39c9d0915c800ac61ad91301a
        """)
        
        self.check(Self.top, radix: 14, ascii: """
        0000000000000000000000000000000000000000000000000000000000001c38\
        14cbd353812dca285cc376972998797340345da539017abd8236000c88ca00da
        """)
    }
        
    func test15() {
        //=--------------------------------------=
        self.check(Self.min, radix: 15, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000\
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 15, ascii: """
        0000000000000000000000000000000000000000000000000000000000000042\
        3182791a2872248a8025e2a5dd9b280362194759e6d4cd299338e9a1e0128a40
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 15, ascii: """
        0000000000000000000000000000000000000000000000000000000000000007\
        864d3605e05bd91d94b651ccc4e3078d6edc902745e03953a310b0de5c602701
        """)
        
        self.check(Self.mid, radix: 15, ascii: """
        0000000000000000000000000000000000000000000000000000000000000024\
        d3c62414986de8676572ab6b9062c4d29268417cca4a59752e596a0e0dbc46d0
        """)
        
        self.check(Self.top, radix: 15, ascii: """
        0000000000000000000000000000000000000000000000000000000000000042\
        314e1223518107b1362e160a5ad29226b4e3e2d35ea57996aaa3242db02966ae
        """)
    }
        
    func test16() {
        //=--------------------------------------=
        self.check(Self.min, radix: 16, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 16, ascii: """
        ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 16, ascii: """
        1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100
        """)
        
        self.check(Self.mid, radix: 16, ascii: """
        8f8e8d8c8b8a898887868584838281807f7e7d7c7b7a79787776757473727170
        """)
        
        self.check(Self.top, radix: 16, ascii: """
        fffefdfcfbfaf9f8f7f6f5f4f3f2f1f0efeeedecebeae9e8e7e6e5e4e3e2e1e0
        """)
    }
    
    func test17() {
        //=--------------------------------------=
        self.check(Self.min, radix: 17, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 17, ascii: """
        05g7dfd526bf1c9b3c3cea92b2cc972cf7c094c59d8549f406b75304a6652640
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 17, ascii: """
        00c5b2gcge3c140g4d527274dgd5cg7g58babg3e21bg76739a559151527ce653
        """)
        
        self.check(Self.mid, radix: 17, ascii: """
        035f3e0ee72c77ga395c5be9c4fc81de475c2751f6e170g890d3a5g47e334030
        """)
        
        self.check(Self.top, radix: 17, ascii: """
        05g7d81gc01cdbf42565444eaa12342c35gd9f66bbg36c8d8841baa7a8faab0e
        """)
    }
        
    func test18() {
        //=--------------------------------------=
        self.check(Self.min, radix: 18, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 18, ascii: """
        0031g025he891652fc25eed6dg159ahb8a4ha2cbd9a3g69a667ehf83g9cceacf
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 18, ascii: """
        0006e51f0da7284a3bb14747c33cgb1hfa3120c549aec7hh58g39hg075a02c3a
        """)
        
        self.check(Self.mid, radix: 18, ascii: """
        001d628a74389385c2da5608ec4699e4b3eb7g626ac9g835dbd15c9c3hd0g536
        """)
        
        self.check(Self.top, radix: 18, ascii: """
        0031fhf5dce9fgc12bg164e9h35028896f83ddhh8be5286c3e9h17360bg1bg32
        """)
    }
        
    func test19() {
        //=--------------------------------------=
        self.check(Self.min, radix: 19, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 19, ascii: """
        000237ifhbbce5diac835ehhg793c6bcdd6739hffgbfcefdedd0fg72b1hd4d7f
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 19, ascii: """
        000050cae6cb5210060eg1g2iicc8e689a04g25829g2f5bc8c84ea4a8a1348f4
        """)
        
        self.check(Self.mid, radix: 19, ascii: """
        00014461c902adcb001h697538d24251dci659hc924dei0480ei07i7g5h85g65
        """)
        
        self.check(Self.top, radix: 19, ascii: """
        000237ibab6cg652id30fgh76hdai93dhfh7dhagfdc5eb7f782c55d551ed74g6
        """)
    }
        
    func test20() {
        //=--------------------------------------=
        self.check(Self.min, radix: 20, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 20, ascii: """
        000020397c3ag5f1a4463ja2f76ieaf6eeaj8c8c3831gjac344j485922d04jgf
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 20, ascii: """
        000004hd5e33e5189jajhc248c2a513ae74fba267d1b3d1743i8ebgb30i9318g
        """)
        
        self.check(Self.mid, radix: 20, ascii: """
        000012ab43eh37754g6157g68c461e7aafg9jggc3j9d4jggh5h68abj9668ijg0
        """)
        
        self.check(Self.top, radix: 20, ascii: """
        000020392d6ac9d1jd12d3a88c61i7ba748483ai05hf66c6a7g42977fbe8ei34
        """)
    }
        
    func test21() {
        //=--------------------------------------=
        self.check(Self.min, radix: 21, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 21, ascii: """
        0000027ge593j7g7c3cgc024cie1e1225bc9c4d76e8ba0igkahgibh891627c0f
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 21, ascii: """
        0000006124cec92463a07f87dgg069g06715hcg4j03fha2f1gafce80g895g09a
        """)
        
        self.check(Self.mid, radix: 21, ascii: """
        0000016j819kah11b220kaac1ad685f0k6832f13fhi64ahihbbf5hhh54gkd713
        """)
        
        self.check(Self.top, radix: 21, ascii: """
        0000027gdj7593kjg0f1c5cga4aca1e1d5f08h72cebhcbc1c6cek06cf13eaddh
        """)
    }
    
    func test22() {
        //=--------------------------------------=
        self.check(Self.min, radix: 22, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 22, ascii: """
        0000003b5kajch2e68a6c0jkl31jklhc6ffik3a74j41f5089jld39k8c087e5kj
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 22, ascii: """
        000000098djlg8ll6ge66j798kd129gf43e7c6586a31h5a25adg2l78kj3a82b6
        """)
        
        self.check(Self.mid, radix: 22, ascii: """
        0000001l75k2ac0f94gca5kb27dhe1g2e61c39k7gdg3i1bi2gfl8ff38a3khebe
        """)
        
        self.check(Self.top, radix: 22, ascii: """
        0000003b5jk54f19beiidebchgec3ffc28aggdd74h75ijdc00i4ea0ji14954c0
        """)
    }
        
    func test23() {
        //=--------------------------------------=
        self.check(Self.min, radix: 23, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 23, ascii: """
        000000069a8e20im6hk55k9fc0k4a35hj2j1fakdi8489l5mg2j2cc42417dhm07
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 23, ascii: """
        00000000hl580j6lii99g9c5137ji22ab5i41mba3lh6091cakd4h6llil689h12
        """)
        
        self.check(Self.mid, radix: 23, ascii: """
        00000003dfhk63blfim02fc1324aei38b60ldgkleib7ejf84a6635858c4j3j13
        """)
        
        self.check(Self.top, radix: 23, ascii: """
        000000069a79baglcjbdblbk5111bb46b66g2b7a2f596763kmm7c3hbl336kl14
        """)
    }
        
    func test24() {
        //=--------------------------------------=
        self.check(Self.min, radix: 24, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 24, ascii: """
        00000000e4ell5fddm7bj57c5eidm0jgcdn4kc1cb8e0g5c984gb0bgfcb6hn9if
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 24, ascii: """
        000000001h9gbi9kc8ig99kj5lil4in9d6e81la5d0h872fff899ebj57j88732g
        """)
        
        self.check(Self.mid, radix: 24, ascii: """
        000000007n05g7189jj5kdnh8mcjn7dgemehhiaeikieh1bn3372n1n800767aa0
        """)
        
        self.check(Self.top, radix: 24, ascii: """
        00000000e4eikjgk76jj7i2fbn6ihk3ngef39fb00gjl3086em4k7g3ag5647hh8
        """)
    }
        
    func test25() {
        //=--------------------------------------=
        self.check(Self.min, radix: 25, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 25, ascii: """
        000000001ceaag3do04biadna0m6jc355741ghej7bgc2dboa2mca6246c4blnma
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 25, ascii: """
        0000000004e4i6362kk6ad7abh2b4j0log0gbjn96nl1d8j88mh9m36enbbmf381
        """)
        
        self.check(Self.mid, radix: 25, ascii: """
        000000000l1jmaj5c02f7dfccinol8o65m2kn6757eg61fe9nnbodjge6cf61b1k
        """)
        
        self.check(Self.top, radix: 25, ascii: """
        000000001cea1fa4l49o4dnedkkdcnmfc3509hg185baem9bdo6e5b1dediecike
        """)
    }
        
    func test26() {
        //=--------------------------------------=
        self.check(Self.min, radix: 26, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 26, ascii: """
        0000000004dd9kkp5ba44dp7ipn0clbhdkil2fad0l16pbbkapbbhal0jip8h1af
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 26, ascii: """
        0000000000e7a4822n1867n87cpm330nai4o7gj05b5j013bb0in29cncoodh584
        """)
        
        self.check(Self.mid, radix: 26, ascii: """
        0000000002dn99hfdj4jjl72icln3on6j80ea5bhp1d0binfi7iigba2ldfeic96
        """)
        
        self.check(Self.top, radix: 26, ascii: """
        0000000004dd8f12of8578gn3cho4kjg1nm4ck49ihk7nahjpeie4d78426fjja8
        """)
    }
        
    func test27() {
        //=--------------------------------------=
        self.check(Self.min, radix: 27, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 27, ascii: """
        0000000000fo848q7qmmh91pof20m8ckmg1n73li63g4kfmc706hgqn0mmci58kf
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 27, ascii: """
        00000000001p4pcg5j6ogq1hng5neo9oj2bk10d12on0go5nd0dcnnj04demflba
        """)
        
        self.check(Self.mid, radix: 27, ascii: """
        00000000008ojpqlp8g5c80ghhkbb9km2n6pg35jg2gci2lc3j3ijd1a7eh0am86
        """)
        
        self.check(Self.top, radix: 27, ascii: """
        0000000000fo7qe0hopd7gqfbj7q7m4jdh2445pb279oj8a0lakof2akafj55n52
        """)
    }
        
    func test28() {
        //=--------------------------------------=
        self.check(Self.min, radix: 28, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 28, ascii: """
        000000000028lpp2b71pnb05eppe6c96n44io2674a7no2o3lkn4i2njnrqllj0f
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 28, ascii: """
        000000000007odiqi7ipkbell34qeml609e642lhrao5n03422ik497coam17kmo
        """)
        
        self.check(Self.mid, radix: 28, ascii: """
        00000000001895b29gmqerfklnlo2pra313erbf7k8cqb8b32l135g9bjojr5heo
        """)
        
        self.check(Self.top, radix: 28, ascii: """
        000000000028lp360pqr9fgjmgalj15e5kknmk8pd61irgj23bbe6nbafahp3e6o
        """)
    }
        
    func test29() {
        //=--------------------------------------=
        self.check(Self.min, radix: 29, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 29, ascii: """
        00000000000acrloaj1mn6j7s7eh8796ss9gjf9gd34bpdf15dies8me9q9g7hsf
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 29, ascii: """
        0000000000017nr4pcg1heg13dh8cgggmn4q34frqm65gn8ec0j45591bmqfhffb
        """)
        
        self.check(Self.mid, radix: 29, ascii: """
        000000000005opmfnbkke4s44oi3lfk204gb439adikf6kqqslpn4c6p9j3jd10l
        """)
        
        self.check(Self.top, radix: 29, ascii: """
        00000000000acrhqlapaaob766is1eng6erp522m0f5opigage3d3j4k7f9n8ff2
        """)
    }
        
    func test30() {
        //=--------------------------------------=
        self.check(Self.min, radix: 30, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 30, ascii: """
        000000000001nmrt3i179ffbdsa0clsq63sttjbrm9pap9ms2pd6nft8iimg2sof
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 30, ascii: """
        0000000000006g1ldfsednredtimcop3b5l3q70e4kitjnhrn4eql74ecaf5j1mg
        """)
        
        self.check(Self.mid, radix: 30, ascii: """
        00000000000104ee3l1et12e66qnnlcm1mt8a5qjfgi3p0ooktk3a1a8gfrgl5e0
        """)
        
        self.check(Self.top, radix: 30, ascii: """
        000000000001nmr6nq4fe87dse4p4i0ama7co4moqch8081liop9spg2kl9rn95e
        """)
    }
        
    func test31() {
        //=--------------------------------------=
        self.check(Self.min, radix: 31, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 31, ascii: """
        000000000000a313gilnoeiiekt9559bqu7h8pbh49n65lt9ek54eo1c67n06b91
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 31, ascii: """
        000000000000171hhf8063e3r4a99sra00a157pihstia75dmk5kfae5nnn9ab6l
        """)
        
        self.check(Self.mid, radix: 31, ascii: """
        0000000000005kgnmq0ofjtltlh6glmhk03fp5aub63se9rdc5pd6r305mcmsem6
        """)
        
        self.check(Self.top, radix: 31, ascii: """
        000000000000a30ts5ohp5e917o3nehp8urue2rb4e97icid1me5tcmpil25fi6m
        """)
    }
        
    func test32() {
        //=--------------------------------------=
        self.check(Self.min, radix: 32, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 32, ascii: """
        0000000000001vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 32, ascii: """
        00000000000007ou3ke1m6gp30bhc58k2c91240f1o6go2oa1440e1g50g1g4080
        """)
        
        self.check(Self.mid, radix: 32, ascii: """
        00000000000013sehm68n2k9h23od1c4ge18303vfpunourqf5s7etjlehpn4sbg
        """)
        
        self.check(Self.top, radix: 32, ascii: """
        0000000000001vvuvnufnunpv3rvdtfkufpf3s7ftrmupqvat7kefpn5sjhu5of0
        """)
    }
        
    func test33() {
        //=--------------------------------------=
        self.check(Self.min, radix: 33, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 33, ascii: """
        0000000000000dodmt2cn3cv3qsjwoca6g1mdp9itk7khqn1g7lpf363qsfnpr2u
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 33, ascii: """
        00000000000001m3p6weqc5jk0wsb37sv08ileepww3jad5cr0cfhd0g1aq8in3s
        """)
        
        self.check(Self.mid, radix: 33, ascii: """
        00000000000007n8k87oh3ecmwwftg4og46nj2cu0v5895bgesatqspmp5acqdq3
        """)
        
        self.check(Self.top, radix: 33, ascii: """
        0000000000000dodf9g17rn5pvw3et1k184sgnb11u6u7uhk2n9b3bhtfwrh14fb
        """)
    }
        
    func test34() {
        //=--------------------------------------=
        self.check(Self.min, radix: 34, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 34, ascii: """
        00000000000003306ba0ke3vb4ndw3cx2uh2ep1rqsk453iarkg4991oohlf6mrh
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 34, ascii: """
        00000000000000cpwunuqgcm028uqxuqmjst7gk65egpsowcgixwuci6x899aa2k
        """)
        
        self.check(Self.mid, radix: 34, ascii: """
        00000000000001ou1n8x1f83gs1t1pve4d8c59xv12qmkf1bq51xeshcciinjla0
        """)
        
        self.check(Self.top, radix: 34, ascii: """
        00000000000003304fs1ae3ixjsrahw1k6lt33dlup2jc54b1p3xxaghpss3swhe
        """)
    }
        
    func test35() {
        //=--------------------------------------=
        self.check(Self.min, radix: 35, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 35, ascii: """
        00000000000000pcyyh26dx4rlcw17xq2fjnau1i9jl90hs95vfptvha2f7lv37f
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 35, ascii: """
        0000000000000032wujn2mg481jyhidxmv5271ucr21qfj9jdvqm429mwneu6b2v
        """)
        
        self.check(Self.mid, radix: 35, ascii: """
        00000000000000e7xo5l5b0ljve9b29f1knysf27c69fkalt1sel45ivbr7w3r6a
        """)
        
        self.check(Self.top, radix: 35, ascii: """
        00000000000000pcyhqj7yk3vq8j4l4vfa7wes91wah4p1y3op2k48s4pv0y189o
        """)
    }
        
    func test36() {
        //=--------------------------------------=
        self.check(Self.min, radix: 36, ascii: """
        0000000000000000000000000000000000000000000000000000000000000000
        """)
        
        self.check(Self.max, radix: 36, ascii: """
        000000000000006dp5qcb22im238nr3wvp0ic7q99w035jmy2iw7i6n43d37jtof
        """)
        //=--------------------------------------=
        self.check(Self.bot, radix: 36, ascii: """
        000000000000000rx55jlhq7obx1pvd9861yo6c11bed0cd8s8wz2hpvczt00c1s
        """)
        
        self.check(Self.mid, radix: 36, ascii: """
        000000000000003kt35jcsnseykryw4dxdsl4jw68mhnaehyh7r7qagypmhufjao
        """)
        
        self.check(Self.top, radix: 36, ascii: """
        000000000000006dp15j43ld5l8i7wvimlj7kxgbfxkxkgmo66lge382296ouqjk
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
