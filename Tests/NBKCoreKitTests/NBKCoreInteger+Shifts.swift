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
// MARK: * NBK x Core Integer x Shifts
//*============================================================================*

final class NBKCoreIntegerTestsOnShifts: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitshiftingLeftByBits() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertShiftLeft(~T(0), 0, ~T(0))
            NBKAssertShiftLeft(~T(0), 1, ~T(1))
            NBKAssertShiftLeft(~T(0), 2, ~T(3))
            NBKAssertShiftLeft(~T(0), 3, ~T(7))
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRightByBits() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertShiftRight(T(7), 0, T(7))
            NBKAssertShiftRight(T(7), 1, T(3))
            NBKAssertShiftRight(T(7), 2, T(1))
            NBKAssertShiftRight(T(7), 3, T(0))
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testBitshiftingRightIsSignedOrUnsigned() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertShiftRight(T(repeating: true), T.bitWidth, T(repeating: T.isSigned))
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testBitshiftingIsSmart() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(T(4) <<  1, T(8))
            XCTAssertEqual(T(4) >> -1, T(8))
            
            XCTAssertEqual(T(4) >>  1, T(2))
            XCTAssertEqual(T(4) << -1, T(2))
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testBitshiftingByMinDistanceDoesNotTrap() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(T(repeating: true) << Int.min, T(repeating: T.isSigned))
            XCTAssertEqual(T(repeating: true) >> Int.min, T(repeating: false))
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
    
    func testBitshiftingByMaskingIsEquivalentToBitshiftingModuloBitWidth() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertShiftLeftByMasking(~T(0), 0 + T.bitWidth, ~T(0))
            NBKAssertShiftLeftByMasking(~T(0), 0 - T.bitWidth, ~T(0))
            NBKAssertShiftLeftByMasking(~T(0), 1 + T.bitWidth, ~T(1))
            NBKAssertShiftLeftByMasking(~T(0), 1 - T.bitWidth, ~T(1))
            NBKAssertShiftLeftByMasking(~T(0), 2 + T.bitWidth, ~T(3))
            NBKAssertShiftLeftByMasking(~T(0), 2 - T.bitWidth, ~T(3))
            NBKAssertShiftLeftByMasking(~T(0), 3 + T.bitWidth, ~T(7))
            NBKAssertShiftLeftByMasking(~T(0), 3 - T.bitWidth, ~T(7))
            
            NBKAssertShiftRightByMasking(T(7), 0 + T.bitWidth,  T(7))
            NBKAssertShiftRightByMasking(T(7), 0 - T.bitWidth,  T(7))
            NBKAssertShiftRightByMasking(T(7), 1 + T.bitWidth,  T(3))
            NBKAssertShiftRightByMasking(T(7), 1 - T.bitWidth,  T(3))
            NBKAssertShiftRightByMasking(T(7), 2 + T.bitWidth,  T(1))
            NBKAssertShiftRightByMasking(T(7), 2 - T.bitWidth,  T(1))
            NBKAssertShiftRightByMasking(T(7), 3 + T.bitWidth,  T(0))
            NBKAssertShiftRightByMasking(T(7), 3 - T.bitWidth,  T(0))
        }
        
        for type: T in types {
            whereIs(type)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Core Integer x Shifts x Assertions
//*============================================================================*

private func NBKAssertShiftLeft<T: NBKCoreInteger>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(                 lhs <<   rhs,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs >>  -rhs,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs <<=  rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs >>= -rhs; return lhs }(), result, file: file, line: line)
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(                 lhs &<<  rhs,                 result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs &<<= rhs; return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(lhs.bitshiftedLeft(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftLeft(by: rhs); return lhs }(), result, file: file, line: line)
    }
}

private func NBKAssertShiftRight<T: NBKCoreInteger>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(                 lhs >>   rhs,                 result, file: file, line: line)
    XCTAssertEqual(                 lhs <<  -rhs,                 result, file: file, line: line)
    
    XCTAssertEqual({ var lhs = lhs; lhs >>=  rhs; return lhs }(), result, file: file, line: line)
    XCTAssertEqual({ var lhs = lhs; lhs <<= -rhs; return lhs }(), result, file: file, line: line)
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(                 lhs &>>  rhs,                 result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs &>>= rhs; return lhs }(), result, file: file, line: line)
    }
    //=------------------------------------------=
    if  0 ..< lhs.bitWidth ~= rhs {
        XCTAssertEqual(lhs.bitshiftedRight(by: rhs), result, file: file, line: line)
        XCTAssertEqual({ var lhs = lhs; lhs.bitshiftRight(by: rhs); return lhs }(), result, file: file, line: line)
    }
}

//=----------------------------------------------------------------------------=
// MARK: + Masking
//=----------------------------------------------------------------------------=

private func NBKAssertShiftLeftByMasking<T: NBKCoreInteger>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line){
    //=------------------------------------------=
    XCTAssertEqual(lhs &<< (rhs),                result, file: file, line: line)
    XCTAssertEqual(lhs &<< (rhs + lhs.bitWidth), result, file: file, line: line)
    XCTAssertEqual(lhs &<< (rhs - lhs.bitWidth), result, file: file, line: line)
}

private func NBKAssertShiftRightByMasking<T: NBKCoreInteger>(
_ lhs: T, _ rhs:  Int, _ result: T,
file: StaticString = #file, line: UInt = #line){
    //=------------------------------------------=
    XCTAssertEqual(lhs &>> (rhs),                result, file: file, line: line)
    XCTAssertEqual(lhs &>> (rhs + lhs.bitWidth), result, file: file, line: line)
    XCTAssertEqual(lhs &>> (rhs - lhs.bitWidth), result, file: file, line: line)
}

#endif
