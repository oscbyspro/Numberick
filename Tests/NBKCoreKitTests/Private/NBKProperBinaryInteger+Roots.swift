//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Roots
//*============================================================================*

final class NBKProperBinaryIntegerTestsOnRoots: XCTestCase {
    
    typealias T = NBK.PBI
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSquareRoot() {
        NBKAssertSquareRoot( Int8 .max, 0000000011)
        NBKAssertSquareRoot( Int16.max, 0000000181)
        NBKAssertSquareRoot( Int32.max, 0000046340)
        NBKAssertSquareRoot( Int64.max, 3037000499)
        
        NBKAssertSquareRoot(UInt8 .max, UInt8 .max >> 04)
        NBKAssertSquareRoot(UInt16.max, UInt16.max >> 08)
        NBKAssertSquareRoot(UInt32.max, UInt32.max >> 16)
        NBKAssertSquareRoot(UInt64.max, UInt64.max >> 32)
        
        for base in 0 as Int64 ..< 144 {
            for power in (base * base) ..< (base + 1) * (base + 1) {
                NBKAssertSquareRoot(power,  base)
            }
        }
    }
}

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Roots x Assertions
//*============================================================================*

private func NBKAssertSquareRoot<T: NBKFixedWidthInteger>(
_ power: T, _ expectation: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertSquareRootAsUnsigned(power.magnitude, expectation.magnitude, file: file, line: line)
    //=------------------------------------------=
    let root = NBK.PBI.squareRootByNewtonsMethod(of: power)
    XCTAssertGreaterThanOrEqual(power, T.zero, file: file, line: line)
    XCTAssertEqual(root.magnitude,  expectation.magnitude, file: file, line: line)
}

private func NBKAssertSquareRootAsUnsigned<T: NBKUnsignedInteger & NBKFixedWidthInteger>(
_ power: T, _ expectation: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let root = NBK.PBI.squareRootByNewtonsMethod(of: power)
    let product0 = (root + 0).multipliedReportingOverflow(by: root + 0)
    let product1 = (root + 1).multipliedReportingOverflow(by: root + 1)
    //=------------------------------------------=
    XCTAssertEqual(root, expectation, file: file, line: line)
    XCTAssertFalse(product0.overflow)
    
    if !product0.overflow {
        XCTAssert(power >= product0.partialValue, file: file, line: line)
    }
    
    if !product1.overflow {
        XCTAssert(power <  product1.partialValue, file: file, line: line)
    }
}
