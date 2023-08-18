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

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Comparisons x Int256
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
final class NBKDoubleWidthTestsOnComparisonsAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
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
    
    func testIsPowerOf2() {
        XCTAssertFalse((T.min).isPowerOf2)
        XCTAssertFalse((T(-4)).isPowerOf2)
        XCTAssertFalse((T(-3)).isPowerOf2)
        XCTAssertFalse((T(-2)).isPowerOf2)
        XCTAssertFalse((T(-1)).isPowerOf2)
        XCTAssertFalse((T( 0)).isPowerOf2)
        XCTAssertTrue ((T( 1)).isPowerOf2)
        XCTAssertTrue ((T( 2)).isPowerOf2)
        XCTAssertFalse((T( 3)).isPowerOf2)
        XCTAssertFalse((T.max).isPowerOf2)
        
        XCTAssertFalse(T(x64: X(0, 0, 0, 0)).isPowerOf2)
        XCTAssertTrue (T(x64: X(1, 0, 0, 0)).isPowerOf2)
        XCTAssertFalse(T(x64: X(1, 1, 0, 0)).isPowerOf2)
        XCTAssertTrue (T(x64: X(0, 1, 0, 0)).isPowerOf2)
        XCTAssertFalse(T(x64: X(0, 1, 1, 0)).isPowerOf2)
        XCTAssertTrue (T(x64: X(0, 0, 1, 0)).isPowerOf2)
        XCTAssertFalse(T(x64: X(0, 0, 1, 1)).isPowerOf2)
        XCTAssertTrue (T(x64: X(0, 0, 0, 1)).isPowerOf2)
    }
    
    func testSignum() {
        NBKAssertSignum( T(0),  Int(0))
        NBKAssertSignum( T(1),  Int(1))
        NBKAssertSignum( T(2),  Int(1))
        
        NBKAssertSignum(~T(0), -Int(1))
        NBKAssertSignum(~T(1), -Int(1))
        NBKAssertSignum(~T(2), -Int(1))
    }
    
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
        
        NBKAssertComparisons(T(x64: X(0, 2, 3, 4)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(1, 0, 3, 4)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 0, 4)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 0)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(0, 2, 3, 4)), T(x64: X(0, 2, 3, 4)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 0, 3, 4)), T(x64: X(1, 0, 3, 4)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 2, 0, 4)), T(x64: X(1, 2, 0, 4)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 0)), T(x64: X(1, 2, 3, 0)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(0, 2, 3, 4)),  Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 0, 3, 4)),  Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 2, 0, 4)),  Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 2, 3, 0)),  Int(1))
    }
    
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
        
        NBKAssertComparisonsByDigit( T(x64: X(0, 0, 0, 0)),  Int(1), -Int(1))
        NBKAssertComparisonsByDigit( T(x64: X(1, 0, 0, 0)),  Int(1),  Int(0))
        NBKAssertComparisonsByDigit( T(x64: X(2, 0, 0, 0)),  Int(1),  Int(1))

        NBKAssertComparisonsByDigit( T(x64: X(0, 1, 0, 0)),  Int(1),  Int(1))
        NBKAssertComparisonsByDigit( T(x64: X(1, 1, 0, 0)),  Int(1),  Int(1))
        NBKAssertComparisonsByDigit( T(x64: X(2, 1, 0, 0)),  Int(1),  Int(1))
        
        NBKAssertComparisonsByDigit(~T(x64: X(0, 0, 0, 0)), ~Int(1),  Int(1))
        NBKAssertComparisonsByDigit(~T(x64: X(1, 0, 0, 0)), ~Int(1),  Int(0))
        NBKAssertComparisonsByDigit(~T(x64: X(2, 0, 0, 0)), ~Int(1), -Int(1))

        NBKAssertComparisonsByDigit(~T(x64: X(0, 1, 0, 0)), ~Int(1), -Int(1))
        NBKAssertComparisonsByDigit(~T(x64: X(1, 1, 0, 0)), ~Int(1), -Int(1))
        NBKAssertComparisonsByDigit(~T(x64: X(2, 1, 0, 0)), ~Int(1), -Int(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x.compared(to: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Comparisons x UInt256
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
final class NBKDoubleWidthTestsOnComparisonsAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
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
    
    func testIsPowerOf2() {
        XCTAssertFalse((T.min).isPowerOf2)
        XCTAssertFalse((T( 0)).isPowerOf2)
        XCTAssertTrue ((T( 1)).isPowerOf2)
        XCTAssertTrue ((T( 2)).isPowerOf2)
        XCTAssertFalse((T( 3)).isPowerOf2)
        XCTAssertTrue ((T( 4)).isPowerOf2)
        XCTAssertFalse((T( 5)).isPowerOf2)
        XCTAssertFalse((T( 6)).isPowerOf2)
        XCTAssertFalse((T( 7)).isPowerOf2)
        XCTAssertFalse((T.max).isPowerOf2)
        
        XCTAssertFalse(T(x64: X(0, 0, 0, 0)).isPowerOf2)
        XCTAssertTrue (T(x64: X(1, 0, 0, 0)).isPowerOf2)
        XCTAssertFalse(T(x64: X(1, 1, 0, 0)).isPowerOf2)
        XCTAssertTrue (T(x64: X(0, 1, 0, 0)).isPowerOf2)
        XCTAssertFalse(T(x64: X(0, 1, 1, 0)).isPowerOf2)
        XCTAssertTrue (T(x64: X(0, 0, 1, 0)).isPowerOf2)
        XCTAssertFalse(T(x64: X(0, 0, 1, 1)).isPowerOf2)
        XCTAssertTrue (T(x64: X(0, 0, 0, 1)).isPowerOf2)
    }
    
    func testSignum() {
        NBKAssertSignum( T(0),  Int(0))
        NBKAssertSignum( T(1),  Int(1))
        NBKAssertSignum( T(2),  Int(1))
        
        NBKAssertSignum(~T(0),  Int(1))
        NBKAssertSignum(~T(1),  Int(1))
        NBKAssertSignum(~T(2),  Int(1))
    }
    
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
        NBKAssertComparisons(T( 0), T( 0),  Int(0))
        NBKAssertComparisons(T( 1), T( 1),  Int(0))
        NBKAssertComparisons(T( 2), T( 3), -Int(1))
        NBKAssertComparisons(T( 3), T( 2),  Int(1))
        
        NBKAssertComparisons(T.max, T.max,  Int(0))
        NBKAssertComparisons(T.max, T.min,  Int(1))
        NBKAssertComparisons(T.min, T.max, -Int(1))
        NBKAssertComparisons(T.min, T.min,  Int(0))
        
        NBKAssertComparisons(T(x64: X(0, 2, 3, 4)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(1, 0, 3, 4)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 0, 4)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 0)), T(x64: X(1, 2, 3, 4)), -Int(1))
        NBKAssertComparisons(T(x64: X(0, 2, 3, 4)), T(x64: X(0, 2, 3, 4)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 0, 3, 4)), T(x64: X(1, 0, 3, 4)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 2, 0, 4)), T(x64: X(1, 2, 0, 4)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 0)), T(x64: X(1, 2, 3, 0)),  Int(0))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(0, 2, 3, 4)),  Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 0, 3, 4)),  Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 2, 0, 4)),  Int(1))
        NBKAssertComparisons(T(x64: X(1, 2, 3, 4)), T(x64: X(1, 2, 3, 0)),  Int(1))
    }
    
    func testComparingByDigit() {
        NBKAssertComparisonsByDigit(T( 0), UInt(0),  Int(0))
        NBKAssertComparisonsByDigit(T( 1), UInt(1),  Int(0))
        NBKAssertComparisonsByDigit(T( 2), UInt(3), -Int(1))
        NBKAssertComparisonsByDigit(T( 3), UInt(2),  Int(1))
        
        NBKAssertComparisonsByDigit(T(x64: X(0, 0, 0, 0)), UInt(1), -Int(1))
        NBKAssertComparisonsByDigit(T(x64: X(1, 0, 0, 0)), UInt(1),  Int(0))
        NBKAssertComparisonsByDigit(T(x64: X(2, 0, 0, 0)), UInt(1),  Int(1))
        
        NBKAssertComparisonsByDigit(T(x64: X(0, 1, 0, 0)), UInt(1),  Int(1))
        NBKAssertComparisonsByDigit(T(x64: X(1, 1, 0, 0)), UInt(1),  Int(1))
        NBKAssertComparisonsByDigit(T(x64: X(2, 1, 0, 0)), UInt(1),  Int(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x.compared(to: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Comparisons x Assertions
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
private func NBKAssertSignum<H: NBKFixedWidthInteger>(
_ operand: NBKDoubleWidth<H>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    XCTAssertEqual(Int(operand.signum() as Int), signum, file: file, line: line)
    XCTAssertEqual(Int(operand.signum() as T  ), signum, file: file, line: line) // stdlib
}

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
private func NBKAssertComparisons<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(lhs == rhs, signum ==  0, file: file, line: line)
    XCTAssertEqual(lhs != rhs, signum !=  0, file: file, line: line)
    
    XCTAssertEqual(lhs <  rhs, signum == -1, file: file, line: line)
    XCTAssertEqual(lhs <= rhs, signum !=  1, file: file, line: line)

    XCTAssertEqual(lhs >  rhs, signum ==  1, file: file, line: line)
    XCTAssertEqual(lhs >= rhs, signum != -1, file: file, line: line)
    
    XCTAssertEqual(lhs.compared(to: rhs), signum, file: file, line: line)
}

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
private func NBKAssertComparisonsByDigit<H: NBKFixedWidthInteger>(
_ lhs: NBKDoubleWidth<H>, _ rhs: NBKDoubleWidth<H>.Digit, _ signum: Int,
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(lhs == rhs, signum ==  0, file: file, line: line)
    XCTAssertEqual(lhs != rhs, signum !=  0, file: file, line: line)
    
    XCTAssertEqual(lhs <  rhs, signum == -1, file: file, line: line)
    XCTAssertEqual(lhs <= rhs, signum !=  1, file: file, line: line)

    XCTAssertEqual(lhs >  rhs, signum ==  1, file: file, line: line)
    XCTAssertEqual(lhs >= rhs, signum != -1, file: file, line: line)
    
    XCTAssertEqual(lhs.compared(to: rhs), signum, file: file, line: line)
}

#endif
