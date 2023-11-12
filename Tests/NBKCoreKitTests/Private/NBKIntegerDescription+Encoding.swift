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
// MARK: * NBK x Integer Description x Encoding x Digit
//*============================================================================*

final class NBKIntegerDescriptionTestsOnEncoding: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEncodingEmptyCollectionsReturnsZero() {
        let words = [] as [UInt]
        for radix in 2 ... 36 {
            NBKAssertSignMagnitude(.plus,  words, radix, false,  "0")
            NBKAssertSignMagnitude(.plus,  words, radix, true,   "0")
            NBKAssertSignMagnitude(.minus, words, radix, false,  "0")
            NBKAssertSignMagnitude(.minus, words, radix, true,   "0")
        }
    }
    
    func testSignExtendingDoesNotChangeTheResult() {
        let words = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0] as [UInt]
        for radix in 2 ... 36 {
            NBKAssertSignMagnitude(.plus,  words, radix, false,  "1")
            NBKAssertSignMagnitude(.plus,  words, radix, true,   "1")
            NBKAssertSignMagnitude(.minus, words, radix, false, "-1")
            NBKAssertSignMagnitude(.minus, words, radix, true,  "-1")
        }
    }
}

//*============================================================================*
// MARK: * NBK x Integer Description x Encoding x Assertions
//*============================================================================*

private func NBKAssertSignMagnitude(
_ sign: FloatingPointSign, _ magnitude: [UInt], _ radix: Int, _ uppercase: Bool, _ result: String,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let encoder = NBK.IntegerDescription.Encoder(radix: radix, uppercase: uppercase)
    //=------------------------------------------=
    brr: do {
        XCTAssertEqual(encoder.encode((sign: sign, magnitude: magnitude)), result, file: file, line: line)
    }
    
    if  magnitude.count <= 1 {
        XCTAssertEqual(encoder.encode((sign: sign, magnitude: magnitude.first ?? 0)), result, file: file, line: line)
    }
}
