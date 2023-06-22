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
@testable import NBKDoubleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x Radix Alphabet
//*============================================================================*

final class RadixAlphabetTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let lowercase: [UInt8] = Array("0123456789abcdefghijklmnopqrstuvwxyz".utf8)
    let uppercase: [UInt8] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".utf8)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decode
    //=------------------------------------------------------------------------=
    
    func testAnyRadixAlphabetDecoder() {
        for radix in 2 ... 36 {
            let alphabet = AnyRadixAlphabetDecoder(radix: radix)
            
            XCTAssertNil(alphabet.decode(UInt8(ascii: "0") - 1))
            XCTAssertNil(alphabet.decode(UInt8(ascii: "A") - 1))
            XCTAssertNil(alphabet.decode(UInt8(ascii: "a") - 1))
            
            XCTAssertNil(alphabet.decode(UInt8(ascii: "9") + 1))
            XCTAssertNil(alphabet.decode(UInt8(ascii: "Z") + 1))
            XCTAssertNil(alphabet.decode(UInt8(ascii: "z") + 1))
            
            for value in 0 ..< 36 {
                let expectation = value < radix ? UInt8(value) : nil
                XCTAssertEqual(alphabet.decode(self.lowercase[value]), expectation)
                XCTAssertEqual(alphabet.decode(self.uppercase[value]), expectation)
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Encode
    //=------------------------------------------------------------------------=
    
    func testLowercaseMaxRadixAlphabetEncoder() {
        let alphabet = MaxRadixAlphabetEncoder(uppercase: false)
        XCTAssertEqual(self.lowercase, (0 ..< 36).map(alphabet.encode(_:)))
    }
    
    func testUppercaseMaxRadixAlphabetEncoder() {
        let alphabet = MaxRadixAlphabetEncoder(uppercase: true)
        XCTAssertEqual(self.uppercase, (0 ..< 36).map(alphabet.encode(_:)))
    }
}

#endif
