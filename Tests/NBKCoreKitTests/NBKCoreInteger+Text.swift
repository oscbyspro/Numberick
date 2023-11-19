//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

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
    
    func testDecodingRadix10() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDecodingText(T( 123), 10,  "123")
            NBKAssertDecodingText(T( 123), 10, "+123")
            
            guard type.isSigned else { return }
            
            NBKAssertDecodingText(T(-123), 10, "-123")
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingRadix16() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDecodingText(T( 123), 16,  "7b")
            NBKAssertDecodingText(T( 123), 16, "+7b")
            
            guard type.isSigned else { return }
            
            NBKAssertDecodingText(T(-123), 16, "-7b")
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingZero() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            for radix in 02 ... 36 {
                NBKAssertDecodingText(T( 0), radix,  "0")
                NBKAssertDecodingText(T( 0), radix, "+0")
                NBKAssertDecodingText(T( 0), radix, "-0")
            }
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingOne() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            for radix in 02 ... 36 {
                NBKAssertDecodingText(T(exactly:  1), radix,  "1")
                NBKAssertDecodingText(T(exactly:  1), radix, "+1")
                NBKAssertDecodingText(T(exactly: -1), radix, "-1")
            }
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingRadixLiteralAsNumber() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDecodingText(T( 33), 36,  "0x")
            NBKAssertDecodingText(T( 24), 36,  "0o")
            NBKAssertDecodingText(T( 11), 36,  "0b")
            
            NBKAssertDecodingText(T( 33), 36, "+0x")
            NBKAssertDecodingText(T( 24), 36, "+0o")
            NBKAssertDecodingText(T( 11), 36, "+0b")
            
            guard type.isSigned else { return }
            
            NBKAssertDecodingText(T(-33), 36, "-0x")
            NBKAssertDecodingText(T(-24), 36, "-0o")
            NBKAssertDecodingText(T(-11), 36, "-0b")
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingRadixLiteralAsRadixReturnsNil() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDecodingText(T?.none, 10,  "0x10")
            NBKAssertDecodingText(T?.none, 10,  "0o10")
            NBKAssertDecodingText(T?.none, 10,  "0b10")
            
            NBKAssertDecodingText(T?.none, 10, "+0x10")
            NBKAssertDecodingText(T?.none, 10, "+0o10")
            NBKAssertDecodingText(T?.none, 10, "+0b10")
            
            guard type.isSigned else { return }
            
            NBKAssertDecodingText(T?.none, 10, "-0x10")
            NBKAssertDecodingText(T?.none, 10, "-0o10")
            NBKAssertDecodingText(T?.none, 10, "-0b10")
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingStringsWithAndWithoutSign() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDecodingText(T( 123), 10,  "123")
            NBKAssertDecodingText(T( 123), 10, "+123")
            
            guard type.isSigned else { return }
            
            NBKAssertDecodingText(T(-123), 10, "-123")
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingPrefixingZerosHasNoEffect() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDecodingText(T(0), 10, String(repeating: "0", count: 99) + "0")
            NBKAssertDecodingText(T(1), 10, String(repeating: "0", count: 99) + "1")
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testDecodingStringsWithoutDigitsReturnsNil() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertDecodingText(T?.none, 10,  "")
            NBKAssertDecodingText(T?.none, 10, "+")
            NBKAssertDecodingText(T?.none, 10, "-")
            NBKAssertDecodingText(T?.none, 10, "~")
            
            NBKAssertDecodingText(T?.none, 16,  "")
            NBKAssertDecodingText(T?.none, 16, "+")
            NBKAssertDecodingText(T?.none, 16, "-")
            NBKAssertDecodingText(T?.none, 16, "~")
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
                NBKAssertDecodingText(T?.none, radix, positive)
                NBKAssertDecodingText(T?.none, radix, negative)
            }
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encode
    //=------------------------------------------------------------------------=
    
    func testEncodingRadix10() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            let max = T(123)
            let min = T(exactly: -123)
            
            NBKAssertEncodingText(max, 10, false,  "123")
            NBKAssertEncodingText(max, 10, true ,  "123")
            
            guard let min else { return }
            
            NBKAssertEncodingText(min, 10, false, "-123")
            NBKAssertEncodingText(min, 10, true , "-123")
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testEncodingRadix16() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            let max = T(123)
            let min = T(exactly: -123)
            
            NBKAssertEncodingText(max, 16, false,  "7b")
            NBKAssertEncodingText(max, 16, true ,  "7B")
            
            guard let min else { return }
            
            NBKAssertEncodingText(min, 16, false, "-7b")
            NBKAssertEncodingText(min, 16, true , "-7B")
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Core Integer x Text x Assertions
//*============================================================================*

private func NBKAssertDecodingText<T: NBKCoreInteger>(
_ integer: T?, _ radix: Int, _ text: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  radix == 10 {
        XCTAssertEqual(T.init(text), integer, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(T.init(text, radix: radix), integer, file: file, line: line)
}

private func NBKAssertEncodingText<T: NBKCoreInteger>(
_ integer: T, _ radix: Int, _ uppercase: Bool, _ text: String,
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
