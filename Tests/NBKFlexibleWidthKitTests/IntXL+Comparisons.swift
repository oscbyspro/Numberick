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
// MARK: * NBK x IntXL x Comparisons
//*============================================================================*

final class IntXLTestsOnComparisons: XCTestCase {

    typealias T =  IntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testIsZero() {
        XCTAssertTrue (T(sign: .plus,  magnitude: M(  )).isZero)
        XCTAssertTrue (T(sign: .minus, magnitude: M(  )).isZero)
        
        XCTAssertTrue (T(words:[ 0] as [UInt]).isZero)
        XCTAssertFalse(T(words:[ 1] as [UInt]).isZero)
        XCTAssertFalse(T(words:[ 2] as [UInt]).isZero)

        XCTAssertFalse(T(words:[~0] as [UInt]).isZero)
        XCTAssertFalse(T(words:[~1] as [UInt]).isZero)
        XCTAssertFalse(T(words:[~2] as [UInt]).isZero)
    }

    func testIsLessThanZero() {
        XCTAssertFalse(T(sign: .plus,  magnitude: M(  )).isLessThanZero)
        XCTAssertFalse(T(sign: .minus, magnitude: M(  )).isLessThanZero)
        
        XCTAssertFalse(T(words:[ 0] as [UInt]).isLessThanZero)
        XCTAssertFalse(T(words:[ 1] as [UInt]).isLessThanZero)
        XCTAssertFalse(T(words:[ 2] as [UInt]).isLessThanZero)

        XCTAssertTrue (T(words:[~0] as [UInt]).isLessThanZero)
        XCTAssertTrue (T(words:[~1] as [UInt]).isLessThanZero)
        XCTAssertTrue (T(words:[~2] as [UInt]).isLessThanZero)
    }

    func testIsMoreThanZero() {
        XCTAssertFalse(T(sign: .plus,  magnitude: M(  )).isMoreThanZero)
        XCTAssertFalse(T(sign: .minus, magnitude: M(  )).isMoreThanZero)
        
        XCTAssertFalse(T(words:[ 0] as [UInt]).isMoreThanZero)
        XCTAssertTrue (T(words:[ 1] as [UInt]).isMoreThanZero)
        XCTAssertTrue (T(words:[ 2] as [UInt]).isMoreThanZero)

        XCTAssertFalse(T(words:[~0] as [UInt]).isMoreThanZero)
        XCTAssertFalse(T(words:[~1] as [UInt]).isMoreThanZero)
        XCTAssertFalse(T(words:[~2] as [UInt]).isMoreThanZero)
    }

    func testIsOdd() {
        XCTAssertFalse(T(sign: .plus,  magnitude: M(  )).isOdd)
        XCTAssertFalse(T(sign: .minus, magnitude: M(  )).isOdd)
        
        XCTAssertFalse(T(words:[ 0] as [UInt]).isOdd)
        XCTAssertTrue (T(words:[ 1] as [UInt]).isOdd)
        XCTAssertFalse(T(words:[ 2] as [UInt]).isOdd)

        XCTAssertTrue (T(words:[~0] as [UInt]).isOdd)
        XCTAssertFalse(T(words:[~1] as [UInt]).isOdd)
        XCTAssertTrue (T(words:[~2] as [UInt]).isOdd)
    }

    func testIsEven() {
        XCTAssertTrue (T(sign: .plus,  magnitude: M(  )).isEven)
        XCTAssertTrue (T(sign: .minus, magnitude: M(  )).isEven)
        
        XCTAssertTrue (T(words:[ 0] as [UInt]).isEven)
        XCTAssertFalse(T(words:[ 1] as [UInt]).isEven)
        XCTAssertTrue (T(words:[ 2] as [UInt]).isEven)
        
        XCTAssertFalse(T(words:[~0] as [UInt]).isEven)
        XCTAssertTrue (T(words:[~1] as [UInt]).isEven)
        XCTAssertFalse(T(words:[~2] as [UInt]).isEven)
    }

