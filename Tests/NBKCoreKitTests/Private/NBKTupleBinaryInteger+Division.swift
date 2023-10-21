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
// MARK: * NBK x Tuple Binary Integer x Division
//*============================================================================*

final class NBKTupleBinaryIntegerTestsOnDivision: XCTestCase {
    
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
    
    func testDividing3212MSB() {
        NBKAssertDivision3212MSB(U3(~0,  0,  0), U2(~0,  1), ~U1(0), U2(~1,  1))
        NBKAssertDivision3212MSB(U3(~0,  0,  0), U2(~0, ~1), ~U1(0), U2( 1, ~1))
        NBKAssertDivision3212MSB(U3(~1, ~0, ~0), U2(~0,  0), ~U1(0), U2(~1, ~0))
        NBKAssertDivision3212MSB(U3(~1, ~0, ~0), U2(~0, ~0), ~U1(0), U2( 0, ~1))
    }
    
    func testDividing3212MSBWithBadInitialEstimate() {
        NBKAssertDivision3212MSB(U3(1 << 63 - 1,  0,  0), U2(1 << 63, ~0), ~U1(3), U2(4, ~3)) // 2
        NBKAssertDivision3212MSB(U3(1 << 63 - 1,  0, ~0), U2(1 << 63, ~0), ~U1(3), U2(5, ~4)) // 2
        NBKAssertDivision3212MSB(U3(1 << 63 - 1, ~0,  0), U2(1 << 63, ~0), ~U1(1), U2(1, ~1)) // 1
        NBKAssertDivision3212MSB(U3(1 << 63 - 1, ~0, ~0), U2(1 << 63, ~0), ~U1(1), U2(2, ~2)) // 1
    }
}

//*============================================================================*
// MARK: * NBK x Tuple Binary Integer x Division x Assertions
//*============================================================================*

private func NBKAssertDivision3212MSB<High: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<High>, _ rhs: NBK.Wide2<High>, _ quotient: High, _ remainder: NBK.Wide2<High>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.TupleBinaryInteger<High>
    //=------------------------------------------=
    var result: QR<T.Wide1, T.Wide3>
    result.remainder = lhs
    result.quotient  = T.divide3212MSBUnchecked(&result.remainder,  by: rhs)
    //=------------------------------------------=
    XCTAssertEqual(result.quotient,       quotient,       file: file, line: line)
    XCTAssertEqual(result.remainder.high, High.zero,      file: file, line: line)
    XCTAssertEqual(result.remainder.mid,  remainder.high, file: file, line: line)
    XCTAssertEqual(result.remainder.low,  remainder.low,  file: file, line: line)
    //=------------------------------------------=
    var back = T.multiplying213(rhs, by: result.quotient )
    let _    = T.increment33B(&back, by: result.remainder)
    XCTAssert(lhs == back, "lhs != rhs * quotient + remainder", file: file, line: line)
}

#endif
