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
// MARK: * NBK x Tuples
//*============================================================================*

final class TuplesTests: XCTestCase {
    
    typealias S  = Int64
    typealias S2 = NBK.Wide2<S>
    typealias S3 = NBK.Wide3<S>
    
    typealias M  = UInt64
    typealias M2 = NBK.Wide2<M>
    typealias M3 = NBK.Wide3<M>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Complements
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        NBKAssertMagnitude(S2(~1, ~1), M2( 1,  2))
        NBKAssertMagnitude(S2(~0,  0), M2( 1,  0))
        NBKAssertMagnitude(S2( 0,  0), M2( 0,  0))
        NBKAssertMagnitude(S2( 1,  0), M2( 1,  0))
        NBKAssertMagnitude(S2( 1,  2), M2( 1,  2))
        
        NBKAssertMagnitude(M2(~1, ~1), M2(~1, ~1))
        NBKAssertMagnitude(M2(~0,  0), M2(~0,  0))
        NBKAssertMagnitude(M2( 0,  0), M2( 0,  0))
        NBKAssertMagnitude(M2( 1,  0), M2( 1,  0))
        NBKAssertMagnitude(M2( 1,  2), M2( 1,  2))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Comparisons
    //=------------------------------------------------------------------------=

    func testComparing22S() {
        NBKAssertComparisons22S(M2(0, ~0), M2(1,  0), Int(-1))
        NBKAssertComparisons22S(M2(1,  0), M2(1,  0), Int( 0))
        NBKAssertComparisons22S(M2(1,  0), M2(0, ~0), Int( 1))
        
        NBKAssertComparisons22S(M2(1,  0), M2(1,  1), Int(-1))
        NBKAssertComparisons22S(M2(1,  1), M2(1,  1), Int( 0))
        NBKAssertComparisons22S(M2(1,  1), M2(1,  0), Int( 1))
    }
    
