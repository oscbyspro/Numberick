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
// MARK: * NBK x Little Endian Ordered
//*============================================================================*

final class NBKLittleEndianOrderedTests: XCTestCase {
    
    typealias T<Base> = NBKLittleEndianOrdered<Base> where
    Base: RandomAccessCollection, Base.Indices == Range<Int>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIteration() {
        var integer = UInt64.zero
        
        integer |= 0 << (0 * 8)
        integer |= 1 << (1 * 8)
        integer |= 2 << (2 * 8)
        integer |= 3 << (3 * 8)
        integer |= 4 << (4 * 8)
        integer |= 5 << (5 * 8)
        integer |= 6 << (6 * 8)
        integer |= 7 << (7 * 8)
        
        Swift.withUnsafeBytes(of: integer) { integer in
            NBKAssertLittleEndianOrderedIteration(T(integer), [0, 1, 2, 3, 4, 5, 6, 7])
        }
    }
}

//*============================================================================*
// MARK: * NBK x Little Endian Ordered x Assertions
//*============================================================================*

private func NBKAssertLittleEndianOrderedIteration<B>(
_ lhs: NBKLittleEndianOrdered<B>, _ rhs: [B.Element],
file: StaticString = #file, line: UInt  = #line) where B.Element: Equatable, B.Indices == Range<Int> {
    XCTAssertEqual(Array(lhs),            rhs,            file: file, line: line)
    XCTAssertEqual(Array(lhs.reversed()), rhs.reversed(), file: file, line: line)
    
    do {
        var lhsIndex = lhs.startIndex
        var rhsIndex = rhs.startIndex
        while lhsIndex < lhs.endIndex {
            XCTAssertEqual(lhs[lhsIndex], rhs[rhsIndex], file: file, line: line)
            lhsIndex = lhs.index(after: lhsIndex)
            rhsIndex = rhs.index(after: rhsIndex)
        }
    }
    
    do {
        var lhsIndex = lhs.endIndex
        var rhsIndex = rhs.endIndex
        while lhsIndex > lhs.startIndex {
            lhsIndex = lhs.index(before: lhsIndex)
            rhsIndex = rhs.index(before: rhsIndex)
            XCTAssertEqual(lhs[lhsIndex], rhs[rhsIndex], file: file, line: line)
        }
    }
    
    do {
        for lhsIndex in lhs.indices.enumerated() {
            XCTAssertEqual(lhs[lhsIndex.element], rhs[lhsIndex.offset], file: file, line: line)
        }
    }
    
    do {
        for lhsIndex in lhs.indices {
            XCTAssertEqual(lhs[lhsIndex], lhs.base[lhsIndex.baseSubscriptIndex()],  file: file, line: line)
            XCTAssertEqual(lhs[lhsIndex], lhs.base[lhs.baseSubscriptIndex(at: lhsIndex)], file: file, line: line)
        }
    }
    
    do {
        for dropFirst in 0 ..< (2 * lhs.count) {
            XCTAssertEqual(Array(lhs.dropFirst(dropFirst)), Array(rhs.dropFirst(dropFirst)), file: file, line: line)
            if  let first = lhs.dropFirst(dropFirst).first {
                let firstIndex = lhs.index(lhs.startIndex, offsetBy: dropFirst)
                XCTAssertEqual(first, lhs[firstIndex],  file: file, line: line)
            }
        }
    }
    
    do {
        for dropLast in 0 ..< (2 * lhs.count) {
            XCTAssertEqual(Array(lhs.dropLast(dropLast)), Array(rhs.dropLast(dropLast)), file: file, line: line)
            if  let last = lhs.dropLast(dropLast).last {
                let lastIndex = lhs.index(lhs.endIndex, offsetBy: ~dropLast)
                XCTAssertEqual(last, lhs[lastIndex], file: file, line: line)
            }
        }
    }
}

#endif
