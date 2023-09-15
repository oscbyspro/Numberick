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
import NBKSignedKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Signed x Comparisons
//*============================================================================*

final class NBKSignedTestsOnComparisonsAsSIntXL: XCTestCase {

    typealias T = NBKSigned<UIntXL>
    typealias M = NBKSigned<UIntXL>.Magnitude
    typealias D = NBKSigned<UIntXL>.Digit
    typealias U = NBKSigned<UIntXL>.Digit.Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testIsZero() {
        XCTAssertTrue (( T(0)).isZero)
        XCTAssertTrue ((-T(0)).isZero)
        XCTAssertFalse(( T(1)).isZero)
        XCTAssertFalse((-T(1)).isZero)
    }

    func testIsLessThanZero() {
        XCTAssertFalse(( T(0)).isLessThanZero)
        XCTAssertFalse((-T(0)).isLessThanZero)
        XCTAssertFalse(( T(1)).isLessThanZero)
        XCTAssertTrue ((-T(1)).isLessThanZero)
    }

    func testIsMoreThanZero() {
        XCTAssertFalse(( T(0)).isMoreThanZero)
        XCTAssertFalse((-T(0)).isMoreThanZero)
        XCTAssertTrue (( T(1)).isMoreThanZero)
        XCTAssertFalse((-T(1)).isMoreThanZero)
    }

    func testSignum() {
        NBKAssertSignum(( T(0)), Int( 0))
        NBKAssertSignum((-T(0)), Int( 0))
        NBKAssertSignum(( T(1)), Int( 1))
        NBKAssertSignum((-T(1)), Int(-1))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testHashing() {
        var union = Set<T>()
        union.insert( T(0))
        union.insert( T(0))
        union.insert(-T(0))
        union.insert(-T(0))
        union.insert( T(1))
        union.insert( T(1))
        union.insert(-T(1))
        union.insert(-T(1))
        XCTAssertEqual(union.count, 3)
    }
    
    func testComparingLargeWithLarge() {
        NBKAssertComparisons(T(M(words:[0, 2, 3, 4] as W)), T(M(words:[1, 2, 3, 4] as W)), -Int(1))
        NBKAssertComparisons(T(M(words:[1, 0, 3, 4] as W)), T(M(words:[1, 2, 3, 4] as W)), -Int(1))
        NBKAssertComparisons(T(M(words:[1, 2, 0, 4] as W)), T(M(words:[1, 2, 3, 4] as W)), -Int(1))
        NBKAssertComparisons(T(M(words:[1, 2, 3, 0] as W)), T(M(words:[1, 2, 3, 4] as W)), -Int(1))
        NBKAssertComparisons(T(M(words:[0, 2, 3, 4] as W)), T(M(words:[0, 2, 3, 4] as W)),  Int(0))
        NBKAssertComparisons(T(M(words:[1, 0, 3, 4] as W)), T(M(words:[1, 0, 3, 4] as W)),  Int(0))
        NBKAssertComparisons(T(M(words:[1, 2, 0, 4] as W)), T(M(words:[1, 2, 0, 4] as W)),  Int(0))
        NBKAssertComparisons(T(M(words:[1, 2, 3, 0] as W)), T(M(words:[1, 2, 3, 0] as W)),  Int(0))
        NBKAssertComparisons(T(M(words:[1, 2, 3, 4] as W)), T(M(words:[0, 2, 3, 4] as W)),  Int(1))
        NBKAssertComparisons(T(M(words:[1, 2, 3, 4] as W)), T(M(words:[1, 0, 3, 4] as W)),  Int(1))
        NBKAssertComparisons(T(M(words:[1, 2, 3, 4] as W)), T(M(words:[1, 2, 0, 4] as W)),  Int(1))
        NBKAssertComparisons(T(M(words:[1, 2, 3, 4] as W)), T(M(words:[1, 2, 3, 0] as W)),  Int(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit (and Self)
    //=------------------------------------------------------------------------=
    
    func testComparingSmallWithSmall() {
        NBKAssertComparisonsByDigit( T(0),  D(0),  Int(0))
        NBKAssertComparisonsByDigit( T(0), -D(0),  Int(0))
        NBKAssertComparisonsByDigit(-T(0),  D(0),  Int(0))
        NBKAssertComparisonsByDigit(-T(0), -D(0),  Int(0))
        
        NBKAssertComparisonsByDigit( T(1),  D(1),  Int(0))
        NBKAssertComparisonsByDigit( T(1), -D(1),  Int(1))
        NBKAssertComparisonsByDigit(-T(1),  D(1), -Int(1))
        NBKAssertComparisonsByDigit(-T(1), -D(1),  Int(0))
        
        NBKAssertComparisonsByDigit( T(2),  D(3), -Int(1))
        NBKAssertComparisonsByDigit( T(2), -D(3),  Int(1))
        NBKAssertComparisonsByDigit(-T(2),  D(3), -Int(1))
        NBKAssertComparisonsByDigit(-T(2), -D(3),  Int(1))
        
        NBKAssertComparisonsByDigit( T(3),  D(2),  Int(1))
        NBKAssertComparisonsByDigit( T(3), -D(2),  Int(1))
        NBKAssertComparisonsByDigit(-T(3),  D(2), -Int(1))
        NBKAssertComparisonsByDigit(-T(3), -D(2), -Int(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguous() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x.signum())
        }
    }
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x.compared(to: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Comparisons x Assertions
//*============================================================================*

private func NBKAssertSignum<M>(
_ operand: NBKSigned<M>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(Int(operand.signum() as Int), signum, file: file, line: line)
}

private func NBKAssertComparisons<M>(
_ lhs: NBKSigned<M>, _ rhs: NBKSigned<M>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(lhs == rhs, signum ==  0, file: file, line: line)
    XCTAssertEqual(lhs != rhs, signum !=  0, file: file, line: line)
    
    XCTAssertEqual(lhs <  rhs, signum == -1, file: file, line: line)
    XCTAssertEqual(lhs <= rhs, signum !=  1, file: file, line: line)
    
    XCTAssertEqual(lhs >  rhs, signum ==  1, file: file, line: line)
    XCTAssertEqual(lhs >= rhs, signum != -1, file: file, line: line)
    
    XCTAssertEqual(lhs.compared(to: rhs), signum, file: file, line: line)
}

private func NBKAssertComparisonsByDigit<M>(
_ lhs: NBKSigned<M>, _ rhs: NBKSigned<M>.Digit, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertComparisons(lhs, NBKSigned<M>(digit: rhs), signum)
    //=------------------------------------------=
    XCTAssertEqual(lhs.compared(to: rhs), signum, file: file, line: line)
}

#endif
