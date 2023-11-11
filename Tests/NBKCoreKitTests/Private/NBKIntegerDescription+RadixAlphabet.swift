//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Integer Description x Radix Alphabet
//*============================================================================*

final class NBKIntegerDescriptionTestsOnRadixAlphabet: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let lowercase: [UInt8] = Array("0123456789abcdefghijklmnopqrstuvwxyz".utf8)
    let uppercase: [UInt8] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".utf8)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Decoding
    //=------------------------------------------------------------------------=
    
    func testAnyRadixAlphabetDecoder() {
        for radix in 2 ... 36 {
            let alphabet = NBK.IntegerDescription.AnyRadixAlphabetDecoder(radix: radix)
            
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
    // MARK: Tests x Encoding
    //=------------------------------------------------------------------------=
    
    func testMaxRadixAlphabetEncoder() {
        let lowercase = NBK.IntegerDescription.MaxRadixAlphabetEncoder(uppercase: false)
        let uppercase = NBK.IntegerDescription.MaxRadixAlphabetEncoder(uppercase: true )
        
        for value in 0 ..< UInt8(44) {
            XCTAssertEqual(lowercase.encode(value), value < 36 ? self.lowercase[Int(value)] : nil)
            XCTAssertEqual(uppercase.encode(value), value < 36 ? self.uppercase[Int(value)] : nil)
        }
    }
}
