//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x Assert x Addition
//*============================================================================*

func NBKAssertAddition<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs: T, _ index: Int, _ partialValue: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  index.isZero {
        XCTAssertEqual(                 lhs +  rhs,                 partialValue, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs += rhs; return lhs }(), partialValue, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs.adding(rhs, at: index), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let _ = x.add(rhs, at: index); return x }(), partialValue, file: file, line: line)
}

func NBKAssertAdditionByDigit<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs: T.Digit, _ index: Int, _ partialValue: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  index.isZero {
        XCTAssertEqual(                 lhs +  rhs,                 partialValue, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs += rhs; return lhs }(), partialValue, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs.adding(rhs, at: index), partialValue, file: file, line: line)
    XCTAssertEqual({ var x = lhs; let _ = x.add(rhs, at: index); return x }(), partialValue, file: file, line: line)
}
