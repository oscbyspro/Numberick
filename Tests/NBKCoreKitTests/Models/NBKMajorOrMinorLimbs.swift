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
// MARK: * NBK x Major Or Minor Integer Limbs
//*============================================================================*

final class NBKMajorOrMinorIntegerLimbsTests: XCTestCase {
    
    private typealias S64 = [Int64]
    private typealias S32 = [Int32]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt32AsUInt32() {
        NBKAssertMajorOrMinorIntegerLimbs([              ] as S32, [              ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([ 1            ] as S32, [ 1            ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  2        ] as S32, [ 1,  2        ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  2,  3    ] as S32, [ 1,  2,  3    ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  2,  3,  4] as S32, [ 1,  2,  3,  4] as S32)
        
        NBKAssertMajorOrMinorIntegerLimbs([              ] as S32, [              ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([~1            ] as S32, [~1            ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~2        ] as S32, [~1, ~2        ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~2, ~3    ] as S32, [~1, ~2, ~3    ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~2, ~3, ~4] as S32, [~1, ~2, ~3, ~4] as S32)
    }
    
    func testUInt32AsUInt64() {
        NBKAssertMajorOrMinorIntegerLimbs([                              ] as S32, [              ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  0                        ] as S32, [ 1            ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  0,  2,  0                ] as S32, [ 1,  2        ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  0,  2,  0,  3,  0        ] as S32, [ 1,  2,  3    ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  0,  2,  0,  3,  0,  4,  0] as S32, [ 1,  2,  3,  4] as S64)
        
        NBKAssertMajorOrMinorIntegerLimbs([                              ] as S32, [              ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~0                        ] as S32, [~1            ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~0, ~2, ~0                ] as S32, [~1, ~2        ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~0, ~2, ~0, ~3, ~0        ] as S32, [~1, ~2, ~3    ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as S32, [~1, ~2, ~3, ~4] as S64)
    }
    
    func testUInt64AsUInt64() {
        NBKAssertMajorOrMinorIntegerLimbs([              ] as S64, [              ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([ 1            ] as S64, [ 1            ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  2        ] as S64, [ 1,  2        ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  2,  3    ] as S64, [ 1,  2,  3    ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  2,  3,  4] as S64, [ 1,  2,  3,  4] as S64)
        
        NBKAssertMajorOrMinorIntegerLimbs([              ] as S64, [              ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([~1            ] as S64, [~1            ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~2        ] as S64, [~1, ~2        ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~2, ~3    ] as S64, [~1, ~2, ~3    ] as S64)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~2, ~3, ~4] as S64, [~1, ~2, ~3, ~4] as S64)
    }
    
    func testUInt64AsUInt32() {
        NBKAssertMajorOrMinorIntegerLimbs([              ] as S64, [                              ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([ 1            ] as S64, [ 1,  0                        ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  2        ] as S64, [ 1,  0,  2,  0                ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  2,  3    ] as S64, [ 1,  0,  2,  0,  3,  0        ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([ 1,  2,  3,  4] as S64, [ 1,  0,  2,  0,  3,  0,  4,  0] as S32)
        
        NBKAssertMajorOrMinorIntegerLimbs([              ] as S64, [                              ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([~1            ] as S64, [~1, ~0                        ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~2        ] as S64, [~1, ~0, ~2, ~0                ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~2, ~3    ] as S64, [~1, ~0, ~2, ~0, ~3, ~0        ] as S32)
        NBKAssertMajorOrMinorIntegerLimbs([~1, ~2, ~3, ~4] as S64, [~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as S32)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Signed or Unsigned
    //=------------------------------------------------------------------------=
    
    func testMajorLimbsFromIncompleteMinorLimbs() {
        NBKAssertMajorOrMinorIntegerLimbsOneWay([                          ] as S32, [                       ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerLimbsOneWay([ 1                        ] as S32, [ 1                     ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerLimbsOneWay([ 1,  0,  2                ] as S32, [ 1,  2                 ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerLimbsOneWay([ 1,  0,  2,  0,  3        ] as S32, [ 1,  2,  3             ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerLimbsOneWay([ 1,  0,  2,  0,  3,  0,  4] as S32, [ 1,  2,  3,  4         ] as S64, isSigned: true )
        
        NBKAssertMajorOrMinorIntegerLimbsOneWay([                          ] as S32, [                       ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerLimbsOneWay([~1                        ] as S32, [~1                     ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerLimbsOneWay([~1, ~0, ~2                ] as S32, [~1, ~2                 ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerLimbsOneWay([~1, ~0, ~2, ~0, ~3        ] as S32, [~1, ~2, ~3             ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerLimbsOneWay([~1, ~0, ~2, ~0, ~3, ~0, ~4] as S32, [~1, ~2, ~3, ~4         ] as S64, isSigned: true )
        
        NBKAssertMajorOrMinorIntegerLimbsOneWay([                          ] as S32, [                       ] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerLimbsOneWay([ 1                        ] as S32, [ 1                     ] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerLimbsOneWay([ 1,  0,  2                ] as S32, [ 1,  2                 ] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerLimbsOneWay([ 1,  0,  2,  0,  3        ] as S32, [ 1,  2,  3             ] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerLimbsOneWay([ 1,  0,  2,  0,  3,  0,  4] as S32, [ 1,  2,  3,  4         ] as S64, isSigned: false)
        
        NBKAssertMajorOrMinorIntegerLimbsOneWay([                          ] as S32, [                       ] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerLimbsOneWay([~1                        ] as S32, [             0xfffffffe] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerLimbsOneWay([~1, ~0, ~2                ] as S32, [~1,          0xfffffffd] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerLimbsOneWay([~1, ~0, ~2, ~0, ~3        ] as S32, [~1, ~2,      0xfffffffc] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerLimbsOneWay([~1, ~0, ~2, ~0, ~3, ~0, ~4] as S32, [~1, ~2, ~3,  0xfffffffb] as S64, isSigned: false)
    }
}

//*============================================================================*
// MARK: * NBK x Major Or Minor Integer Limbs x Assertions
//*============================================================================*

private func NBKAssertMajorOrMinorIntegerLimbs<A: NBKCoreInteger, B: NBKCoreInteger>(
_ lhs: [A], _ rhs: [B], isSigned: Bool? = nil,
file: StaticString = #file, line: UInt  = #line) {
    
    NBKAssertMajorOrMinorIntegerLimbsOneWay(lhs, rhs, isSigned: isSigned)
    NBKAssertMajorOrMinorIntegerLimbsOneWay(rhs, lhs, isSigned: isSigned)
}

private func NBKAssertMajorOrMinorIntegerLimbsOneWay<A: NBKCoreInteger, B: NBKCoreInteger>(
_ lhs: [A], _ rhs: [B], isSigned: Bool? = nil,
file: StaticString = #file, line: UInt  = #line) {
    //=------------------------------------------=
    typealias X = Array
    typealias Y = ContiguousArray
    typealias T = NBKMajorOrMinorIntegerLimbs
    //=------------------------------------------=
    let lhsUnsigned = lhs.map(A.Magnitude.init(bitPattern:))
    let rhsUnsigned = rhs.map(B.Magnitude.init(bitPattern:))
    //=------------------------------------------=
    if  isSigned == nil || isSigned == true {
        XCTAssertEqual(X(T(X(lhs),         isSigned: true )), X(rhs),         file: file, line: line)
        XCTAssertEqual(X(T(X(lhsUnsigned), isSigned: true )), X(rhsUnsigned), file: file, line: line)
        XCTAssertEqual(Y(T(Y(lhs),         isSigned: true )), Y(rhs),         file: file, line: line)
        XCTAssertEqual(Y(T(Y(lhsUnsigned), isSigned: true )), Y(rhsUnsigned), file: file, line: line)
    }
    
    if  isSigned == nil || isSigned == false {
        XCTAssertEqual(X(T(X(lhs),         isSigned: false)), X(rhs),         file: file, line: line)
        XCTAssertEqual(X(T(X(lhsUnsigned), isSigned: false)), X(rhsUnsigned), file: file, line: line)
        XCTAssertEqual(Y(T(Y(lhs),         isSigned: false)), Y(rhs),         file: file, line: line)
        XCTAssertEqual(Y(T(Y(lhsUnsigned), isSigned: false)), Y(rhsUnsigned), file: file, line: line)
    }
}

#endif
