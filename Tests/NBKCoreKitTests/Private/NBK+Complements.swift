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
// MARK: * NBK x Complements
//*============================================================================*

final class NBKTestsOnComplements: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Binary Integer Limbs x Succinct
    //=------------------------------------------------------------------------=
    
    func testSuccinctSignedInteger() {
        NBKAssertSuccinctSignedInteger([   0,  0,  0,  0] as W, [              ] as W, false)
        NBKAssertSuccinctSignedInteger([   1,  0,  0,  0] as W, [ 1            ] as W, false)
        NBKAssertSuccinctSignedInteger([   1,  2,  0,  0] as W, [ 1,  2        ] as W, false)
        NBKAssertSuccinctSignedInteger([   1,  2,  3,  0] as W, [ 1,  2,  3    ] as W, false)
        NBKAssertSuccinctSignedInteger([   1,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, false)
        
        NBKAssertSuccinctSignedInteger([  ~0, ~0, ~0, ~0] as W, [              ] as W, true )
        NBKAssertSuccinctSignedInteger([  ~1, ~0, ~0, ~0] as W, [~1            ] as W, true )
        NBKAssertSuccinctSignedInteger([  ~1, ~2, ~0, ~0] as W, [~1, ~2        ] as W, true )
        NBKAssertSuccinctSignedInteger([  ~1, ~2, ~3, ~0] as W, [~1, ~2, ~3    ] as W, true )
        NBKAssertSuccinctSignedInteger([  ~1, ~2, ~3, ~4] as W, [~1, ~2, ~3, ~4] as W, true )
    }
    
    func testSuccinctUnsignedInteger() {
        NBKAssertSuccinctUnsignedInteger([ 0,  0,  0,  0] as W, [              ] as W, false)
        NBKAssertSuccinctUnsignedInteger([ 1,  0,  0,  0] as W, [ 1            ] as W, false)
        NBKAssertSuccinctUnsignedInteger([ 1,  2,  0,  0] as W, [ 1,  2        ] as W, false)
        NBKAssertSuccinctUnsignedInteger([ 1,  2,  3,  0] as W, [ 1,  2,  3    ] as W, false)
        NBKAssertSuccinctUnsignedInteger([ 1,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, false)
        
        NBKAssertSuccinctUnsignedInteger([~0, ~0, ~0, ~0] as W, [~0, ~0, ~0, ~0] as W, false)
        NBKAssertSuccinctUnsignedInteger([~1, ~0, ~0, ~0] as W, [~1, ~0, ~0, ~0] as W, false)
        NBKAssertSuccinctUnsignedInteger([~1, ~2, ~0, ~0] as W, [~1, ~2, ~0, ~0] as W, false)
        NBKAssertSuccinctUnsignedInteger([~1, ~2, ~3, ~0] as W, [~1, ~2, ~3, ~0] as W, false)
        NBKAssertSuccinctUnsignedInteger([~1, ~2, ~3, ~4] as W, [~1, ~2, ~3, ~4] as W, false)
    }
}

//*============================================================================*
// MARK: * NBK x Complements x Assertions
//*============================================================================*

private func NBKAssertSuccinctSignedInteger(
_ source: [UInt], _ body: [UInt], _ sign: Bool,
file: StaticString = #file, line: UInt = #line) {
    source.withUnsafeBufferPointer {
        XCTAssertEqual(      NBK.makeSuccinctSignedIntegerLimbs($0).sign,  sign, file: file, line: line)
        XCTAssertEqual(Array(NBK.makeSuccinctSignedIntegerLimbs($0).body), body, file: file, line: line)
    }
}

private func NBKAssertSuccinctUnsignedInteger(
_ source: [UInt], _ body: [UInt], _ sign: Bool,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(sign, false, file: file, line: line)
    source.withUnsafeBufferPointer {
        XCTAssert(           NBK.makeSuccinctUnsignedInteger($0).sign ==  (), file: file, line: line)
        XCTAssertEqual(Array(NBK.makeSuccinctUnsignedInteger($0).body), body, file: file, line: line)
    }
}

#endif
