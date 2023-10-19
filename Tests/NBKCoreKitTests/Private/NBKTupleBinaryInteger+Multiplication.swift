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
// MARK: * NBK x Tuple Binary Integer x Multiplication
//*============================================================================*

final class NBKTupleBinaryIntegerTestsOnMultiplication: XCTestCase {
    
    typealias TS = NBK.TupleBinaryInteger< Int64>
    typealias TM = NBK.TupleBinaryInteger<UInt64>
    
    typealias S1 = TS.Wide1
    typealias S2 = TS.Wide2
    typealias S3 = TS.Wide3
    
    typealias M1 = TM.Wide1
    typealias M2 = TM.Wide2
    typealias M3 = TM.Wide3
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplying213() {
        NBKAssertMultiplication213(M2( 1,  2),  3, M3( 0,  3,  6))
        NBKAssertMultiplication213(M2(~1, ~2), ~3, M3(~4,  1, 12))
        NBKAssertMultiplication213(M2(~0, ~0), ~0, M3(~1, ~0,  1))
    }
}

//*============================================================================*
// MARK: * NBK x Tuple Binary Integer x Multiplication x Assertions
//*============================================================================*

private func NBKAssertMultiplication213<High: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide2<High>, _ rhs: High, _ product: NBK.Wide3<High>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.TupleBinaryInteger<High>
    //=------------------------------------------=
    let (high, mid, low) = T.multiplying213(lhs, by: rhs)
    XCTAssertEqual(low,  product.low,  file: file, line: line)
    XCTAssertEqual(mid,  product.mid,  file: file, line: line)
    XCTAssertEqual(high, product.high, file: file, line: line)
}

#endif
