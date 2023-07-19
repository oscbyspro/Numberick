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
// MARK: * NBK x Assert x Shifts
//*============================================================================*

func NBKAssertShiftLeft<T: NBKFixedWidthInteger>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(                 lhs <<   rhs,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs >>  -rhs,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs <<=  rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs >>= -rhs; return lhs }(), result, file: file, line: line)
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(                 lhs &<<  rhs,                 result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs &<<= rhs; return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(lhs.bitshiftedLeft(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(by: rhs); return lhs }(), result, file: file, line: line)
    }
}

func NBKAssertShiftRight<T: NBKFixedWidthInteger>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(                 lhs >>   rhs,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs <<  -rhs,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs >>=  rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs <<= -rhs; return lhs }(), result, file: file, line: line)
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(                 lhs &>>  rhs,                 result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs &>>= rhs; return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(lhs.bitshiftedRight(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(by: rhs); return lhs }(), result, file: file, line: line)
    }
}

//*============================================================================*
// MARK: * NBK x Assert x Shifts x Masked
//*============================================================================*

func NBKAssertShiftLeftByMasking<T: NBKFixedWidthInteger>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line){
    //=------------------------------------------=
    XCTAssertEqual(lhs &<< (rhs),                result, file: file, line: line)
    XCTAssertEqual(lhs &<< (rhs + lhs.bitWidth), result, file: file, line: line)
    XCTAssertEqual(lhs &<< (rhs - lhs.bitWidth), result, file: file, line: line)
}

func NBKAssertShiftRightByMasking<T: NBKFixedWidthInteger>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line){
    //=------------------------------------------=
    XCTAssertEqual(lhs &>> (rhs),                result, file: file, line: line)
    XCTAssertEqual(lhs &>> (rhs + lhs.bitWidth), result, file: file, line: line)
    XCTAssertEqual(lhs &>> (rhs - lhs.bitWidth), result, file: file, line: line)
}
