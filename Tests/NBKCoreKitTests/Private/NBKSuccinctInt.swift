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

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Succinct Int
//*============================================================================*

final class NBKSuccinctIntTests: XCTestCase {
    
    typealias T = NBK.SuccinctInt<[UInt]>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsValid() {
        NBKAssertIsValid([      ] as X, true,  true )
        NBKAssertIsValid([      ] as X, false, true )
        
        NBKAssertIsValid([ 0,  1] as X, true,  true )
        NBKAssertIsValid([ 0,  1] as X, false, true )
        NBKAssertIsValid([~0, ~1] as X, true,  true )
        NBKAssertIsValid([~0, ~1] as X, false, true )
        
        NBKAssertIsValid([ 1,  0] as X, true,  true )
        NBKAssertIsValid([ 1,  0] as X, false, false)
        NBKAssertIsValid([~1, ~0] as X, true,  false)
        NBKAssertIsValid([~1, ~0] as X, false, true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromStrictSignedInteger() {
        NBKAssertFromStrictSignedIntegerSubSequence([   0,  0,  0,  0] as X, [              ] as X, false)
        NBKAssertFromStrictSignedIntegerSubSequence([   1,  0,  0,  0] as X, [ 1            ] as X, false)
        NBKAssertFromStrictSignedIntegerSubSequence([   1,  2,  0,  0] as X, [ 1,  2        ] as X, false)
        NBKAssertFromStrictSignedIntegerSubSequence([   1,  2,  3,  0] as X, [ 1,  2,  3    ] as X, false)
        NBKAssertFromStrictSignedIntegerSubSequence([   1,  2,  3,  4] as X, [ 1,  2,  3,  4] as X, false)
        
        NBKAssertFromStrictSignedIntegerSubSequence([  ~0, ~0, ~0, ~0] as X, [              ] as X, true )
        NBKAssertFromStrictSignedIntegerSubSequence([  ~1, ~0, ~0, ~0] as X, [~1            ] as X, true )
        NBKAssertFromStrictSignedIntegerSubSequence([  ~1, ~2, ~0, ~0] as X, [~1, ~2        ] as X, true )
        NBKAssertFromStrictSignedIntegerSubSequence([  ~1, ~2, ~3, ~0] as X, [~1, ~2, ~3    ] as X, true )
        NBKAssertFromStrictSignedIntegerSubSequence([  ~1, ~2, ~3, ~4] as X, [~1, ~2, ~3, ~4] as X, true )
    }
    
    func testFromStrictSignedIntegerThatIsEmptyReturnsNil() {
        NBKAssertFromStrictSignedIntegerSubSequence(X(), nil, nil)
    }
    
    func testFromStrictUnsignedIntegerSubSequence() {
        NBKAssertFromStrictUnsignedIntegerSubSequence([ 0,  0,  0,  0] as X, [              ] as X, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([ 1,  0,  0,  0] as X, [ 1            ] as X, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([ 1,  2,  0,  0] as X, [ 1,  2        ] as X, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([ 1,  2,  3,  0] as X, [ 1,  2,  3    ] as X, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([ 1,  2,  3,  4] as X, [ 1,  2,  3,  4] as X, false)
        
        NBKAssertFromStrictUnsignedIntegerSubSequence([~0, ~0, ~0, ~0] as X, [~0, ~0, ~0, ~0] as X, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([~1, ~0, ~0, ~0] as X, [~1, ~0, ~0, ~0] as X, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([~1, ~2, ~0, ~0] as X, [~1, ~2, ~0, ~0] as X, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([~1, ~2, ~3, ~0] as X, [~1, ~2, ~3, ~0] as X, false)
        NBKAssertFromStrictUnsignedIntegerSubSequence([~1, ~2, ~3, ~4] as X, [~1, ~2, ~3, ~4] as X, false)
    }
    
    func testFromStrictUnsignedIntegerSubSequenceThatIsEmptyReturnsZero() {
        NBKAssertFromStrictUnsignedIntegerSubSequence(X(), X(), false)
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
