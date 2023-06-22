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
    // MARK: Tests x Encode
    //=------------------------------------------------------------------------=
    
    func testLowercaseMaxRadixAlphabetEncoder() {
        let alphabet = MaxRadixAlphabetEncoder(uppercase: false)
        let list = (0 ..< 36).map(alphabet.encode(_:))
        let expectation = Array("0123456789abcdefghijklmnopqrstuvwxyz".utf8)
        XCTAssertEqual(list, expectation)
    }
    
    func testUppercaseMaxRadixAlphabetEncoder() {
        let alphabet = MaxRadixAlphabetEncoder(uppercase: true)
        let list = (0 ..< 36).map(alphabet.encode(_:))
        let expectation = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ".utf8)
        XCTAssertEqual(list, expectation)
    }
}

#endif
