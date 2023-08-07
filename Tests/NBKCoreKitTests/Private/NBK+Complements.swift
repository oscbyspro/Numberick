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
// MARK: * NBK x Complements
//*============================================================================*

final class NBKTestsOnComplements: XCTestCase {
    
    private typealias S64 = [Int64]
    private typealias S32 = [Int32]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Succinct Binary Integer
    //=------------------------------------------------------------------------=
    
    func testSuccinctSignedInteger() {
        NBKAssertSuccinctSignedInteger([   0,  0,  0,  0], [              ], false)
        NBKAssertSuccinctSignedInteger([   1,  0,  0,  0], [ 1            ], false)
        NBKAssertSuccinctSignedInteger([   1,  2,  0,  0], [ 1,  2        ], false)
        NBKAssertSuccinctSignedInteger([   1,  2,  3,  0], [ 1,  2,  3    ], false)
        NBKAssertSuccinctSignedInteger([   1,  2,  3,  4], [ 1,  2,  3,  4], false)
        
        NBKAssertSuccinctSignedInteger([  ~0, ~0, ~0, ~0], [              ], true )
        NBKAssertSuccinctSignedInteger([  ~1, ~0, ~0, ~0], [~1            ], true )
        NBKAssertSuccinctSignedInteger([  ~1, ~2, ~0, ~0], [~1, ~2        ], true )
        NBKAssertSuccinctSignedInteger([  ~1, ~2, ~3, ~0], [~1, ~2, ~3    ], true )
        NBKAssertSuccinctSignedInteger([  ~1, ~2, ~3, ~4], [~1, ~2, ~3, ~4], true )
    }
    
    func testSuccinctUnsignedInteger() {
        NBKAssertSuccinctUnsignedInteger([ 0,  0,  0,  0], [              ], false)
        NBKAssertSuccinctUnsignedInteger([ 1,  0,  0,  0], [ 1            ], false)
        NBKAssertSuccinctUnsignedInteger([ 1,  2,  0,  0], [ 1,  2        ], false)
        NBKAssertSuccinctUnsignedInteger([ 1,  2,  3,  0], [ 1,  2,  3    ], false)
        NBKAssertSuccinctUnsignedInteger([ 1,  2,  3,  4], [ 1,  2,  3,  4], false)
        
        NBKAssertSuccinctUnsignedInteger([~0, ~0, ~0, ~0], [~0, ~0, ~0, ~0], false)
        NBKAssertSuccinctUnsignedInteger([~1, ~0, ~0, ~0], [~1, ~0, ~0, ~0], false)
        NBKAssertSuccinctUnsignedInteger([~1, ~2, ~0, ~0], [~1, ~2, ~0, ~0], false)
        NBKAssertSuccinctUnsignedInteger([~1, ~2, ~3, ~0], [~1, ~2, ~3, ~0], false)
        NBKAssertSuccinctUnsignedInteger([~1, ~2, ~3, ~4], [~1, ~2, ~3, ~4], false)
    }
}

//*============================================================================*
// MARK: * NBK x Complements x Assertions
//*============================================================================*

private func NBKAssertSuccinctSignedInteger(
_ source: [UInt], _ body: [UInt], _ sign: Bool,
file: StaticString = #file, line: UInt = #line) {
    source.withUnsafeBufferPointer {
        XCTAssertEqual(      NBK.succinctSignedInteger($0).sign,  sign, file: file, line: line)
        XCTAssertEqual(Array(NBK.succinctSignedInteger($0).body), body, file: file, line: line)
    }
}

private func NBKAssertSuccinctUnsignedInteger(
_ source: [UInt], _ body: [UInt], _ sign: Bool,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(sign, false, file: file, line: line)
    source.withUnsafeBufferPointer {
        XCTAssert(           NBK.succinctUnsignedInteger($0).sign ==  (), file: file, line: line)
        XCTAssertEqual(Array(NBK.succinctUnsignedInteger($0).body), body, file: file, line: line)
    }
}

#endif
