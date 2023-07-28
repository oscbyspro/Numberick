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
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Int256 x Comparisons
//*============================================================================*

final class Int256TestsOnComparisons: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testHashing() {
        var union = Set<T>()
        union.insert(T(x64: X(0, 0, 0, 0)))
        union.insert(T(x64: X(1, 0, 0, 0)))
        union.insert(T(x64: X(0, 1, 0, 0)))
        union.insert(T(x64: X(0, 0, 1, 0)))
        union.insert(T(x64: X(0, 0, 0, 1)))
        union.insert(T(x64: X(0, 0, 0, 0)))
        XCTAssertEqual(union.count, 5)
    }
    
    func testComparing() {
        NBKAssertComparisons( T(0),  T(0),  Int(0))
        NBKAssertComparisons( T(0), -T(0),  Int(0))
        NBKAssertComparisons(-T(0),  T(0),  Int(0))
        NBKAssertComparisons(-T(0), -T(0),  Int(0))
        
        NBKAssertComparisons( T(1),  T(1),  Int(0))
        NBKAssertComparisons( T(1), -T(1),  Int(1))
        NBKAssertComparisons(-T(1),  T(1), -Int(1))
        NBKAssertComparisons(-T(1), -T(1),  Int(0))
        
        NBKAssertComparisons( T(2),  T(3), -Int(1))
        NBKAssertComparisons( T(2), -T(3),  Int(1))
        NBKAssertComparisons(-T(2),  T(3), -Int(1))
        NBKAssertComparisons(-T(2), -T(3),  Int(1))
        
        NBKAssertComparisons( T(3),  T(2),  Int(1))
        NBKAssertComparisons( T(3), -T(2),  Int(1))
        NBKAssertComparisons(-T(3),  T(2), -Int(1))
        NBKAssertComparisons(-T(3), -T(2), -Int(1))
        
        NBKAssertComparisons(T.max, T.max,  Int(0))
        NBKAssertComparisons(T.max, T.min,  Int(1))
        NBKAssertComparisons(T.min, T.max, -Int(1))
        NBKAssertComparisons(T.min, T.min,  Int(0))
        
        NBKAssertComparisons(T(x64: X(0, 2, 3, 4)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(1, 0, 3, 4)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 0, 4)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 0)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(0, 2, 3, 4)), T(x64: X(0, 2, 3, 4)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 0, 3, 4)), T(x64: X(1, 0, 3, 4)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 2, 0, 4)), T(x64: X(1, 2, 0, 4)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 0)), T(x64: X(1, 2, 3, 0)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(0, 2, 3, 4)),  Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 0, 3, 4)),  Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 2, 0, 4)),  Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 2, 3, 0)),  Int(1))
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
        
        XCTAssertTrue ((~T(0)).isLessThanZero)
        XCTAssertTrue ((~T(1)).isLessThanZero)
        XCTAssertTrue ((~T(2)).isLessThanZero)
    }
    
    func testIsMoreThanZero() {
        XCTAssertFalse(( T(0)).isMoreThanZero)
        XCTAssertTrue (( T(1)).isMoreThanZero)
        XCTAssertTrue (( T(2)).isMoreThanZero)
        
        XCTAssertFalse((~T(0)).isMoreThanZero)
        XCTAssertFalse((~T(1)).isMoreThanZero)
        XCTAssertFalse((~T(2)).isMoreThanZero)
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
    
    func testIsPowerOf2() {
        XCTAssertFalse((T.min).isPowerOf2)
        XCTAssertFalse((T(-4)).isPowerOf2)
        XCTAssertFalse((T(-3)).isPowerOf2)
        XCTAssertFalse((T(-2)).isPowerOf2)
        XCTAssertFalse((T(-1)).isPowerOf2)
        XCTAssertFalse((T( 0)).isPowerOf2)
        XCTAssertTrue ((T( 1)).isPowerOf2)
        XCTAssertTrue ((T( 2)).isPowerOf2)
        XCTAssertFalse((T( 3)).isPowerOf2)
        XCTAssertFalse((T.max).isPowerOf2)
        
        XCTAssertFalse(T(x64: X(0, 0, 0, 0)).isPowerOf2)
        XCTAssertTrue (T(x64: X(1, 0, 0, 0)).isPowerOf2)
        XCTAssertFalse(T(x64: X(1, 1, 0, 0)).isPowerOf2)
        XCTAssertTrue (T(x64: X(0, 1, 0, 0)).isPowerOf2)
        XCTAssertFalse(T(x64: X(0, 1, 1, 0)).isPowerOf2)
        XCTAssertTrue (T(x64: X(0, 0, 1, 0)).isPowerOf2)
        XCTAssertFalse(T(x64: X(0, 0, 1, 1)).isPowerOf2)
        XCTAssertTrue (T(x64: X(0, 0, 0, 1)).isPowerOf2)
    }
    
    func testSignum() {
        NBKAssertSignum( T(0),  Int(0))
        NBKAssertSignum( T(1),  Int(1))
        NBKAssertSignum( T(2),  Int(1))
        
        NBKAssertSignum(~T(0), -Int(1))
        NBKAssertSignum(~T(1), -Int(1))
        NBKAssertSignum(~T(2), -Int(1))
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Comparisons
//*============================================================================*

final class UInt256TestsOnComparisons: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testHashing() {
        var union = Set<T>()
        union.insert(T(x64: X(0, 0, 0, 0)))
        union.insert(T(x64: X(1, 0, 0, 0)))
        union.insert(T(x64: X(0, 1, 0, 0)))
        union.insert(T(x64: X(0, 0, 1, 0)))
        union.insert(T(x64: X(0, 0, 0, 1)))
        union.insert(T(x64: X(0, 0, 0, 0)))
        XCTAssertEqual(union.count, 5)
    }
    
    func testComparing() {
        NBKAssertComparisons( T(0),  T(0),  Int(0))
        NBKAssertComparisons( T(1),  T(1),  Int(0))
        NBKAssertComparisons( T(2),  T(3), -Int(1))
        NBKAssertComparisons( T(3),  T(2),  Int(1))

        NBKAssertComparisons(T.max, T.max,  Int(0))
        NBKAssertComparisons(T.max, T.min,  Int(1))
        NBKAssertComparisons(T.min, T.max, -Int(1))
        NBKAssertComparisons(T.min, T.min,  Int(0))
        
        NBKAssertComparisons(T(x64: X(0, 2, 3, 4)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(1, 0, 3, 4)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 0, 4)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 0)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(0, 2, 3, 4)), T(x64: X(0, 2, 3, 4)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 0, 3, 4)), T(x64: X(1, 0, 3, 4)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 2, 0, 4)), T(x64: X(1, 2, 0, 4)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 0)), T(x64: X(1, 2, 3, 0)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(0, 2, 3, 4)),  Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 0, 3, 4)),  Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 2, 0, 4)),  Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 2, 3, 0)),  Int(1))
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
    
    func testIsPowerOf2() {
        XCTAssertFalse((T.min).isPowerOf2)
        XCTAssertFalse((T( 0)).isPowerOf2)
        XCTAssertTrue ((T( 1)).isPowerOf2)
        XCTAssertTrue ((T( 2)).isPowerOf2)
        XCTAssertFalse((T( 3)).isPowerOf2)
        XCTAssertTrue ((T( 4)).isPowerOf2)
        XCTAssertFalse((T( 5)).isPowerOf2)
        XCTAssertFalse((T( 6)).isPowerOf2)
        XCTAssertFalse((T( 7)).isPowerOf2)
        XCTAssertFalse((T.max).isPowerOf2)
        
        XCTAssertFalse(T(x64: X(0, 0, 0, 0)).isPowerOf2)
        XCTAssertTrue (T(x64: X(1, 0, 0, 0)).isPowerOf2)
        XCTAssertFalse(T(x64: X(1, 1, 0, 0)).isPowerOf2)
        XCTAssertTrue (T(x64: X(0, 1, 0, 0)).isPowerOf2)
        XCTAssertFalse(T(x64: X(0, 1, 1, 0)).isPowerOf2)
        XCTAssertTrue (T(x64: X(0, 0, 1, 0)).isPowerOf2)
        XCTAssertFalse(T(x64: X(0, 0, 1, 1)).isPowerOf2)
        XCTAssertTrue (T(x64: X(0, 0, 0, 1)).isPowerOf2)
    }
    
    func testSignum() {
        NBKAssertSignum( T(0),  Int(0))
        NBKAssertSignum( T(1),  Int(1))
        NBKAssertSignum( T(2),  Int(1))
        
        NBKAssertSignum(~T(0),  Int(1))
        NBKAssertSignum(~T(1),  Int(1))
        NBKAssertSignum(~T(2),  Int(1))
    }
}

#endif
