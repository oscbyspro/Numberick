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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Limbs x Succinct
//*============================================================================*

final class NBKTestsOnLimbsBySuccinct: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMakeSuccinctSignedInteger() {
        NBKAssertMakeSuccinctSignedInteger([   0,  0,  0,  0] as W, [              ] as W, false)
        NBKAssertMakeSuccinctSignedInteger([   1,  0,  0,  0] as W, [ 1            ] as W, false)
        NBKAssertMakeSuccinctSignedInteger([   1,  2,  0,  0] as W, [ 1,  2        ] as W, false)
        NBKAssertMakeSuccinctSignedInteger([   1,  2,  3,  0] as W, [ 1,  2,  3    ] as W, false)
        NBKAssertMakeSuccinctSignedInteger([   1,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, false)
        
        NBKAssertMakeSuccinctSignedInteger([  ~0, ~0, ~0, ~0] as W, [              ] as W, true )
        NBKAssertMakeSuccinctSignedInteger([  ~1, ~0, ~0, ~0] as W, [~1            ] as W, true )
        NBKAssertMakeSuccinctSignedInteger([  ~1, ~2, ~0, ~0] as W, [~1, ~2        ] as W, true )
        NBKAssertMakeSuccinctSignedInteger([  ~1, ~2, ~3, ~0] as W, [~1, ~2, ~3    ] as W, true )
        NBKAssertMakeSuccinctSignedInteger([  ~1, ~2, ~3, ~4] as W, [~1, ~2, ~3, ~4] as W, true )
    }
    
    func testMakeSuccinctUnsignedInteger() {
        NBKAssertMakeSuccinctUnsignedInteger([ 0,  0,  0,  0] as W, [              ] as W, false)
        NBKAssertMakeSuccinctUnsignedInteger([ 1,  0,  0,  0] as W, [ 1            ] as W, false)
        NBKAssertMakeSuccinctUnsignedInteger([ 1,  2,  0,  0] as W, [ 1,  2        ] as W, false)
        NBKAssertMakeSuccinctUnsignedInteger([ 1,  2,  3,  0] as W, [ 1,  2,  3    ] as W, false)
        NBKAssertMakeSuccinctUnsignedInteger([ 1,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, false)
        
        NBKAssertMakeSuccinctUnsignedInteger([~0, ~0, ~0, ~0] as W, [~0, ~0, ~0, ~0] as W, false)
        NBKAssertMakeSuccinctUnsignedInteger([~1, ~0, ~0, ~0] as W, [~1, ~0, ~0, ~0] as W, false)
        NBKAssertMakeSuccinctUnsignedInteger([~1, ~2, ~0, ~0] as W, [~1, ~2, ~0, ~0] as W, false)
        NBKAssertMakeSuccinctUnsignedInteger([~1, ~2, ~3, ~0] as W, [~1, ~2, ~3, ~0] as W, false)
        NBKAssertMakeSuccinctUnsignedInteger([~1, ~2, ~3, ~4] as W, [~1, ~2, ~3, ~4] as W, false)
    }
}

//*============================================================================*
// MARK: * NBK x Limbs x Assertions
//*============================================================================*

private func NBKAssertMakeSuccinctSignedInteger(
_ source: [UInt], _ body: [UInt], _ sign: Bool,
file: StaticString = #file, line: UInt = #line) {
    source.withUnsafeBufferPointer {
        XCTAssertEqual(      NBK.makeSuccinctSignedInteger(fromStrictSignedInteger: $0).sign,  sign, file: file, line: line)
        XCTAssertEqual(Array(NBK.makeSuccinctSignedInteger(fromStrictSignedInteger: $0).body), body, file: file, line: line)
    }
}

private func NBKAssertMakeSuccinctUnsignedInteger(
_ source: [UInt], _ body: [UInt], _ sign: Bool,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(sign, false, file: file, line: line)
    source.withUnsafeBufferPointer {
        XCTAssertEqual(      NBK.makeSuccinctUnsignedInteger(fromLenientUnsignedInteger: $0).sign,  sign, file: file, line: line)
        XCTAssertEqual(Array(NBK.makeSuccinctUnsignedInteger(fromLenientUnsignedInteger: $0).body), body, file: file, line: line)
    }
}

#endif
