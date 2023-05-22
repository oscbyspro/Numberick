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
// MARK: * NBK x Assert x Shifts x L
//*============================================================================*

func NBKAssertShiftLeft<T: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<T>, _ rhs:  Int, _ result: NBKDoubleWidth<T>,
file: StaticString = #file, line: UInt = #line) {
    //=--------------------------------------=
    let (words, bits) = rhs.quotientAndRemainder(dividingBy: UInt.bitWidth)
    //=--------------------------------------=
    XCTAssertEqual(                 lhs <<   rhs,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs >>  -rhs,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs <<=  rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs >>= -rhs; return lhs }(), result, file: file, line: line)
        
    XCTAssertEqual(lhs.bitshiftedLeftSmart(by:   rhs), result, file: file, line: line)
    XCTAssertEqual(lhs.bitshiftedRightSmart(by: -rhs), result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftSmart(by:   rhs); return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightSmart(by: -rhs); return lhs }(), result, file: file, line: line)
    //=--------------------------------------=
    if (0 ..< lhs.bitWidth) ~= rhs {
        XCTAssertEqual(                 lhs &<<  rhs,                 result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs &<<= rhs; return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedLeftUnchecked(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftUnchecked(by: rhs); return lhs }(), result, file: file, line: line)
    }
    //=--------------------------------------=
    if (0 ..< lhs.bitWidth) ~= rhs {
        XCTAssertEqual(lhs.bitshiftedLeftUnchecked(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftUnchecked(by: rhs); return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedLeftUnchecked(words: words, bits: bits), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftUnchecked(words: words, bits: bits); return lhs }(), result, file: file, line: line)
    }
}

//*============================================================================*
// MARK: * NBK x Assert x Shifts x R
//*============================================================================*

func NBKAssertShiftRight<T: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<T>, _ rhs:  Int, _ result: NBKDoubleWidth<T>,
file: StaticString = #file, line: UInt = #line) {
    //=--------------------------------------=
    let (words, bits) = rhs.quotientAndRemainder(dividingBy: UInt.bitWidth)
    //=--------------------------------------=
    XCTAssertEqual(                 lhs >>   rhs,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs <<  -rhs,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs >>=  rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs <<= -rhs; return lhs }(), result, file: file, line: line)
        
    XCTAssertEqual(lhs.bitshiftedRightSmart(by: rhs), result, file: file, line: line)
    XCTAssertEqual(lhs.bitshiftedLeftSmart(by: -rhs), result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightSmart(by: rhs); return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftSmart(by: -rhs); return lhs }(), result, file: file, line: line)
    //=--------------------------------------=
    if (0 ..< lhs.bitWidth) ~= rhs {
        XCTAssertEqual(                 lhs &>>  rhs,                 result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs &>>= rhs; return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedRightUnchecked(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightUnchecked(by: rhs); return lhs }(), result, file: file, line: line)
    }
    //=--------------------------------------=
    if (0 ..< lhs.bitWidth) ~= rhs {
        XCTAssertEqual(lhs.bitshiftedRightUnchecked(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightUnchecked(by: rhs); return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedRightUnchecked(words: words, bits: bits), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightUnchecked(words: words, bits: bits); return lhs }(), result, file: file, line: line)
    }
}
