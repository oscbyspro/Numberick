//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG
#if SBI && swift(>=5.8)

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Static Big Int
//*============================================================================*

final class NBKStaticBigIntTests: XCTestCase {
    
    typealias T = NBKStaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testToFromSwiftStaticBigInt() {
        XCTAssertEqual(T(Swift.StaticBigInt(123))[0], 123)
        XCTAssertEqual(Swift.StaticBigInt(T(123))[0], 123)
    }
    
    func testBitWidth() {
        XCTAssertEqual(T( 1).bitWidth, 2)
        XCTAssertEqual(T( 0).bitWidth, 1)
        XCTAssertEqual(T(-1).bitWidth, 1)
        XCTAssertEqual(T(-2).bitWidth, 2)
        
        XCTAssertEqual(T( 2147483648).bitWidth, 33)
        XCTAssertEqual(T( 2147483647).bitWidth, 32)
        XCTAssertEqual(T(-2147483648).bitWidth, 32)
        XCTAssertEqual(T(-2147483649).bitWidth, 33)
        
        XCTAssertEqual(T( 9223372036854775808).bitWidth, 65)
        XCTAssertEqual(T( 9223372036854775807).bitWidth, 64)
        XCTAssertEqual(T(-9223372036854775808).bitWidth, 64)
        XCTAssertEqual(T(-9223372036854775809).bitWidth, 65)
    }
    
    func testSignum() {
        XCTAssertEqual(T( 1).signum(),  1)
        XCTAssertEqual(T( 0).signum(),  0)
        XCTAssertEqual(T(-1).signum(), -1)
        XCTAssertEqual(T(-2).signum(), -1)
        
        XCTAssertEqual(T( 2147483648).signum(),  1)
        XCTAssertEqual(T( 2147483647).signum(),  1)
        XCTAssertEqual(T(-2147483648).signum(), -1)
        XCTAssertEqual(T(-2147483649).signum(), -1)
        
        XCTAssertEqual(T( 9223372036854775808).signum(),  1)
        XCTAssertEqual(T( 9223372036854775807).signum(),  1)
        XCTAssertEqual(T(-9223372036854775808).signum(), -1)
        XCTAssertEqual(T(-9223372036854775809).signum(), -1)
    }
    
    func testSubscriptSignExtension() {
        XCTAssertEqual(T( 0)[Int.max],  0 as UInt)
        XCTAssertEqual(T(-1)[Int.max], ~0 as UInt)
    }
}

//*============================================================================*
// MARK: * NBK x Static Big Int x Collection
//*============================================================================*

final class NBKStaticBigIntTestsOnCollection: XCTestCase {
    
    typealias T = NBKStaticBigInt
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let top256:    T = -0x000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e20
    let bottom256: T =  0x1f1e1d1c1b1a191817161514131211100f0e0d0c0b0a09080706050403020100
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIteration() {
        NBKAssertIteration(T( 0),  [UInt.min])
        NBKAssertIteration(T(-1),  [UInt.max])
    }
    
    func testIterationX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertIteration(-0x8000000000000001, [UInt(bitPattern: Int.max), UInt.max])
        NBKAssertIteration(-0x8000000000000000, [UInt(bitPattern: Int.min)])
        NBKAssertIteration( 0x7fffffffffffffff, [UInt(bitPattern: Int.max)])
        NBKAssertIteration( 0x8000000000000000, [UInt(bitPattern: Int.min), UInt.min])
        
        NBKAssertIteration(   top256, [0xe7e6e5e4e3e2e1e0, 0xefeeedecebeae9e8, 0xf7f6f5f4f3f2f1f0, 0xfffefdfcfbfaf9f8])
        NBKAssertIteration(bottom256, [0x0706050403020100, 0x0f0e0d0c0b0a0908, 0x1716151413121110, 0x1f1e1d1c1b1a1918])
    }
    
    func testIterationX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertIteration(-0x80000001, [UInt(bitPattern: Int.max), UInt.max])
        NBKAssertIteration(-0x80000000, [UInt(bitPattern: Int.min)])
        NBKAssertIteration( 0x7fffffff, [UInt(bitPattern: Int.max)])
        NBKAssertIteration( 0x80000000, [UInt(bitPattern: Int.min), UInt.min])
        
        NBKAssertIteration(   top256, [0xe3e2e1e0, 0xe7e6e5e4, 0xebeae9e8, 0xefeeedec, 0xf3f2f1f0, 0xf7f6f5f4, 0xfbfaf9f8, 0xfffefdfc])
        NBKAssertIteration(bottom256, [0x03020100, 0x07060504, 0x0b0a0908, 0x0f0e0d0c, 0x13121110, 0x17161514, 0x1b1a1918, 0x1f1e1d1c])
    }
}

