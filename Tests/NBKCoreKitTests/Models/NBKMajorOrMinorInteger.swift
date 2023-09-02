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
// MARK: * NBK x Major Or Minor Integer 
//*============================================================================*

final class NBKMajorOrMinorIntegerTests: XCTestCase {
    
    private typealias S64 = [Int64]
    private typealias S32 = [Int32]
    
    private typealias T = NBKMajorOrMinorInteger
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt32AsUInt32() {
        NBKAssertMajorOrMinorInteger([              ] as S32, [              ] as S32)
        NBKAssertMajorOrMinorInteger([ 1            ] as S32, [ 1            ] as S32)
        NBKAssertMajorOrMinorInteger([ 1,  2        ] as S32, [ 1,  2        ] as S32)
        NBKAssertMajorOrMinorInteger([ 1,  2,  3    ] as S32, [ 1,  2,  3    ] as S32)
        NBKAssertMajorOrMinorInteger([ 1,  2,  3,  4] as S32, [ 1,  2,  3,  4] as S32)
        
        NBKAssertMajorOrMinorInteger([              ] as S32, [              ] as S32)
        NBKAssertMajorOrMinorInteger([~1            ] as S32, [~1            ] as S32)
        NBKAssertMajorOrMinorInteger([~1, ~2        ] as S32, [~1, ~2        ] as S32)
        NBKAssertMajorOrMinorInteger([~1, ~2, ~3    ] as S32, [~1, ~2, ~3    ] as S32)
        NBKAssertMajorOrMinorInteger([~1, ~2, ~3, ~4] as S32, [~1, ~2, ~3, ~4] as S32)
    }
    
