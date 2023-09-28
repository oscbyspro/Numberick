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
// MARK: * NBK x Twin Headed
//*============================================================================*

final class NBKTwinHeadedTests: XCTestCase {
    
    typealias T = NBK.TwinHeaded
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Initializers
    //=------------------------------------------------------------------------=
    
    func testFromBase() {
        let base = [0, 1, 2, 3]
        
        NBKAssertIteration(  T(base),  [0, 1, 2, 3])
        NBKAssertIteration(T(T(base)), [0, 1, 2, 3])
        
        NBKAssertIteration(  T(base, reversed: false),                   [0, 1, 2, 3])
        NBKAssertIteration(  T(base, reversed: true ),                   [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, reversed: false), reversed: false), [0, 1, 2, 3])
        NBKAssertIteration(T(T(base, reversed: false), reversed: true ), [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, reversed: true ), reversed: false), [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, reversed: true ), reversed: true ), [0, 1, 2, 3])
        
        XCTAssert(T<[Int]>.self == type(of:   T(base) ))
        XCTAssert(T<[Int]>.self == type(of: T(T(base))))
    }
    
    func testFromReversedCollection() {
        let base = [3, 2, 1, 0].reversed() as ReversedCollection<[Int]>
        
        NBKAssertIteration(  T(base),  [0, 1, 2, 3])
        NBKAssertIteration(T(T(base)), [0, 1, 2, 3])
        
        NBKAssertIteration(  T(base, reversed: false),                   [0, 1, 2, 3])
        NBKAssertIteration(  T(base, reversed: true ),                   [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, reversed: false), reversed: false), [0, 1, 2, 3])
        NBKAssertIteration(T(T(base, reversed: false), reversed: true ), [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, reversed: true ), reversed: false), [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, reversed: true ), reversed: true ), [0, 1, 2, 3])
        
        XCTAssert(T<[Int]>.self == type(of: T(base)))
    }
    
    func testFromNoElements() {
        NBKAssertIteration(T(Array<UInt>()),            [ ])
        NBKAssertIteration(T(Array<UInt>().reversed()), [ ])
        NBKAssertIteration(T(EmptyCollection<UInt> ()), [ ])
        
        NBKAssertIteration(T(Array<UInt>(),            reversed: false), [ ])
        NBKAssertIteration(T(Array<UInt>(),            reversed: true ), [ ])
        NBKAssertIteration(T(Array<UInt>().reversed(), reversed: false), [ ])
        NBKAssertIteration(T(Array<UInt>().reversed(), reversed: true ), [ ])
        NBKAssertIteration(T(EmptyCollection<UInt> (), reversed: false), [ ])
        NBKAssertIteration(T(EmptyCollection<UInt> (), reversed: true ), [ ])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Accessors
    //=------------------------------------------------------------------------=
    
    func testDirection() {
        XCTAssertEqual(T([0, 1, 2, 3], reversed: false).direction,  1)
        XCTAssertEqual(T([0, 1, 2, 3], reversed: true ).direction, -1)
    }
    
    func testIsFrontToBack() {
        XCTAssertEqual(T([0, 1, 2, 3], reversed: false).isFrontToBack, true )
        XCTAssertEqual(T([0, 1, 2, 3], reversed: true ).isFrontToBack, false)
    }
    
    func testIsBackToFront() {
        XCTAssertEqual(T([0, 1, 2, 3], reversed: false).isBackToFront, false)
        XCTAssertEqual(T([0, 1, 2, 3], reversed: true ).isBackToFront, true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testReversed() {
        let base = [0, 1, 2, 3]
        
        NBKAssertIteration(T(base, reversed: false),                       [0, 1, 2, 3])
        NBKAssertIteration(T(base, reversed: false).reversed(),            [3, 2, 1, 0])
        NBKAssertIteration(T(base, reversed: false).reversed().reversed(), [0, 1, 2, 3])
        
        NBKAssertIteration(T(base, reversed: true ),                       [3, 2, 1, 0])
        NBKAssertIteration(T(base, reversed: true ).reversed(),            [0, 1, 2, 3])
        NBKAssertIteration(T(base, reversed: true ).reversed().reversed(), [3, 2, 1, 0])
        
        XCTAssert(T<[Int]>.self == type(of: T(base)))
        XCTAssert(T<[Int]>.self == type(of: T(base).reversed()))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Details x Rebasing Unsafe Buffer Pointers
    //=------------------------------------------------------------------------=
    
    func testFromSubSequenceByRebasingUnsafeBufferPointer() {
        let frontToBack = [0, 1, 2, 3]
        let backToFront = [3, 2, 1, 0]
        
        frontToBack.withUnsafeBufferPointer { frontToBack in
        backToFront.withUnsafeBufferPointer { backToFront in
            for i in 0 ... 4 {
            for j in i ... 4 {
                XCTAssert(T(rebasing: T(frontToBack, reversed: false)[i ..< j]).elementsEqual(frontToBack[i ..< j]))
                XCTAssert(T(rebasing: T(frontToBack, reversed: true )[i ..< j]).elementsEqual(backToFront[i ..< j]))
                XCTAssert(T(rebasing: T(backToFront, reversed: false)[i ..< j]).elementsEqual(backToFront[i ..< j]))
                XCTAssert(T(rebasing: T(backToFront, reversed: true )[i ..< j]).elementsEqual(frontToBack[i ..< j]))
            }}
        }}
    }
    
    func testFromSubSequenceByRebasingUnsafeMutableBufferPointer() {
        var frontToBack = [0, 1, 2, 3]
        var backToFront = [3, 2, 1, 0]
        
        frontToBack.withUnsafeMutableBufferPointer { frontToBack in
        backToFront.withUnsafeMutableBufferPointer { backToFront in
            for i in 0 ... 4 {
            for j in i ... 4 {
                XCTAssert(T(rebasing: T(frontToBack, reversed: false)[i ..< j]).elementsEqual(frontToBack[i ..< j]))
                XCTAssert(T(rebasing: T(frontToBack, reversed: true )[i ..< j]).elementsEqual(backToFront[i ..< j]))
                XCTAssert(T(rebasing: T(backToFront, reversed: false)[i ..< j]).elementsEqual(backToFront[i ..< j]))
                XCTAssert(T(rebasing: T(backToFront, reversed: true )[i ..< j]).elementsEqual(frontToBack[i ..< j]))
            }}
        }}
    }
}

//*============================================================================*
// MARK: * NBK x Twin Headed x Assertions
//*============================================================================*

private func NBKAssertIteration<T: RandomAccessCollection & MutableCollection>(
_ lhs: NBK.TwinHeaded<T>, _ rhs: [T.Element],
file: StaticString = #file, line: UInt  = #line) where T.Element: FixedWidthInteger, T.Element: Equatable {
    XCTAssertEqual(Array(lhs),            rhs,            file: file, line: line)
    XCTAssertEqual(Array(lhs.reversed()), rhs.reversed(), file: file, line: line)
    XCTAssertEqual(Array({ var x = lhs; x.reverse(); return x }()), rhs.reversed(), file: file, line: line)
    
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
    
    testAsMutableCollection: do {
        var lhs = lhs, lhsIndex = lhs.startIndex
        var rhs = rhs, rhsIndex = rhs.startIndex
        while lhsIndex < lhs.endIndex {
            lhs[lhsIndex] &+= 1
            rhs[rhsIndex] &+= 1
            
            XCTAssertEqual(lhs[lhsIndex], rhs[rhsIndex], file: file, line: line)
            
            lhs.formIndex(after: &lhsIndex)
            rhs.formIndex(after: &rhsIndex)
        }
    }
}

#endif
