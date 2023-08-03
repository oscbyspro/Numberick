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
// MARK: * NBK x Bits
//*============================================================================*

final class BitsTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNonzeroBitCountEquals() {
        NBKAssertNonzeroBitCount([00, 00, 00, 00], 00)
        NBKAssertNonzeroBitCount([01, 00, 00, 00], 01)
        NBKAssertNonzeroBitCount([01, 03, 00, 00], 03)
        NBKAssertNonzeroBitCount([01, 03, 07, 00], 06)
        NBKAssertNonzeroBitCount([01, 03, 07, 15], 10)
        NBKAssertNonzeroBitCount([00, 03, 07, 15], 09)
        NBKAssertNonzeroBitCount([00, 00, 07, 15], 07)
        NBKAssertNonzeroBitCount([00, 00, 00, 15], 04)
        NBKAssertNonzeroBitCount([00, 00, 15, 07], 07)
        NBKAssertNonzeroBitCount([15, 07, 03, 01], 10)
        
        NBKAssertNonzeroBitCount([01, 00, 00, 00], 01)
        NBKAssertNonzeroBitCount([00, 02, 00, 00], 01)
        NBKAssertNonzeroBitCount([00, 00, 04, 00], 01)
        NBKAssertNonzeroBitCount([00, 00, 00, 08], 01)
        
        NBKAssertNonzeroBitCount([01, 00, 00, 00], 01)
        NBKAssertNonzeroBitCount([00, 01, 00, 00], 01)
        NBKAssertNonzeroBitCount([00, 00, 01, 00], 01)
        NBKAssertNonzeroBitCount([00, 00, 00, 01], 01)
        
        NBKAssertNonzeroBitCount([01, 00, 00, 00], 00, false)
        NBKAssertNonzeroBitCount([00, 01, 00, 00], 00, false)
        NBKAssertNonzeroBitCount([00, 00, 01, 00], 00, false)
        NBKAssertNonzeroBitCount([00, 00, 00, 01], 00, false)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

private func NBKAssertNonzeroBitCount(_ limbs: [UInt], _ comparand: Int, _ success: Bool = true) {
    //=------------------------------------------=
    if  success {
        XCTAssertEqual(NBK.nonzeroBitCount(of: limbs), comparand)
        XCTAssertFalse(NBK.nonzeroBitCount(of: limbs,  equals: comparand + 1))
        XCTAssertFalse(NBK.nonzeroBitCount(of: limbs,  equals: comparand - 1))
    }
    //=------------------------------------------=
    XCTAssertEqual(NBK.nonzeroBitCount(of: limbs,  equals: comparand), success)
}

#endif
