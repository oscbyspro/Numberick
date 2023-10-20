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
// MARK: * NBK x Tuple Binary Integer x Comparisons
//*============================================================================*

final class NBKTupleBinaryIntegerTestsOnComparisons: XCTestCase {
    
    typealias TS = NBK.TupleBinaryInteger< Int64>
    typealias TU = NBK.TupleBinaryInteger<UInt64>
    
    typealias S1 = TS.Wide1
    typealias S2 = TS.Wide2
    typealias S3 = TS.Wide3
    
    typealias U1 = TU.Wide1
    typealias U2 = TU.Wide2
    typealias U3 = TU.Wide3

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testComparing22S() {
        NBKAssertComparisons22S(U2(0, ~0), U2(1,  0), Int(-1))
        NBKAssertComparisons22S(U2(1,  0), U2(1,  0), Int( 0))
        NBKAssertComparisons22S(U2(1,  0), U2(0, ~0), Int( 1))
        
        NBKAssertComparisons22S(U2(1,  0), U2(1,  1), Int(-1))
        NBKAssertComparisons22S(U2(1,  1), U2(1,  1), Int( 0))
        NBKAssertComparisons22S(U2(1,  1), U2(1,  0), Int( 1))
    }
    
    func testComparing33S() {
        NBKAssertComparisons33S(U3(0, ~0, ~0), U3(1,  0,  0), Int(-1))
        NBKAssertComparisons33S(U3(1,  0,  0), U3(1,  0,  0), Int( 0))
        NBKAssertComparisons33S(U3(1,  0,  0), U3(0, ~0, ~0), Int( 1))

        NBKAssertComparisons33S(U3(1,  0, ~0), U3(1,  1,  0), Int(-1))
        NBKAssertComparisons33S(U3(1,  1,  0), U3(1,  1,  0), Int( 0))
        NBKAssertComparisons33S(U3(1,  1,  0), U3(1,  0, ~0), Int( 1))

        NBKAssertComparisons33S(U3(1,  1,  0), U3(1,  1,  1), Int(-1))
        NBKAssertComparisons33S(U3(1,  1,  1), U3(1,  1,  1), Int( 0))
        NBKAssertComparisons33S(U3(1,  1,  1), U3(1,  1,  0), Int( 1))
    }
}

//*============================================================================*
// MARK: * NBK x Tuple Binary Integer x Comparisons x Assertions
//*============================================================================*

private func NBKAssertComparisons22S<High: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide2<High>, _ rhs: NBK.Wide2<High>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.TupleBinaryInteger<High>
    //=------------------------------------------=
    XCTAssertEqual(T.compare22S(lhs, to: rhs), signum, file: file, line: line)
}

private func NBKAssertComparisons33S<High: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<High>, _ rhs: NBK.Wide3<High>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.TupleBinaryInteger<High>
    //=------------------------------------------=
    XCTAssertEqual(T.compare33S(lhs, to: rhs), signum, file: file, line: line)
}

#endif
