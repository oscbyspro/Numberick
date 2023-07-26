//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x Assert x Comparisons
//*============================================================================*

func NBKAssertComparisons<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(lhs == rhs, signum ==  0, file: file, line: line)
    XCTAssertEqual(lhs != rhs, signum !=  0, file: file, line: line)
    
    XCTAssertEqual(lhs <  rhs, signum == -1, file: file, line: line)
    XCTAssertEqual(lhs <= rhs, signum !=  1, file: file, line: line)

    XCTAssertEqual(lhs >  rhs, signum ==  1, file: file, line: line)
    XCTAssertEqual(lhs >= rhs, signum != -1, file: file, line: line)
    
    XCTAssertEqual(lhs.compared(to: rhs), signum, file: file, line: line)
}
