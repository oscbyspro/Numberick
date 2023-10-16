//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKSignedKit
import NBKFlexibleWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Signed x Negation
//*============================================================================*

final class NBKSignedTestsOnNegation: XCTestCase {
    
    typealias T = NBKSigned<UInt>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNegating() {
        NBKAssertNegation( T(1), -T(1))
        NBKAssertNegation( T(0), -T(0))
        NBKAssertNegation(-T(0),  T(0))
        NBKAssertNegation(-T(1),  T(1))
        
        NBKAssertNegation(T.max, T.min)
        NBKAssertNegation(T.min, T.max)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testOverloadsAreUnambiguous() {
        func becauseThisCompilesSuccessfully(_ x: inout T) {
            XCTAssertNotNil(-x)
            XCTAssertNotNil(x.negate())
            XCTAssertNotNil(x.negated())
        }
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Negation x Open Source Issues
//*============================================================================*

final class NBKSignedTestsOnNegationOpenSourceIssues: XCTestCase {
    
    typealias SIntXL = NBKSigned<UIntXL>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// https://github.com/apple/swift-numerics/pull/253
    ///
    /// - Note: Said to return incorrect values.
    ///
    func testSwiftNumericsPull253() {
        NBKAssertNegation(SIntXL(Int.min), SIntXL(Int.min.magnitude))
        NBKAssertNegation(SIntXL(Int.min.magnitude), SIntXL(Int.min))
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Negation x Assertions
//*============================================================================*

private func NBKAssertNegation<M>(
_ operand: NBKSigned<M>, _ result: NBKSigned<M>,
file: StaticString = #file, line: UInt = #line) {
    NBKAssertIdentical(-operand,                                    result, file: file, line: line)
    NBKAssertIdentical((operand).negated(),                         result, file: file, line: line)
    NBKAssertIdentical({ var x = operand; x.negate(); return x }(), result, file: file, line: line)
}

#endif
