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
// MARK: * NBK x Assert
//*============================================================================*

func NBKAssertHalvesGetSetInit<H: NBKFixedWidthInteger>(
_ value: NBKDoubleWidth<H>, _ low: H.Magnitude, _ high: H,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    if  high.isZero {
        XCTAssertEqual(value, T(low:  low ), file: file, line: line)
    }
    
    if  low.isZero {
        XCTAssertEqual(value, T(high: high), file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(value, T(low:  low,  high: high), file: file, line: line)
    XCTAssertEqual(value, T(high: high, low:  low ), file: file, line: line)
    
    XCTAssertEqual(value, T(ascending:  LH(low, high)), file: file, line: line)
    XCTAssertEqual(value, T(descending: HL(high, low)), file: file, line: line)
    
    XCTAssertEqual(value.low,  low,  file: file, line: line)
    XCTAssertEqual(value.high, high, file: file, line: line)
    
    XCTAssertEqual(value.ascending.low,   low,  file: file, line: line)
    XCTAssertEqual(value.ascending.high,  high, file: file, line: line)
    
    XCTAssertEqual(value.descending.low,  low,  file: file, line: line)
    XCTAssertEqual(value.descending.high, high, file: file, line: line)
    
    XCTAssertEqual(value, { var x = T(); x.low = low; x.high =  high;  return x }(), file: file, line: line)
    XCTAssertEqual(value, { var x = T(); x.ascending  = LH(low, high); return x }(), file: file, line: line)
    XCTAssertEqual(value, { var x = T(); x.descending = HL(high, low); return x }(), file: file, line: line)
}
