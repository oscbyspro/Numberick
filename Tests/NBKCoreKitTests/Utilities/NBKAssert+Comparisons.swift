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

func NBKAssertSignum<T: NBKFixedWidthInteger>(
_ operand: T, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(Int(operand.signum() as Int), signum, file: file, line: line)
    XCTAssertEqual(Int(operand.signum() as T  ), signum, file: file, line: line) // stdlib
}

func NBKAssertComparisons<T: NBKFixedWidthInteger>(
_ lhs: T, _ rhs: T, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(lhs == rhs, signum ==  0, file: file, line: line)
    XCTAssertEqual(lhs != rhs, signum !=  0, file: file, line: line)
    
    XCTAssertEqual(lhs <  rhs, signum == -1, file: file, line: line)
    XCTAssertEqual(lhs <= rhs, signum !=  1, file: file, line: line)
    
    XCTAssertEqual(lhs >  rhs, signum ==  1, file: file, line: line)
    XCTAssertEqual(lhs >= rhs, signum != -1, file: file, line: line)
    
    XCTAssertEqual(lhs.compared(to: rhs), signum, file: file, line: line)
}
