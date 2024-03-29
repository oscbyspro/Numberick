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
// MARK: * NBK x Tuple Binary Integer x Subtraction
//*============================================================================*

final class NBKTupleBinaryIntegerTestsOnSubtraction: XCTestCase {
    
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
    
    func testSubtracting32B() {
        NBKAssertSubtraction32B(U3( 0,  0,  0), U2(~4, ~5), U3(~0,  4,  6), true )
        NBKAssertSubtraction32B(U3( 1,  2,  3), U2(~4, ~5), U3( 0,  6,  9), false)
        NBKAssertSubtraction32B(U3(~1, ~2, ~3), U2( 4,  5), U3(~1, ~6, ~8), false)
        NBKAssertSubtraction32B(U3(~0, ~0, ~0), U2( 4,  5), U3(~0, ~4, ~5), false)
    }
    
    func testSubtracting33B() {
        NBKAssertSubtraction33B(U3( 0,  0,  0), U3(~4, ~5, ~6), U3( 4,  5,  7), true )
        NBKAssertSubtraction33B(U3( 1,  2,  3), U3(~4, ~5, ~6), U3( 5,  7, 10), true )
        NBKAssertSubtraction33B(U3(~1, ~2, ~3), U3( 4,  5,  6), U3(~5, ~7, ~9), false)
        NBKAssertSubtraction33B(U3(~0, ~0, ~0), U3( 4,  5,  6), U3(~4, ~5, ~6), false)
    }
}

//*============================================================================*
// MARK: * NBK x Tuple Binary Integer x Subtraction x Assertions
//*============================================================================*

private func NBKAssertSubtraction32B<High: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<High>, _ rhs: NBK.Wide2<High>, _ difference: NBK.Wide3<High>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.TupleBinaryInteger<High>
    //=------------------------------------------=
    var x = lhs
    let o = T.decrement32B(&x, by: rhs)
    XCTAssertEqual(x.low,  difference.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  difference.mid,  file: file, line: line)
    XCTAssertEqual(x.high, difference.high, file: file, line: line)
    XCTAssertEqual(o,      overflow,        file: file, line: line)
}

private func NBKAssertSubtraction33B<High: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<High>, _ rhs: NBK.Wide3<High>, _ difference: NBK.Wide3<High>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.TupleBinaryInteger<High>
    //=------------------------------------------=
    var x = lhs
    let o = T.decrement33B(&x, by: rhs)
    XCTAssertEqual(x.low,  difference.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  difference.mid,  file: file, line: line)
    XCTAssertEqual(x.high, difference.high, file: file, line: line)
    XCTAssertEqual(o,      overflow,        file: file, line: line)
}
