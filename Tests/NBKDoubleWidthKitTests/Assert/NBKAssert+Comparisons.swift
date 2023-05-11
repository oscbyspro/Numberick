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
// MARK: * NBK x Assert x Comparisons
//*============================================================================*

func NBKAssertComparisons<T: NBKFixedWidthInteger>(
_ lhs: T, _ rhs: T, _ result: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(lhs == rhs, result ==  0, file: file, line: line)
    XCTAssertEqual(lhs != rhs, result !=  0, file: file, line: line)
    
    XCTAssertEqual(lhs <  rhs, result == -1, file: file, line: line)
    XCTAssertEqual(lhs <= rhs, result !=  1, file: file, line: line)

    XCTAssertEqual(lhs >  rhs, result ==  1, file: file, line: line)
    XCTAssertEqual(lhs >= rhs, result != -1, file: file, line: line)
    
    XCTAssertEqual(lhs.compared(to: rhs), result, file: file, line: line)
}
