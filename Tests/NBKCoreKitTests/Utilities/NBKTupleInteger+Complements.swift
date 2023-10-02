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
// MARK: * NBK x Tuple Integer x Complements
//*============================================================================*

final class NBKTupleIntegerTestsOnComplements: XCTestCase {
    
    typealias S  = Int64
    typealias S2 = NBK.Wide2<S>
    typealias S3 = NBK.Wide3<S>
    
    typealias M  = UInt64
    typealias M2 = NBK.Wide2<M>
    typealias M3 = NBK.Wide3<M>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        NBKAssertMagnitude(S2(~1, ~1), M2( 1,  2))
        NBKAssertMagnitude(S2(~0,  0), M2( 1,  0))
        NBKAssertMagnitude(S2( 0,  0), M2( 0,  0))
        NBKAssertMagnitude(S2( 1,  0), M2( 1,  0))
        NBKAssertMagnitude(S2( 1,  2), M2( 1,  2))
        
        NBKAssertMagnitude(M2(~1, ~1), M2(~1, ~1))
        NBKAssertMagnitude(M2(~0,  0), M2(~0,  0))
        NBKAssertMagnitude(M2( 0,  0), M2( 0,  0))
        NBKAssertMagnitude(M2( 1,  0), M2( 1,  0))
        NBKAssertMagnitude(M2( 1,  2), M2( 1,  2))
    }
}

//*============================================================================*
// MARK: * NBK x Tuple Integer x Complements x Assertions
//*============================================================================*

private func NBKAssertMagnitude<High: NBKFixedWidthInteger>(
_ value: NBK.Wide2<High>, _ magnitude: NBK.Wide2<High.Magnitude>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let result = NBK.TupleInteger.magnitude(of: value)
    //=------------------------------------------=
    if  let value = value as? NBK.Wide2<High.Magnitude> {
        XCTAssert(result == value, file: file, line: line)
    }   else {
        XCTAssert(High.isSigned,   file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssert(result == magnitude, file: file, line: line)
    XCTAssert(NBK.TupleInteger.magnitude(of: result) == magnitude, file: file, line: line)
}

#endif
