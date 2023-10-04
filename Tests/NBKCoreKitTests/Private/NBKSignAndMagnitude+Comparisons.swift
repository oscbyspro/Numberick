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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Sign & Magnitude x Comparisons
//*============================================================================*

final class NBKSignAndMagnitudeTestsOnComparisons: XCTestCase {
        
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
}

//*============================================================================*
// MARK: * NBK x Sign & Magnitude x Comparisons x Assertions
//*============================================================================*

private func NBKAssertCompareTo<M: NBKUnsignedInteger>(
_ lhs: SM<M>, _ rhs: SM<M>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(NBK.SAM.compare(lhs, to: rhs, using:{ $0.compared(to: $1) }), signum, file: file, line: line)
}

#endif
