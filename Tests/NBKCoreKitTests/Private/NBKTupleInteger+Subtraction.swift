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
// MARK: * NBK x Tuple Integer x Subtraction
//*============================================================================*

final class NBKTupleIntegerTestsOnSubtraction: XCTestCase {
    
    typealias S  = Int64
    typealias S2 = NBK.Wide2<S>
    typealias S3 = NBK.Wide3<S>
    
    typealias M  = UInt64
    typealias M2 = NBK.Wide2<M>
    typealias M3 = NBK.Wide3<M>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting32B() {
        NBKAssertSubtraction32B(M3( 0,  0,  0), M2(~4, ~5), M3(~0,  4,  6), true )
        NBKAssertSubtraction32B(M3( 1,  2,  3), M2(~4, ~5), M3( 0,  6,  9), false)
        NBKAssertSubtraction32B(M3(~1, ~2, ~3), M2( 4,  5), M3(~1, ~6, ~8), false)
        NBKAssertSubtraction32B(M3(~0, ~0, ~0), M2( 4,  5), M3(~0, ~4, ~5), false)
    }
    
    func testSubtracting33B() {
        NBKAssertSubtraction33B(M3( 0,  0,  0), M3(~4, ~5, ~6), M3( 4,  5,  7), true )
        NBKAssertSubtraction33B(M3( 1,  2,  3), M3(~4, ~5, ~6), M3( 5,  7, 10), true )
        NBKAssertSubtraction33B(M3(~1, ~2, ~3), M3( 4,  5,  6), M3(~5, ~7, ~9), false)
        NBKAssertSubtraction33B(M3(~0, ~0, ~0), M3( 4,  5,  6), M3(~4, ~5, ~6), false)
    }
}

//*============================================================================*
// MARK: * NBK x Tuple Integer x Subtraction x Assertions
//*============================================================================*

private func NBKAssertSubtraction32B<High: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<High>, _ rhs: NBK.Wide2<High>, _ difference: NBK.Wide3<High>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    var x = lhs
    let o = NBK.TupleInteger.decrement32B(&x, by: rhs)
    XCTAssertEqual(x.low,  difference.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  difference.mid,  file: file, line: line)
    XCTAssertEqual(x.high, difference.high, file: file, line: line)
    XCTAssertEqual(o,      overflow,        file: file, line: line)
}

private func NBKAssertSubtraction33B<High: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<High>, _ rhs: NBK.Wide3<High>, _ difference: NBK.Wide3<High>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    var x = lhs
    let o = NBK.TupleInteger.decrement33B(&x, by: rhs)
    XCTAssertEqual(x.low,  difference.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  difference.mid,  file: file, line: line)
    XCTAssertEqual(x.high, difference.high, file: file, line: line)
    XCTAssertEqual(o,      overflow,        file: file, line: line)
}

#endif
