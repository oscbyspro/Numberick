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
// MARK: * NBK x Tuple Binary Integer x Complements
//*============================================================================*

final class NBKTupleBinaryIntegerTestsOnComplements: XCTestCase {
    
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
    
    func testMagnitude() {
        NBKAssertMagnitude(S2(~1, ~1), U2( 1,  2))
        NBKAssertMagnitude(S2(~0,  0), U2( 1,  0))
        NBKAssertMagnitude(S2( 0,  0), U2( 0,  0))
        NBKAssertMagnitude(S2( 1,  0), U2( 1,  0))
        NBKAssertMagnitude(S2( 1,  2), U2( 1,  2))
        
        NBKAssertMagnitude(U2(~1, ~1), U2(~1, ~1))
        NBKAssertMagnitude(U2(~0,  0), U2(~0,  0))
        NBKAssertMagnitude(U2( 0,  0), U2( 0,  0))
        NBKAssertMagnitude(U2( 1,  0), U2( 1,  0))
        NBKAssertMagnitude(U2( 1,  2), U2( 1,  2))
    }
}

//*============================================================================*
// MARK: * NBK x Tuple Binary Integer x Complements x Assertions
//*============================================================================*

private func NBKAssertMagnitude<High: NBKFixedWidthInteger>(
_ value: NBK.Wide2<High>, _ magnitude: NBK.Wide2<High.Magnitude>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.TupleBinaryInteger<High>
    //=------------------------------------------=
    let result  = T.magnitude(of: value)
    //=------------------------------------------=
    if  let value = value as? NBK.Wide2<High.Magnitude> {
        XCTAssert(result == value, file: file, line: line)
    }   else {
        XCTAssert(High.isSigned,   file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssert(result == magnitude, file: file, line: line)
    XCTAssert(T.Magnitude.magnitude(of: result) == magnitude, file: file, line: line)
}
