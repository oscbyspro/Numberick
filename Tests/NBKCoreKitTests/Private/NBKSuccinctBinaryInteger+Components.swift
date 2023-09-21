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
// MARK: * NBK x Succinct Binary Integer x Components
//*============================================================================*

final class NBKSuccinctBinaryIntegerTestsOnComponents: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMakeSuccinctSignedIntegerComponents() {
        NBKAssertMakeSuccinctSignedIntegerComponents([   0,  0,  0,  0] as W, [              ] as W, false)
        NBKAssertMakeSuccinctSignedIntegerComponents([   1,  0,  0,  0] as W, [ 1            ] as W, false)
        NBKAssertMakeSuccinctSignedIntegerComponents([   1,  2,  0,  0] as W, [ 1,  2        ] as W, false)
        NBKAssertMakeSuccinctSignedIntegerComponents([   1,  2,  3,  0] as W, [ 1,  2,  3    ] as W, false)
        NBKAssertMakeSuccinctSignedIntegerComponents([   1,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, false)
        
        NBKAssertMakeSuccinctSignedIntegerComponents([  ~0, ~0, ~0, ~0] as W, [              ] as W, true )
        NBKAssertMakeSuccinctSignedIntegerComponents([  ~1, ~0, ~0, ~0] as W, [~1            ] as W, true )
        NBKAssertMakeSuccinctSignedIntegerComponents([  ~1, ~2, ~0, ~0] as W, [~1, ~2        ] as W, true )
        NBKAssertMakeSuccinctSignedIntegerComponents([  ~1, ~2, ~3, ~0] as W, [~1, ~2, ~3    ] as W, true )
        NBKAssertMakeSuccinctSignedIntegerComponents([  ~1, ~2, ~3, ~4] as W, [~1, ~2, ~3, ~4] as W, true )
    }
    
    func testMakeSuccinctUnsignedIntegerComponents() {
        NBKAssertMakeSuccinctUnsignedIntegerComponents([ 0,  0,  0,  0] as W, [              ] as W, false)
        NBKAssertMakeSuccinctUnsignedIntegerComponents([ 1,  0,  0,  0] as W, [ 1            ] as W, false)
        NBKAssertMakeSuccinctUnsignedIntegerComponents([ 1,  2,  0,  0] as W, [ 1,  2        ] as W, false)
        NBKAssertMakeSuccinctUnsignedIntegerComponents([ 1,  2,  3,  0] as W, [ 1,  2,  3    ] as W, false)
        NBKAssertMakeSuccinctUnsignedIntegerComponents([ 1,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, false)
        
        NBKAssertMakeSuccinctUnsignedIntegerComponents([~0, ~0, ~0, ~0] as W, [~0, ~0, ~0, ~0] as W, false)
        NBKAssertMakeSuccinctUnsignedIntegerComponents([~1, ~0, ~0, ~0] as W, [~1, ~0, ~0, ~0] as W, false)
        NBKAssertMakeSuccinctUnsignedIntegerComponents([~1, ~2, ~0, ~0] as W, [~1, ~2, ~0, ~0] as W, false)
        NBKAssertMakeSuccinctUnsignedIntegerComponents([~1, ~2, ~3, ~0] as W, [~1, ~2, ~3, ~0] as W, false)
        NBKAssertMakeSuccinctUnsignedIntegerComponents([~1, ~2, ~3, ~4] as W, [~1, ~2, ~3, ~4] as W, false)
    }
}

//*============================================================================*
// MARK: * NBK x Succinct Binary Integer x Components x Assertions
//*============================================================================*

private func NBKAssertMakeSuccinctSignedIntegerComponents(
_ source: [UInt], _ body: [UInt], _ sign: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SuccinctBinaryInteger<UnsafeBufferPointer<UInt>>
    //=------------------------------------------=
    source.withUnsafeBufferPointer {
        XCTAssertEqual(      T.components(fromStrictSignedInteger: $0).sign,  sign, file: file, line: line)
        XCTAssertEqual(Array(T.components(fromStrictSignedInteger: $0).body), body, file: file, line: line)
    }
}

private func NBKAssertMakeSuccinctUnsignedIntegerComponents(
_ source: [UInt], _ body: [UInt], _ sign: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SuccinctBinaryInteger<UnsafeBufferPointer<UInt>>
    //=------------------------------------------=
    XCTAssertEqual(sign, false, file: file, line: line)
    source.withUnsafeBufferPointer {
        XCTAssertEqual(      T.components(fromStrictUnsignedIntegerSubSequence: $0).sign,  sign, file: file, line: line)
        XCTAssertEqual(Array(T.components(fromStrictUnsignedIntegerSubSequence: $0).body), body, file: file, line: line)
    }
}

#endif
