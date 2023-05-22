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
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(Int(T(decoding:  "7b", radix: 16)!),  123)
            XCTAssertEqual(Int(T(decoding: "+7b", radix: 16)!),  123)
            guard type.isSigned else { return }
            XCTAssertEqual(Int(T(decoding: "-7b", radix: 16)!), -123)
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingRadix10() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(Int(T(decoding:  "123", radix: 10)!),  123)
            XCTAssertEqual(Int(T(decoding: "+123", radix: 10)!),  123)
            guard type.isSigned else { return }
            XCTAssertEqual(Int(T(decoding: "-123", radix: 10)!), -123)
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingRadixLiteralAsNumber() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(Int(T(decoding:  "0x", radix: 36)!),  33)
            XCTAssertEqual(Int(T(decoding:  "0o", radix: 36)!),  24)
            XCTAssertEqual(Int(T(decoding:  "0b", radix: 36)!),  11)
            guard type.isSigned else { return }
            XCTAssertEqual(Int(T(decoding: "-0x", radix: 36)!), -33)
            XCTAssertEqual(Int(T(decoding: "-0o", radix: 36)!), -24)
            XCTAssertEqual(Int(T(decoding: "-0b", radix: 36)!), -11)
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingStringsWithOrWithoutSign() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(Int(T(decoding:  "10", radix: 10)!),  10)
            XCTAssertEqual(Int(T(decoding: "+10", radix: 10)!),  10)
            guard type.isSigned else { return }
            XCTAssertEqual(Int(T(decoding: "-10", radix: 10)!), -10)
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingPrefixingZerosHasNoEffect() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(Int(T(decoding: String(repeating: "0", count: 99) + "0", radix: 10)!), 0)
            XCTAssertEqual(Int(T(decoding: String(repeating: "0", count: 99) + "1", radix: 10)!), 1)
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingValueOutsideOfRepresentableRangeReturnsNil() {
        let positive = "+" + String(repeating: "1", count: 65)
        let negative = "-" + String(repeating: "1", count: 65)
        
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            for radix in 2 ... 36 {
                XCTAssertNil(T(decoding: positive, radix: radix))
                XCTAssertNil(T(decoding: negative, radix: radix))
            }
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encode
    //=------------------------------------------------------------------------=
    
    func testEncodingRadix16() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            let max = T(123), min = T(exactly: -123)
            XCTAssertEqual(String(encoding: max, radix: 16, uppercase: false),   "7b")
            XCTAssertEqual(String(encoding: max, radix: 16, uppercase: true ),   "7B")
            guard let min else { return }
            XCTAssertEqual(String(encoding: min, radix: 16, uppercase: false),  "-7b")
            XCTAssertEqual(String(encoding: min, radix: 16, uppercase: true ),  "-7B")
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testEncodingRadix10() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            let max = T(123), min = T(exactly: -123)
            XCTAssertEqual(String(encoding: max, radix: 10, uppercase: false),  "123")
            XCTAssertEqual(String(encoding: max, radix: 10, uppercase: true ),  "123")
            guard let min else { return }
            XCTAssertEqual(String(encoding: min, radix: 10, uppercase: false), "-123")
            XCTAssertEqual(String(encoding: min, radix: 10, uppercase: true ), "-123")
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
}

#endif