    func testIsPowerOf2() {
        XCTAssertFalse(T(sign: .plus,  magnitude: M(  )).isPowerOf2)
        XCTAssertFalse(T(sign: .minus, magnitude: M(  )).isPowerOf2)

        XCTAssertFalse(T(words:[~3] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[~2] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[~1] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[~0] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[ 0] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[ 1] as [UInt]).isPowerOf2)
        XCTAssertTrue (T(words:[ 2] as [UInt]).isPowerOf2)
        XCTAssertFalse(T(words:[ 3] as [UInt]).isPowerOf2)
        
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
        NBKAssertSignum(T(sign: .plus,  magnitude: M(  )), Int( 0))
        NBKAssertSignum(T(sign: .minus, magnitude: M(  )), Int( 0))
        
        NBKAssertSignum(T(words:[ 0] as [UInt]), Int( 0))
        NBKAssertSignum(T(words:[ 1] as [UInt]), Int( 1))
        NBKAssertSignum(T(words:[ 2] as [UInt]), Int( 1))

        NBKAssertSignum(T(words:[~0] as [UInt]), Int(-1))
        NBKAssertSignum(T(words:[~1] as [UInt]), Int(-1))
        NBKAssertSignum(T(words:[~2] as [UInt]), Int(-1))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testHashing() {
        var union = Set<T>()
        union.insert(T(sign: .minus, magnitude: M()))
        union.insert(T(sign: .minus, magnitude: M()))
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
    
    func testComparingAtIndex() {
        NBKAssertComparisonsAtIndex( T(0),  T(0), Int(4),  Int(0))
        NBKAssertComparisonsAtIndex( T(0), -T(0), Int(4),  Int(0))
        NBKAssertComparisonsAtIndex(-T(0),  T(0), Int(4),  Int(0))
        NBKAssertComparisonsAtIndex(-T(0), -T(0), Int(4),  Int(0))
        
        NBKAssertComparisonsAtIndex( T(1),  T(1), Int(4), -Int(1))
        NBKAssertComparisonsAtIndex( T(1), -T(1), Int(4),  Int(1))
        NBKAssertComparisonsAtIndex(-T(1),  T(1), Int(4), -Int(1))
        NBKAssertComparisonsAtIndex(-T(1), -T(1), Int(4),  Int(1))
        
        NBKAssertComparisonsAtIndex( T(2),  T(3), Int(4), -Int(1))
        NBKAssertComparisonsAtIndex( T(2), -T(3), Int(4),  Int(1))
        NBKAssertComparisonsAtIndex(-T(2),  T(3), Int(4), -Int(1))
        NBKAssertComparisonsAtIndex(-T(2), -T(3), Int(4),  Int(1))
        
        NBKAssertComparisonsAtIndex( T(3),  T(2), Int(4), -Int(1))
        NBKAssertComparisonsAtIndex( T(3), -T(2), Int(4),  Int(1))
        NBKAssertComparisonsAtIndex(-T(3),  T(2), Int(4), -Int(1))
        NBKAssertComparisonsAtIndex(-T(3), -T(2), Int(4),  Int(1))
        
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
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testComparingByDigit() {
        NBKAssertComparisonsByDigit( T(0),  Int(0),  Int(0))
        NBKAssertComparisonsByDigit( T(0), -Int(0),  Int(0))
        NBKAssertComparisonsByDigit(-T(0),  Int(0),  Int(0))
        NBKAssertComparisonsByDigit(-T(0), -Int(0),  Int(0))
        
        NBKAssertComparisonsByDigit( T(1),  Int(1),  Int(0))
        NBKAssertComparisonsByDigit( T(1), -Int(1),  Int(1))
        NBKAssertComparisonsByDigit(-T(1),  Int(1), -Int(1))
        NBKAssertComparisonsByDigit(-T(1), -Int(1),  Int(0))
        
        NBKAssertComparisonsByDigit( T(2),  Int(3), -Int(1))
        NBKAssertComparisonsByDigit( T(2), -Int(3),  Int(1))
        NBKAssertComparisonsByDigit(-T(2),  Int(3), -Int(1))
        NBKAssertComparisonsByDigit(-T(2), -Int(3),  Int(1))
        
        NBKAssertComparisonsByDigit( T(3),  Int(2),  Int(1))
        NBKAssertComparisonsByDigit( T(3), -Int(2),  Int(1))
        NBKAssertComparisonsByDigit(-T(3),  Int(2), -Int(1))
        NBKAssertComparisonsByDigit(-T(3), -Int(2), -Int(1))
        
        NBKAssertComparisonsByDigit(T(words:[0, 0, 0, 0]), Int(1), -Int(1))
        NBKAssertComparisonsByDigit(T(words:[1, 0, 0, 0]), Int(1),  Int(0))
        NBKAssertComparisonsByDigit(T(words:[2, 0, 0, 0]), Int(1),  Int(1))
        
        NBKAssertComparisonsByDigit(T(words:[0, 1, 0, 0]), Int(1),  Int(1))
        NBKAssertComparisonsByDigit(T(words:[1, 1, 0, 0]), Int(1),  Int(1))
        NBKAssertComparisonsByDigit(T(words:[2, 1, 0, 0]), Int(1),  Int(1))
    }
    
    func testComparingByDigitAtIndex() {
        NBKAssertComparisonsByDigitAtIndex( T(0),  Int(0), Int(4),  Int(0))
        NBKAssertComparisonsByDigitAtIndex( T(0), -Int(0), Int(4),  Int(0))
        NBKAssertComparisonsByDigitAtIndex(-T(0),  Int(0), Int(4),  Int(0))
        NBKAssertComparisonsByDigitAtIndex(-T(0), -Int(0), Int(4),  Int(0))
        
        NBKAssertComparisonsByDigitAtIndex( T(1),  Int(1), Int(4), -Int(1))
        NBKAssertComparisonsByDigitAtIndex( T(1), -Int(1), Int(4),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(-T(1),  Int(1), Int(4), -Int(1))
        NBKAssertComparisonsByDigitAtIndex(-T(1), -Int(1), Int(4),  Int(1))
        
        NBKAssertComparisonsByDigitAtIndex( T(2),  Int(3), Int(4), -Int(1))
        NBKAssertComparisonsByDigitAtIndex( T(2), -Int(3), Int(4),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(-T(2),  Int(3), Int(4), -Int(1))
        NBKAssertComparisonsByDigitAtIndex(-T(2), -Int(3), Int(4),  Int(1))
        
        NBKAssertComparisonsByDigitAtIndex( T(3),  Int(2), Int(4), -Int(1))
        NBKAssertComparisonsByDigitAtIndex( T(3), -Int(2), Int(4),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(-T(3),  Int(2), Int(4), -Int(1))
        NBKAssertComparisonsByDigitAtIndex(-T(3), -Int(2), Int(4),  Int(1))
        
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), Int(4), Int(0),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), Int(4), Int(1),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), Int(4), Int(2),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), Int(4), Int(3),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), Int(4), Int(4), -Int(1))
        
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), Int(5), Int(0),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), Int(5), Int(1),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), Int(5), Int(2),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), Int(5), Int(3), -Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), Int(5), Int(4), -Int(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x.compared(to: 0))
            XCTAssertNotNil(x.compared(to: 0, at: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x UIntXL x Comparisons
//*============================================================================*

final class UIntXLTestsOnComparisons: XCTestCase {

    typealias T = UIntXL
    typealias M = UIntXL

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

    func testComparing() {
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
    
    func testComparingAtIndex() {
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
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testComparingByDigit() {
        NBKAssertComparisonsByDigit(T(words:[0, 0, 0, 0]), UInt(1), -Int(1))
        NBKAssertComparisonsByDigit(T(words:[1, 0, 0, 0]), UInt(1),  Int(0))
        NBKAssertComparisonsByDigit(T(words:[2, 0, 0, 0]), UInt(1),  Int(1))
        
        NBKAssertComparisonsByDigit(T(words:[0, 1, 0, 0]), UInt(1),  Int(1))
        NBKAssertComparisonsByDigit(T(words:[1, 1, 0, 0]), UInt(1),  Int(1))
        NBKAssertComparisonsByDigit(T(words:[2, 1, 0, 0]), UInt(1),  Int(1))
    }
    
    func testComparingByDigitAtIndex() {
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), UInt(4), Int(0),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), UInt(4), Int(1),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), UInt(4), Int(2),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), UInt(4), Int(3),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), UInt(4), Int(4), -Int(1))
        
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), UInt(5), Int(0),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), UInt(5), Int(1),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), UInt(5), Int(2),  Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), UInt(5), Int(3), -Int(1))
        NBKAssertComparisonsByDigitAtIndex(T(words:[1, 2, 3, 4]), UInt(5), Int(4), -Int(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x.compared(to: 0))
            XCTAssertNotNil(x.compared(to: 0, at: 0))
        }
    }
}

#endif
