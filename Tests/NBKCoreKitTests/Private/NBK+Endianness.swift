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
// MARK: * NBK x Endianness
//*============================================================================*

final class NBKTestsOnEndianness: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsLittleOrBigEndian() {
        #if _endian(big)
        XCTAssertTrue (NBK.isBigEndian)
        XCTAssertFalse(NBK.isLittleEndian)
        #elseif _endian(little)
        XCTAssertFalse(NBK.isBigEndian)
        XCTAssertTrue (NBK.isLittleEndian)
        #endif
    }
}
