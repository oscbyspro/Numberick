//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Comparisons x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnComparisonsAsUIntXL: XCTestCase {

    typealias T = UIntXL
    typealias M = UIntXL

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testIsZero() {
        XCTAssertTrue (T(words:[ 0] as X).isZero)
        XCTAssertFalse(T(words:[ 1] as X).isZero)
        XCTAssertFalse(T(words:[ 2] as X).isZero)

        XCTAssertFalse(T(words:[~0] as X).isZero)
        XCTAssertFalse(T(words:[~1] as X).isZero)
        XCTAssertFalse(T(words:[~2] as X).isZero)
    }

    func testIsLessThanZero() {
        XCTAssertFalse(T(words:[ 0] as X).isLessThanZero)
        XCTAssertFalse(T(words:[ 1] as X).isLessThanZero)
        XCTAssertFalse(T(words:[ 2] as X).isLessThanZero)

        XCTAssertFalse(T(words:[~0] as X).isLessThanZero)
        XCTAssertFalse(T(words:[~1] as X).isLessThanZero)
        XCTAssertFalse(T(words:[~2] as X).isLessThanZero)
    }

    func testIsMoreThanZero() {
        XCTAssertFalse(T(words:[ 0] as X).isMoreThanZero)
        XCTAssertTrue (T(words:[ 1] as X).isMoreThanZero)
        XCTAssertTrue (T(words:[ 2] as X).isMoreThanZero)

        XCTAssertTrue (T(words:[~0] as X).isMoreThanZero)
        XCTAssertTrue (T(words:[~1] as X).isMoreThanZero)
        XCTAssertTrue (T(words:[~2] as X).isMoreThanZero)
    }

    func testIsOdd() {
        XCTAssertFalse(T(words:[ 0] as X).isOdd)
        XCTAssertTrue (T(words:[ 1] as X).isOdd)
        XCTAssertFalse(T(words:[ 2] as X).isOdd)

        XCTAssertTrue (T(words:[~0] as X).isOdd)
        XCTAssertFalse(T(words:[~1] as X).isOdd)
        XCTAssertTrue (T(words:[~2] as X).isOdd)
    }

    func testIsEven() {
        XCTAssertTrue (T(words:[ 0] as X).isEven)
        XCTAssertFalse(T(words:[ 1] as X).isEven)
        XCTAssertTrue (T(words:[ 2] as X).isEven)
        
        XCTAssertFalse(T(words:[~0] as X).isEven)
        XCTAssertTrue (T(words:[~1] as X).isEven)
        XCTAssertFalse(T(words:[~2] as X).isEven)
    }

    func testIsPowerOf2() {
        XCTAssertFalse(T(words:[ 0] as X).isPowerOf2)
        XCTAssertTrue (T(words:[ 1] as X).isPowerOf2)
        XCTAssertTrue (T(words:[ 2] as X).isPowerOf2)
        XCTAssertFalse(T(words:[ 3] as X).isPowerOf2)
        XCTAssertTrue (T(words:[ 4] as X).isPowerOf2)
        XCTAssertFalse(T(words:[ 5] as X).isPowerOf2)
        XCTAssertFalse(T(words:[ 6] as X).isPowerOf2)
        XCTAssertFalse(T(words:[ 7] as X).isPowerOf2)
        
        XCTAssertFalse(T(words:[ 0,  0,  0,  0] as X).isPowerOf2)
        XCTAssertTrue (T(words:[ 1,  0,  0,  0] as X).isPowerOf2)
        XCTAssertFalse(T(words:[ 1,  1,  0,  0] as X).isPowerOf2)
        XCTAssertTrue (T(words:[ 0,  1,  0,  0] as X).isPowerOf2)
        XCTAssertFalse(T(words:[ 0,  1,  1,  0] as X).isPowerOf2)
        XCTAssertTrue (T(words:[ 0,  0,  1,  0] as X).isPowerOf2)
        XCTAssertFalse(T(words:[ 0,  0,  1,  1] as X).isPowerOf2)
        XCTAssertTrue (T(words:[ 0,  0,  0,  1] as X).isPowerOf2)
    }
    
    func testSignum() {
        NBKAssertSignum(T(words:[ 0] as X), Int(0))
        NBKAssertSignum(T(words:[ 1] as X), Int(1))
        NBKAssertSignum(T(words:[ 2] as X), Int(1))

        NBKAssertSignum(T(words:[~0] as X), Int(1))
        NBKAssertSignum(T(words:[~1] as X), Int(1))
        NBKAssertSignum(T(words:[~2] as X), Int(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testHashing() {
        var union = Set<T>()
        union.insert(T(words:[0, 0, 0, 0] as X))
        union.insert(T(words:[0, 0, 0, 0] as X))
        union.insert(T(words:[1, 0, 0, 0] as X))
        union.insert(T(words:[1, 0, 0, 0] as X))
        union.insert(T(words:[0, 1, 0, 0] as X))
        union.insert(T(words:[0, 1, 0, 0] as X))
        union.insert(T(words:[0, 0, 1, 0] as X))
        union.insert(T(words:[0, 0, 1, 0] as X))
        union.insert(T(words:[0, 0, 0, 1] as X))
        union.insert(T(words:[0, 0, 0, 1] as X))
        XCTAssertEqual(union.count, 5 as Int)
    }

    func testComparing() {
        NBKAssertComparisons(T(words:[0, 2, 3, 4] as X), T(words:[1, 2, 3, 4] as X), -Int(1))
        NBKAssertComparisons(T(words:[1, 0, 3, 4] as X), T(words:[1, 2, 3, 4] as X), -Int(1))
        NBKAssertComparisons(T(words:[1, 2, 0, 4] as X), T(words:[1, 2, 3, 4] as X), -Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 0] as X), T(words:[1, 2, 3, 4] as X), -Int(1))
        NBKAssertComparisons(T(words:[0, 2, 3, 4] as X), T(words:[0, 2, 3, 4] as X),  Int(0))
        NBKAssertComparisons(T(words:[1, 0, 3, 4] as X), T(words:[1, 0, 3, 4] as X),  Int(0))
        NBKAssertComparisons(T(words:[1, 2, 0, 4] as X), T(words:[1, 2, 0, 4] as X),  Int(0))
        NBKAssertComparisons(T(words:[1, 2, 3, 0] as X), T(words:[1, 2, 3, 0] as X),  Int(0))
        NBKAssertComparisons(T(words:[1, 2, 3, 4] as X), T(words:[0, 2, 3, 4] as X),  Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 4] as X), T(words:[1, 0, 3, 4] as X),  Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 4] as X), T(words:[1, 2, 0, 4] as X),  Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 4] as X), T(words:[1, 2, 3, 0] as X),  Int(1))
    }
    
    func testComparingAtIndex() {
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as X), T(words:[0, 0, 0, 0] as X), Int(0),  Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as X), T(words:[0, 0, 0, 0] as X), Int(1),  Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as X), T(words:[0, 0, 0, 0] as X), Int(2),  Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as X), T(words:[0, 0, 0, 0] as X), Int(3),  Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as X), T(words:[0, 0, 0, 0] as X), Int(4),  Int(0))
        
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as X), T(words:[1, 2, 3, 4] as X), Int(0), -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as X), T(words:[1, 2, 3, 4] as X), Int(1), -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as X), T(words:[1, 2, 3, 4] as X), Int(2), -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as X), T(words:[1, 2, 3, 4] as X), Int(3), -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as X), T(words:[1, 2, 3, 4] as X), Int(4), -Int(1))
        
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 0, 0, 0] as X), Int(0),  Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 0, 0, 0] as X), Int(1),  Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 0, 0, 0] as X), Int(2),  Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 0, 0, 0] as X), Int(3),  Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[0, 0, 0, 0] as X), Int(4),  Int(1))
        
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[1, 2, 3, 4] as X), Int(0),  Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[1, 2, 3, 4] as X), Int(1),  Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[1, 2, 3, 4] as X), Int(2),  Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[1, 2, 3, 4] as X), Int(3), -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as X), T(words:[1, 2, 3, 4] as X), Int(4), -Int(1))
    }
    
    func testComparingByDigit() {
        NBKAssertComparisonsByDigit(T(0), UInt(0),  Int(0))
        NBKAssertComparisonsByDigit(T(1), UInt(1),  Int(0))
        NBKAssertComparisonsByDigit(T(2), UInt(3), -Int(1))
        NBKAssertComparisonsByDigit(T(3), UInt(2),  Int(1))
        
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
    
    func testOverloadsAreUnambiguous() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x.signum())
        }
    }
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x.compared(to: 0))
            XCTAssertNotNil(x.compared(to: 0, at: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Comparisons x Assertions
//*============================================================================*

private func NBKAssertSignum<T: NBKBinaryInteger>(
_ operand: T, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(Int(operand.signum() as Int), signum, file: file, line: line)
    XCTAssertEqual(Int(operand.signum() as T  ), signum, file: file, line: line) // stdlib
}

private func NBKAssertComparisons<T: NBKBinaryInteger>(
_ lhs: T, _ rhs: T, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(lhs == rhs, signum ==  0, file: file, line: line)
    XCTAssertEqual(lhs != rhs, signum !=  0, file: file, line: line)
    
    XCTAssertEqual(lhs <  rhs, signum == -1, file: file, line: line)
    XCTAssertEqual(lhs <= rhs, signum !=  1, file: file, line: line)
    
    XCTAssertEqual(lhs >  rhs, signum ==  1, file: file, line: line)
    XCTAssertEqual(lhs >= rhs, signum != -1, file: file, line: line)
    
    XCTAssertEqual(lhs.compared(to: rhs), signum, file: file, line: line)
}

private func NBKAssertComparisonsAtIndex<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs: T, _ index: Int, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  index.isZero {
        NBKAssertComparisons(lhs, rhs, signum, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs.compared(to: rhs, at: index), signum, file: file, line: line)
}

private func NBKAssertComparisonsByDigit<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs: T.Digit, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(lhs == rhs, signum ==  0, file: file, line: line)
    XCTAssertEqual(lhs != rhs, signum !=  0, file: file, line: line)
    
    XCTAssertEqual(lhs <  rhs, signum == -1, file: file, line: line)
    XCTAssertEqual(lhs <= rhs, signum !=  1, file: file, line: line)
    
    XCTAssertEqual(lhs >  rhs, signum ==  1, file: file, line: line)
    XCTAssertEqual(lhs >= rhs, signum != -1, file: file, line: line)
    
    XCTAssertEqual(lhs.compared(to: rhs), signum, file: file, line: line)
}

private func NBKAssertComparisonsByDigitAtIndex<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs: T.Digit, _ index: Int, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  index.isZero {
        NBKAssertComparisonsByDigit(lhs, rhs, signum, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(lhs.compared(to: rhs, at: index), signum, file: file, line: line)
}
