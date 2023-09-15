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
// MARK: * NBK x Signed x Addition x SIntXL
//*============================================================================*

final class NBKSignedTestsOnAdditionAsSIntXL: XCTestCase {
    
    typealias T = NBKSigned<UIntXL>
    typealias M = NBKSigned<UIntXL>.Magnitude
    typealias D = NBKSigned<UIntXL>.Digit
    typealias U = NBKSigned<UIntXL>.Digit.Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAdding() {
        NBKAssertAddition( T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[3, 0, 0, 0] as X)),  T(M(x64:[ 2,  0,  0,  1] as X)))
        NBKAssertAddition( T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[0, 3, 0, 0] as X)),  T(M(x64:[~0,  2,  0,  1] as X)))
        NBKAssertAddition( T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[0, 0, 3, 0] as X)),  T(M(x64:[~0, ~0,  2,  1] as X)))
        NBKAssertAddition( T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[0, 0, 0, 3] as X)),  T(M(x64:[~0, ~0, ~0,  3] as X)))

        NBKAssertAddition( T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[3, 0, 0, 0] as X)),  T(M(x64:[~3, ~0, ~0,  0] as X)))
        NBKAssertAddition( T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[0, 3, 0, 0] as X)),  T(M(x64:[~0, ~3, ~0,  0] as X)))
        NBKAssertAddition( T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[0, 0, 3, 0] as X)),  T(M(x64:[~0, ~0, ~3,  0] as X)))
        NBKAssertAddition( T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[0, 0, 0, 3] as X)), -T(M(x64:[ 1,  0,  0,  2] as X)))
        
        NBKAssertAddition(-T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[3, 0, 0, 0] as X)), -T(M(x64:[~3, ~0, ~0,  0] as X)))
        NBKAssertAddition(-T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[0, 3, 0, 0] as X)), -T(M(x64:[~0, ~3, ~0,  0] as X)))
        NBKAssertAddition(-T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[0, 0, 3, 0] as X)), -T(M(x64:[~0, ~0, ~3,  0] as X)))
        NBKAssertAddition(-T(M(x64:[~0, ~0, ~0,  0] as X)),  T(M(x64:[0, 0, 0, 3] as X)),  T(M(x64:[ 1,  0,  0,  2] as X)))

        NBKAssertAddition(-T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[3, 0, 0, 0] as X)), -T(M(x64:[ 2,  0,  0,  1] as X)))
        NBKAssertAddition(-T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[0, 3, 0, 0] as X)), -T(M(x64:[~0,  2,  0,  1] as X)))
        NBKAssertAddition(-T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[0, 0, 3, 0] as X)), -T(M(x64:[~0, ~0,  2,  1] as X)))
        NBKAssertAddition(-T(M(x64:[~0, ~0, ~0,  0] as X)), -T(M(x64:[0, 0, 0, 3] as X)), -T(M(x64:[~0, ~0, ~0,  3] as X)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testAddingDigit() {
        NBKAssertAdditionByDigit( T(M(1)),  D(U(2)),  T(M(3)))
        NBKAssertAdditionByDigit( T(M(1)),  D(U(1)),  T(M(2)))
        NBKAssertAdditionByDigit( T(M(1)),  D(U(0)),  T(M(1)))
        NBKAssertAdditionByDigit( T(M(1)), -D(U(0)),  T(M(1)))
        NBKAssertAdditionByDigit( T(M(1)), -D(U(1)),  T(M(0)))
        NBKAssertAdditionByDigit( T(M(1)), -D(U(2)), -T(M(1)))
        
        NBKAssertAdditionByDigit( T(M(0)),  D(U(2)),  T(M(2)))
        NBKAssertAdditionByDigit( T(M(0)),  D(U(1)),  T(M(1)))
        NBKAssertAdditionByDigit( T(M(0)),  D(U(0)),  T(M(0)))
        NBKAssertAdditionByDigit( T(M(0)), -D(U(0)),  T(M(0)))
        NBKAssertAdditionByDigit( T(M(0)), -D(U(1)), -T(M(1)))
        NBKAssertAdditionByDigit( T(M(0)), -D(U(2)), -T(M(2)))
        
        NBKAssertAdditionByDigit(-T(M(0)),  D(U(2)),  T(M(2)))
        NBKAssertAdditionByDigit(-T(M(0)),  D(U(1)),  T(M(1)))
        NBKAssertAdditionByDigit(-T(M(0)),  D(U(0)), -T(M(0)))
        NBKAssertAdditionByDigit(-T(M(0)), -D(U(0)), -T(M(0)))
        NBKAssertAdditionByDigit(-T(M(0)), -D(U(1)), -T(M(1)))
        NBKAssertAdditionByDigit(-T(M(0)), -D(U(2)), -T(M(2)))
        
        NBKAssertAdditionByDigit(-T(M(1)),  D(U(2)),  T(M(1)))
        NBKAssertAdditionByDigit(-T(M(1)),  D(U(1)), -T(M(0)))
        NBKAssertAdditionByDigit(-T(M(1)),  D(U(0)), -T(M(1)))
        NBKAssertAdditionByDigit(-T(M(1)), -D(U(0)), -T(M(1)))
        NBKAssertAdditionByDigit(-T(M(1)), -D(U(1)), -T(M(2)))
        NBKAssertAdditionByDigit(-T(M(1)), -D(U(2)), -T(M(3)))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguousWhenUsingIntegerLiterals() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(x += 0)
            XCTAssertNotNil(x +  0)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Addition x Assertions
//*============================================================================*

private func NBKAssertAddition<M: NBKUnsignedInteger>(
_ lhs: NBKSigned<M>, _ rhs: NBKSigned<M>, _ partialValue: NBKSigned<M>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertIdentical(                 lhs +  rhs,                 partialValue, file: file, line: line)
    NBKAssertIdentical({ var lhs = lhs; lhs += rhs; return lhs }(), partialValue, file: file, line: line)
}

private func NBKAssertAdditionByDigit<M: NBKUnsignedInteger>(
_ lhs: NBKSigned<M>, _ rhs: NBKSigned<M>.Digit, _ partialValue: NBKSigned<M>,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertIdentical(                 lhs +  rhs,                 partialValue, file: file, line: line)
    NBKAssertIdentical({ var lhs = lhs; lhs += rhs; return lhs }(), partialValue, file: file, line: line)
    //=------------------------------------------=
    NBKAssertAddition(lhs, NBKSigned(digit: rhs), partialValue)
}

#endif
