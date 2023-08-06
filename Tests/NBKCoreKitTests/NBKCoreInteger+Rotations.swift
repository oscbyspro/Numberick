//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Core Integer x Rotations
//*============================================================================*

final class NBKCoreIntegerTestsOnRotations: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitrotatingLeftByBits() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertRotateLeft( (T(7) << T(T.bitWidth - 3)), 0,  (T(7) << T(T.bitWidth - 3)) |  T(0))
            NBKAssertRotateLeft( (T(7) << T(T.bitWidth - 3)), 1,  (T(3) << T(T.bitWidth - 2)) |  T(1))
            NBKAssertRotateLeft( (T(7) << T(T.bitWidth - 3)), 2,  (T(1) << T(T.bitWidth - 1)) |  T(3))
            NBKAssertRotateLeft( (T(7) << T(T.bitWidth - 3)), 3,  (T(0) << T(T.bitWidth - 0)) |  T(7))
            
            NBKAssertRotateLeft(~(T(7) << T(T.bitWidth - 3)), 0, ~(T(7) << T(T.bitWidth - 3)) & ~T(0))
            NBKAssertRotateLeft(~(T(7) << T(T.bitWidth - 3)), 1, ~(T(3) << T(T.bitWidth - 2)) & ~T(1))
            NBKAssertRotateLeft(~(T(7) << T(T.bitWidth - 3)), 2, ~(T(1) << T(T.bitWidth - 1)) & ~T(3))
            NBKAssertRotateLeft(~(T(7) << T(T.bitWidth - 3)), 3, ~(T(0) << T(T.bitWidth - 0)) & ~T(7))
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitrotatingRightByBits() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertRotateRight( T(7), 0,  (T(0) << T(T.bitWidth - 0)) |  T(7))
            NBKAssertRotateRight( T(7), 1,  (T(1) << T(T.bitWidth - 1)) |  T(3))
            NBKAssertRotateRight( T(7), 2,  (T(3) << T(T.bitWidth - 2)) |  T(1))
            NBKAssertRotateRight( T(7), 3,  (T(7) << T(T.bitWidth - 3)) |  T(0))
            
            NBKAssertRotateRight(~T(7), 0, ~(T(0) << T(T.bitWidth - 0)) & ~T(7))
            NBKAssertRotateRight(~T(7), 1, ~(T(1) << T(T.bitWidth - 1)) & ~T(3))
            NBKAssertRotateRight(~T(7), 2, ~(T(3) << T(T.bitWidth - 2)) & ~T(1))
            NBKAssertRotateRight(~T(7), 3, ~(T(7) << T(T.bitWidth - 3)) & ~T(0))
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Core Integer x Rotations x Assertions
//*============================================================================*

private func NBKAssertRotateLeft<T: NBKCoreInteger>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssert(0 ..< lhs.bitWidth ~= rhs, "no smart rotations", file: file, line: line)
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(lhs.bitrotatedLeft(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitrotateLeft(by: rhs); return lhs }(), result, file: file, line: line)
    }
}

private func NBKAssertRotateRight<T: NBKCoreInteger>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssert(0 ..< lhs.bitWidth ~= rhs, "no smart rotations", file: file, line: line)
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(lhs.bitrotatedRight(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitrotateRight(by: rhs); return lhs }(), result, file: file, line: line)
    }
}

#endif
