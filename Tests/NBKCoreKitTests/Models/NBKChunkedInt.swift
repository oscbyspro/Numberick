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
// MARK: * NBK x Chunked Int 
//*============================================================================*

final class NBKChunkedIntTests: XCTestCase {
    
    private typealias S64 = [Int64]
    private typealias S32 = [Int32]
    
    private typealias T = NBKChunkedInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt32AsUInt32() {
        NBKAssertChunkedInt([              ] as S32, [              ] as S32)
        NBKAssertChunkedInt([ 1            ] as S32, [ 1            ] as S32)
        NBKAssertChunkedInt([ 1,  2        ] as S32, [ 1,  2        ] as S32)
        NBKAssertChunkedInt([ 1,  2,  3    ] as S32, [ 1,  2,  3    ] as S32)
        NBKAssertChunkedInt([ 1,  2,  3,  4] as S32, [ 1,  2,  3,  4] as S32)
        
        NBKAssertChunkedInt([              ] as S32, [              ] as S32)
        NBKAssertChunkedInt([~1            ] as S32, [~1            ] as S32)
        NBKAssertChunkedInt([~1, ~2        ] as S32, [~1, ~2        ] as S32)
        NBKAssertChunkedInt([~1, ~2, ~3    ] as S32, [~1, ~2, ~3    ] as S32)
        NBKAssertChunkedInt([~1, ~2, ~3, ~4] as S32, [~1, ~2, ~3, ~4] as S32)
    }
    
