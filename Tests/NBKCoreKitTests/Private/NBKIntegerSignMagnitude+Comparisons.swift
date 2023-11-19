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

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Integer Sign Magnitude x Comparisons
//*============================================================================*

final class NBKIntegerSignMagnitudeTestsOnComparisons: XCTestCase {
        
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCompareTo() {
        NBKAssertCompareTo(SM(.plus,  UInt(0)), SM(.plus,  UInt(0)),  Int(0))
        NBKAssertCompareTo(SM(.plus,  UInt(0)), SM(.minus, UInt(0)),  Int(0))
        NBKAssertCompareTo(SM(.minus, UInt(0)), SM(.plus,  UInt(0)),  Int(0))
        NBKAssertCompareTo(SM(.minus, UInt(0)), SM(.minus, UInt(0)),  Int(0))
        
        NBKAssertCompareTo(SM(.plus,  UInt(1)), SM(.plus,  UInt(1)),  Int(0))
        NBKAssertCompareTo(SM(.plus,  UInt(1)), SM(.minus, UInt(1)),  Int(1))
        NBKAssertCompareTo(SM(.minus, UInt(1)), SM(.plus,  UInt(1)), -Int(1))
        NBKAssertCompareTo(SM(.minus, UInt(1)), SM(.minus, UInt(1)),  Int(0))
        
        NBKAssertCompareTo(SM(.plus,  UInt(2)), SM(.plus,  UInt(3)), -Int(1))
        NBKAssertCompareTo(SM(.plus,  UInt(2)), SM(.minus, UInt(3)),  Int(1))
        NBKAssertCompareTo(SM(.minus, UInt(2)), SM(.plus,  UInt(3)), -Int(1))
        NBKAssertCompareTo(SM(.minus, UInt(2)), SM(.minus, UInt(3)),  Int(1))
        
        NBKAssertCompareTo(SM(.plus,  UInt(3)), SM(.plus,  UInt(2)),  Int(1))
        NBKAssertCompareTo(SM(.plus,  UInt(3)), SM(.minus, UInt(2)),  Int(1))
        NBKAssertCompareTo(SM(.minus, UInt(3)), SM(.plus,  UInt(2)), -Int(1))
        NBKAssertCompareTo(SM(.minus, UInt(3)), SM(.minus, UInt(2)), -Int(1))
    }
    
    func testCompareToZero() {
        NBKAssertCompareToZero(SM(.plus,  UInt(0)),  Int(0))
        NBKAssertCompareToZero(SM(.plus,  UInt(1)),  Int(1))
        NBKAssertCompareToZero(SM(.plus,  UInt(2)),  Int(1))
        
        NBKAssertCompareToZero(SM(.minus, UInt(0)),  Int(0))
        NBKAssertCompareToZero(SM(.minus, UInt(1)), -Int(1))
        NBKAssertCompareToZero(SM(.minus, UInt(2)), -Int(1))
    }
}

//*============================================================================*
// MARK: * NBK x Integer Sign Magnitude x Comparisons x Assertions
//*============================================================================*

private func NBKAssertCompareTo<Magnitude: NBKUnsignedInteger>(
_ lhs: SM<Magnitude>, _ rhs: SM<Magnitude>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(NBK.ISM.compare(lhs, to: rhs, using:{ $0.compared(to: $1) }), signum, file: file, line: line)
}

private func NBKAssertCompareToZero<Magnitude: NBKUnsignedInteger>(
_ components: SM<Magnitude>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssert(NBK.ISM.signum/*----*/(components) == signum,                file: file, line: line)
    XCTAssert(NBK.ISM.isLessThanZero(components) == signum.isLessThanZero, file: file, line: line)
    XCTAssert(NBK.ISM.isMoreThanZero(components) == signum.isMoreThanZero, file: file, line: line)
}