    func testComparing33S() {
        NBKAssertComparisons33S(M3(0, ~0, ~0), M3(1,  0,  0), Int(-1))
        NBKAssertComparisons33S(M3(1,  0,  0), M3(1,  0,  0), Int( 0))
        NBKAssertComparisons33S(M3(1,  0,  0), M3(0, ~0, ~0), Int( 1))

        NBKAssertComparisons33S(M3(1,  0, ~0), M3(1,  1,  0), Int(-1))
        NBKAssertComparisons33S(M3(1,  1,  0), M3(1,  1,  0), Int( 0))
        NBKAssertComparisons33S(M3(1,  1,  0), M3(1,  0, ~0), Int( 1))

        NBKAssertComparisons33S(M3(1,  1,  0), M3(1,  1,  1), Int(-1))
        NBKAssertComparisons33S(M3(1,  1,  1), M3(1,  1,  1), Int( 0))
        NBKAssertComparisons33S(M3(1,  1,  1), M3(1,  1,  0), Int( 1))
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Addition
    //=------------------------------------------------------------------------=

    func testAdding32B() {
        NBKAssertAdding32B(M3( 0,  0,  0), M2(~4, ~5), M3( 0, ~4, ~5), false)
        NBKAssertAdding32B(M3( 1,  2,  3), M2(~4, ~5), M3( 1, ~2, ~2), false)
        NBKAssertAdding32B(M3(~1, ~2, ~3), M2( 4,  5), M3(~0,  2,  1), false)
        NBKAssertAdding32B(M3(~0, ~0, ~0), M2( 4,  5), M3( 0,  4,  4), true )
    }

    func testAdding33B() {
        NBKAssertAdding33B(M3( 0,  0,  0), M3(~4, ~5, ~6), M3(~4, ~5, ~6), false)
        NBKAssertAdding33B(M3( 1,  2,  3), M3(~4, ~5, ~6), M3(~3, ~3, ~3), false)
        NBKAssertAdding33B(M3(~1, ~2, ~3), M3( 4,  5,  6), M3( 3,  3,  2), true )
        NBKAssertAdding33B(M3(~0, ~0, ~0), M3( 4,  5,  6), M3( 4,  5,  5), true )
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Subtraction
    //=------------------------------------------------------------------------=

    func testSubtracting32B() {
        NBKAssertSubtraction32B(M3( 0,  0,  0), M2(~4, ~5), M3(~0,  4,  6), true )
        NBKAssertSubtraction32B(M3( 1,  2,  3), M2(~4, ~5), M3( 0,  6,  9), false)
        NBKAssertSubtraction32B(M3(~1, ~2, ~3), M2( 4,  5), M3(~1, ~6, ~8), false)
        NBKAssertSubtraction32B(M3(~0, ~0, ~0), M2( 4,  5), M3(~0, ~4, ~5), false)
    }
    
    func testSubtracting33B() {
        NBKAssertSubtraction33B(M3( 0,  0,  0), M3(~4, ~5, ~6), M3( 4,  5,  7), true )
        NBKAssertSubtraction33B(M3( 1,  2,  3), M3(~4, ~5, ~6), M3( 5,  7, 10), true )
        NBKAssertSubtraction33B(M3(~1, ~2, ~3), M3( 4,  5,  6), M3(~5, ~7, ~9), false)
        NBKAssertSubtraction33B(M3(~0, ~0, ~0), M3( 4,  5,  6), M3(~4, ~5, ~6), false)
    }

    //=------------------------------------------------------------------------=
    // MARK: Tests x Multiplication
    //=------------------------------------------------------------------------=

    func testMultiplying213() {
        NBKAssertMultiplication213(M2( 1,  2),  3, M3( 0,  3,  6))
        NBKAssertMultiplication213(M2(~1, ~2), ~3, M3(~4,  1, 12))
        NBKAssertMultiplication213(M2(~0, ~0), ~0, M3(~1, ~0,  1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Division
    //=------------------------------------------------------------------------=
    
    func testDividing3212MSB() {
        NBKAssertDivision3212MSB(M3(~0,  0,  0), M2(~0,  1), ~M(0), M2(~1,  1))
        NBKAssertDivision3212MSB(M3(~0,  0,  0), M2(~0, ~1), ~M(0), M2( 1, ~1))
        NBKAssertDivision3212MSB(M3(~1, ~0, ~0), M2(~0,  0), ~M(0), M2(~1, ~0))
        NBKAssertDivision3212MSB(M3(~1, ~0, ~0), M2(~0, ~0), ~M(0), M2( 0, ~1))
    }
    
    func testDividing3212MSBWithBadInitialEstimate() {
        NBKAssertDivision3212MSB(M3(1 << 63 - 1,  0,  0), M2(1 << 63, ~0), ~M(3), M2(4, ~3)) // 2
        NBKAssertDivision3212MSB(M3(1 << 63 - 1,  0, ~0), M2(1 << 63, ~0), ~M(3), M2(5, ~4)) // 2
        NBKAssertDivision3212MSB(M3(1 << 63 - 1, ~0,  0), M2(1 << 63, ~0), ~M(1), M2(1, ~1)) // 1
        NBKAssertDivision3212MSB(M3(1 << 63 - 1, ~0, ~0), M2(1 << 63, ~0), ~M(1), M2(2, ~2)) // 1
    }
}

//=------------------------------------------------------------------------=
// MARK: + Utilities x Complements
//=------------------------------------------------------------------------=

private func NBKAssertMagnitude<T: NBKFixedWidthInteger>(
_ value: NBK.Wide2<T>, _ magnitude: NBK.Wide2<T.Magnitude>,
file: StaticString = #file, line: UInt = #line) {
    let result = NBK.magnitude(of: value)
    //=------------------------------------------=
    if  let value = value as? NBK.Wide2<T.Magnitude> {
        XCTAssert(result == value, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssert(result == magnitude, file: file, line: line)
    XCTAssert(NBK.magnitude(of: result) == magnitude, file: file, line: line)
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

//=----------------------------------------------------------------------------=
// MARK: + Utilities x Division
//=----------------------------------------------------------------------------=

private func NBKAssertDivision3212MSB<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: NBK.Wide3<T>, _ rhs: NBK.Wide2<T>, _ quotient: T, _ remainder: NBK.Wide2<T>,
file: StaticString = #file, line: UInt = #line) {
    var result: QR<T, NBK.Wide3<T>>
    result.remainder = lhs
    result.quotient  = NBK.divide3212MSBUnchecked(&result.remainder,  by: rhs)
    //=------------------------------------------=
    XCTAssertEqual(result.quotient,       quotient,       file: file, line: line)
    XCTAssertEqual(result.remainder.high, T.zero,         file: file, line: line)
    XCTAssertEqual(result.remainder.mid,  remainder.high, file: file, line: line)
    XCTAssertEqual(result.remainder.low,  remainder.low,  file: file, line: line)
    //=------------------------------------------=
    var composite: NBK.Wide3<T>
    composite = NBK.multiplying213(rhs,  by: result.quotient )
    let _ = NBK.increment33B(&composite, by: result.remainder)
    XCTAssert(lhs == composite, "lhs != rhs * quotient + remainder", file: file, line: line)
}

#endif
