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
// MARK: * NBK x Tuple Binary Integer x Addition
//*============================================================================*

final class NBKTupleBinaryIntegerTestsOnAddition: XCTestCase {
    
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

    func testAdding32B() {
        NBKAssertAdding32B(U3( 0,  0,  0), U2(~4, ~5), U3( 0, ~4, ~5), false)
        NBKAssertAdding32B(U3( 1,  2,  3), U2(~4, ~5), U3( 1, ~2, ~2), false)
        NBKAssertAdding32B(U3(~1, ~2, ~3), U2( 4,  5), U3(~0,  2,  1), false)
        NBKAssertAdding32B(U3(~0, ~0, ~0), U2( 4,  5), U3( 0,  4,  4), true )
    }

    func testAdding33B() {
        NBKAssertAdding33B(U3( 0,  0,  0), U3(~4, ~5, ~6), U3(~4, ~5, ~6), false)
        NBKAssertAdding33B(U3( 1,  2,  3), U3(~4, ~5, ~6), U3(~3, ~3, ~3), false)
        NBKAssertAdding33B(U3(~1, ~2, ~3), U3( 4,  5,  6), U3( 3,  3,  2), true )
        NBKAssertAdding33B(U3(~0, ~0, ~0), U3( 4,  5,  6), U3( 4,  5,  5), true )
    }
}

//*============================================================================*
// MARK: * NBK x Tuple Binary Integer x Addition x Assertions
//*============================================================================*

private func NBKAssertAdding32B<High: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<High>, _ rhs: NBK.Wide2<High>, _ sum: NBK.Wide3<High>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.TupleBinaryInteger<High>
    //=------------------------------------------=
    var x = lhs
    let o = T.increment32B(&x, by: rhs)
    XCTAssertEqual(x.low,  sum.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  sum.mid,  file: file, line: line)
    XCTAssertEqual(x.high, sum.high, file: file, line: line)
    XCTAssertEqual(o,      overflow, file: file, line: line)
}

private func NBKAssertAdding33B<High: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<High>, _ rhs: NBK.Wide3<High>, _ sum: NBK.Wide3<High>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.TupleBinaryInteger<High>
    //=------------------------------------------=
    var x = lhs
    let o = T.increment33B(&x, by: rhs)
    XCTAssertEqual(x.low,  sum.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  sum.mid,  file: file, line: line)
    XCTAssertEqual(x.high, sum.high, file: file, line: line)
    XCTAssertEqual(o,      overflow, file: file, line: line)
}
