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
import NBKFlexibleWidthKit
import XCTest

private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x UIntXL x Comparisons
//*============================================================================*

final class UIntXLTestsOnComparisons: XCTestCase {

    typealias T = UIntXL

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testHashing() {
        var union = Set<T>()
        union.insert(T(words:[0, 0, 0, 0] as [UInt]))
        union.insert(T(words:[0, 0, 0, 0] as [UInt]))
        union.insert(T(words:[1, 0, 0, 0] as [UInt]))
        union.insert(T(words:[1, 0, 0, 0] as [UInt]))
        union.insert(T(words:[0, 1, 0, 0] as [UInt]))
        union.insert(T(words:[0, 1, 0, 0] as [UInt]))
        union.insert(T(words:[0, 0, 1, 0] as [UInt]))
        union.insert(T(words:[0, 0, 1, 0] as [UInt]))
        union.insert(T(words:[0, 0, 0, 1] as [UInt]))
        union.insert(T(words:[0, 0, 0, 1] as [UInt]))
        XCTAssertEqual(union.count, 5 as Int)
    }

    func testComparisons() {
        NBKAssertComparisons(T(words:[0, 2, 3, 4] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), -Int(1))
        NBKAssertComparisons(T(words:[1, 0, 3, 4] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), -Int(1))
        NBKAssertComparisons(T(words:[1, 2, 0, 4] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), -Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 0] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), -Int(1))
        NBKAssertComparisons(T(words:[0, 2, 3, 4] as [UInt]), T(words:[0, 2, 3, 4] as [UInt]),  Int(0))
        NBKAssertComparisons(T(words:[1, 0, 3, 4] as [UInt]), T(words:[1, 0, 3, 4] as [UInt]),  Int(0))
        NBKAssertComparisons(T(words:[1, 2, 0, 4] as [UInt]), T(words:[1, 2, 0, 4] as [UInt]),  Int(0))
        NBKAssertComparisons(T(words:[1, 2, 3, 0] as [UInt]), T(words:[1, 2, 3, 0] as [UInt]),  Int(0))
        NBKAssertComparisons(T(words:[1, 2, 3, 4] as [UInt]), T(words:[0, 2, 3, 4] as [UInt]),  Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 4] as [UInt]), T(words:[1, 0, 3, 4] as [UInt]),  Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 4] as [UInt]), T(words:[1, 2, 0, 4] as [UInt]),  Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 4] as [UInt]), T(words:[1, 2, 3, 0] as [UInt]),  Int(1))
    }
    
    func testComparisonsAtIndex() {
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as [UInt]), T(words:[0, 0, 0, 0] as [UInt]), Int(0),   Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as [UInt]), T(words:[0, 0, 0, 0] as [UInt]), Int(1),   Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as [UInt]), T(words:[0, 0, 0, 0] as [UInt]), Int(2),   Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as [UInt]), T(words:[0, 0, 0, 0] as [UInt]), Int(3),   Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as [UInt]), T(words:[0, 0, 0, 0] as [UInt]), Int(4),   Int(0))
        
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), Int(0),  -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), Int(1),  -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), Int(2),  -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), Int(3),  -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), Int(4),  -Int(1))
        
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as [UInt]), T(words:[0, 0, 0, 0] as [UInt]), Int(0),   Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as [UInt]), T(words:[0, 0, 0, 0] as [UInt]), Int(1),   Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as [UInt]), T(words:[0, 0, 0, 0] as [UInt]), Int(2),   Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as [UInt]), T(words:[0, 0, 0, 0] as [UInt]), Int(3),   Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as [UInt]), T(words:[0, 0, 0, 0] as [UInt]), Int(4),   Int(1))
        
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), Int(0),   Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), Int(1),   Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), Int(2),   Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), Int(3),  -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as [UInt]), T(words:[1, 2, 3, 4] as [UInt]), Int(4),  -Int(1))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testIsZero() {
        XCTAssertTrue (T(words:[ 0] as [UInt]).isZero)
        XCTAssertFalse(T(words:[ 1] as [UInt]).isZero)
        XCTAssertFalse(T(words:[ 2] as [UInt]).isZero)

        XCTAssertFalse(T(words:[~0] as [UInt]).isZero)
        XCTAssertFalse(T(words:[~1] as [UInt]).isZero)
        XCTAssertFalse(T(words:[~2] as [UInt]).isZero)
    }

    func testIsLessThanZero() {
        XCTAssertFalse(T(words:[ 0] as [UInt]).isLessThanZero)
        XCTAssertFalse(T(words:[ 1] as [UInt]).isLessThanZero)
        XCTAssertFalse(T(words:[ 2] as [UInt]).isLessThanZero)

        XCTAssertFalse(T(words:[~0] as [UInt]).isLessThanZero)
        XCTAssertFalse(T(words:[~1] as [UInt]).isLessThanZero)
        XCTAssertFalse(T(words:[~2] as [UInt]).isLessThanZero)
    }

    func testIsMoreThanZero() {
        XCTAssertFalse(T(words:[ 0] as [UInt]).isMoreThanZero)
        XCTAssertTrue (T(words:[ 1] as [UInt]).isMoreThanZero)
        XCTAssertTrue (T(words:[ 2] as [UInt]).isMoreThanZero)

        XCTAssertTrue (T(words:[~0] as [UInt]).isMoreThanZero)
        XCTAssertTrue (T(words:[~1] as [UInt]).isMoreThanZero)
        XCTAssertTrue (T(words:[~2] as [UInt]).isMoreThanZero)
    }

    func testIsOdd() {
        XCTAssertFalse(T(words:[ 0] as [UInt]).isOdd)
        XCTAssertTrue (T(words:[ 1] as [UInt]).isOdd)
        XCTAssertFalse(T(words:[ 2] as [UInt]).isOdd)

        XCTAssertTrue (T(words:[~0] as [UInt]).isOdd)
        XCTAssertFalse(T(words:[~1] as [UInt]).isOdd)
        XCTAssertTrue (T(words:[~2] as [UInt]).isOdd)
    }

    func testIsEven() {
        XCTAssertTrue (T(words:[ 0] as [UInt]).isEven)
        XCTAssertFalse(T(words:[ 1] as [UInt]).isEven)
        XCTAssertTrue (T(words:[ 2] as [UInt]).isEven)
        
        XCTAssertFalse(T(words:[~0] as [UInt]).isEven)
        XCTAssertTrue (T(words:[~1] as [UInt]).isEven)
        XCTAssertFalse(T(words:[~2] as [UInt]).isEven)
    }

    func testIsPowerOf2() {
        XCTAssertFalse(T(words:[ 0] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[ 1] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[ 2] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[ 3] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[ 4] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[ 5] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[ 6] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[ 7] as [UInt]).isPowerOf2)
        
        XCTAssertFalse(T(words:[ 0,  0,  0,  0] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[ 1,  0,  0,  0] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[ 1,  1,  0,  0] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[ 0,  1,  0,  0] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[ 0,  1,  1,  0] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[ 0,  0,  1,  0] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[ 0,  0,  1,  1] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[ 0,  0,  0,  1] as [UInt]).isPowerOf2)
    }
    
    func testSignum() {
        NBKAssertSignum(T(words:[ 0] as [UInt]), Int(0))
        NBKAssertSignum(T(words:[ 1] as [UInt]), Int(1))
        NBKAssertSignum(T(words:[ 2] as [UInt]), Int(1))

        NBKAssertSignum(T(words:[~0] as [UInt]), Int(1))
        NBKAssertSignum(T(words:[~1] as [UInt]), Int(1))
        NBKAssertSignum(T(words:[~2] as [UInt]), Int(1))
    }
}

#endif
