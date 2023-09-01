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
// MARK: * NBK x Offset Index
//*============================================================================*

final class NBKOffsetIndexedTests: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIndexOffsetByLimitedBy() {
        NBKAssertIndexOffsetByLimitedBy(1,  2,  2,  nil)
        NBKAssertIndexOffsetByLimitedBy(1,  1,  2,  2)
        NBKAssertIndexOffsetByLimitedBy(1,  0,  2,  1)
        NBKAssertIndexOffsetByLimitedBy(1, -1,  2,  0)
        NBKAssertIndexOffsetByLimitedBy(1, -2,  2, -1)
        
        NBKAssertIndexOffsetByLimitedBy(2,  2,  2,  nil)
        NBKAssertIndexOffsetByLimitedBy(2,  1,  2,  nil)
        NBKAssertIndexOffsetByLimitedBy(2,  0,  2,  2)
        NBKAssertIndexOffsetByLimitedBy(2, -1,  2,  nil)
        NBKAssertIndexOffsetByLimitedBy(2, -2,  2,  nil)
        
        NBKAssertIndexOffsetByLimitedBy(3,  2,  2,  5)
        NBKAssertIndexOffsetByLimitedBy(3,  1,  2,  4)
        NBKAssertIndexOffsetByLimitedBy(3,  0,  2,  3)
        NBKAssertIndexOffsetByLimitedBy(3, -1,  2,  2)
        NBKAssertIndexOffsetByLimitedBy(3, -2,  2,  nil)
    }
}

//*============================================================================*
// MARK: * NBK x Offset Indexed x Assertions
//*============================================================================*

private func NBKAssertIndexOffsetByLimitedBy(
_ index: Int, _ distance: Int, _ limit: Int, _ expectation: Int?,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(NBK   .offset(index, by:       distance, limit:     limit), expectation, file: file, line: line)
    XCTAssertEqual([Int]().index(index, offsetBy: distance, limitedBy: limit), expectation, file: file, line: line)
}

#endif
