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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

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
        XCTAssertTrue (T(words:[ 0] as W).isZero)
        XCTAssertFalse(T(words:[ 1] as W).isZero)
        XCTAssertFalse(T(words:[ 2] as W).isZero)

        XCTAssertFalse(T(words:[~0] as W).isZero)
        XCTAssertFalse(T(words:[~1] as W).isZero)
        XCTAssertFalse(T(words:[~2] as W).isZero)
    }

    func testIsLessThanZero() {
        XCTAssertFalse(T(words:[ 0] as W).isLessThanZero)
        XCTAssertFalse(T(words:[ 1] as W).isLessThanZero)
        XCTAssertFalse(T(words:[ 2] as W).isLessThanZero)

        XCTAssertFalse(T(words:[~0] as W).isLessThanZero)
        XCTAssertFalse(T(words:[~1] as W).isLessThanZero)
        XCTAssertFalse(T(words:[~2] as W).isLessThanZero)
    }

    func testIsMoreThanZero() {
        XCTAssertFalse(T(words:[ 0] as W).isMoreThanZero)
        XCTAssertTrue (T(words:[ 1] as W).isMoreThanZero)
        XCTAssertTrue (T(words:[ 2] as W).isMoreThanZero)

        XCTAssertTrue (T(words:[~0] as W).isMoreThanZero)
        XCTAssertTrue (T(words:[~1] as W).isMoreThanZero)
        XCTAssertTrue (T(words:[~2] as W).isMoreThanZero)
    }

    func testIsOdd() {
        XCTAssertFalse(T(words:[ 0] as W).isOdd)
        XCTAssertTrue (T(words:[ 1] as W).isOdd)
        XCTAssertFalse(T(words:[ 2] as W).isOdd)

        XCTAssertTrue (T(words:[~0] as W).isOdd)
        XCTAssertFalse(T(words:[~1] as W).isOdd)
        XCTAssertTrue (T(words:[~2] as W).isOdd)
    }

    func testIsEven() {
        XCTAssertTrue (T(words:[ 0] as W).isEven)
        XCTAssertFalse(T(words:[ 1] as W).isEven)
        XCTAssertTrue (T(words:[ 2] as W).isEven)
        
        XCTAssertFalse(T(words:[~0] as W).isEven)
        XCTAssertTrue (T(words:[~1] as W).isEven)
        XCTAssertFalse(T(words:[~2] as W).isEven)
    }

    func testIsPowerOf2() {
        XCTAssertFalse(T(words:[ 0] as W).isPowerOf2)
        XCTAssertTrue (T(words:[ 1] as W).isPowerOf2)
        XCTAssertTrue (T(words:[ 2] as W).isPowerOf2)
        XCTAssertFalse(T(words:[ 3] as W).isPowerOf2)
        XCTAssertTrue (T(words:[ 4] as W).isPowerOf2)
        XCTAssertFalse(T(words:[ 5] as W).isPowerOf2)
        XCTAssertFalse(T(words:[ 6] as W).isPowerOf2)
        XCTAssertFalse(T(words:[ 7] as W).isPowerOf2)
        
        XCTAssertFalse(T(words:[ 0,  0,  0,  0] as W).isPowerOf2)
        XCTAssertTrue (T(words:[ 1,  0,  0,  0] as W).isPowerOf2)
        XCTAssertFalse(T(words:[ 1,  1,  0,  0] as W).isPowerOf2)
        XCTAssertTrue (T(words:[ 0,  1,  0,  0] as W).isPowerOf2)
        XCTAssertFalse(T(words:[ 0,  1,  1,  0] as W).isPowerOf2)
        XCTAssertTrue (T(words:[ 0,  0,  1,  0] as W).isPowerOf2)
        XCTAssertFalse(T(words:[ 0,  0,  1,  1] as W).isPowerOf2)
        XCTAssertTrue (T(words:[ 0,  0,  0,  1] as W).isPowerOf2)
    }
    
    func testSignum() {
        NBKAssertSignum(T(words:[ 0] as W), Int(0))
        NBKAssertSignum(T(words:[ 1] as W), Int(1))
        NBKAssertSignum(T(words:[ 2] as W), Int(1))

        NBKAssertSignum(T(words:[~0] as W), Int(1))
        NBKAssertSignum(T(words:[~1] as W), Int(1))
        NBKAssertSignum(T(words:[~2] as W), Int(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=

    func testHashing() {
        var union = Set<T>()
        union.insert(T(words:[0, 0, 0, 0] as W))
        union.insert(T(words:[0, 0, 0, 0] as W))
        union.insert(T(words:[1, 0, 0, 0] as W))
        union.insert(T(words:[1, 0, 0, 0] as W))
        union.insert(T(words:[0, 1, 0, 0] as W))
        union.insert(T(words:[0, 1, 0, 0] as W))
        union.insert(T(words:[0, 0, 1, 0] as W))
        union.insert(T(words:[0, 0, 1, 0] as W))
        union.insert(T(words:[0, 0, 0, 1] as W))
        union.insert(T(words:[0, 0, 0, 1] as W))
        XCTAssertEqual(union.count, 5 as Int)
    }

    func testComparing() {
        NBKAssertComparisons(T(words:[0, 2, 3, 4] as W), T(words:[1, 2, 3, 4] as W), -Int(1))
        NBKAssertComparisons(T(words:[1, 0, 3, 4] as W), T(words:[1, 2, 3, 4] as W), -Int(1))
        NBKAssertComparisons(T(words:[1, 2, 0, 4] as W), T(words:[1, 2, 3, 4] as W), -Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 0] as W), T(words:[1, 2, 3, 4] as W), -Int(1))
        NBKAssertComparisons(T(words:[0, 2, 3, 4] as W), T(words:[0, 2, 3, 4] as W),  Int(0))
        NBKAssertComparisons(T(words:[1, 0, 3, 4] as W), T(words:[1, 0, 3, 4] as W),  Int(0))
        NBKAssertComparisons(T(words:[1, 2, 0, 4] as W), T(words:[1, 2, 0, 4] as W),  Int(0))
        NBKAssertComparisons(T(words:[1, 2, 3, 0] as W), T(words:[1, 2, 3, 0] as W),  Int(0))
        NBKAssertComparisons(T(words:[1, 2, 3, 4] as W), T(words:[0, 2, 3, 4] as W),  Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 4] as W), T(words:[1, 0, 3, 4] as W),  Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 4] as W), T(words:[1, 2, 0, 4] as W),  Int(1))
        NBKAssertComparisons(T(words:[1, 2, 3, 4] as W), T(words:[1, 2, 3, 0] as W),  Int(1))
    }
    
    func testComparingAtIndex() {
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as W), T(words:[0, 0, 0, 0] as W), Int(0),  Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as W), T(words:[0, 0, 0, 0] as W), Int(1),  Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as W), T(words:[0, 0, 0, 0] as W), Int(2),  Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as W), T(words:[0, 0, 0, 0] as W), Int(3),  Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as W), T(words:[0, 0, 0, 0] as W), Int(4),  Int(0))
        
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as W), T(words:[1, 2, 3, 4] as W), Int(0), -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as W), T(words:[1, 2, 3, 4] as W), Int(1), -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as W), T(words:[1, 2, 3, 4] as W), Int(2), -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as W), T(words:[1, 2, 3, 4] as W), Int(3), -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 0, 0, 0, 0, 0, 0] as W), T(words:[1, 2, 3, 4] as W), Int(4), -Int(1))
        
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as W), T(words:[0, 0, 0, 0] as W), Int(0),  Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as W), T(words:[0, 0, 0, 0] as W), Int(1),  Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as W), T(words:[0, 0, 0, 0] as W), Int(2),  Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as W), T(words:[0, 0, 0, 0] as W), Int(3),  Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as W), T(words:[0, 0, 0, 0] as W), Int(4),  Int(1))
        
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as W), T(words:[1, 2, 3, 4] as W), Int(0),  Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as W), T(words:[1, 2, 3, 4] as W), Int(1),  Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as W), T(words:[1, 2, 3, 4] as W), Int(2),  Int(0))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as W), T(words:[1, 2, 3, 4] as W), Int(3), -Int(1))
        NBKAssertComparisonsAtIndex(T(words:[0, 0, 1, 2, 3, 4, 0, 0] as W), T(words:[1, 2, 3, 4] as W), Int(4), -Int(1))
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

#endif
