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
        
        NBKAssertElementsEqual(  T(base),  [0, 1, 2, 3])
        NBKAssertElementsEqual(T(T(base)), [0, 1, 2, 3])
        
        NBKAssertElementsEqual(  T(base, reversed: false),                   [0, 1, 2, 3])
        NBKAssertElementsEqual(  T(base, reversed: true ),                   [3, 2, 1, 0])
        NBKAssertElementsEqual(T(T(base, reversed: false), reversed: false), [0, 1, 2, 3])
        NBKAssertElementsEqual(T(T(base, reversed: false), reversed: true ), [3, 2, 1, 0])
        NBKAssertElementsEqual(T(T(base, reversed: true ), reversed: false), [3, 2, 1, 0])
        NBKAssertElementsEqual(T(T(base, reversed: true ), reversed: true ), [0, 1, 2, 3])
        
        XCTAssert(T<[Int]>.self == type(of:   T(base) ))
        XCTAssert(T<[Int]>.self == type(of: T(T(base))))
    }
    
    func testFromReversedCollection() {
        let base = [3, 2, 1, 0].reversed() as ReversedCollection<[Int]>
        
        NBKAssertElementsEqual(  T(base),  [0, 1, 2, 3])
        NBKAssertElementsEqual(T(T(base)), [0, 1, 2, 3])
        
        NBKAssertElementsEqual(  T(base, reversed: false),                   [0, 1, 2, 3])
        NBKAssertElementsEqual(  T(base, reversed: true ),                   [3, 2, 1, 0])
        NBKAssertElementsEqual(T(T(base, reversed: false), reversed: false), [0, 1, 2, 3])
        NBKAssertElementsEqual(T(T(base, reversed: false), reversed: true ), [3, 2, 1, 0])
        NBKAssertElementsEqual(T(T(base, reversed: true ), reversed: false), [3, 2, 1, 0])
        NBKAssertElementsEqual(T(T(base, reversed: true ), reversed: true ), [0, 1, 2, 3])
        
        XCTAssert(T<[Int]>.self == type(of: T(base)))
    }
    
    func testFromNoElements() {
        NBKAssertElementsEqual(T(Array<UInt>()),            [ ])
        NBKAssertElementsEqual(T(Array<UInt>().reversed()), [ ])
        NBKAssertElementsEqual(T(EmptyCollection<UInt> ()), [ ])
        
        NBKAssertElementsEqual(T(Array<UInt>(),            reversed: false), [ ])
        NBKAssertElementsEqual(T(Array<UInt>(),            reversed: true ), [ ])
        NBKAssertElementsEqual(T(Array<UInt>().reversed(), reversed: false), [ ])
        NBKAssertElementsEqual(T(Array<UInt>().reversed(), reversed: true ), [ ])
        NBKAssertElementsEqual(T(EmptyCollection<UInt> (), reversed: false), [ ])
        NBKAssertElementsEqual(T(EmptyCollection<UInt> (), reversed: true ), [ ])
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
        
        NBKAssertElementsEqual(T(base, reversed: false),                       [0, 1, 2, 3])
        NBKAssertElementsEqual(T(base, reversed: false).reversed(),            [3, 2, 1, 0])
        NBKAssertElementsEqual(T(base, reversed: false).reversed().reversed(), [0, 1, 2, 3])
        
        NBKAssertElementsEqual(T(base, reversed: true ),                       [3, 2, 1, 0])
        NBKAssertElementsEqual(T(base, reversed: true ).reversed(),            [0, 1, 2, 3])
        NBKAssertElementsEqual(T(base, reversed: true ).reversed().reversed(), [3, 2, 1, 0])
        
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
//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

private func NBKAssertElementsEqual<Base: RandomAccessCollection>(
_ base: Base, _ expectation: [Base.Element],
file: StaticString = #file, line: UInt = #line) where Base.Element: Equatable {
    //=------------------------------------------=
    XCTAssertEqual(Array(base), expectation, file: file,  line: line)
    XCTAssertEqual(Array(base.indices.map({ base[$0] })), expectation, file: file, line: line)
    //=------------------------------------------=
    for distance in 0 ..< base.count {
        //=--------------------------------------=
        let index0 = base.index(base.startIndex, offsetBy: distance + 0)
        let index1 = base.index(base.startIndex, offsetBy: distance + 1)
        //=--------------------------------------=
        XCTAssertEqual(base[index0], expectation[distance], file: file, line: line)
        //=--------------------------------------=
        XCTAssertEqual(base.index(before: index1), index0, file: file, line: line)
        XCTAssertEqual(base.index(after:  index0), index1, file: file, line: line)

        XCTAssertEqual(base.index(base.endIndex, offsetBy: distance + 0 - base.count), index0, file: file, line: line)
        XCTAssertEqual(base.index(base.endIndex, offsetBy: distance + 1 - base.count), index1, file: file, line: line)
        //=--------------------------------------=
        XCTAssertEqual(base.distance(from: base.startIndex, to: index0), distance + 0, file: file, line: line)
        XCTAssertEqual(base.distance(from: base.startIndex, to: index1), distance + 1, file: file, line: line)
        
        XCTAssertEqual(base.distance(from: index0, to: base.endIndex), base.count - distance - 0, file: file, line: line)
        XCTAssertEqual(base.distance(from: index1, to: base.endIndex), base.count - distance - 1, file: file, line: line)
    }
    //=------------------------------------------=
    for distance in 0 ... base.count + 1 {
        XCTAssert(base.prefix(distance).elementsEqual(expectation.prefix(distance)), file: file, line: line)
        XCTAssert(base.suffix(distance).elementsEqual(expectation.suffix(distance)), file: file, line: line)
    }
}

#endif
