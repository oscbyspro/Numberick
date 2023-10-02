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
import XCTest

//*============================================================================*
// MARK: * NBK x Integer Description x Encoding x Digit
//*============================================================================*

final class NBKIntegerDescriptionTestsOnEncoding: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testEncodingEmptyCollectionsReturnsZero() {
        let empty =  [UInt]()
        for radix in 2 ... 36 {
            NBKAssertSignMagnitude(.plus,  empty, radix, false, "0")
            NBKAssertSignMagnitude(.plus,  empty, radix, true,  "0")
            NBKAssertSignMagnitude(.minus, empty, radix, false, "0")
            NBKAssertSignMagnitude(.minus, empty, radix, true,  "0")
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
    XCTAssertEqual(encoder.encode(sign: sign, magnitude: magnitude), result, file: file, line: line)
}

#endif
