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
// MARK: * NBK x Limbs
//*============================================================================*

final class NBKTestsOnLimbs: XCTestCase {
    
    private typealias S64 = [Int64]
    private typealias S32 = [Int32]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt32AsUInt32() {
        NBKAssertLimbs([              ] as S32, [              ] as S32)
        NBKAssertLimbs([ 1            ] as S32, [ 1            ] as S32)
        NBKAssertLimbs([ 1,  2        ] as S32, [ 1,  2        ] as S32)
        NBKAssertLimbs([ 1,  2,  3    ] as S32, [ 1,  2,  3    ] as S32)
        NBKAssertLimbs([ 1,  2,  3,  4] as S32, [ 1,  2,  3,  4] as S32)
        
        NBKAssertLimbs([              ] as S32, [              ] as S32)
        NBKAssertLimbs([~1            ] as S32, [~1            ] as S32)
        NBKAssertLimbs([~1, ~2        ] as S32, [~1, ~2        ] as S32)
        NBKAssertLimbs([~1, ~2, ~3    ] as S32, [~1, ~2, ~3    ] as S32)
        NBKAssertLimbs([~1, ~2, ~3, ~4] as S32, [~1, ~2, ~3, ~4] as S32)
    }
    
    func testUInt32AsUInt64() {
        NBKAssertLimbs([                              ] as S32, [              ] as S64)
        NBKAssertLimbs([ 1,  0                        ] as S32, [ 1            ] as S64)
        NBKAssertLimbs([ 1,  0,  2,  0                ] as S32, [ 1,  2        ] as S64)
        NBKAssertLimbs([ 1,  0,  2,  0,  3,  0        ] as S32, [ 1,  2,  3    ] as S64)
        NBKAssertLimbs([ 1,  0,  2,  0,  3,  0,  4,  0] as S32, [ 1,  2,  3,  4] as S64)
        
        NBKAssertLimbs([                              ] as S32, [              ] as S64)
        NBKAssertLimbs([~1, ~0                        ] as S32, [~1            ] as S64)
        NBKAssertLimbs([~1, ~0, ~2, ~0                ] as S32, [~1, ~2        ] as S64)
        NBKAssertLimbs([~1, ~0, ~2, ~0, ~3, ~0        ] as S32, [~1, ~2, ~3    ] as S64)
        NBKAssertLimbs([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as S32, [~1, ~2, ~3, ~4] as S64)
    }
    
    func testUInt64AsUInt64() {
        NBKAssertLimbs([              ] as S64, [              ] as S64)
        NBKAssertLimbs([ 1            ] as S64, [ 1            ] as S64)
        NBKAssertLimbs([ 1,  2        ] as S64, [ 1,  2        ] as S64)
        NBKAssertLimbs([ 1,  2,  3    ] as S64, [ 1,  2,  3    ] as S64)
        NBKAssertLimbs([ 1,  2,  3,  4] as S64, [ 1,  2,  3,  4] as S64)
        
        NBKAssertLimbs([              ] as S64, [              ] as S64)
        NBKAssertLimbs([~1            ] as S64, [~1            ] as S64)
        NBKAssertLimbs([~1, ~2        ] as S64, [~1, ~2        ] as S64)
        NBKAssertLimbs([~1, ~2, ~3    ] as S64, [~1, ~2, ~3    ] as S64)
        NBKAssertLimbs([~1, ~2, ~3, ~4] as S64, [~1, ~2, ~3, ~4] as S64)
    }
    
    func testUInt64AsUInt32() {
        NBKAssertLimbs([              ] as S64, [                              ] as S32)
        NBKAssertLimbs([ 1            ] as S64, [ 1,  0                        ] as S32)
        NBKAssertLimbs([ 1,  2        ] as S64, [ 1,  0,  2,  0                ] as S32)
        NBKAssertLimbs([ 1,  2,  3    ] as S64, [ 1,  0,  2,  0,  3,  0        ] as S32)
        NBKAssertLimbs([ 1,  2,  3,  4] as S64, [ 1,  0,  2,  0,  3,  0,  4,  0] as S32)
        
        NBKAssertLimbs([              ] as S64, [                              ] as S32)
        NBKAssertLimbs([~1            ] as S64, [~1, ~0                        ] as S32)
        NBKAssertLimbs([~1, ~2        ] as S64, [~1, ~0, ~2, ~0                ] as S32)
        NBKAssertLimbs([~1, ~2, ~3    ] as S64, [~1, ~0, ~2, ~0, ~3, ~0        ] as S32)
        NBKAssertLimbs([~1, ~2, ~3, ~4] as S64, [~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as S32)
    }
    
    func testMajorLimbsFromMinorLimbsSubsequence() {
        NBKAssertLimbsSubsequence([                              ] as S32, [                       ] as S64, isSigned: true )
        NBKAssertLimbsSubsequence([ 1                            ] as S32, [ 1                     ] as S64, isSigned: true )
        NBKAssertLimbsSubsequence([ 1,  0,  2                    ] as S32, [ 1,  2                 ] as S64, isSigned: true )
        NBKAssertLimbsSubsequence([ 1,  0,  2,  0,  3            ] as S32, [ 1,  2,  3             ] as S64, isSigned: true )
        NBKAssertLimbsSubsequence([ 1,  0,  2,  0,  3,  0,  4    ] as S32, [ 1,  2,  3,  4         ] as S64, isSigned: true )

        NBKAssertLimbsSubsequence([                              ] as S32, [                       ] as S64, isSigned: true )
        NBKAssertLimbsSubsequence([~1                            ] as S32, [~1                     ] as S64, isSigned: true )
        NBKAssertLimbsSubsequence([~1, ~0, ~2                    ] as S32, [~1, ~2                 ] as S64, isSigned: true )
        NBKAssertLimbsSubsequence([~1, ~0, ~2, ~0, ~3            ] as S32, [~1, ~2, ~3             ] as S64, isSigned: true )
        NBKAssertLimbsSubsequence([~1, ~0, ~2, ~0, ~3, ~0, ~4    ] as S32, [~1, ~2, ~3, ~4         ] as S64, isSigned: true )

        NBKAssertLimbsSubsequence([                              ] as S32, [                       ] as S64, isSigned: false)
        NBKAssertLimbsSubsequence([ 1                            ] as S32, [ 1                     ] as S64, isSigned: false)
        NBKAssertLimbsSubsequence([ 1,  0,  2                    ] as S32, [ 1,  2                 ] as S64, isSigned: false)
        NBKAssertLimbsSubsequence([ 1,  0,  2,  0,  3            ] as S32, [ 1,  2,  3             ] as S64, isSigned: false)
        NBKAssertLimbsSubsequence([ 1,  0,  2,  0,  3,  0,  4    ] as S32, [ 1,  2,  3,  4         ] as S64, isSigned: false)
                
        NBKAssertLimbsSubsequence([                              ] as S32, [                       ] as S64, isSigned: false)
        NBKAssertLimbsSubsequence([~1                            ] as S32, [             0xfffffffe] as S64, isSigned: false)
        NBKAssertLimbsSubsequence([~1, ~0, ~2                    ] as S32, [~1,          0xfffffffd] as S64, isSigned: false)
        NBKAssertLimbsSubsequence([~1, ~0, ~2, ~0, ~3            ] as S32, [~1, ~2,      0xfffffffc] as S64, isSigned: false)
        NBKAssertLimbsSubsequence([~1, ~0, ~2, ~0, ~3, ~0, ~4    ] as S32, [~1, ~2, ~3,  0xfffffffb] as S64, isSigned: false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Succinct
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

private func NBKAssertLimbs<A: NBKCoreInteger, B: NBKCoreInteger>(
_ lhs: [A], _ rhs: [B], isSigned: Bool? = nil,
file: StaticString = #file, line: UInt  = #line) {
    //=------------------------------------------=
    typealias X<T> = Array<T>
    typealias Y<T> = ContiguousArray<T>
    //=------------------------------------------=
    let lhsUnsigned = lhs.map(A.Magnitude.init(bitPattern:))
    let rhsUnsigned = rhs.map(B.Magnitude.init(bitPattern:))
    //=------------------------------------------=
    if  isSigned == nil || isSigned == true {
        XCTAssertEqual(NBK.limbs( (lhs),         isSigned: true ),  (rhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs( (lhsUnsigned), isSigned: true ),  (rhsUnsigned), file: file, line: line)
        XCTAssertEqual(NBK.limbs(X(lhs),         isSigned: true ), X(rhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs(X(lhsUnsigned), isSigned: true ), X(rhsUnsigned), file: file, line: line)
        XCTAssertEqual(NBK.limbs(Y(lhs),         isSigned: true ), Y(rhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs(Y(lhsUnsigned), isSigned: true ), Y(rhsUnsigned), file: file, line: line)
        
        XCTAssertEqual(NBK.limbs( (rhs),         isSigned: true ),  (lhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs( (rhsUnsigned), isSigned: true ),  (lhsUnsigned), file: file, line: line)
        XCTAssertEqual(NBK.limbs(X(rhs),         isSigned: true ), X(lhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs(X(rhsUnsigned), isSigned: true ), X(lhsUnsigned), file: file, line: line)
        XCTAssertEqual(NBK.limbs(Y(rhs),         isSigned: true ), Y(lhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs(Y(rhsUnsigned), isSigned: true ), Y(lhsUnsigned), file: file, line: line)
    }
    
    if  isSigned == nil || isSigned == false {
        XCTAssertEqual(NBK.limbs( (lhs),         isSigned: true ),  (rhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs( (lhsUnsigned), isSigned: true ),  (rhsUnsigned), file: file, line: line)
        XCTAssertEqual(NBK.limbs(X(lhs),         isSigned: true ), X(rhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs(X(lhsUnsigned), isSigned: true ), X(rhsUnsigned), file: file, line: line)
        XCTAssertEqual(NBK.limbs(Y(lhs),         isSigned: true ), Y(rhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs(Y(lhsUnsigned), isSigned: true ), Y(rhsUnsigned), file: file, line: line)

        XCTAssertEqual(NBK.limbs( (rhs),         isSigned: false),  (lhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs( (rhsUnsigned), isSigned: false),  (lhsUnsigned), file: file, line: line)
        XCTAssertEqual(NBK.limbs(X(rhs),         isSigned: false), X(lhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs(X(rhsUnsigned), isSigned: false), X(lhsUnsigned), file: file, line: line)
        XCTAssertEqual(NBK.limbs(Y(rhs),         isSigned: false), Y(lhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs(Y(rhsUnsigned), isSigned: false), Y(lhsUnsigned), file: file, line: line)
    }
}

private func NBKAssertLimbsSubsequence<A: NBKCoreInteger, B: NBKCoreInteger>(
_ lhs: [A], _ rhs: [B], isSigned: Bool? = nil,
file: StaticString = #file, line: UInt  = #line) {
    //=------------------------------------------=
    typealias X<T> = Array<T>
    typealias Y<T> = ContiguousArray<T>
    //=------------------------------------------=
    let lhsUnsigned = lhs.map(A.Magnitude.init(bitPattern:))
    let rhsUnsigned = rhs.map(B.Magnitude.init(bitPattern:))
    //=------------------------------------------=
    if  isSigned == nil || isSigned == true {
        XCTAssertEqual(NBK.limbs( (lhs),         isSigned: true ),  (rhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs( (lhsUnsigned), isSigned: true ),  (rhsUnsigned), file: file, line: line)
        XCTAssertEqual(NBK.limbs(X(lhs),         isSigned: true ), X(rhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs(X(lhsUnsigned), isSigned: true ), X(rhsUnsigned), file: file, line: line)
        XCTAssertEqual(NBK.limbs(Y(lhs),         isSigned: true ), Y(rhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs(Y(lhsUnsigned), isSigned: true ), Y(rhsUnsigned), file: file, line: line)
    }
    
    if  isSigned == nil || isSigned == false {
        XCTAssertEqual(NBK.limbs( (lhs),         isSigned: false),  (rhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs( (lhsUnsigned), isSigned: false),  (rhsUnsigned), file: file, line: line)
        XCTAssertEqual(NBK.limbs(X(lhs),         isSigned: false), X(rhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs(X(lhsUnsigned), isSigned: false), X(rhsUnsigned), file: file, line: line)
        XCTAssertEqual(NBK.limbs(Y(lhs),         isSigned: false), Y(rhs),         file: file, line: line)
        XCTAssertEqual(NBK.limbs(Y(lhsUnsigned), isSigned: false), Y(rhsUnsigned), file: file, line: line)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Succinct
//=----------------------------------------------------------------------------=

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
