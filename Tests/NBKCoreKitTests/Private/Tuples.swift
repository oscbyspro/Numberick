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
import XCTest

//*============================================================================*
// MARK: * NBK x Arithmagick x Tuples
//*============================================================================*

final class ArithmagickTestsOnTuples: XCTestCase {
    
    typealias T  = UInt64
    typealias T2 = NBK.Wide2<T>
    typealias T3 = NBK.Wide3<T>

    //=------------------------------------------------------------------------=
    // MARK: Tests x Comparisons
    //=------------------------------------------------------------------------=

    func testComparing22S() {
        NBKAssertComparisons22S(T2(0, ~0), T2(1,  0), Int(-1))
        NBKAssertComparisons22S(T2(1,  0), T2(1,  0), Int( 0))
        NBKAssertComparisons22S(T2(1,  0), T2(0, ~0), Int( 1))
        
        NBKAssertComparisons22S(T2(1,  0), T2(1,  1), Int(-1))
        NBKAssertComparisons22S(T2(1,  1), T2(1,  1), Int( 0))
        NBKAssertComparisons22S(T2(1,  1), T2(1,  0), Int( 1))
    }
    
    func testComparing33S() {
        NBKAssertComparisons33S(T3(0, ~0, ~0), T3(1,  0,  0), Int(-1))
        NBKAssertComparisons33S(T3(1,  0,  0), T3(1,  0,  0), Int( 0))
        NBKAssertComparisons33S(T3(1,  0,  0), T3(0, ~0, ~0), Int( 1))

        NBKAssertComparisons33S(T3(1,  0, ~0), T3(1,  1,  0), Int(-1))
        NBKAssertComparisons33S(T3(1,  1,  0), T3(1,  1,  0), Int( 0))
        NBKAssertComparisons33S(T3(1,  1,  0), T3(1,  0, ~0), Int( 1))

        NBKAssertComparisons33S(T3(1,  1,  0), T3(1,  1,  1), Int(-1))
        NBKAssertComparisons33S(T3(1,  1,  1), T3(1,  1,  1), Int( 0))
        NBKAssertComparisons33S(T3(1,  1,  1), T3(1,  1,  0), Int( 1))
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

private func NBKAssertComparisons22S<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide2<T>, _ rhs: NBK.Wide2<T>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(NBK.compare22S(lhs, to: rhs), signum, file: file, line: line)
}

private func NBKAssertComparisons33S<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<T>, _ rhs: NBK.Wide3<T>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(NBK.compare33S(lhs, to: rhs), signum, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities x Addition
//=----------------------------------------------------------------------------=

private func NBKAssertAdding32B<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<T>, _ rhs: NBK.Wide2<T>, _ sum: NBK.Wide3<T>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    var x = lhs
    let o = NBK.increment32B(&x, by: rhs)
    XCTAssertEqual(x.low,  sum.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  sum.mid,  file: file, line: line)
    XCTAssertEqual(x.high, sum.high, file: file, line: line)
    XCTAssertEqual(o,      overflow, file: file, line: line)
}

private func NBKAssertAdding33B<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<T>, _ rhs: NBK.Wide3<T>, _ sum: NBK.Wide3<T>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    var x = lhs
    let o = NBK.increment33B(&x, by: rhs)
    XCTAssertEqual(x.low,  sum.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  sum.mid,  file: file, line: line)
    XCTAssertEqual(x.high, sum.high, file: file, line: line)
    XCTAssertEqual(o,      overflow, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities x Subtraction
//=----------------------------------------------------------------------------=

private func NBKAssertSubtraction32B<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<T>, _ rhs: NBK.Wide2<T>, _ difference: NBK.Wide3<T>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    var x = lhs
    let o = NBK.decrement32B(&x, by: rhs)
    XCTAssertEqual(x.low,  difference.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  difference.mid,  file: file, line: line)
    XCTAssertEqual(x.high, difference.high, file: file, line: line)
    XCTAssertEqual(o,      overflow,        file: file, line: line)
}

private func NBKAssertSubtraction33B<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<T>, _ rhs: NBK.Wide3<T>, _ difference: NBK.Wide3<T>, _ overflow: Bool,
file: StaticString = #file, line: UInt = #line) {
    var x = lhs
    let o = NBK.decrement33B(&x, by: rhs)
    XCTAssertEqual(x.low,  difference.low,  file: file, line: line)
    XCTAssertEqual(x.mid,  difference.mid,  file: file, line: line)
    XCTAssertEqual(x.high, difference.high, file: file, line: line)
    XCTAssertEqual(o,      overflow,        file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Utilities x Multiplication
//=----------------------------------------------------------------------------=

private func NBKAssertMultiplication213<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide2<T>, _ rhs: T, _ product: NBK.Wide3<T>,
file: StaticString = #file, line: UInt = #line) {
    let (high, mid, low) = NBK.multiplying213(lhs, by: rhs)
    XCTAssertEqual(low,  product.low,  file: file, line: line)
    XCTAssertEqual(mid,  product.mid,  file: file, line: line)
    XCTAssertEqual(high, product.high, file: file, line: line)
}

#endif
