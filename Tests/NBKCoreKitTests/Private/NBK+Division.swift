//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Division x Int or UInt
//*============================================================================*

final class NBKTestsOnDivisionAsIntOrUInt: XCTestCase {
    
    typealias T = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let bitWidth = T(T.bitWidth)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividingByBitWidth() {
        NBKAssertDividingByBitWidthAsIntOrUInt(T(0) * bitWidth + T(0), T(0), T(0))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(0) * bitWidth + T(1), T(0), T(1))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(0) * bitWidth + T(2), T(0), T(2))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(0) * bitWidth + T(3), T(0), T(3))
        
        NBKAssertDividingByBitWidthAsIntOrUInt(T(1) * bitWidth + T(0), T(1), T(0))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(1) * bitWidth + T(1), T(1), T(1))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(1) * bitWidth + T(2), T(1), T(2))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(1) * bitWidth + T(3), T(1), T(3))
        
        NBKAssertDividingByBitWidthAsIntOrUInt(T(2) * bitWidth + T(0), T(2), T(0))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(2) * bitWidth + T(1), T(2), T(1))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(2) * bitWidth + T(2), T(2), T(2))
        NBKAssertDividingByBitWidthAsIntOrUInt(T(2) * bitWidth + T(3), T(2), T(3))
        
        NBKAssertDividingByBitWidthAsIntOrUInt(T.min, T.min / bitWidth, T.min % bitWidth)
        NBKAssertDividingByBitWidthAsIntOrUInt(T.max, T.max / bitWidth, T.max % bitWidth)
    }
}

//*============================================================================*
// MARK: * NBK x Division x Assertions
//*============================================================================*

private func NBKAssertDividingByBitWidthAsIntOrUInt(
_ value: UInt, _ quotient: UInt, _ remainder: UInt,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(NBK .quotientDividingByBitWidth(value), quotient,  file: file, line: line)
    XCTAssertEqual(NBK.remainderDividingByBitWidth(value), remainder, file: file, line: line)
    //=------------------------------------------=
    if  let value = Int(exactly: value), let quotient = Int(exactly: quotient), let remainder = Int(exactly: remainder) {
        XCTAssertEqual(NBK .quotientDividingByBitWidthAssumingIsAtLeastZero(value), quotient,  file: file, line: line)
        XCTAssertEqual(NBK.remainderDividingByBitWidthAssumingIsAtLeastZero(value), remainder, file: file, line: line)
    }
}

#endif
