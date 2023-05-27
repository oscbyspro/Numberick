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
// MARK: * NBK x Text x UInt
//*============================================================================*

final class TextTestsOnUInt: XCTestCase {
    
    typealias T = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDecodingStringWithoutDigitsReturnsNil() {
        NBKAssertDecodeDigitsAsUInt(T?.none, 10,  "")
        NBKAssertDecodeDigitsAsUInt(T?.none, 10, "+")
        NBKAssertDecodeDigitsAsUInt(T?.none, 10, "-")
        NBKAssertDecodeDigitsAsUInt(T?.none, 10, "~")
        
        NBKAssertDecodeDigitsAsUInt(T?.none, 16,  "")
        NBKAssertDecodeDigitsAsUInt(T?.none, 16, "+")
        NBKAssertDecodeDigitsAsUInt(T?.none, 16, "-")
        NBKAssertDecodeDigitsAsUInt(T?.none, 16, "~")
    }
    
    func testDecodingDigitsOutsideOfRepresentableRangeReturnsNil() {
        let digits = String(repeating: "1", count: T.bitWidth + 1)
        
        for radix in 2 ... 36 {
            NBKAssertDecodeDigitsAsUInt(T?.none, radix, digits)
        }
        
        NBKAssertDecodeDigitsAsUInt(T?.none, 10, "18446744073709551616" ) // + 01
        NBKAssertDecodeDigitsAsUInt(T?.none, 10, "184467440737095516150") // * 10
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Utilities
    //=------------------------------------------------------------------------=

    func NBKAssertDecodeDigitsAsUInt(_ integer: T?, _ radix: Int, _ digits: String, file: StaticString = #file, line: UInt = #line) {
        var digits = digits; digits.withUTF8 {
            XCTAssertEqual(UInt(digits: $0, radix: radix), integer, file: file, line: line)
        }
    }
}

#endif
