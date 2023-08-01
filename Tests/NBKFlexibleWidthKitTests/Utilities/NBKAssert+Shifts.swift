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
// MARK: * NBK x Assert x Shifts
//*============================================================================*

func NBKAssertShiftLeft<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let (words, bits) = rhs.quotientAndRemainder(dividingBy: UInt.bitWidth)
    //=------------------------------------------=
    XCTAssertEqual(                 lhs <<   rhs,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs >>  -rhs,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs <<=  rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs >>= -rhs; return lhs }(), result, file: file, line: line)
        
    XCTAssertEqual(lhs.bitshiftedLeftSmart(by:   rhs), result, file: file, line: line)
    XCTAssertEqual(lhs.bitshiftedRightSmart(by: -rhs), result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftSmart(by:   rhs); return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightSmart(by: -rhs); return lhs }(), result, file: file, line: line)
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(lhs.bitshiftedLeft(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(by: rhs); return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedLeft(words: words, bits: bits), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(words: words, bits: bits); return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs, bits.isZero {
        XCTAssertEqual(lhs.bitshiftedLeft(words: words), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(words: words); return lhs }(), result, file: file, line: line)
    }
}

func NBKAssertShiftRight<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let (words, bits) = rhs.quotientAndRemainder(dividingBy: UInt.bitWidth)
    //=------------------------------------------=
    XCTAssertEqual(                 lhs >>   rhs,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs <<  -rhs,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs >>=  rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs <<= -rhs; return lhs }(), result, file: file, line: line)
        
    XCTAssertEqual(lhs.bitshiftedRightSmart(by: rhs), result, file: file, line: line)
    XCTAssertEqual(lhs.bitshiftedLeftSmart(by: -rhs), result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightSmart(by: rhs); return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftSmart(by: -rhs); return lhs }(), result, file: file, line: line)
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(lhs.bitshiftedRight(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(by: rhs); return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedRight(words: words, bits: bits), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(words: words, bits: bits); return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs, bits.isZero {
        XCTAssertEqual(lhs.bitshiftedRight(words: words), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(words: words); return lhs }(), result, file: file, line: line)
    }
}
