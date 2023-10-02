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
// MARK: * NBK x Tuple Integer x Comparisons
//*============================================================================*

final class NBKTupleIntegerTestsOnComparisons: XCTestCase {
    
    typealias S  = Int64
    typealias S2 = NBK.Wide2<S>
    typealias S3 = NBK.Wide3<S>
    
    typealias M  = UInt64
    typealias M2 = NBK.Wide2<M>
    typealias M3 = NBK.Wide3<M>

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testComparing22S() {
        NBKAssertComparisons22S(M2(0, ~0), M2(1,  0), Int(-1))
        NBKAssertComparisons22S(M2(1,  0), M2(1,  0), Int( 0))
        NBKAssertComparisons22S(M2(1,  0), M2(0, ~0), Int( 1))
        
        NBKAssertComparisons22S(M2(1,  0), M2(1,  1), Int(-1))
        NBKAssertComparisons22S(M2(1,  1), M2(1,  1), Int( 0))
        NBKAssertComparisons22S(M2(1,  1), M2(1,  0), Int( 1))
    }
    
    func testComparing33S() {
        NBKAssertComparisons33S(M3(0, ~0, ~0), M3(1,  0,  0), Int(-1))
        NBKAssertComparisons33S(M3(1,  0,  0), M3(1,  0,  0), Int( 0))
        NBKAssertComparisons33S(M3(1,  0,  0), M3(0, ~0, ~0), Int( 1))

        NBKAssertComparisons33S(M3(1,  0, ~0), M3(1,  1,  0), Int(-1))
        NBKAssertComparisons33S(M3(1,  1,  0), M3(1,  1,  0), Int( 0))
        NBKAssertComparisons33S(M3(1,  1,  0), M3(1,  0, ~0), Int( 1))

        NBKAssertComparisons33S(M3(1,  1,  0), M3(1,  1,  1), Int(-1))
        NBKAssertComparisons33S(M3(1,  1,  1), M3(1,  1,  1), Int( 0))
        NBKAssertComparisons33S(M3(1,  1,  1), M3(1,  1,  0), Int( 1))
    }
}

//*============================================================================*
// MARK: * NBK x Tuple Integer x Comparisons x Assertions
//*============================================================================*

private func NBKAssertComparisons22S<High: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide2<High>, _ rhs: NBK.Wide2<High>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(NBK.TupleInteger.compare22S(lhs, to: rhs), signum, file: file, line: line)
}

private func NBKAssertComparisons33S<High: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<High>, _ rhs: NBK.Wide3<High>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(NBK.TupleInteger.compare33S(lhs, to: rhs), signum, file: file, line: line)
}

#endif
