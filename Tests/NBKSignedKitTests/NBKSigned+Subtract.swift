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
// MARK: * NBK x Signed x Subtraction x SIntXL
//*============================================================================*

final class NBKSignedTestsOnSubtractionAsSIntXL: XCTestCase {
    
    typealias T = NBKSigned<UIntXL>
    typealias M = NBKSigned<UIntXL>.Magnitude
    typealias D = NBKSigned<UIntXL>.Digit
    typealias U = NBKSigned<UIntXL>.Digit.Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtracting() {
        NBKAssertSubtraction( T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[3, 0, 0, 0] as X)),  T(M(x64:[~3, ~0, ~0,  0] as X)))
        NBKAssertSubtraction( T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[0, 3, 0, 0] as X)),  T(M(x64:[~0, ~3, ~0,  0] as X)))
        NBKAssertSubtraction( T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[0, 0, 3, 0] as X)),  T(M(x64:[~0, ~0, ~3,  0] as X)))
        NBKAssertSubtraction( T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[0, 0, 0, 3] as X)), -T(M(x64:[ 1,  0,  0,  2] as X)))
        
        NBKAssertSubtraction( T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[3, 0, 0, 0] as X)),  T(M(x64:[ 2,  0,  0,  1] as X)))
        NBKAssertSubtraction( T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[0, 3, 0, 0] as X)),  T(M(x64:[~0,  2,  0,  1] as X)))
        NBKAssertSubtraction( T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[0, 0, 3, 0] as X)),  T(M(x64:[~0, ~0,  2,  1] as X)))
        NBKAssertSubtraction( T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[0, 0, 0, 3] as X)),  T(M(x64:[~0, ~0, ~0,  3] as X)))
        
        NBKAssertSubtraction(-T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[3, 0, 0, 0] as X)), -T(M(x64:[ 2,  0,  0,  1] as X)))
        NBKAssertSubtraction(-T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[0, 3, 0, 0] as X)), -T(M(x64:[~0,  2,  0,  1] as X)))
        NBKAssertSubtraction(-T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[0, 0, 3, 0] as X)), -T(M(x64:[~0, ~0,  2,  1] as X)))
        NBKAssertSubtraction(-T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[0, 0, 0, 3] as X)), -T(M(x64:[~0, ~0, ~0,  3] as X)))
        
        NBKAssertSubtraction(-T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[3, 0, 0, 0] as X)), -T(M(x64:[~3, ~0, ~0,  0] as X)))
        NBKAssertSubtraction(-T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[0, 3, 0, 0] as X)), -T(M(x64:[~0, ~3, ~0,  0] as X)))
        NBKAssertSubtraction(-T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[0, 0, 3, 0] as X)), -T(M(x64:[~0, ~0, ~3,  0] as X)))
        NBKAssertSubtraction(-T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[0, 0, 0, 3] as X)),  T(M(x64:[ 1,  0,  0,  2] as X)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractingDigit() {
        NBKAssertSubtractionByDigit( T(M(1)),  D(U(2)), -T(M(1)))
        NBKAssertSubtractionByDigit( T(M(1)),  D(U(1)),  T(M(0)))
        NBKAssertSubtractionByDigit( T(M(1)),  D(U(0)),  T(M(1)))
        NBKAssertSubtractionByDigit( T(M(1)), -D(U(0)),  T(M(1)))
        NBKAssertSubtractionByDigit( T(M(1)), -D(U(1)),  T(M(2)))
        NBKAssertSubtractionByDigit( T(M(1)), -D(U(2)),  T(M(3)))
        
        NBKAssertSubtractionByDigit( T(M(0)),  D(U(2)), -T(M(2)))
        NBKAssertSubtractionByDigit( T(M(0)),  D(U(1)), -T(M(1)))
        NBKAssertSubtractionByDigit( T(M(0)),  D(U(0)),  T(M(0)))
        NBKAssertSubtractionByDigit( T(M(0)), -D(U(0)),  T(M(0)))
        NBKAssertSubtractionByDigit( T(M(0)), -D(U(1)),  T(M(1)))
        NBKAssertSubtractionByDigit( T(M(0)), -D(U(2)),  T(M(2)))
        
        NBKAssertSubtractionByDigit(-T(M(0)),  D(U(2)), -T(M(2)))
        NBKAssertSubtractionByDigit(-T(M(0)),  D(U(1)), -T(M(1)))
        NBKAssertSubtractionByDigit(-T(M(0)),  D(U(0)), -T(M(0)))
        NBKAssertSubtractionByDigit(-T(M(0)), -D(U(0)), -T(M(0)))
        NBKAssertSubtractionByDigit(-T(M(0)), -D(U(1)),  T(M(1)))
        NBKAssertSubtractionByDigit(-T(M(0)), -D(U(2)),  T(M(2)))
        
        NBKAssertSubtractionByDigit(-T(M(1)),  D(U(2)), -T(M(3)))
        NBKAssertSubtractionByDigit(-T(M(1)),  D(U(1)), -T(M(2)))
        NBKAssertSubtractionByDigit(-T(M(1)),  D(U(0)), -T(M(1)))
        NBKAssertSubtractionByDigit(-T(M(1)), -D(U(0)), -T(M(1)))
        NBKAssertSubtractionByDigit(-T(M(1)), -D(U(1)), -T(M(0)))
        NBKAssertSubtractionByDigit(-T(M(1)), -D(U(2)),  T(M(1)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x -= 0)
            XCTAssertNotNil(x -  0)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Subtraction x Assertions
//*============================================================================*

private func NBKAssertSubtraction<M: NBKUnsignedInteger>(
_ lhs: NBKSigned<M>, _ rhs: NBKSigned<M>, _ partialValue: NBKSigned<M>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertIdentical(                 lhs -  rhs,                 partialValue, file: file, line: line)
    NBKAssertIdentical({ var lhs = lhs; lhs -= rhs; return lhs }(), partialValue, file: file, line: line)
}

private func NBKAssertSubtractionByDigit<M: NBKUnsignedInteger>(
_ lhs: NBKSigned<M>, _ rhs: NBKSigned<M>.Digit, _ partialValue: NBKSigned<M>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertIdentical(                 lhs -  rhs,                 partialValue, file: file, line: line)
    NBKAssertIdentical({ var lhs = lhs; lhs -= rhs; return lhs }(), partialValue, file: file, line: line)
    //=------------------------------------------=
    NBKAssertSubtraction(lhs, NBKSigned(digit: rhs), partialValue)
}

#endif
