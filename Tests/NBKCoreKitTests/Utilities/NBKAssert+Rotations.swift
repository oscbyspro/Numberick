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
// MARK: * NBK x Assert x Rotations
//*============================================================================*

func NBKAssertRotateLeft<T: NBKCoreInteger>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssert(0 ..< lhs.bitWidth ~= rhs, "no smart rotations", file: file, line: line)
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(lhs.bitrotatedLeft(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitrotateLeft(by: rhs); return lhs }(), result, file: file, line: line)
    }
}

func NBKAssertRotateRight<T: NBKCoreInteger>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssert(0 ..< lhs.bitWidth ~= rhs, "no smart rotations", file: file, line: line)
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(lhs.bitrotatedRight(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitrotateRight(by: rhs); return lhs }(), result, file: file, line: line)
    }
}
