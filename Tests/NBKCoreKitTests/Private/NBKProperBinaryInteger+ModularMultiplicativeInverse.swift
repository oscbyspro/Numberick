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
// MARK: * NBK x Proper Binary Integer x Modular Mul. Inverse
//*============================================================================*

final class NBKProperBinaryIntegerTestsOnModularMultiplicativeInverse: XCTestCase {
    
    typealias T = NBK.PBI
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
        
    func testSomeSmallPrimes() {
        NBKAssertModularMultiplicativeInverse(  2 as Int,   31 as Int,   16 as Int) // primes:  1,  11
        NBKAssertModularMultiplicativeInverse(  3 as Int,   79 as Int,   53 as Int) // primes:  2,  22
        NBKAssertModularMultiplicativeInverse(  5 as Int,  137 as Int,   55 as Int) // primes:  3,  33
        NBKAssertModularMultiplicativeInverse(  7 as Int,  193 as Int,  138 as Int) // primes:  4,  44
        NBKAssertModularMultiplicativeInverse( 11 as Int,  257 as Int,  187 as Int) // primes:  5,  55
        NBKAssertModularMultiplicativeInverse( 13 as Int,  317 as Int,  122 as Int) // primes:  6,  66
        NBKAssertModularMultiplicativeInverse( 17 as Int,  389 as Int,  206 as Int) // primes:  7,  77
        NBKAssertModularMultiplicativeInverse( 19 as Int,  457 as Int,  433 as Int) // primes:  8,  88
        NBKAssertModularMultiplicativeInverse( 23 as Int,  523 as Int,   91 as Int) // primes:  9,  99
        
        NBKAssertModularMultiplicativeInverse(  2 as Int,  607 as Int,  304 as Int) // primes:  1, 111
        NBKAssertModularMultiplicativeInverse(  3 as Int, 1399 as Int,  933 as Int) // primes:  2, 222
        NBKAssertModularMultiplicativeInverse(  5 as Int, 2239 as Int,  448 as Int) // primes:  3, 333
        NBKAssertModularMultiplicativeInverse(  7 as Int, 3119 as Int, 2228 as Int) // primes:  4, 444
        NBKAssertModularMultiplicativeInverse( 11 as Int, 4019 as Int, 2923 as Int) // primes:  5, 555
        NBKAssertModularMultiplicativeInverse( 13 as Int, 4973 as Int, 4208 as Int) // primes:  6, 666
        NBKAssertModularMultiplicativeInverse( 17 as Int, 5903 as Int, 1389 as Int) // primes:  7, 777
        NBKAssertModularMultiplicativeInverse( 19 as Int, 6907 as Int, 6180 as Int) // primes:  8, 888
        NBKAssertModularMultiplicativeInverse( 23 as Int, 7907 as Int, 4813 as Int) // primes:  9, 999
        
        NBKAssertModularMultiplicativeInverse( 31 as Int,  607 as Int,  235 as Int) // primes: 11, 111
        NBKAssertModularMultiplicativeInverse( 79 as Int, 1399 as Int,  974 as Int) // primes: 22, 222
        NBKAssertModularMultiplicativeInverse(137 as Int, 2239 as Int, 1667 as Int) // primes: 33, 333
        NBKAssertModularMultiplicativeInverse(193 as Int, 3119 as Int,  905 as Int) // primes: 44, 444
        NBKAssertModularMultiplicativeInverse(257 as Int, 4019 as Int, 2377 as Int) // primes: 55, 555
        NBKAssertModularMultiplicativeInverse(317 as Int, 4973 as Int, 4722 as Int) // primes: 66, 666
        NBKAssertModularMultiplicativeInverse(389 as Int, 5903 as Int, 2170 as Int) // primes: 77, 777
        NBKAssertModularMultiplicativeInverse(457 as Int, 6907 as Int, 4383 as Int) // primes: 88, 888
        NBKAssertModularMultiplicativeInverse(523 as Int, 7907 as Int, 2933 as Int) // primes: 99, 999
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Simple Cases
    //=------------------------------------------------------------------------=
    
    func testInverseModuloZeroIsNil() {
        for x in 0 as Int ..< 10 {
            NBKAssertModularMultiplicativeInverse(x as Int, 0 as Int, nil as Int?)
        }
    }
    
    func testInverseModuloOneIsZero() {
        for x in 0 as Int ..< 10 {
            NBKAssertModularMultiplicativeInverse(x as Int, 1 as Int, 000 as Int?)
        }
    }
    
    func testZeroHasNoModularInverseForEachModulusGreaterThanOne() {
        for x in 2 as Int ..< 10 {
            NBKAssertModularMultiplicativeInverse(0 as Int, x as Int, nil as Int?)
        }
    }
    
    func testOneIsAlwaysItsOwnInverseForEachModulusGreaterThanOne() {
        for x in 2 as Int ..< 10 {
            NBKAssertModularMultiplicativeInverse(1 as Int, x as Int, 001 as Int?)
        }
    }
    
    func testThereIsNoInverseForAnyModulusLessThanOne() {
        for x in -10 as Int ..< 1 {
            NBKAssertModularMultiplicativeInverse(1 as Int, x as Int, nil as Int?)
        }
    }
    
    func testInverseIsNilWhenInputsAreNotCoprime() {
        NBKAssertModularMultiplicativeInverse(1 * 1 * 1 as Int, 2 * 3 * 5 as Int, 001 as Int?)
        NBKAssertModularMultiplicativeInverse(2 * 1 * 1 as Int, 2 * 3 * 5 as Int, nil as Int?)
        NBKAssertModularMultiplicativeInverse(1 * 3 * 1 as Int, 2 * 3 * 5 as Int, nil as Int?)
        NBKAssertModularMultiplicativeInverse(1 * 1 * 5 as Int, 2 * 3 * 5 as Int, nil as Int?)
        NBKAssertModularMultiplicativeInverse(2 * 3 * 1 as Int, 2 * 3 * 5 as Int, nil as Int?)
        NBKAssertModularMultiplicativeInverse(2 * 1 * 5 as Int, 2 * 3 * 5 as Int, nil as Int?)
        NBKAssertModularMultiplicativeInverse(1 * 3 * 5 as Int, 2 * 3 * 5 as Int, nil as Int?)
        NBKAssertModularMultiplicativeInverse(2 * 3 * 5 as Int, 2 * 3 * 5 as Int, nil as Int?)
        NBKAssertModularMultiplicativeInverse(7 * 7 * 7 as Int, 2 * 3 * 5 as Int, 007 as Int?)
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Modular Mul. Inverse x Assertions
//*============================================================================*

private func NBKAssertModularMultiplicativeInverse<T: NBKFixedWidthInteger>(
_ lhs: T, _ rhs: T, _ expectation: T?,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if !lhs.addingReportingOverflow(rhs).overflow {
        NBKAssertModularMultiplicativeInverseInvariants(lhs + rhs, rhs, expectation, file: file, line: line)
    }
    
    brr: do {
        NBKAssertModularMultiplicativeInverseInvariants(lhs + 000, rhs, expectation, file: file, line: line)
    }
    
    if !lhs.subtractingReportingOverflow(rhs).overflow {
        NBKAssertModularMultiplicativeInverseInvariants(lhs - rhs, rhs, expectation, file: file, line: line)
    }
}

private func NBKAssertModularMultiplicativeInverseInvariants<T: NBKFixedWidthInteger>(
_ lhs: T, _ rhs: T, _ expectation: T?,
file: StaticString = #file, line: UInt = #line) {
    //=--------------------------------------=
    let inverse = NBK.PBI.modularMultiplicativeInverse(of: lhs, modulo: rhs)
    //=--------------------------------------=
    XCTAssertEqual(inverse, expectation, file: file, line: line)
    //=--------------------------------------=
    if  let inverse {
        var remainder  = rhs.dividingFullWidth(lhs.multipliedFullWidth(by: inverse)).remainder
        if  remainder.isLessThanZero {
            remainder += rhs
        }
        
        XCTAssert(0000 ..< rhs ~=  inverse, file: file, line: line)
        XCTAssertEqual(remainder,  1 % rhs, file: file, line: line)
        XCTAssertEqual(inverse.isZero, rhs  == 1, file: file, line: line)
    }
    //=--------------------------------------=
    if  T.isSigned, !lhs.isLessThanZero, !rhs.isLessThanZero {
        NBKAssertModularMultiplicativeInverseInvariants(lhs.magnitude, rhs.magnitude, expectation?.magnitude, file: file, line: line)
    }
}

#endif
