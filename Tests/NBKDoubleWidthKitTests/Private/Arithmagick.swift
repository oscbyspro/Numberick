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
// MARK: * NBK x Arithmagick
//*============================================================================*

final class ArithmagickTests: XCTestCase {
    
    typealias T  = UInt64
    typealias T2 = Wide2<T>
    typealias T3 = Wide3<T>
    typealias X2 = Each2<T>
    typealias X3 = Each3<T>
    
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
    
    func testAdding12D() {
        NBKAssertAddition12D( 0, X2( 0,  0), T2( 0,  0))
        NBKAssertAddition12D( 1, X2( 2,  3), T2( 0,  6))
        NBKAssertAddition12D(~1, X2(~2, ~3), T2( 2, ~8))
        NBKAssertAddition12D(~0, X2(~0, ~0), T2( 2, ~2))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Subtraction
    //=------------------------------------------------------------------------=
    
    func testSubtracting32B() {
        NBKAssertSubtraction32B(T3( 0,  0,  0), T2(~0, ~0), T3(~0,  0,  1), true )
        NBKAssertSubtraction32B(T3( 1,  2,  3), T2(~4, ~5), T3( 0,  6,  9), false)
        NBKAssertSubtraction32B(T3(~1, ~2, ~3), T2( 4,  5), T3(~1, ~6, ~8), false)
        NBKAssertSubtraction32B(T3(~0, ~0, ~0), T2( 0,  0), T3(~0, ~0, ~0), false)
    }
    
    func testSubtracting33B() {
        NBKAssertSubtraction33B(T3( 0,  0,  0), T3(~0, ~0, ~0), T3( 0,  0,  1), true )
        NBKAssertSubtraction33B(T3( 1,  2,  3), T3(~4, ~5, ~6), T3( 5,  7, 10), true )
        NBKAssertSubtraction33B(T3(~1, ~2, ~3), T3( 4,  5,  6), T3(~5, ~7, ~9), false)
        NBKAssertSubtraction33B(T3(~0, ~0, ~0), T3( 0,  0,  0), T3(~0, ~0, ~0), false)
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

private func NBKAssertAddition12D<T: NBKFixedWidthInteger & NBKUnsignedInteger>(
_ lhs: T, _ rhs: Each2<T>, _ sum: HL<T.Digit, T>,
file: StaticString = #file, line: UInt = #line) {
    var a = lhs
    let b = T.increment12D(&a, by: rhs)
    XCTAssertEqual(a, sum.low,  file: file, line: line)
    XCTAssertEqual(b, sum.high, file: file, line: line)
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
