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
_ lhs: NBKDoubleWidth<T>, _ shift: Int, _ result: NBKDoubleWidth<T>,
file: StaticString = #file, line: UInt = #line) {
    //=--------------------------------------=
    let (words, bits) = shift.quotientAndRemainder(dividingBy: UInt.bitWidth)
    //=--------------------------------------=
    XCTAssertEqual(                 lhs <<   shift,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs >>  -shift,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs <<=  shift; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs >>= -shift; return lhs }(), result, file: file, line: line)
        
    XCTAssertEqual(lhs.bitshiftedLeftSmart(by:   shift), result, file: file, line: line)
    XCTAssertEqual(lhs.bitshiftedRightSmart(by: -shift), result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftSmart(by:   shift); return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightSmart(by: -shift); return lhs }(), result, file: file, line: line)
    //=--------------------------------------=
    if (0 ..< lhs.bitWidth) ~= shift {
        XCTAssertEqual(                 lhs &<<  shift,                 result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs &<<= shift; return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedLeftUnchecked(by: shift), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftUnchecked(by: shift); return lhs }(), result, file: file, line: line)
    }
    //=--------------------------------------=
    if (0 ..< lhs.bitWidth) ~= shift {
        XCTAssertEqual(lhs.bitshiftedLeftUnchecked(by: shift), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftUnchecked(by: shift); return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedLeftUnchecked(words: words, bits: bits), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftUnchecked(words: words, bits: bits); return lhs }(), result, file: file, line: line)
    }
}

//*============================================================================*
// MARK: * NBK x Assert x Shifts x R
//*============================================================================*

func NBKAssertShiftRight<T: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<T>, _ shift: Int, _ result: NBKDoubleWidth<T>,
file: StaticString = #file, line: UInt = #line) {
    //=--------------------------------------=
    let (words, bits) = shift.quotientAndRemainder(dividingBy: UInt.bitWidth)
    //=--------------------------------------=
    XCTAssertEqual(                 lhs >>   shift,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs <<  -shift,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs >>=  shift; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs <<= -shift; return lhs }(), result, file: file, line: line)
        
    XCTAssertEqual(lhs.bitshiftedRightSmart(by: shift), result, file: file, line: line)
    XCTAssertEqual(lhs.bitshiftedLeftSmart(by: -shift), result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightSmart(by: shift); return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeftSmart(by: -shift); return lhs }(), result, file: file, line: line)
    //=--------------------------------------=
    if (0 ..< lhs.bitWidth) ~= shift {
        XCTAssertEqual(                 lhs &>>  shift,                 result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs &>>= shift; return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedRightUnchecked(by: shift), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightUnchecked(by: shift); return lhs }(), result, file: file, line: line)
    }
    //=--------------------------------------=
    if (0 ..< lhs.bitWidth) ~= shift {
        XCTAssertEqual(lhs.bitshiftedRightUnchecked(by: shift), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightUnchecked(by: shift); return lhs }(), result, file: file, line: line)
        
        XCTAssertEqual(lhs.bitshiftedRightUnchecked(words: words, bits: bits), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRightUnchecked(words: words, bits: bits); return lhs }(), result, file: file, line: line)
    }
}
