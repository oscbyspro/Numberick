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
// MARK: * NBK x Tuple Binary Integer x Collection
//*============================================================================*

final class NBKTupleBinaryIntegerTestsOnCollection: XCTestCase {
    
    typealias TS = NBK.TupleBinaryInteger< Int64>
    typealias TU = NBK.TupleBinaryInteger<UInt64>
    
    typealias S1 = TS.Wide1
    typealias S2 = TS.Wide2
    typealias S3 = TS.Wide3
    
    typealias U1 = TU.Wide1
    typealias U2 = TU.Wide2
    typealias U3 = TU.Wide3

    //=------------------------------------------------------------------------=
    // MARK: Tests x Prefix
    //=------------------------------------------------------------------------=
    
    func testPrefix1() {
        XCTAssert(TS.prefix1([~0    ]) == (~0) as S1)
        XCTAssert(TS.prefix1([~0, ~1]) == (~0) as S1)
        XCTAssert(TU.prefix1([~0    ]) == (~0) as U1)
        XCTAssert(TU.prefix1([~0, ~1]) == (~0) as U1)
    }
    
    func testPrefix2() {
        XCTAssert(TS.prefix2([~0, ~1    ]) == (~1, ~0) as S2)
        XCTAssert(TS.prefix2([~0, ~1, ~2]) == (~1, ~0) as S2)
        XCTAssert(TU.prefix2([~0, ~1    ]) == (~1, ~0) as U2)
        XCTAssert(TU.prefix2([~0, ~1, ~2]) == (~1, ~0) as U2)
    }
    
    func testPrefix3() {
        XCTAssert(TS.prefix3([~0, ~1, ~2    ]) == (~2, ~1, ~0) as S3)
        XCTAssert(TS.prefix3([~0, ~1, ~2, ~3]) == (~2, ~1, ~0) as S3)
        XCTAssert(TU.prefix3([~0, ~1, ~2    ]) == (~2, ~1, ~0) as U3)
        XCTAssert(TU.prefix3([~0, ~1, ~2, ~3]) == (~2, ~1, ~0) as U3)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Suffix
    //=------------------------------------------------------------------------=

    func testSuffix1() {
        XCTAssert(TS.suffix1([~0    ]) == (~0) as S1)
        XCTAssert(TS.suffix1([~0, ~1]) == (~1) as S1)
        XCTAssert(TU.suffix1([~0    ]) == (~0) as U1)
        XCTAssert(TU.suffix1([~0, ~1]) == (~1) as U1)
    }
    
    func testSuffix2() {
        XCTAssert(TS.suffix2([~0, ~1    ]) == (~1, ~0) as S2)
        XCTAssert(TS.suffix2([~0, ~1, ~2]) == (~2, ~1) as S2)
        XCTAssert(TU.suffix2([~0, ~1    ]) == (~1, ~0) as U2)
        XCTAssert(TU.suffix2([~0, ~1, ~2]) == (~2, ~1) as U2)
    }
    
    func testSuffix3() {
        XCTAssert(TS.suffix3([~0, ~1, ~2    ]) == (~2, ~1, ~0) as S3)
        XCTAssert(TS.suffix3([~0, ~1, ~2, ~3]) == (~3, ~2, ~1) as S3)
        XCTAssert(TU.suffix3([~0, ~1, ~2    ]) == (~2, ~1, ~0) as U3)
        XCTAssert(TU.suffix3([~0, ~1, ~2, ~3]) == (~3, ~2, ~1) as U3)
    }
}

#endif
