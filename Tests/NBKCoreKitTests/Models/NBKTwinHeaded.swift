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
    
    typealias T<Base> = NBKTwinHeaded<Base> where Base: RandomAccessCollection
    
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
        
        NBKAssertIteration(  T(base, head:   .little),                   [0, 1, 2, 3])
        NBKAssertIteration(  T(base, head:   .big   ),                   [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, head:   .little), head:   .little), [0, 1, 2, 3])
        NBKAssertIteration(T(T(base, head:   .little), head:   .big   ), [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, head:   .big   ), head:   .little), [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, head:   .big   ), head:   .big   ), [0, 1, 2, 3])
        
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
        
        NBKAssertIteration(  T(base, head:   .little),                   [0, 1, 2, 3])
        NBKAssertIteration(  T(base, head:   .big   ),                   [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, head:   .little), head:   .little), [0, 1, 2, 3])
        NBKAssertIteration(T(T(base, head:   .little), head:   .big   ), [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, head:   .big   ), head:   .little), [3, 2, 1, 0])
        NBKAssertIteration(T(T(base, head:   .big   ), head:   .big   ), [0, 1, 2, 3])
        
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
        
        NBKAssertIteration(T(Array<UInt>(),            head:   .little), [ ])
        NBKAssertIteration(T(Array<UInt>(),            head:   .big   ), [ ])
        NBKAssertIteration(T(Array<UInt>().reversed(), head:   .little), [ ])
        NBKAssertIteration(T(Array<UInt>().reversed(), head:   .big   ), [ ])
        NBKAssertIteration(T(EmptyCollection<UInt> (), head:   .little), [ ])
        NBKAssertIteration(T(EmptyCollection<UInt> (), head:   .big   ), [ ])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Accessors
    //=------------------------------------------------------------------------=
    
    func testIsFrontToBackOrBackToFront() {
        let base = [0, 1, 2, 3]
        
        XCTAssertEqual(T(base, reversed: false).isFrontToBack, true )
        XCTAssertEqual(T(base, reversed: true ).isFrontToBack, false)
        
        XCTAssertEqual(T(base, reversed: false).asFrontToBack, base )
        XCTAssertEqual(T(base, reversed: true ).asFrontToBack, nil  )
        
        XCTAssertEqual(T(base, reversed: false).isBackToFront, false)
        XCTAssertEqual(T(base, reversed: true ).isBackToFront, true )
        
        XCTAssertEqual(T(base, reversed: false).asBackToFront.map(Array.init), nil)
        XCTAssertEqual(T(base, reversed: true ).asBackToFront.map(Array.init), base.reversed())
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

private func NBKAssertIteration<B: RandomAccessCollection & MutableCollection>(
_ lhs: NBKTwinHeaded<B>, _ rhs: [B.Element],
file: StaticString = #file, line: UInt  = #line) where B.Element: FixedWidthInteger, B.Element: Equatable {
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
