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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Predicate Wrapper
//*============================================================================*

final class NBKPredicateWrapperTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Is Zero
    //=------------------------------------------------------------------------=
    
    func testIsZero() {
        NBKAssert(Int.min, false, NBK.IsZero.self)
        NBKAssert(Int(-2), false, NBK.IsZero.self)
        NBKAssert(Int(-1), false, NBK.IsZero.self)
        NBKAssert(Int( 0), true,  NBK.IsZero.self)
        NBKAssert(Int( 1), false, NBK.IsZero.self)
        NBKAssert(Int.max, false, NBK.IsZero.self)
    }
    
    func testIsNonZero() {
        NBKAssert(Int.min, true,  NBK.IsNonZero.self)
        NBKAssert(Int(-2), true,  NBK.IsNonZero.self)
        NBKAssert(Int(-1), true,  NBK.IsNonZero.self)
        NBKAssert(Int( 0), false, NBK.IsNonZero.self)
        NBKAssert(Int( 1), true,  NBK.IsNonZero.self)
        NBKAssert(Int.max, true,  NBK.IsNonZero.self)
    }
    
    func testIsZeroOrLess() {
        NBKAssert(Int.min, true,  NBK.IsZeroOrLess.self)
        NBKAssert(Int(-2), true,  NBK.IsZeroOrLess.self)
        NBKAssert(Int(-1), true,  NBK.IsZeroOrLess.self)
        NBKAssert(Int( 0), true,  NBK.IsZeroOrLess.self)
        NBKAssert(Int( 1), false, NBK.IsZeroOrLess.self)
        NBKAssert(Int.max, false, NBK.IsZeroOrLess.self)
    }
    
    func testIsZeroOrMore() {
        NBKAssert(Int.min, false, NBK.IsZeroOrMore.self)
        NBKAssert(Int(-2), false, NBK.IsZeroOrMore.self)
        NBKAssert(Int(-1), false, NBK.IsZeroOrMore.self)
        NBKAssert(Int( 0), true,  NBK.IsZeroOrMore.self)
        NBKAssert(Int( 1), true,  NBK.IsZeroOrMore.self)
        NBKAssert(Int.max, true,  NBK.IsZeroOrMore.self)
    }
    
    func testIsLessThanZero() {
        NBKAssert(Int.min, true,  NBK.IsLessThanZero.self)
        NBKAssert(Int(-2), true,  NBK.IsLessThanZero.self)
        NBKAssert(Int(-1), true,  NBK.IsLessThanZero.self)
        NBKAssert(Int( 0), false, NBK.IsLessThanZero.self)
        NBKAssert(Int( 1), false, NBK.IsLessThanZero.self)
        NBKAssert(Int.max, false, NBK.IsLessThanZero.self)
    }
    
    func testIsMoreThanZero() {
        NBKAssert(Int.min, false, NBK.IsMoreThanZero.self)
        NBKAssert(Int(-2), false, NBK.IsMoreThanZero.self)
        NBKAssert(Int(-1), false, NBK.IsMoreThanZero.self)
        NBKAssert(Int( 0), false, NBK.IsMoreThanZero.self)
        NBKAssert(Int( 1), true,  NBK.IsMoreThanZero.self)
        NBKAssert(Int.max, true,  NBK.IsMoreThanZero.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Is Power Of 2
    //=------------------------------------------------------------------------=
    
    func testIsPowerOf2() {
        NBKAssert(Int.min, false, NBK.IsPowerOf2.self)
        NBKAssert(Int(-2), false, NBK.IsPowerOf2.self)
        NBKAssert(Int(-1), false, NBK.IsPowerOf2.self)
        NBKAssert(Int( 0), false, NBK.IsPowerOf2.self)
        NBKAssert(Int( 1), true,  NBK.IsPowerOf2.self)
        NBKAssert(Int.max, false, NBK.IsPowerOf2.self)
        
        for i in 0 ..< Int.bitWidth {
            NBKAssert(Int(3) << i, false, NBK.IsPowerOf2.self)
            NBKAssert(Int(1) << i, i + 2 <= Int.bitWidth, NBK.IsPowerOf2.self)
        }
        
        for i in 0 ..< Int.bitWidth - 1 {
            NBKAssert(UInt(1) << i, true, NBK.IsPowerOf2.self)
            NBKAssert(UInt(3) << i, i + 1 >= Int.bitWidth, NBK.IsPowerOf2.self)
        }
    }
    
    func testIsNonPowerOf2() {
        NBKAssert(Int.min, true,  NBK.IsNonPowerOf2.self)
        NBKAssert(Int(-2), true,  NBK.IsNonPowerOf2.self)
        NBKAssert(Int(-1), true,  NBK.IsNonPowerOf2.self)
        NBKAssert(Int( 0), true,  NBK.IsNonPowerOf2.self)
        NBKAssert(Int( 1), false, NBK.IsNonPowerOf2.self)
        NBKAssert(Int.max, true,  NBK.IsNonPowerOf2.self)
        
        for i in 0 ..< Int.bitWidth {
            NBKAssert(Int(3) << i, true, NBK.IsNonPowerOf2.self)
            NBKAssert(Int(1) << i, i + 1 >= Int.bitWidth, NBK.IsNonPowerOf2.self)
        }
        
        for i in 0 ..< Int.bitWidth - 1 {
            NBKAssert(UInt(1) << i, false, NBK.IsNonPowerOf2.self)
            NBKAssert(UInt(3) << i, i + 2  <= Int.bitWidth, NBK.IsNonPowerOf2.self)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Predicate Wrapper x Assertions
//*============================================================================*

private func NBKAssert<Predicate: _NBKPredicate>(
_ value: Predicate.Value, _ success: Bool, _ predicate: Predicate.Type,
file: StaticString = #file, line: UInt = #line) where Predicate.Value: Equatable {
    //=------------------------------------------=
    typealias T = _NBKPredicateWrapper<Predicate>
    typealias N = _NBKPredicateWrapper<NBK.IsNot<Predicate>>
    //=------------------------------------------=
    func wrapping<X>(@_NBKPredicateWrapper<X> _ wrapped: X.Value, precondition type: X.Type) where X: _NBKPredicate<Predicate.Value> {
        XCTAssertEqual(wrapped, value, file:  file,  line: line)
        XCTAssertEqual($wrapped.value, value, file:  file, line: line)
        XCTAssertEqual($wrapped.wrappedValue, value, file: file, line: line)
    }
    
    brr: do {
        XCTAssertEqual(T(exactly: value) != nil, success, file: file, line: line)
    }
    
    if  success {
        wrapping(value, precondition: T.Predicate.self)
        XCTAssertEqual(T(/*------*/ value).value, value, file: file, line: line)
        XCTAssertEqual(T(unchecked: value).value, value, file: file, line: line)
    }   else {
        wrapping(value, precondition: N.Predicate.self)
        XCTAssertEqual(N(/*------*/ value).value, value, file: file, line: line)
        XCTAssertEqual(N(unchecked: value).value, value, file: file, line: line)
    }
}

#endif