    func testUInt32AsUInt64() {
        NBKAssertChunkedInt([                              ] as S32, [              ] as S64)
        NBKAssertChunkedInt([ 1,  0                        ] as S32, [ 1            ] as S64)
        NBKAssertChunkedInt([ 1,  0,  2,  0                ] as S32, [ 1,  2        ] as S64)
        NBKAssertChunkedInt([ 1,  0,  2,  0,  3,  0        ] as S32, [ 1,  2,  3    ] as S64)
        NBKAssertChunkedInt([ 1,  0,  2,  0,  3,  0,  4,  0] as S32, [ 1,  2,  3,  4] as S64)
        
        NBKAssertChunkedInt([                              ] as S32, [              ] as S64)
        NBKAssertChunkedInt([~1, ~0                        ] as S32, [~1            ] as S64)
        NBKAssertChunkedInt([~1, ~0, ~2, ~0                ] as S32, [~1, ~2        ] as S64)
        NBKAssertChunkedInt([~1, ~0, ~2, ~0, ~3, ~0        ] as S32, [~1, ~2, ~3    ] as S64)
        NBKAssertChunkedInt([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as S32, [~1, ~2, ~3, ~4] as S64)
    }
    
    func testUInt64AsUInt64() {
        NBKAssertChunkedInt([              ] as S64, [              ] as S64)
        NBKAssertChunkedInt([ 1            ] as S64, [ 1            ] as S64)
        NBKAssertChunkedInt([ 1,  2        ] as S64, [ 1,  2        ] as S64)
        NBKAssertChunkedInt([ 1,  2,  3    ] as S64, [ 1,  2,  3    ] as S64)
        NBKAssertChunkedInt([ 1,  2,  3,  4] as S64, [ 1,  2,  3,  4] as S64)
        
        NBKAssertChunkedInt([              ] as S64, [              ] as S64)
        NBKAssertChunkedInt([~1            ] as S64, [~1            ] as S64)
        NBKAssertChunkedInt([~1, ~2        ] as S64, [~1, ~2        ] as S64)
        NBKAssertChunkedInt([~1, ~2, ~3    ] as S64, [~1, ~2, ~3    ] as S64)
        NBKAssertChunkedInt([~1, ~2, ~3, ~4] as S64, [~1, ~2, ~3, ~4] as S64)
    }
    
    func testUInt64AsUInt32() {
        NBKAssertChunkedInt([              ] as S64, [                              ] as S32)
        NBKAssertChunkedInt([ 1            ] as S64, [ 1,  0                        ] as S32)
        NBKAssertChunkedInt([ 1,  2        ] as S64, [ 1,  0,  2,  0                ] as S32)
        NBKAssertChunkedInt([ 1,  2,  3    ] as S64, [ 1,  0,  2,  0,  3,  0        ] as S32)
        NBKAssertChunkedInt([ 1,  2,  3,  4] as S64, [ 1,  0,  2,  0,  3,  0,  4,  0] as S32)
        
        NBKAssertChunkedInt([              ] as S64, [                              ] as S32)
        NBKAssertChunkedInt([~1            ] as S64, [~1, ~0                        ] as S32)
        NBKAssertChunkedInt([~1, ~2        ] as S64, [~1, ~0, ~2, ~0                ] as S32)
        NBKAssertChunkedInt([~1, ~2, ~3    ] as S64, [~1, ~0, ~2, ~0, ~3, ~0        ] as S32)
        NBKAssertChunkedInt([~1, ~2, ~3, ~4] as S64, [~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as S32)
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
        NBKAssertChunkedIntOneWay([                          ] as S32, [                       ] as S64, isSigned: true )
        NBKAssertChunkedIntOneWay([ 1                        ] as S32, [ 1                     ] as S64, isSigned: true )
        NBKAssertChunkedIntOneWay([ 1,  0,  2                ] as S32, [ 1,  2                 ] as S64, isSigned: true )
        NBKAssertChunkedIntOneWay([ 1,  0,  2,  0,  3        ] as S32, [ 1,  2,  3             ] as S64, isSigned: true )
        NBKAssertChunkedIntOneWay([ 1,  0,  2,  0,  3,  0,  4] as S32, [ 1,  2,  3,  4         ] as S64, isSigned: true )
        
        NBKAssertChunkedIntOneWay([                          ] as S32, [                       ] as S64, isSigned: true )
        NBKAssertChunkedIntOneWay([~1                        ] as S32, [~1                     ] as S64, isSigned: true )
        NBKAssertChunkedIntOneWay([~1, ~0, ~2                ] as S32, [~1, ~2                 ] as S64, isSigned: true )
        NBKAssertChunkedIntOneWay([~1, ~0, ~2, ~0, ~3        ] as S32, [~1, ~2, ~3             ] as S64, isSigned: true )
        NBKAssertChunkedIntOneWay([~1, ~0, ~2, ~0, ~3, ~0, ~4] as S32, [~1, ~2, ~3, ~4         ] as S64, isSigned: true )
        
        NBKAssertChunkedIntOneWay([                          ] as S32, [                       ] as S64, isSigned: false)
        NBKAssertChunkedIntOneWay([ 1                        ] as S32, [ 1                     ] as S64, isSigned: false)
        NBKAssertChunkedIntOneWay([ 1,  0,  2                ] as S32, [ 1,  2                 ] as S64, isSigned: false)
        NBKAssertChunkedIntOneWay([ 1,  0,  2,  0,  3        ] as S32, [ 1,  2,  3             ] as S64, isSigned: false)
        NBKAssertChunkedIntOneWay([ 1,  0,  2,  0,  3,  0,  4] as S32, [ 1,  2,  3,  4         ] as S64, isSigned: false)
        
        NBKAssertChunkedIntOneWay([                          ] as S32, [                       ] as S64, isSigned: false)
        NBKAssertChunkedIntOneWay([~1                        ] as S32, [             0xfffffffe] as S64, isSigned: false)
        NBKAssertChunkedIntOneWay([~1, ~0, ~2                ] as S32, [~1,          0xfffffffd] as S64, isSigned: false)
        NBKAssertChunkedIntOneWay([~1, ~0, ~2, ~0, ~3        ] as S32, [~1, ~2,      0xfffffffc] as S64, isSigned: false)
        NBKAssertChunkedIntOneWay([~1, ~0, ~2, ~0, ~3, ~0, ~4] as S32, [~1, ~2, ~3,  0xfffffffb] as S64, isSigned: false)
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
// MARK: * NBK x Chunked Int x Assertions
//*============================================================================*

private func NBKAssertChunkedInt<A: NBKCoreInteger, B: NBKCoreInteger>(
_ lhs: [A], _ rhs: [B], isSigned: Bool? = nil,
file: StaticString = #file, line: UInt  = #line) {
    
    NBKAssertChunkedIntOneWay(lhs, rhs, isSigned: isSigned, file: file, line: line)
    NBKAssertChunkedIntOneWay(rhs, lhs, isSigned: isSigned, file: file, line: line)
}

private func NBKAssertChunkedIntOneWay<A: NBKCoreInteger, B: NBKCoreInteger>(
_ lhs: [A], _ rhs: [B], isSigned: Bool? = nil,
file: StaticString = #file, line: UInt  = #line) {
    typealias T = NBKChunkedInt
    //=------------------------------------------=
    let lhsUnsigned = lhs.map(A.Magnitude.init(bitPattern:))
    let rhsUnsigned = rhs.map(B.Magnitude.init(bitPattern:))
    //=------------------------------------------=
    func with(isSigned: Bool) {
        NBKAssertIteration(T(lhs,         isSigned: isSigned), rhs,         file: file, line: line)
        NBKAssertIteration(T(lhsUnsigned, isSigned: isSigned), rhsUnsigned, file: file, line: line)
    }
    //=------------------------------------------=
    if isSigned == nil || isSigned == true  { with(isSigned: true ) }
    if isSigned == nil || isSigned == false { with(isSigned: false) }
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

private func NBKAssertIteration<Base: RandomAccessCollection, Element>(
_ lhs: NBKChunkedInt<Base, Element>, _ rhs: [Element],
file: StaticString = #file, line: UInt  = #line) {
    XCTAssertEqual(Array(lhs),            rhs,            file: file, line: line)
    XCTAssertEqual(Array(lhs.reversed()), rhs.reversed(), file: file, line: line)
    
    testIndices: do {
        for lhsIndex in lhs.indices.enumerated() {
            XCTAssertEqual(lhs[lhsIndex.element], rhs[lhsIndex.offset], file: file, line: line)
        }
    }
    
    testFrontToBack: do {
        var lhsIndex = lhs.startIndex
        var rhsIndex = rhs.startIndex
        while lhsIndex < lhs.endIndex {
            let lhsIndexAfter = lhs.index(after: lhsIndex)
            let rhsIndexAfter = rhs.index(after: lhsIndex)
            
            XCTAssertEqual(lhs[lhsIndex], rhs[rhsIndex], file: file, line: line)
            XCTAssertEqual(lhsIndexAfter, rhsIndexAfter, file: file, line: line)
            
            lhs.formIndex(after: &lhsIndex)
            rhs.formIndex(after: &rhsIndex)
        }
    }
    
    testBackToFront: do {
        var lhsIndex = lhs.endIndex
        var rhsIndex = rhs.endIndex
        while lhsIndex > lhs.startIndex {
            let lhsIndexBefore = lhs.index(before: lhsIndex)
            let rhsIndexBefore = rhs.index(before: lhsIndex)
            
            lhs.formIndex(before: &lhsIndex)
            rhs.formIndex(before: &rhsIndex)
            
            XCTAssertEqual(lhs[lhsIndex],  rhs[rhsIndex],  file: file, line: line)
            XCTAssertEqual(lhsIndexBefore, rhsIndexBefore, file: file, line: line)
        }
    }
    
    testDropFirst: do {
        for dropFirst in 0 ..< (2 * lhs.count) {
            let lhsDropFirst = lhs.dropFirst(dropFirst)
            let rhsDropFirst = rhs.dropFirst(dropFirst)

            let lhsDropFirstIndices = lhs.indices[lhsDropFirst.indices]
            let rhsDropFirstIndices = rhs.indices[rhsDropFirst.indices]
            
            XCTAssertEqual(Array(lhsDropFirst),             Array(rhsDropFirst),             file: file, line: line)
            XCTAssertEqual(Array(lhs[lhsDropFirstIndices]), Array(rhs[rhsDropFirstIndices]), file: file, line: line)
            
            if  let first = lhs.dropFirst(dropFirst).first {
                let firstIndex = lhs.index(lhs.startIndex, offsetBy: dropFirst)
                XCTAssertEqual(first, lhs[firstIndex],  file: file, line: line)
            }
        }
    }
    
    testDropLast: do {
        for dropLast in 0 ..< (2 * lhs.count) {
            let lhsDropLast = lhs.dropFirst(dropLast)
            let rhsDropLast = rhs.dropFirst(dropLast)

            let lhsDropLastIndices = lhs.indices[lhsDropLast.indices]
            let rhsDropLastIndices = rhs.indices[rhsDropLast.indices]
            
            XCTAssertEqual(Array(lhsDropLast),             Array(rhsDropLast),             file: file, line: line)
            XCTAssertEqual(Array(lhs[lhsDropLastIndices]), Array(rhs[rhsDropLastIndices]), file: file, line: line)
            
            if  let last = lhs.dropLast(dropLast).last {
                let lastIndex = lhs.index(lhs.endIndex, offsetBy: ~dropLast)
                XCTAssertEqual(last, lhs[lastIndex], file: file, line: line)
            }
        }
    }
}

#endif
