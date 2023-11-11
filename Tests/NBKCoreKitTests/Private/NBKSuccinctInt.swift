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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Succinct Int
//*============================================================================*

final class NBKSuccinctIntTests: XCTestCase {
    
    typealias T = NBK.SuccinctInt<[UInt]>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsValid() {
        NBKAssertIsValid([      ] as W, true,  true )
        NBKAssertIsValid([      ] as W, false, true )
        
        NBKAssertIsValid([ 0,  1] as W, true,  true )
        NBKAssertIsValid([ 0,  1] as W, false, true )
        NBKAssertIsValid([~0, ~1] as W, true,  true )
        NBKAssertIsValid([~0, ~1] as W, false, true )
        
        NBKAssertIsValid([ 1,  0] as W, true,  true )
        NBKAssertIsValid([ 1,  0] as W, false, false)
        NBKAssertIsValid([~1, ~0] as W, true,  false)
        NBKAssertIsValid([~1, ~0] as W, false, true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromStrictSignedInteger() {
        NBKAssertFromStrictSignedIntegerSubSequence([   0,  0,  0,  0] as W, [              ] as W, false)
        NBKAssertFromStrictSignedIntegerSubSequence([   1,  0,  0,  0] as W, [ 1            ] as W, false)
        NBKAssertFromStrictSignedIntegerSubSequence([   1,  2,  0,  0] as W, [ 1,  2        ] as W, false)
        NBKAssertFromStrictSignedIntegerSubSequence([   1,  2,  3,  0] as W, [ 1,  2,  3    ] as W, false)
        NBKAssertFromStrictSignedIntegerSubSequence([   1,  2,  3,  4] as W, [ 1,  2,  3,  4] as W, false)
        
        NBKAssertFromStrictSignedIntegerSubSequence([  ~0, ~0, ~0, ~0] as W, [              ] as W, true )
        NBKAssertFromStrictSignedIntegerSubSequence([  ~1, ~0, ~0, ~0] as W, [~1            ] as W, true )
        NBKAssertFromStrictSignedIntegerSubSequence([  ~1, ~2, ~0, ~0] as W, [~1, ~2        ] as W, true )
        NBKAssertFromStrictSignedIntegerSubSequence([  ~1, ~2, ~3, ~0] as W, [~1, ~2, ~3    ] as W, true )
        NBKAssertFromStrictSignedIntegerSubSequence([  ~1, ~2, ~3, ~4] as W, [~1, ~2, ~3, ~4] as W, true )
    }
    
    func testFromStrictSignedIntegerThatIsEmptyReturnsNil() {
        NBKAssertFromStrictSignedIntegerSubSequence(W(), nil, nil)
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

private func NBKAssertIsValid(
_ body: [UInt], _ sign: Bool, _ success: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SuccinctInt
    //=------------------------------------------=
    XCTAssertEqual(T.validate(body, sign: sign), success, file: file, line: line)
    //=------------------------------------------=
    if  success {
        XCTAssertNotNil(T(           body, sign: sign), file: file, line: line)
        XCTAssertNotNil(T(unchecked: body, sign: sign), file: file, line: line)
    }
}

private func NBKAssertFromStrictSignedIntegerSubSequence(
_ source: [UInt], _ body: [UInt]?, _ sign: Bool?,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SuccinctInt
    //=------------------------------------------=
    var source = source
    //=------------------------------------------=
    brr: do {
        XCTAssertEqual(T(fromStrictSignedIntegerSubSequence: source).map({       $0.sign  }), sign, file: file, line: line)
        XCTAssertEqual(T(fromStrictSignedIntegerSubSequence: source).map({ Array($0.body) }), body, file: file, line: line)
    }
    
    source.withUnsafeBufferPointer { source in
        XCTAssertEqual(T(fromStrictSignedIntegerSubSequence: source).map({       $0.sign  }), sign, file: file, line: line)
        XCTAssertEqual(T(fromStrictSignedIntegerSubSequence: source).map({ Array($0.body) }), body, file: file, line: line)
    }
    
    source.withUnsafeBufferPointer { source in
        XCTAssertEqual(T(fromStrictSignedIntegerSubSequence: source).map(T.init(rebasing:)).map({       $0.sign  }), sign, file: file, line: line)
        XCTAssertEqual(T(fromStrictSignedIntegerSubSequence: source).map(T.init(rebasing:)).map({ Array($0.body) }), body, file: file, line: line)
    }
    
    source.withUnsafeMutableBufferPointer { source in
        XCTAssertEqual(T(fromStrictSignedIntegerSubSequence: source).map({       $0.sign  }), sign, file: file, line: line)
        XCTAssertEqual(T(fromStrictSignedIntegerSubSequence: source).map({ Array($0.body) }), body, file: file, line: line)
    }
    
    source.withUnsafeMutableBufferPointer { source in
        XCTAssertEqual(T(fromStrictSignedIntegerSubSequence: source).map(T.init(rebasing:)).map({       $0.sign  }), sign, file: file, line: line)
        XCTAssertEqual(T(fromStrictSignedIntegerSubSequence: source).map(T.init(rebasing:)).map({ Array($0.body) }), body, file: file, line: line)
    }
}

private func NBKAssertFromStrictUnsignedIntegerSubSequence(
_ source: [UInt], _ body: [UInt], _ sign: Bool,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBK.SuccinctInt
    //=------------------------------------------=
    var source = source
    //=------------------------------------------=
    XCTAssertEqual(sign, false, file: file, line: line)
    
    brr: do {
        XCTAssertEqual(      T(fromStrictUnsignedIntegerSubSequence: source).sign,  sign, file: file, line: line)
        XCTAssertEqual(Array(T(fromStrictUnsignedIntegerSubSequence: source).body), body, file: file, line: line)
    }
    
    source.withUnsafeBufferPointer { source in
        XCTAssertEqual(      T(fromStrictUnsignedIntegerSubSequence: source).sign,  sign, file: file, line: line)
        XCTAssertEqual(Array(T(fromStrictUnsignedIntegerSubSequence: source).body), body, file: file, line: line)
    }
    
    source.withUnsafeBufferPointer { source in
        XCTAssertEqual(      T(rebasing: T(fromStrictUnsignedIntegerSubSequence: source)).sign,  sign, file: file, line: line)
        XCTAssertEqual(Array(T(rebasing: T(fromStrictUnsignedIntegerSubSequence: source)).body), body, file: file, line: line)
    }
    
    source.withUnsafeMutableBufferPointer { source in
        XCTAssertEqual(      T(fromStrictUnsignedIntegerSubSequence: source).sign,  sign, file: file, line: line)
        XCTAssertEqual(Array(T(fromStrictUnsignedIntegerSubSequence: source).body), body, file: file, line: line)
    }
    
    source.withUnsafeMutableBufferPointer { source in
        XCTAssertEqual(      T(rebasing: T(fromStrictUnsignedIntegerSubSequence: source)).sign,  sign, file: file, line: line)
        XCTAssertEqual(Array(T(rebasing: T(fromStrictUnsignedIntegerSubSequence: source)).body), body, file: file, line: line)
    }
}
