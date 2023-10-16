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
// MARK: * NBK x Signed x Division x SIntXL
//*============================================================================*

final class NBKSignedTestsOnDivisionAsSIntXL: XCTestCase {
    
    typealias T = NBKSigned<UIntXL>
    typealias M = NBKSigned<UIntXL>.Magnitude
    typealias D = NBKSigned<UIntXL>.Digit
    typealias U = NBKSigned<UIntXL>.Digit.Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testDividingLargeByLarge() {
        NBKAssertDivision( T(M(x64:[~2,  ~4,  ~6,  9] as X)),  T(M(x64:[~1, ~2, ~3, 4] as X)),  T(2),  T(1))
        NBKAssertDivision( T(M(x64:[~3,  ~6,  ~9, 14] as X)), -T(M(x64:[~1, ~2, ~3, 4] as X)), -T(3),  T(2))
        NBKAssertDivision(-T(M(x64:[~4,  ~8, ~12, 19] as X)),  T(M(x64:[~1, ~2, ~3, 4] as X)), -T(4), -T(3))
        NBKAssertDivision(-T(M(x64:[~5, ~10, ~15, 24] as X)), -T(M(x64:[~1, ~2, ~3, 4] as X)),  T(5), -T(4))
    }
    
    func testDividingLargeByLargeWithLargeRemainder() {
        NBKAssertDivision( T(M(x64:[1, 2, 3, 4 + 1 << 63] as X)),  T(M(x64:[ 1,  2,  3,  4 &+ 1 << 63] as X)),  T(1),  T(M(x64:[0, 0, 0, 0] as X)))
        NBKAssertDivision( T(M(x64:[1, 2, 3, 4 + 1 << 63] as X)),  T(M(x64:[ 0,  1,  2,  3 &+ 1 << 63] as X)),  T(1),  T(M(x64:[1, 1, 1, 1] as X)))
        NBKAssertDivision( T(M(x64:[1, 2, 3, 4 + 1 << 63] as X)), -T(M(x64:[~0, ~0,  0,  2 &+ 1 << 63] as X)), -T(1),  T(M(x64:[2, 2, 2, 2] as X)))
        NBKAssertDivision( T(M(x64:[1, 2, 3, 4 + 1 << 63] as X)), -T(M(x64:[~1, ~1, ~0,  0 &+ 1 << 63] as X)), -T(1),  T(M(x64:[3, 3, 3, 3] as X)))
        NBKAssertDivision(-T(M(x64:[1, 2, 3, 4 + 1 << 63] as X)),  T(M(x64:[~2, ~2, ~1, ~0 &+ 1 << 63] as X)), -T(1), -T(M(x64:[4, 4, 4, 4] as X)))
        NBKAssertDivision(-T(M(x64:[1, 2, 3, 4 + 1 << 63] as X)),  T(M(x64:[~3, ~3, ~2, ~1 &+ 1 << 63] as X)), -T(1), -T(M(x64:[5, 5, 5, 5] as X)))
        NBKAssertDivision(-T(M(x64:[1, 2, 3, 4 + 1 << 63] as X)), -T(M(x64:[~4, ~4, ~3, ~2 &+ 1 << 63] as X)),  T(1), -T(M(x64:[6, 6, 6, 6] as X)))
        NBKAssertDivision(-T(M(x64:[1, 2, 3, 4 + 1 << 63] as X)), -T(M(x64:[~5, ~5, ~4, ~3 &+ 1 << 63] as X)),  T(1), -T(M(x64:[7, 7, 7, 7] as X)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testDividingSmallBySmall() {
        NBKAssertDivisionByDigit( T( ),  D(1),  T( ),  D( ))
        NBKAssertDivisionByDigit( T( ), -D(2), -T( ),  D( ))
        NBKAssertDivisionByDigit(-T(7),  D(1), -T(7), -D( ))
        NBKAssertDivisionByDigit(-T(7), -D(2),  T(3), -D(1))
                
        NBKAssertDivisionByDigit( T(7),  D(3),  T(2),  D(1))
        NBKAssertDivisionByDigit( T(7), -D(3), -T(2),  D(1))
        NBKAssertDivisionByDigit(-T(7),  D(3), -T(2), -D(1))
        NBKAssertDivisionByDigit(-T(7), -D(3),  T(2), -D(1))
    }
    
    func testDividingLargeBySmall() {
        NBKAssertDivisionByDigit( T(M(words:[1, 2, 3, 4] as W)),  D(2),  T(M(words:[0, ~0/2 + 2, 1, 2] as W)),  D(1))
        NBKAssertDivisionByDigit( T(M(words:[1, 2, 3, 4] as W)), -D(2), -T(M(words:[0, ~0/2 + 2, 1, 2] as W)),  D(1))
        NBKAssertDivisionByDigit(-T(M(words:[1, 2, 3, 4] as W)),  D(2), -T(M(words:[0, ~0/2 + 2, 1, 2] as W)), -D(1))
        NBKAssertDivisionByDigit(-T(M(words:[1, 2, 3, 4] as W)), -D(2),  T(M(words:[0, ~0/2 + 2, 1, 2] as W)), -D(1))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x /= 0)
            XCTAssertNotNil(x %= 0)
            XCTAssertNotNil(x /  0)
            XCTAssertNotNil(x %  0)
            XCTAssertNotNil(x.quotientAndRemainder(dividingBy: 0))
        }
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Division x Open Source Issues
//*============================================================================*

final class NBKSignedTestsOnDivisionOpenSourceIssues: XCTestCase {
    
    typealias SIntXL = NBKSigned<UIntXL>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// https://github.com/apple/swift-numerics/pull/250
    ///
    /// - Note: Said to crash and return incorrect values.
    ///
    func testSwiftNumericsPull250() {
        NBKAssertDivision(
        SIntXL("-9223372036854775808"),
        SIntXL("-0000000000000000001"),
        SIntXL("+9223372036854775808"),
        SIntXL("-0000000000000000000"))
        
        NBKAssertDivision(
        SIntXL("+18446744073709551615"),
        SIntXL("-00000000000000000001"),
        SIntXL("-18446744073709551615"),
        SIntXL("+00000000000000000000"))
        
        NBKAssertDivision(
        SIntXL("-340282366920938463481821351505477763074"),
        SIntXL("+000000000000000000018446744073709551629"),
        SIntXL("-000000000000000000018446744073709551604"),
        SIntXL("-000000000000000000000000000000000000158"))
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Division x Assertions
//*============================================================================*

private func NBKAssertDivision<M>(
_ lhs: NBKSigned<M>, _ rhs: NBKSigned<M>, _ quotient: NBKSigned<M>, _ remainder: NBKSigned<M>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(lhs, quotient * rhs + remainder, "dividend != divisor * quotient + remainder", file: file, line: line)
    //=------------------------------------------=
    NBKAssertIdentical(lhs / rhs, quotient,  file: file, line: line)
    NBKAssertIdentical(lhs % rhs, remainder, file: file, line: line)
    
    NBKAssertIdentical({ var x = lhs; x /= rhs; return x }(), quotient,  file: file, line: line)
    NBKAssertIdentical({ var x = lhs; x %= rhs; return x }(), remainder, file: file, line: line)
    
    NBKAssertIdentical(lhs.quotientAndRemainder(dividingBy: rhs).quotient,  quotient,  file: file, line: line)
    NBKAssertIdentical(lhs.quotientAndRemainder(dividingBy: rhs).remainder, remainder, file: file, line: line)
}

private func NBKAssertDivisionByDigit<M>(
_ lhs: NBKSigned<M>, _ rhs: NBKSigned<M>.Digit, _ quotient: NBKSigned<M>, _ remainder: NBKSigned<M>.Digit,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let extended = NBKSigned<M>(digit: remainder)
    //=------------------------------------------=
    NBKAssertDivision(lhs, NBKSigned<M>(digit: rhs), quotient, extended)
    //=------------------------------------------=
    XCTAssertEqual(lhs, quotient * rhs + remainder, "dividend != divisor * quotient + remainder", file: file, line: line)
    //=------------------------------------------=
    NBKAssertIdentical(lhs / rhs, quotient,  file: file, line: line)
    NBKAssertIdentical(lhs % rhs, remainder, file: file, line: line)
    
    NBKAssertIdentical({ var x = lhs; x /= rhs; return x }(), quotient, file: file, line: line)
    NBKAssertIdentical({ var x = lhs; x %= rhs; return x }(), extended, file: file, line: line)
    
    NBKAssertIdentical(lhs.quotientAndRemainder(dividingBy: rhs).quotient,  quotient,  file: file, line: line)
    NBKAssertIdentical(lhs.quotientAndRemainder(dividingBy: rhs).remainder, remainder, file: file, line: line)
}

#endif
