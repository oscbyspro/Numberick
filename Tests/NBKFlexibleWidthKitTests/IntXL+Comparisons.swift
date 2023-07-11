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
        union.insert(T(words:[1, 0, 0, 0] as [UInt]))
        union.insert(T(words:[0, 1, 0, 0] as [UInt]))
        union.insert(T(words:[0, 0, 1, 0] as [UInt]))
        union.insert(T(words:[0, 0, 0, 1] as [UInt]))
        union.insert(T(words:[0, 0, 0, 0] as [UInt]))
        XCTAssertEqual(union.count, 5)
    }

    func testComparing() {
        NBKAssertComparisons(T(0), T(0),  Int(0))
        NBKAssertComparisons(T(1), T(1),  Int(0))
        NBKAssertComparisons(T(2), T(3), -Int(1))
        NBKAssertComparisons(T(3), T(2),  Int(1))

        NBKAssertComparisons(T(words:[0, 2, 3, 4]), T(words:[1, 2, 3, 4]), -Int(1))
        NBKAssertComparisons(T(words:[1, 0, 3, 4]), T(words:[1, 2, 3, 4]), -Int(1))
        NBKAssertComparisons(T(words:[1, 2, 0, 4]), T(words:[1, 2, 3, 4]), -Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 0]), T(words:[1, 2, 3, 4]), -Int(1))
        NBKAssertComparisons(T(words:[0, 2, 3, 4]), T(words:[0, 2, 3, 4]),  Int(0))
        NBKAssertComparisons(T(words:[1, 0, 3, 4]), T(words:[1, 0, 3, 4]),  Int(0))
        NBKAssertComparisons(T(words:[1, 2, 0, 4]), T(words:[1, 2, 0, 4]),  Int(0))
        NBKAssertComparisons(T(words:[1, 2, 3, 0]), T(words:[1, 2, 3, 0]),  Int(0))
        NBKAssertComparisons(T(words:[1, 2, 3, 4]), T(words:[0, 2, 3, 4]),  Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 4]), T(words:[1, 0, 3, 4]),  Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 4]), T(words:[1, 2, 0, 4]),  Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 4]), T(words:[1, 2, 3, 0]),  Int(1))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testIsZero() {
        XCTAssertTrue (( T(0)).isZero)
        XCTAssertFalse(( T(1)).isZero)
        XCTAssertFalse(( T(2)).isZero)

        XCTAssertFalse((~T(0)).isZero)
        XCTAssertFalse((~T(1)).isZero)
        XCTAssertFalse((~T(2)).isZero)
    }

    func testIsLessThanZero() {
        XCTAssertFalse(( T(0)).isLessThanZero)
        XCTAssertFalse(( T(1)).isLessThanZero)
        XCTAssertFalse(( T(2)).isLessThanZero)

        XCTAssertFalse((~T(0)).isLessThanZero)
        XCTAssertFalse((~T(1)).isLessThanZero)
        XCTAssertFalse((~T(2)).isLessThanZero)
    }

    func testIsMoreThanZero() {
        XCTAssertFalse(( T(0)).isMoreThanZero)
        XCTAssertTrue (( T(1)).isMoreThanZero)
        XCTAssertTrue (( T(2)).isMoreThanZero)

        XCTAssertTrue ((~T(0)).isMoreThanZero)
        XCTAssertTrue ((~T(1)).isMoreThanZero)
        XCTAssertTrue ((~T(2)).isMoreThanZero)
    }

    func testIsOdd() {
        XCTAssertFalse(( T(0)).isOdd)
        XCTAssertTrue (( T(1)).isOdd)
        XCTAssertFalse(( T(2)).isOdd)

        XCTAssertTrue ((~T(0)).isOdd)
        XCTAssertFalse((~T(1)).isOdd)
        XCTAssertTrue ((~T(2)).isOdd)
    }

    func testIsEven() {
        XCTAssertTrue (( T(0)).isEven)
        XCTAssertFalse(( T(1)).isEven)
        XCTAssertTrue (( T(2)).isEven)

        XCTAssertFalse((~T(0)).isEven)
        XCTAssertTrue ((~T(1)).isEven)
        XCTAssertFalse((~T(2)).isEven)
    }

    func testSignum() {
        XCTAssertEqual(( T(0)).signum(), Int(0))
        XCTAssertEqual(( T(1)).signum(), Int(1))
        XCTAssertEqual(( T(2)).signum(), Int(1))

        XCTAssertEqual((~T(0)).signum(), Int(1))
        XCTAssertEqual((~T(1)).signum(), Int(1))
        XCTAssertEqual((~T(2)).signum(), Int(1))
    }

    func testIsPowerOf2() {
        XCTAssertFalse((T( 0)).isPowerOf2)
        XCTAssertTrue ((T( 1)).isPowerOf2)
        XCTAssertTrue ((T( 2)).isPowerOf2)
        XCTAssertFalse((T( 3)).isPowerOf2)
        XCTAssertTrue ((T( 4)).isPowerOf2)
        XCTAssertFalse((T( 5)).isPowerOf2)
        XCTAssertFalse((T( 6)).isPowerOf2)
        XCTAssertFalse((T( 7)).isPowerOf2)
        
        XCTAssertFalse(T(words:[0, 0, 0, 0] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[1, 0, 0, 0] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[1, 1, 0, 0] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[0, 1, 0, 0] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[0, 1, 1, 0] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[0, 0, 1, 0] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[0, 0, 1, 1] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[0, 0, 0, 1] as [UInt]).isPowerOf2)
    }
}

#endif
