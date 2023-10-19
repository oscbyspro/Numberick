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
    
    typealias S  = Int64
    typealias S2 = NBK.Wide2<S>
    typealias S3 = NBK.Wide3<S>
    
    typealias M  = UInt64
    typealias M2 = NBK.Wide2<M>
    typealias M3 = NBK.Wide3<M>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividing3212MSB() {
        NBKAssertDivision3212MSB(M3(~0,  0,  0), M2(~0,  1), ~M(0), M2(~1,  1))
        NBKAssertDivision3212MSB(M3(~0,  0,  0), M2(~0, ~1), ~M(0), M2( 1, ~1))
        NBKAssertDivision3212MSB(M3(~1, ~0, ~0), M2(~0,  0), ~M(0), M2(~1, ~0))
        NBKAssertDivision3212MSB(M3(~1, ~0, ~0), M2(~0, ~0), ~M(0), M2( 0, ~1))
    }
    
    func testDividing3212MSBWithBadInitialEstimate() {
        NBKAssertDivision3212MSB(M3(1 << 63 - 1,  0,  0), M2(1 << 63, ~0), ~M(3), M2(4, ~3)) // 2
        NBKAssertDivision3212MSB(M3(1 << 63 - 1,  0, ~0), M2(1 << 63, ~0), ~M(3), M2(5, ~4)) // 2
        NBKAssertDivision3212MSB(M3(1 << 63 - 1, ~0,  0), M2(1 << 63, ~0), ~M(1), M2(1, ~1)) // 1
        NBKAssertDivision3212MSB(M3(1 << 63 - 1, ~0, ~0), M2(1 << 63, ~0), ~M(1), M2(2, ~2)) // 1
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