    func testUInt32AsUInt64() {
        NBKAssertMajorOrMinorInteger([                              ] as S32, [              ] as S64)
        NBKAssertMajorOrMinorInteger([ 1,  0                        ] as S32, [ 1            ] as S64)
        NBKAssertMajorOrMinorInteger([ 1,  0,  2,  0                ] as S32, [ 1,  2        ] as S64)
        NBKAssertMajorOrMinorInteger([ 1,  0,  2,  0,  3,  0        ] as S32, [ 1,  2,  3    ] as S64)
        NBKAssertMajorOrMinorInteger([ 1,  0,  2,  0,  3,  0,  4,  0] as S32, [ 1,  2,  3,  4] as S64)
        
        NBKAssertMajorOrMinorInteger([                              ] as S32, [              ] as S64)
        NBKAssertMajorOrMinorInteger([~1, ~0                        ] as S32, [~1            ] as S64)
        NBKAssertMajorOrMinorInteger([~1, ~0, ~2, ~0                ] as S32, [~1, ~2        ] as S64)
        NBKAssertMajorOrMinorInteger([~1, ~0, ~2, ~0, ~3, ~0        ] as S32, [~1, ~2, ~3    ] as S64)
        NBKAssertMajorOrMinorInteger([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as S32, [~1, ~2, ~3, ~4] as S64)
    }
    
    func testUInt64AsUInt64() {
        NBKAssertMajorOrMinorInteger([              ] as S64, [              ] as S64)
        NBKAssertMajorOrMinorInteger([ 1            ] as S64, [ 1            ] as S64)
        NBKAssertMajorOrMinorInteger([ 1,  2        ] as S64, [ 1,  2        ] as S64)
        NBKAssertMajorOrMinorInteger([ 1,  2,  3    ] as S64, [ 1,  2,  3    ] as S64)
        NBKAssertMajorOrMinorInteger([ 1,  2,  3,  4] as S64, [ 1,  2,  3,  4] as S64)
        
        NBKAssertMajorOrMinorInteger([              ] as S64, [              ] as S64)
        NBKAssertMajorOrMinorInteger([~1            ] as S64, [~1            ] as S64)
        NBKAssertMajorOrMinorInteger([~1, ~2        ] as S64, [~1, ~2        ] as S64)
        NBKAssertMajorOrMinorInteger([~1, ~2, ~3    ] as S64, [~1, ~2, ~3    ] as S64)
        NBKAssertMajorOrMinorInteger([~1, ~2, ~3, ~4] as S64, [~1, ~2, ~3, ~4] as S64)
    }
    
    func testUInt64AsUInt32() {
        NBKAssertMajorOrMinorInteger([              ] as S64, [                              ] as S32)
        NBKAssertMajorOrMinorInteger([ 1            ] as S64, [ 1,  0                        ] as S32)
        NBKAssertMajorOrMinorInteger([ 1,  2        ] as S64, [ 1,  0,  2,  0                ] as S32)
        NBKAssertMajorOrMinorInteger([ 1,  2,  3    ] as S64, [ 1,  0,  2,  0,  3,  0        ] as S32)
        NBKAssertMajorOrMinorInteger([ 1,  2,  3,  4] as S64, [ 1,  0,  2,  0,  3,  0,  4,  0] as S32)
        
        NBKAssertMajorOrMinorInteger([              ] as S64, [                              ] as S32)
        NBKAssertMajorOrMinorInteger([~1            ] as S64, [~1, ~0                        ] as S32)
        NBKAssertMajorOrMinorInteger([~1, ~2        ] as S64, [~1, ~0, ~2, ~0                ] as S32)
        NBKAssertMajorOrMinorInteger([~1, ~2, ~3    ] as S64, [~1, ~0, ~2, ~0, ~3, ~0        ] as S32)
        NBKAssertMajorOrMinorInteger([~1, ~2, ~3, ~4] as S64, [~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as S32)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Count
    //=------------------------------------------------------------------------=
    
    func testUInt32AsUInt64WithCustomCount() {
        XCTAssertEqual([1, 2   ], Array(T([1, 0, 2, 0] as S32, count: nil, as: Int64.self)))
        XCTAssertEqual([       ], Array(T([1, 0, 2, 0] as S32, count: 000, as: Int64.self)))
        XCTAssertEqual([1      ], Array(T([1, 0, 2, 0] as S32, count: 001, as: Int64.self)))
        XCTAssertEqual([1, 2   ], Array(T([1, 0, 2, 0] as S32, count: 002, as: Int64.self)))
        XCTAssertEqual([1, 2, 0], Array(T([1, 0, 2, 0] as S32, count: 003, as: Int64.self)))
    }
    
    func testUInt64AsUInt32WithCustomCount() {
        XCTAssertEqual([1, 0, 2, 0      ], Array(T([1, 2] as S64, count: nil, as: Int32.self)))
        XCTAssertEqual([                ], Array(T([1, 2] as S64, count: 000, as: Int32.self)))
        XCTAssertEqual([1               ], Array(T([1, 2] as S64, count: 001, as: Int32.self)))
        XCTAssertEqual([1, 0            ], Array(T([1, 2] as S64, count: 002, as: Int32.self)))
        XCTAssertEqual([1, 0, 2         ], Array(T([1, 2] as S64, count: 003, as: Int32.self)))
        XCTAssertEqual([1, 0, 2, 0      ], Array(T([1, 2] as S64, count: 004, as: Int32.self)))
        XCTAssertEqual([1, 0, 2, 0, 0   ], Array(T([1, 2] as S64, count: 005, as: Int32.self)))
        XCTAssertEqual([1, 0, 2, 0, 0, 0], Array(T([1, 2] as S64, count: 006, as: Int32.self)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Signed or Unsigned
    //=------------------------------------------------------------------------=
    
    func testSubscriptSignExtension() {
        XCTAssertEqual(T([ 0] as S32, isSigned: false, as: Int32.self)[144],  0)
        XCTAssertEqual(T([ 0] as S32, isSigned: true,  as: Int32.self)[144],  0)
        XCTAssertEqual(T([~0] as S32, isSigned: false, as: Int32.self)[144],  0)
        XCTAssertEqual(T([~0] as S32, isSigned: true,  as: Int32.self)[144], ~0)
        
        XCTAssertEqual(T([ 0] as S32, isSigned: false, as: Int64.self)[144],  0)
        XCTAssertEqual(T([ 0] as S32, isSigned: true,  as: Int64.self)[144],  0)
        XCTAssertEqual(T([~0] as S32, isSigned: false, as: Int64.self)[144],  0)
        XCTAssertEqual(T([~0] as S32, isSigned: true,  as: Int64.self)[144], ~0)
        
        XCTAssertEqual(T([ 0] as S64, isSigned: false, as: Int32.self)[144],  0)
        XCTAssertEqual(T([ 0] as S64, isSigned: true,  as: Int32.self)[144],  0)
        XCTAssertEqual(T([~0] as S64, isSigned: false, as: Int32.self)[144],  0)
        XCTAssertEqual(T([~0] as S64, isSigned: true,  as: Int32.self)[144], ~0)
        
        XCTAssertEqual(T([ 0] as S64, isSigned: false, as: Int64.self)[144],  0)
        XCTAssertEqual(T([ 0] as S64, isSigned: true,  as: Int64.self)[144],  0)
        XCTAssertEqual(T([~0] as S64, isSigned: false, as: Int64.self)[144],  0)
        XCTAssertEqual(T([~0] as S64, isSigned: true,  as: Int64.self)[144], ~0)
    }
    
    func testMajorLimbsFromIncompleteMinorLimbs() {
        NBKAssertMajorOrMinorIntegerOneWay([                          ] as S32, [                       ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerOneWay([ 1                        ] as S32, [ 1                     ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerOneWay([ 1,  0,  2                ] as S32, [ 1,  2                 ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerOneWay([ 1,  0,  2,  0,  3        ] as S32, [ 1,  2,  3             ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerOneWay([ 1,  0,  2,  0,  3,  0,  4] as S32, [ 1,  2,  3,  4         ] as S64, isSigned: true )
        
        NBKAssertMajorOrMinorIntegerOneWay([                          ] as S32, [                       ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerOneWay([~1                        ] as S32, [~1                     ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerOneWay([~1, ~0, ~2                ] as S32, [~1, ~2                 ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerOneWay([~1, ~0, ~2, ~0, ~3        ] as S32, [~1, ~2, ~3             ] as S64, isSigned: true )
        NBKAssertMajorOrMinorIntegerOneWay([~1, ~0, ~2, ~0, ~3, ~0, ~4] as S32, [~1, ~2, ~3, ~4         ] as S64, isSigned: true )
        
        NBKAssertMajorOrMinorIntegerOneWay([                          ] as S32, [                       ] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerOneWay([ 1                        ] as S32, [ 1                     ] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerOneWay([ 1,  0,  2                ] as S32, [ 1,  2                 ] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerOneWay([ 1,  0,  2,  0,  3        ] as S32, [ 1,  2,  3             ] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerOneWay([ 1,  0,  2,  0,  3,  0,  4] as S32, [ 1,  2,  3,  4         ] as S64, isSigned: false)
        
        NBKAssertMajorOrMinorIntegerOneWay([                          ] as S32, [                       ] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerOneWay([~1                        ] as S32, [             0xfffffffe] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerOneWay([~1, ~0, ~2                ] as S32, [~1,          0xfffffffd] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerOneWay([~1, ~0, ~2, ~0, ~3        ] as S32, [~1, ~2,      0xfffffffc] as S64, isSigned: false)
        NBKAssertMajorOrMinorIntegerOneWay([~1, ~0, ~2, ~0, ~3, ~0, ~4] as S32, [~1, ~2, ~3,  0xfffffffb] as S64, isSigned: false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testMajorToMinorComposableReordering() {
        XCTAssertEqual([1, 2, 3, 4], Array(T(([0x0201, 0x0403] as [Int16]),            as: Int8.self)))
        XCTAssertEqual([2, 1, 4, 3], Array(T(([0x0201, 0x0403] as [Int16]).reversed(), as: Int8.self)).reversed())
        XCTAssertEqual([3, 4, 1, 2], Array(T(([0x0201, 0x0403] as [Int16]).reversed(), as: Int8.self)))
        XCTAssertEqual([4, 3, 2, 1], Array(T(([0x0201, 0x0403] as [Int16]),            as: Int8.self)).reversed())
    }
    
    func testMinorToMajorComposableReordering() {
        XCTAssertEqual([0x0201, 0x0403], Array(T(([1, 2, 3, 4] as [Int8]),            as: Int16.self)))
        XCTAssertEqual([0x0102, 0x0304], Array(T(([1, 2, 3, 4] as [Int8]).reversed(), as: Int16.self)).reversed())
        XCTAssertEqual([0x0403, 0x0201], Array(T(([1, 2, 3, 4] as [Int8]),            as: Int16.self)).reversed())
        XCTAssertEqual([0x0304, 0x0102], Array(T(([1, 2, 3, 4] as [Int8]).reversed(), as: Int16.self)))
    }
}

//*============================================================================*
// MARK: * NBK x Major Or Minor Integer  x Assertions
//*============================================================================*

private func NBKAssertMajorOrMinorInteger<A: NBKCoreInteger, B: NBKCoreInteger>(
_ lhs: [A], _ rhs: [B], isSigned: Bool? = nil,
file: StaticString = #file, line: UInt  = #line) {
    
    NBKAssertMajorOrMinorIntegerOneWay(lhs, rhs, isSigned: isSigned, file: file, line: line)
    NBKAssertMajorOrMinorIntegerOneWay(rhs, lhs, isSigned: isSigned, file: file, line: line)
}

private func NBKAssertMajorOrMinorIntegerOneWay<A: NBKCoreInteger, B: NBKCoreInteger>(
_ lhs: [A], _ rhs: [B], isSigned: Bool? = nil,
file: StaticString = #file, line: UInt  = #line) {
    typealias T = NBKMajorOrMinorInteger
    //=------------------------------------------=
    let lhsUnsigned = lhs.map(A.Magnitude.init(bitPattern:))
    let rhsUnsigned = rhs.map(B.Magnitude.init(bitPattern:))
    //=------------------------------------------=
    func with(isSigned: Bool) {
        do {
            XCTAssertEqual(Array(T.init (lhs,         isSigned: isSigned)), rhs,         file: file, line: line)
            XCTAssertEqual(Array(T.init (lhsUnsigned, isSigned: isSigned)), rhsUnsigned, file: file, line: line)
        };  if B.bitWidth >= A.bitWidth {
            XCTAssertEqual(Array(T.Major(lhs,         isSigned: isSigned)), rhs,         file: file, line: line)
            XCTAssertEqual(Array(T.Major(lhsUnsigned, isSigned: isSigned)), rhsUnsigned, file: file, line: line)
        };  if B.bitWidth <= A.bitWidth {
            XCTAssertEqual(Array(T.Minor(lhs,         isSigned: isSigned)), rhs,         file: file, line: line)
            XCTAssertEqual(Array(T.Minor(lhsUnsigned, isSigned: isSigned)), rhsUnsigned, file: file, line: line)
        }
    }
    //=------------------------------------------=
    if isSigned == nil || isSigned == true  { with(isSigned: true ) }
    if isSigned == nil || isSigned == false { with(isSigned: false) }
}

#endif
