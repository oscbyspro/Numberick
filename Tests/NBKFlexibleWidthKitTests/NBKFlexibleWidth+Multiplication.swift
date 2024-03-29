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
// MARK: * NBK x Flexible Width x Multiplication x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnMultiplicationAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplying() {
        NBKAssertMultiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[2, 0, 0, 0] as X), T(words:[ 2,  4,  6,  8,  0,  0,  0,  0] as X))
        NBKAssertMultiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[0, 2, 0, 0] as X), T(words:[ 0,  2,  4,  6,  8,  0,  0,  0] as X))
        NBKAssertMultiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[0, 0, 2, 0] as X), T(words:[ 0,  0,  2,  4,  6,  8,  0,  0] as X))
        NBKAssertMultiplication(T(words:[ 1,  2,  3,  4] as X), T(words:[0, 0, 0, 2] as X), T(words:[ 0,  0,  0,  2,  4,  6,  8,  0] as X))
        
        NBKAssertMultiplication(T(words:[~1, ~2, ~3, ~4] as X), T(words:[2, 0, 0, 0] as X), T(words:[~3, ~4, ~6, ~8,  1,  0,  0,  0] as X))
        NBKAssertMultiplication(T(words:[~1, ~2, ~3, ~4] as X), T(words:[0, 2, 0, 0] as X), T(words:[ 0, ~3, ~4, ~6, ~8,  1,  0,  0] as X))
        NBKAssertMultiplication(T(words:[~1, ~2, ~3, ~4] as X), T(words:[0, 0, 2, 0] as X), T(words:[ 0,  0, ~3, ~4, ~6, ~8,  1,  0] as X))
        NBKAssertMultiplication(T(words:[~1, ~2, ~3, ~4] as X), T(words:[0, 0, 0, 2] as X), T(words:[ 0,  0,  0, ~3, ~4, ~6, ~8,  1] as X))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit (and Self)
    //=------------------------------------------------------------------------=
    
    func testMultiplyingByDigit() {
        NBKAssertMultiplicationByDigit(T(words:[1, 2, 3, 4] as X),  UInt(0),  T(words:[ 0,  0,  0,  0,  0] as X))
        NBKAssertMultiplicationByDigit(T(words:[1, 2, 3, 4] as X),  UInt(1),  T(words:[ 1,  2,  3,  4,  0] as X))
        NBKAssertMultiplicationByDigit(T(words:[1, 2, 3, 4] as X),  UInt(2),  T(words:[ 2,  4,  6,  8,  0] as X))

        NBKAssertMultiplicationByDigit(T(words:[1, 2, 3, 4] as X), ~UInt(0), ~T(words:[ 0,  1,  1,  1, ~3] as X))
        NBKAssertMultiplicationByDigit(T(words:[1, 2, 3, 4] as X), ~UInt(1), ~T(words:[ 1,  3,  4,  5, ~3] as X))
        NBKAssertMultiplicationByDigit(T(words:[1, 2, 3, 4] as X), ~UInt(2), ~T(words:[ 2,  5,  7,  9, ~3] as X))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit x Addition
    //=------------------------------------------------------------------------=
    
    func testMultiplyingByDigitWithAddition() {
        NBKAssertMultiplicationByDigitWithAddition(T(words:[~0, ~0, ~0, ~0] as X),  0,  0, T(words:[ 0,  0,  0,  0,  0] as X))
        NBKAssertMultiplicationByDigitWithAddition(T(words:[~0, ~0, ~0, ~0] as X),  0, ~0, T(words:[~0,  0,  0,  0,  0] as X))
        NBKAssertMultiplicationByDigitWithAddition(T(words:[~0, ~0, ~0, ~0] as X), ~0,  0, T(words:[ 1, ~0, ~0, ~0, ~1] as X))
        NBKAssertMultiplicationByDigitWithAddition(T(words:[~0, ~0, ~0, ~0] as X), ~0, ~0, T(words:[ 0,  0,  0,  0, ~0] as X))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Square
    //=------------------------------------------------------------------------=
    
    func testMultiplyingBySquaring() {
        NBKAssertMultiplicationBySquaring(T(words:[ 0,  0,  0,  0] as X), T(words:[ 0,  0,  0,  0,  0,  0,  0,  0] as X))
        NBKAssertMultiplicationBySquaring(T(words:[ 1,  2,  3,  4] as X), T(words:[ 1,  4, 10, 20, 25, 24, 16,  0] as X))
        NBKAssertMultiplicationBySquaring(T(words:[~1, ~2, ~3, ~4] as X), T(words:[ 4,  8, 16, 28, 21, 20, 10, ~7] as X))
        NBKAssertMultiplicationBySquaring(T(words:[~0, ~0, ~0, ~0] as X), T(words:[ 1,  0,  0,  0, ~1, ~0, ~0, ~0] as X))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x  *= 0)
            XCTAssertNotNil(x.multiply(by: 0, add: 0))

            XCTAssertNotNil(x  *  0)
            XCTAssertNotNil(x.multiplied(by: 0, adding: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Multiplication x Assertions
//*============================================================================*

private func NBKAssertMultiplication<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs:  T, _ product: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(                 lhs *  rhs,                 product, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs *= rhs; return lhs }(), product, file: file, line: line)
}

private func NBKAssertMultiplicationByDigit<T: IntXLOrUIntXL>(
_ lhs: T, _ rhs: T.Digit, _ product: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertMultiplication(lhs, T(digit: rhs), product, file: file, line: line)
    //=------------------------------------------=
    XCTAssertEqual(                 lhs *  rhs,                 product, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs *= rhs; return lhs }(), product, file: file, line: line)
}

private func NBKAssertMultiplicationBySquaring<T: IntXLOrUIntXL>(
_ base: T, _ product: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertMultiplication(base, base, product, file: file, line: line)
    //=------------------------------------------=
    XCTAssertEqual(                   base.squared(),                  product, file: file, line: line)
    XCTAssertEqual({ var base = base; base.square (); return base }(), product, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + UIntXL
//=----------------------------------------------------------------------------=

private func NBKAssertMultiplicationByDigitWithAddition(
_ lhs: UIntXL, _ rhs:  UInt, _ addend: UInt, _ product: UIntXL,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(lhs.multiplied(by: rhs, adding: addend),                             product, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs.multiply(by: rhs, add: addend); return lhs }(), product, file: file, line: line)
}
