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

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * Int256 x Comparisons
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
        
        NBKAssertComparisons(T(x64: X(0, 2, 3, 4)), T(x64: X(1, 2, 3, 4)), -1)
        NBKAssertComparisons(T(x64: X(1, 0, 3, 4)), T(x64: X(1, 2, 3, 4)), -1)
        NBKAssertComparisons(T(x64: X(1, 2, 0, 4)), T(x64: X(1, 2, 3, 4)), -1)
        NBKAssertComparisons(T(x64: X(1, 2, 3, 0)), T(x64: X(1, 2, 3, 4)), -1)
        NBKAssertComparisons(T(x64: X(0, 2, 3, 4)), T(x64: X(0, 2, 3, 4)),  0)
        NBKAssertComparisons(T(x64: X(1, 0, 3, 4)), T(x64: X(1, 0, 3, 4)),  0)
        NBKAssertComparisons(T(x64: X(1, 2, 0, 4)), T(x64: X(1, 2, 0, 4)),  0)
        NBKAssertComparisons(T(x64: X(1, 2, 3, 0)), T(x64: X(1, 2, 3, 0)),  0)
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(0, 2, 3, 4)),  1)
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 0, 3, 4)),  1)
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 2, 0, 4)),  1)
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 2, 3, 0)),  1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsFull() {
        XCTAssertFalse(( T(0)).isFull)
        XCTAssertFalse(( T(1)).isFull)
        XCTAssertFalse(( T(2)).isFull)
        
        XCTAssertTrue ((~T(0)).isFull)
        XCTAssertFalse((~T(1)).isFull)
        XCTAssertFalse((~T(2)).isFull)
    }
    
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
    
    func testSignum() {
        XCTAssertEqual(( T(0)).signum(), Int( 0))
        XCTAssertEqual(( T(1)).signum(), Int( 1))
        XCTAssertEqual(( T(2)).signum(), Int( 1))
        
        XCTAssertEqual((~T(0)).signum(), Int(-1))
        XCTAssertEqual((~T(1)).signum(), Int(-1))
        XCTAssertEqual((~T(2)).signum(), Int(-1))
    }
    
    func testMatchesRepeatingBit() {
        XCTAssertFalse(( T(0)).matches(repeating: true ))
        XCTAssertTrue (( T(0)).matches(repeating: false))
        XCTAssertTrue ((~T(0)).matches(repeating: true ))
        XCTAssertFalse((~T(0)).matches(repeating: false))
    }
}

//*============================================================================*
// MARK: * UInt256 x Comparisons
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
        
        NBKAssertComparisons(T(x64: X(0, 2, 3, 4)), T(x64: X(1, 2, 3, 4)), -1)
        NBKAssertComparisons(T(x64: X(1, 0, 3, 4)), T(x64: X(1, 2, 3, 4)), -1)
        NBKAssertComparisons(T(x64: X(1, 2, 0, 4)), T(x64: X(1, 2, 3, 4)), -1)
        NBKAssertComparisons(T(x64: X(1, 2, 3, 0)), T(x64: X(1, 2, 3, 4)), -1)
        NBKAssertComparisons(T(x64: X(0, 2, 3, 4)), T(x64: X(0, 2, 3, 4)),  0)
        NBKAssertComparisons(T(x64: X(1, 0, 3, 4)), T(x64: X(1, 0, 3, 4)),  0)
        NBKAssertComparisons(T(x64: X(1, 2, 0, 4)), T(x64: X(1, 2, 0, 4)),  0)
        NBKAssertComparisons(T(x64: X(1, 2, 3, 0)), T(x64: X(1, 2, 3, 0)),  0)
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(0, 2, 3, 4)),  1)
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 0, 3, 4)),  1)
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 2, 0, 4)),  1)
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 2, 3, 0)),  1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsFull() {
        XCTAssertFalse(( T(0)).isFull)
        XCTAssertFalse(( T(1)).isFull)
        XCTAssertFalse(( T(2)).isFull)
        
        XCTAssertTrue ((~T(0)).isFull)
        XCTAssertFalse((~T(1)).isFull)
        XCTAssertFalse((~T(2)).isFull)
    }
    
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
    
    func testMatchesRepeatingBit() {
        XCTAssertFalse(( T(0)).matches(repeating: true ))
        XCTAssertTrue (( T(0)).matches(repeating: false))
        XCTAssertTrue ((~T(0)).matches(repeating: true ))
        XCTAssertFalse((~T(0)).matches(repeating: false))
    }
}

#endif
