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
// MARK: * NBK x Signed x Multiplication x SIntXL
//*============================================================================*

final class NBKSignedTestsOnMultiplicationAsSIntXL: XCTestCase {
    
    typealias T = NBKSigned<UIntXL>
    typealias M = NBKSigned<UIntXL>.Magnitude
    typealias D = NBKSigned<UIntXL>.Digit
    typealias U = NBKSigned<UIntXL>.Digit.Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplyingLargeByLarge() {
        NBKAssertMultiplication( T( M(x64:[1, 2, 3, 4] as X)),  T(M(x64:[2, 0, 0, 0] as X)),  T(M(x64:[ 2,  4,  6,  8,  0,  0,  0,  0] as X)))
        NBKAssertMultiplication( T( M(x64:[1, 2, 3, 4] as X)), -T(M(x64:[0, 2, 0, 0] as X)), -T(M(x64:[ 0,  2,  4,  6,  8,  0,  0,  0] as X)))
        NBKAssertMultiplication(-T( M(x64:[1, 2, 3, 4] as X)),  T(M(x64:[0, 0, 2, 0] as X)), -T(M(x64:[ 0,  0,  2,  4,  6,  8,  0,  0] as X)))
        NBKAssertMultiplication(-T( M(x64:[1, 2, 3, 4] as X)), -T(M(x64:[0, 0, 0, 2] as X)),  T(M(x64:[ 0,  0,  0,  2,  4,  6,  8,  0] as X)))
        
        NBKAssertMultiplication( T(~M(x64:[1, 2, 3, 4] as X)),  T(M(x64:[2, 0, 0, 0] as X)),  T(M(x64:[~3, ~4, ~6, ~8,  1,  0,  0,  0] as X)))
        NBKAssertMultiplication( T(~M(x64:[1, 2, 3, 4] as X)), -T(M(x64:[0, 2, 0, 0] as X)), -T(M(x64:[ 0, ~3, ~4, ~6, ~8,  1,  0,  0] as X)))
        NBKAssertMultiplication(-T(~M(x64:[1, 2, 3, 4] as X)),  T(M(x64:[0, 0, 2, 0] as X)), -T(M(x64:[ 0,  0, ~3, ~4, ~6, ~8,  1,  0] as X)))
        NBKAssertMultiplication(-T(~M(x64:[1, 2, 3, 4] as X)), -T(M(x64:[0, 0, 0, 2] as X)),  T(M(x64:[ 0,  0,  0, ~3, ~4, ~6, ~8,  1] as X)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit (and Self)
    //=------------------------------------------------------------------------=
    
    func testMultiplyingLargeBySmall() {
        NBKAssertMultiplicationByDigit( T( M(words:[1, 2, 3, 4] as W)),  D(0),  T( M(words:[ 0,  0,  0,  0,  0] as W)))
        NBKAssertMultiplicationByDigit( T( M(words:[1, 2, 3, 4] as W)), -D(1), -T( M(words:[ 1,  2,  3,  4,  0] as W)))
        NBKAssertMultiplicationByDigit(-T( M(words:[1, 2, 3, 4] as W)),  D(2), -T( M(words:[ 2,  4,  6,  8,  0] as W)))
        NBKAssertMultiplicationByDigit(-T( M(words:[1, 2, 3, 4] as W)), -D(3),  T( M(words:[ 3,  6,  9, 12,  0] as W)))
        
        NBKAssertMultiplicationByDigit( T(~M(words:[1, 2, 3, 4] as W)),  D(0),  T(~M(words:[~0, ~0, ~0, ~0, ~0] as W)))
        NBKAssertMultiplicationByDigit( T(~M(words:[1, 2, 3, 4] as W)), -D(1), -T(~M(words:[ 1,  2,  3,  4, ~0] as W)))
        NBKAssertMultiplicationByDigit(-T(~M(words:[1, 2, 3, 4] as W)),  D(2), -T(~M(words:[ 3,  4,  6,  8, ~1] as W)))
        NBKAssertMultiplicationByDigit(-T(~M(words:[1, 2, 3, 4] as W)), -D(3),  T(~M(words:[ 5,  6,  9, 12, ~2] as W)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x *= 0)
            XCTAssertNotNil(x *  0)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Addition x Assertions
//*============================================================================*

private func NBKAssertMultiplication<M>(
_ lhs: NBKSigned<M>, _ rhs:  NBKSigned<M>, _ result: NBKSigned<M>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertIdentical(                 lhs *  rhs,                 result, file: file, line: line)
    NBKAssertIdentical({ var lhs = lhs; lhs *= rhs; return lhs }(), result, file: file, line: line)
}

private func NBKAssertMultiplicationByDigit<M>(
_ lhs: NBKSigned<M>, _ rhs:  NBKSigned<M>.Digit, _ result: NBKSigned<M>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertMultiplication(lhs, NBKSigned<M>(digit: rhs), result)
    //=------------------------------------------=
    NBKAssertIdentical(                 lhs *  rhs,                 result, file: file, line: line)
    NBKAssertIdentical({ var lhs = lhs; lhs *= rhs; return lhs }(), result, file: file, line: line)
}

#endif