//*============================================================================*
// MARK: * NBK x Static Big Int x Assertions
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

private func NBKAssertIteration(_ lhs: NBKStaticBigInt, _ rhs: [UInt], file: StaticString = #file, line: UInt = #line) {
    
    XCTAssertEqual(Array(lhs),            rhs,            file: file, line: line)
    XCTAssertEqual(Array(lhs.reversed()), rhs.reversed(), file: file, line: line)
    
    testIndices: do {
        for lhsIndex in lhs.indices.enumerated() {
            XCTAssertEqual(lhs[lhsIndex.element], rhs[lhsIndex.offset], file: file, line: line)
        }
    }
    
    testFrontToBack: do {
        var lhsIndex = lhs.startIndex
        var rhsIndex = rhs.startIndex
        while lhsIndex < lhs.endIndex {
            let lhsIndexAfter = lhs.index(after: lhsIndex)
            let rhsIndexAfter = rhs.index(after: lhsIndex)
            
            XCTAssertEqual(lhs[lhsIndex], rhs[rhsIndex], file: file, line: line)
            XCTAssertEqual(lhsIndexAfter, rhsIndexAfter, file: file, line: line)
            
            lhs.formIndex(after: &lhsIndex)
            rhs.formIndex(after: &rhsIndex)
        }
    }
    
    testBackToFront: do {
        var lhsIndex = lhs.endIndex
        var rhsIndex = rhs.endIndex
        while lhsIndex > lhs.startIndex {
            let lhsIndexBefore = lhs.index(before: lhsIndex)
            let rhsIndexBefore = rhs.index(before: lhsIndex)
            
            lhs.formIndex(before: &lhsIndex)
            rhs.formIndex(before: &rhsIndex)
            
            XCTAssertEqual(lhs[lhsIndex],  rhs[rhsIndex],  file: file, line: line)
            XCTAssertEqual(lhsIndexBefore, rhsIndexBefore, file: file, line: line)
        }
    }
    
    testDropFirst: do {
        for dropFirst in 0 ..< (2 * lhs.count) {
            let lhsDropFirst = lhs.dropFirst(dropFirst)
            let rhsDropFirst = rhs.dropFirst(dropFirst)

            let lhsDropFirstIndices = lhs.indices[lhsDropFirst.indices]
            let rhsDropFirstIndices = rhs.indices[rhsDropFirst.indices]
            
            XCTAssertEqual(Array(lhsDropFirst),             Array(rhsDropFirst),             file: file, line: line)
            XCTAssertEqual(Array(lhs[lhsDropFirstIndices]), Array(rhs[rhsDropFirstIndices]), file: file, line: line)
            
            if  let first = lhs.dropFirst(dropFirst).first {
                let firstIndex = lhs.index(lhs.startIndex, offsetBy: dropFirst)
                XCTAssertEqual(first, lhs[firstIndex],  file: file, line: line)
            }
        }
    }
    
    testDropLast: do {
        for dropLast in 0 ..< (2 * lhs.count) {
            let lhsDropLast = lhs.dropFirst(dropLast)
            let rhsDropLast = rhs.dropFirst(dropLast)

            let lhsDropLastIndices = lhs.indices[lhsDropLast.indices]
            let rhsDropLastIndices = rhs.indices[rhsDropLast.indices]
            
            XCTAssertEqual(Array(lhsDropLast),             Array(rhsDropLast),             file: file, line: line)
            XCTAssertEqual(Array(lhs[lhsDropLastIndices]), Array(rhs[rhsDropLastIndices]), file: file, line: line)
            
            if  let last = lhs.dropLast(dropLast).last {
                let lastIndex = lhs.index(lhs.endIndex, offsetBy: ~dropLast)
                XCTAssertEqual(last, lhs[lastIndex], file: file, line: line)
            }
        }
    }
}

#endif
#endif
