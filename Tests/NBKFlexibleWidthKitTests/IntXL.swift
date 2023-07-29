//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKFlexibleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x IntXL
//*============================================================================*

final class IntXLTests: XCTestCase {
    
    typealias T =  IntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSign() {
        XCTAssertEqual(T(sign: .plus,  magnitude: 0).sign, .plus )
        XCTAssertEqual(T(sign: .minus, magnitude: 0).sign, .minus)
        XCTAssertEqual(T(sign: .plus,  magnitude: 1).sign, .plus )
        XCTAssertEqual(T(sign: .minus, magnitude: 1).sign, .minus)
    }
}

#endif
