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
// MARK: * NBK x Succinct Int x Components
//*============================================================================*

final class NBKSuccinctIntTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromStrictSignedInteger() {
        NBKAssertFromStrictSignedInteger([   0,  0,  0,  0] as W, [              ] as W, false)
        NBKAssertFromStrictSignedInteger([   1,  0,  0,  0] as W, [ 1            ] as W, false)
        NBKAssertFromStrictSignedInteger([   1,  2,  0,  0] as W, [ 1,  2        ] as W, false)
        NBKAssertFromStrictSignedInteger([   1,  2,  3,  0] as W, [ 1,  2,  3    ] as W, false)
        NBKAssertFromStrictSignedInteger([   1,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, false)
        
        NBKAssertFromStrictSignedInteger([  ~0, ~0, ~0, ~0] as W, [              ] as W, true )
        NBKAssertFromStrictSignedInteger([  ~1, ~0, ~0, ~0] as W, [~1            ] as W, true )
        NBKAssertFromStrictSignedInteger([  ~1, ~2, ~0, ~0] as W, [~1, ~2        ] as W, true )
        NBKAssertFromStrictSignedInteger([  ~1, ~2, ~3, ~0] as W, [~1, ~2, ~3    ] as W, true )
        NBKAssertFromStrictSignedInteger([  ~1, ~2, ~3, ~4] as W, [~1, ~2, ~3, ~4] as W, true )
    }
    
    func testFromStrictSignedIntegerThatIsEmptyReturnsNil() {
        NBKAssertFromStrictSignedInteger(W(), nil, nil)
    }
    
    func testFromStrictUnsignedIntegerSubSequence() {
        NBKAssertFromStrictUnsignedIntegerSubSequence([ 0,  0,  0,  0] as W, [              ] as W, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([ 1,  0,  0,  0] as W, [ 1            ] as W, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([ 1,  2,  0,  0] as W, [ 1,  2        ] as W, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([ 1,  2,  3,  0] as W, [ 1,  2,  3    ] as W, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([ 1,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, false)
        
        NBKAssertFromStrictUnsignedIntegerSubSequence([~0, ~0, ~0, ~0] as W, [~0, ~0, ~0, ~0] as W, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([~1, ~0, ~0, ~0] as W, [~1, ~0, ~0, ~0] as W, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([~1, ~2, ~0, ~0] as W, [~1, ~2, ~0, ~0] as W, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([~1, ~2, ~3, ~0] as W, [~1, ~2, ~3, ~0] as W, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([~1, ~2, ~3, ~4] as W, [~1, ~2, ~3, ~4] as W, false)
    }
    
    func testFromStrictUnsignedIntegerSubSequenceThatIsEmptyReturnsZero() {
        NBKAssertFromStrictUnsignedIntegerSubSequence(W(), W(), false)
    }
}

//*============================================================================*
// MARK: * NBK x Succinct Int x Assertions
//*============================================================================*

private func NBKAssertFromStrictSignedInteger(
_ source: [UInt], _ body: [UInt]?, _ sign: Bool?,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SuccinctInt<UnsafeBufferPointer<UInt>>
    //=------------------------------------------=
    source.withUnsafeBufferPointer {
        XCTAssertEqual(T(fromStrictSignedInteger: $0)?.sign,                   sign, file: file, line: line)
        XCTAssertEqual(T(fromStrictSignedInteger: $0).map({ Array($0.body) }), body, file: file, line: line)
    }
}

private func NBKAssertFromStrictUnsignedIntegerSubSequence(
_ source: [UInt], _ body: [UInt], _ sign: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SuccinctInt<UnsafeBufferPointer<UInt>>
    //=------------------------------------------=
    XCTAssertEqual(sign, false, file: file, line: line)
    source.withUnsafeBufferPointer {
        XCTAssertEqual(      T(fromStrictUnsignedIntegerSubSequence: $0).sign,  sign, file: file, line: line)
        XCTAssertEqual(Array(T(fromStrictUnsignedIntegerSubSequence: $0).body), body, file: file, line: line)
    }
}

#endif
