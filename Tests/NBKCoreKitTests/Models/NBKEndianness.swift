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
// MARK: * NBK x Endianness
//*============================================================================*

final class NBKEndiannessTests: XCTestCase {
    
    typealias T = NBKEndianness
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSystem() {
        #if _endian(big)
        XCTAssertEqual(T.system, T.big)
        #elseif _endian(little)
        XCTAssertEqual(T.system, T.little)
        #endif
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testOpposite() {
        XCTAssertEqual(!T.big, T.little)
        XCTAssertEqual(!T.little, T.big)
    }
}

#endif
