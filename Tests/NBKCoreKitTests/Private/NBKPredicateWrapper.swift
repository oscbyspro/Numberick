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
        NBKAssert(Int.min, false, NBK.Zero.self)
        NBKAssert(Int(-2), false, NBK.Zero.self)
        NBKAssert(Int(-1), false, NBK.Zero.self)
        NBKAssert(Int( 0), true,  NBK.Zero.self)
        NBKAssert(Int( 1), false, NBK.Zero.self)
        NBKAssert(Int.max, false, NBK.Zero.self)
    }
    
    func testIsNonZero() {
        NBKAssert(Int.min, true,  NBK.NonZero.self)
        NBKAssert(Int(-2), true,  NBK.NonZero.self)
        NBKAssert(Int(-1), true,  NBK.NonZero.self)
        NBKAssert(Int( 0), false, NBK.NonZero.self)
        NBKAssert(Int( 1), true,  NBK.NonZero.self)
        NBKAssert(Int.max, true,  NBK.NonZero.self)
    }
    
    func testIsZeroOrLess() {
        NBKAssert(Int.min, true,  NBK.ZeroOrLess.self)
        NBKAssert(Int(-2), true,  NBK.ZeroOrLess.self)
        NBKAssert(Int(-1), true,  NBK.ZeroOrLess.self)
        NBKAssert(Int( 0), true,  NBK.ZeroOrLess.self)
        NBKAssert(Int( 1), false, NBK.ZeroOrLess.self)
        NBKAssert(Int.max, false, NBK.ZeroOrLess.self)
    }
    
    func testIsZeroOrMore() {
        NBKAssert(Int.min, false, NBK.ZeroOrMore.self)
        NBKAssert(Int(-2), false, NBK.ZeroOrMore.self)
        NBKAssert(Int(-1), false, NBK.ZeroOrMore.self)
        NBKAssert(Int( 0), true,  NBK.ZeroOrMore.self)
        NBKAssert(Int( 1), true,  NBK.ZeroOrMore.self)
        NBKAssert(Int.max, true,  NBK.ZeroOrMore.self)
    }
    
    func testIsLessThanZero() {
        NBKAssert(Int.min, true,  NBK.LessThanZero.self)
        NBKAssert(Int(-2), true,  NBK.LessThanZero.self)
        NBKAssert(Int(-1), true,  NBK.LessThanZero.self)
        NBKAssert(Int( 0), false, NBK.LessThanZero.self)
        NBKAssert(Int( 1), false, NBK.LessThanZero.self)
        NBKAssert(Int.max, false, NBK.LessThanZero.self)
    }
    
    func testIsMoreThanZero() {
        NBKAssert(Int.min, false, NBK.MoreThanZero.self)
        NBKAssert(Int(-2), false, NBK.MoreThanZero.self)
        NBKAssert(Int(-1), false, NBK.MoreThanZero.self)
        NBKAssert(Int( 0), false, NBK.MoreThanZero.self)
        NBKAssert(Int( 1), true,  NBK.MoreThanZero.self)
        NBKAssert(Int.max, true,  NBK.MoreThanZero.self)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Is Power Of 2
    //=------------------------------------------------------------------------=
    
    func testIsPowerOf2() {
        NBKAssert(Int.min, false, NBK.PowerOf2.self)
        NBKAssert(Int(-2), false, NBK.PowerOf2.self)
        NBKAssert(Int(-1), false, NBK.PowerOf2.self)
        NBKAssert(Int( 0), false, NBK.PowerOf2.self)
        NBKAssert(Int( 1), true,  NBK.PowerOf2.self)
        NBKAssert(Int.max, false, NBK.PowerOf2.self)
        
        for i in 0 ..< Int.bitWidth {
            NBKAssert(Int(3) << i, false, NBK.PowerOf2.self)
            NBKAssert(Int(1) << i, i + 2 <= Int.bitWidth, NBK.PowerOf2.self)
        }
        
        for i in 0 ..< Int.bitWidth - 1 {
            NBKAssert(UInt(1) << i, true, NBK.PowerOf2.self)
            NBKAssert(UInt(3) << i, i + 1 >= Int.bitWidth, NBK.PowerOf2.self)
        }
    }
    
    func testIsNonPowerOf2() {
        NBKAssert(Int.min, true,  NBK.NonPowerOf2.self)
        NBKAssert(Int(-2), true,  NBK.NonPowerOf2.self)
        NBKAssert(Int(-1), true,  NBK.NonPowerOf2.self)
        NBKAssert(Int( 0), true,  NBK.NonPowerOf2.self)
        NBKAssert(Int( 1), false, NBK.NonPowerOf2.self)
        NBKAssert(Int.max, true,  NBK.NonPowerOf2.self)
        
        for i in 0 ..< Int.bitWidth {
            NBKAssert(Int(3) << i, true, NBK.NonPowerOf2.self)
            NBKAssert(Int(1) << i, i + 1 >= Int.bitWidth, NBK.NonPowerOf2.self)
        }
        
        for i in 0 ..< Int.bitWidth - 1 {
            NBKAssert(UInt(1) << i, false, NBK.NonPowerOf2.self)
            NBKAssert(UInt(3) << i, i + 2  <= Int.bitWidth, NBK.NonPowerOf2.self)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Predicate Wrapper x Assertions
//*============================================================================*

private func NBKAssert<Predicate: _NBKPredicate>(
_ value: Predicate.Value, _ success: Bool, _ predicate: _NBKPredicateWrapper<Predicate>.Type,
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
