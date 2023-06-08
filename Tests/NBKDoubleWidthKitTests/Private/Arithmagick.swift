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
@testable import NBKDoubleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x Arithmagick x UInt
//*============================================================================*

final class ArithmagickTestsOnUInt: XCTestCase {
    
    typealias T = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let bitWidth = T(T.bitWidth)
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividingByBitWidth() {
        NBKAssertDividingByBitWidthAsUInt(T(0) * bitWidth + T(0), T(0), T(0))
        NBKAssertDividingByBitWidthAsUInt(T(0) * bitWidth + T(1), T(0), T(1))
        NBKAssertDividingByBitWidthAsUInt(T(0) * bitWidth + T(2), T(0), T(2))
        NBKAssertDividingByBitWidthAsUInt(T(0) * bitWidth + T(3), T(0), T(3))
        
        NBKAssertDividingByBitWidthAsUInt(T(1) * bitWidth + T(0), T(1), T(0))
        NBKAssertDividingByBitWidthAsUInt(T(1) * bitWidth + T(1), T(1), T(1))
        NBKAssertDividingByBitWidthAsUInt(T(1) * bitWidth + T(2), T(1), T(2))
        NBKAssertDividingByBitWidthAsUInt(T(1) * bitWidth + T(3), T(1), T(3))
        
        NBKAssertDividingByBitWidthAsUInt(T(2) * bitWidth + T(0), T(2), T(0))
        NBKAssertDividingByBitWidthAsUInt(T(2) * bitWidth + T(1), T(2), T(1))
        NBKAssertDividingByBitWidthAsUInt(T(2) * bitWidth + T(2), T(2), T(2))
        NBKAssertDividingByBitWidthAsUInt(T(2) * bitWidth + T(3), T(2), T(3))
        
        NBKAssertDividingByBitWidthAsUInt(T.min, T.min / bitWidth, T.min % bitWidth)
        NBKAssertDividingByBitWidthAsUInt(T.max, T.max / bitWidth, T.max % bitWidth)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities
//=----------------------------------------------------------------------------=

private func NBKAssertDividingByBitWidthAsUInt(
_ value: UInt, _ quotient: UInt, _ remainder: UInt,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(value .quotientDividingByBitWidth(), quotient,  file: file, line: line)
    XCTAssertEqual(value.remainderDividingByBitWidth(), remainder, file: file, line: line)
    
    XCTAssertEqual(value.dividedByBitWidth().quotient,  quotient,  file: file, line: line)
    XCTAssertEqual(value.dividedByBitWidth().remainder, remainder, file: file, line: line)
}

//*============================================================================*
// MARK: * NBK x Arithmagick x Tuples
//*============================================================================*

final class ArithmagickTestsOnTuples: XCTestCase {
    
    typealias T  = UInt64
    typealias T2 = Wide2<T>
    typealias T3 = Wide3<T>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Comparisons
    //=------------------------------------------------------------------------=
    
    func testComparing33S() {
        NBKAssertComparisons33S(T3(0, ~0, ~0), T3(1,  0,  0), -1)
        NBKAssertComparisons33S(T3(1,  0,  0), T3(1,  0,  0),  0)
        NBKAssertComparisons33S(T3(1,  0,  0), T3(0, ~0, ~0),  1)

        NBKAssertComparisons33S(T3(1,  0, ~0), T3(1,  1,  0), -1)
        NBKAssertComparisons33S(T3(1,  1,  0), T3(1,  1,  0),  0)
        NBKAssertComparisons33S(T3(1,  1,  0), T3(1,  0, ~0),  1)
        
        NBKAssertComparisons33S(T3(1,  1,  0), T3(1,  1,  1), -1)
        NBKAssertComparisons33S(T3(1,  1,  1), T3(1,  1,  1),  0)
        NBKAssertComparisons33S(T3(1,  1,  1), T3(1,  1,  0),  1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Addition
    //=------------------------------------------------------------------------=
    
    func testAdding32B() {
        NBKAssertAdding32B(T3( 0,  0,  0), T2(~4, ~5), T3( 0, ~4, ~5), false)
        NBKAssertAdding32B(T3( 1,  2,  3), T2(~4, ~5), T3( 1, ~2, ~2), false)
        NBKAssertAdding32B(T3(~1, ~2, ~3), T2( 4,  5), T3(~0,  2,  1), false)
        NBKAssertAdding32B(T3(~0, ~0, ~0), T2( 4,  5), T3( 0,  4,  4), true )
    }
    
    func testAdding33B() {
        NBKAssertAdding33B(T3( 0,  0,  0), T3(~4, ~5, ~6), T3(~4, ~5, ~6), false)
        NBKAssertAdding33B(T3( 1,  2,  3), T3(~4, ~5, ~6), T3(~3, ~3, ~3), false)
        NBKAssertAdding33B(T3(~1, ~2, ~3), T3( 4,  5,  6), T3( 3,  3,  2), true )
        NBKAssertAdding33B(T3(~0, ~0, ~0), T3( 4,  5,  6), T3( 4,  5,  5), true )
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Subtraction
    //=------------------------------------------------------------------------=
    
    func testSubtracting32B() {
        NBKAssertSubtraction32B(T3( 0,  0,  0), T2(~4, ~5), T3(~0,  4,  6), true )
        NBKAssertSubtraction32B(T3( 1,  2,  3), T2(~4, ~5), T3( 0,  6,  9), false)
        NBKAssertSubtraction32B(T3(~1, ~2, ~3), T2( 4,  5), T3(~1, ~6, ~8), false)
        NBKAssertSubtraction32B(T3(~0, ~0, ~0), T2( 4,  5), T3(~0, ~4, ~5), false)
    }
    
    func testSubtracting33B() {
        NBKAssertSubtraction33B(T3( 0,  0,  0), T3(~4, ~5, ~6), T3( 4,  5,  7), true )
        NBKAssertSubtraction33B(T3( 1,  2,  3), T3(~4, ~5, ~6), T3( 5,  7, 10), true )
        NBKAssertSubtraction33B(T3(~1, ~2, ~3), T3( 4,  5,  6), T3(~5, ~7, ~9), false)
        NBKAssertSubtraction33B(T3(~0, ~0, ~0), T3( 4,  5,  6), T3(~4, ~5, ~6), false)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Multiplication
    //=------------------------------------------------------------------------=
    
    func testMultipliplying213() {
        NBKAssertMultiplication213(T2( 1,  2),  3, T3( 0,  3,  6))
        NBKAssertMultiplication213(T2(~1, ~2), ~3, T3(~4,  1, 12))
        NBKAssertMultiplication213(T2(~0, ~0), ~0, T3(~1, ~0,  1))
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities x Comparisons
//=----------------------------------------------------------------------------=

private func NBKAssertComparisons33S<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: Wide3<T>, _ rhs: Wide3<T>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(T.compare33S(lhs, to: rhs), signum, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities x Addition
//=----------------------------------------------------------------------------=

private func NBKAssertAdding32B<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: Wide3<T>, _ rhs: Wide2<T>, _ sum: Wide3<T>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    var x = lhs
    let o = T.increment32B(&x, by: rhs)
    XCTAssertEqual(x.low,  sum.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  sum.mid,  file: file, line: line)
    XCTAssertEqual(x.high, sum.high, file: file, line: line)
    XCTAssertEqual(o,      overflow, file: file, line: line)
}

private func NBKAssertAdding33B<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: Wide3<T>, _ rhs: Wide3<T>, _ sum: Wide3<T>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    var x = lhs
    let o = T.increment33B(&x, by: rhs)
    XCTAssertEqual(x.low,  sum.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  sum.mid,  file: file, line: line)
    XCTAssertEqual(x.high, sum.high, file: file, line: line)
    XCTAssertEqual(o,      overflow, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities x Subtraction
//=----------------------------------------------------------------------------=

private func NBKAssertSubtraction32B<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: Wide3<T>, _ rhs: Wide2<T>, _ difference: Wide3<T>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    var x = lhs
    let o = T.decrement32B(&x, by: rhs)
    XCTAssertEqual(x.low,  difference.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  difference.mid,  file: file, line: line)
    XCTAssertEqual(x.high, difference.high, file: file, line: line)
    XCTAssertEqual(o,      overflow,        file: file, line: line)
}

private func NBKAssertSubtraction33B<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: Wide3<T>, _ rhs: Wide3<T>, _ difference: Wide3<T>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    var x = lhs
    let o = T.decrement33B(&x, by: rhs)
    XCTAssertEqual(x.low,  difference.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  difference.mid,  file: file, line: line)
    XCTAssertEqual(x.high, difference.high, file: file, line: line)
    XCTAssertEqual(o,      overflow,        file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities x Multiplication
//=----------------------------------------------------------------------------=

private func NBKAssertMultiplication213<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: Wide2<T>, _ rhs: T, _ product: Wide3<T>,
file: StaticString = #file, line: UInt = #line) {
    let (high, mid, low) = T.multiplying213(lhs, by: rhs)
    XCTAssertEqual(low,  product.low,  file: file, line: line)
    XCTAssertEqual(mid,  product.mid,  file: file, line: line)
    XCTAssertEqual(high, product.high, file: file, line: line)
}

#endif
