//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Core Integer x Text
//*============================================================================*

final class NBKCoreIntegerTestsOnText: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decode
    //=------------------------------------------------------------------------=
    
    func testDecodingRadix16() {
        for type: T in types {
            XCTAssertEqual(Int(type.init(decoding:  "7b", radix: 16)!),  123)
            XCTAssertEqual(Int(type.init(decoding: "+7b", radix: 16)!),  123)
            guard type.isSigned else { continue }
            XCTAssertEqual(Int(type.init(decoding: "-7b", radix: 16)!), -123)
        }
    }
    
    func testDecodingRadix10() {
        for type: T in types {
            XCTAssertEqual(Int(type.init(decoding:  "123", radix: 10)!),  123)
            XCTAssertEqual(Int(type.init(decoding: "+123", radix: 10)!),  123)
            guard type.isSigned else { continue }
            XCTAssertEqual(Int(type.init(decoding: "-123", radix: 10)!), -123)
        }
    }
    
    func testDecodingRadixLiteralAsNumber() {
        for type: T in types {
            XCTAssertEqual(Int(type.init(decoding:  "0x", radix: 36)!),  33)
            XCTAssertEqual(Int(type.init(decoding:  "0o", radix: 36)!),  24)
            XCTAssertEqual(Int(type.init(decoding:  "0b", radix: 36)!),  11)
            guard type.isSigned else { continue }
            XCTAssertEqual(Int(type.init(decoding: "-0x", radix: 36)!), -33)
            XCTAssertEqual(Int(type.init(decoding: "-0o", radix: 36)!), -24)
            XCTAssertEqual(Int(type.init(decoding: "-0b", radix: 36)!), -11)
        }
    }
    
    func testDecodingStringsWithOrWithoutSign() {
        for type: T in types {
            XCTAssertEqual(Int(type.init(decoding:  "10", radix: 10)!),  10)
            XCTAssertEqual(Int(type.init(decoding: "+10", radix: 10)!),  10)
            guard type.isSigned else { continue }
            XCTAssertEqual(Int(type.init(decoding: "-10", radix: 10)!), -10)
        }
    }
    
    func testDecodingPrefixingZerosHasNoEffect() {
        for type: T in types {
            XCTAssertEqual(Int(type.init(decoding: String(repeating: "0", count: 99) + "0", radix: 10)!), 0)
            XCTAssertEqual(Int(type.init(decoding: String(repeating: "0", count: 99) + "1", radix: 10)!), 1)
        }
    }
    
    func testDecodingValueOutsideOfRepresentableRangeReturnsNil() {
        let positive = "+" + String(repeating: "1", count: 65)
        let negative = "-" + String(repeating: "1", count: 65)
        for type: T in types {
            for radix in 2 ... 36 {
                XCTAssertNil(type.init(decoding: positive, radix: radix))
                XCTAssertNil(type.init(decoding: negative, radix: radix))
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encode
    //=------------------------------------------------------------------------=
    
    func testEncodingRadix16() {
        for type: T in types {
            let max = type.init(123), min = type.init(exactly: -123)
            XCTAssertEqual(String(encoding: max, radix: 16, uppercase: false),   "7b")
            XCTAssertEqual(String(encoding: max, radix: 16, uppercase: true ),   "7B")
            guard let min else { continue }
            XCTAssertEqual(String(encoding: min, radix: 16, uppercase: false),  "-7b")
            XCTAssertEqual(String(encoding: min, radix: 16, uppercase: true ),  "-7B")
        }
    }
    
    func testEncodingRadix10() {
        for type: T in types {
            let max = type.init(123), min = type.init(exactly: -123)
            XCTAssertEqual(String(encoding: max, radix: 10, uppercase: false),  "123")
            XCTAssertEqual(String(encoding: max, radix: 10, uppercase: true ),  "123")
            guard let min else { continue }
            XCTAssertEqual(String(encoding: min, radix: 10, uppercase: false), "-123")
            XCTAssertEqual(String(encoding: min, radix: 10, uppercase: true ), "-123")
        }
    }
}

#endif
