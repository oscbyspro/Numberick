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
import NBKTextKit
import XCTest

//*============================================================================*
// MARK: * NBK x Integer Description x Radix Solution
//*============================================================================*

final class NBKIntegerDescriptionTestsOnRadixSolution: XCTestCase {

    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAnyRadixSolution() {
        func whereIs<T>(_ element: T.Type) where T: NBKCoreInteger & NBKUnsignedInteger {
            for radix in 2 ... 36 {
                let solution = NBK.IntegerDescription.AnyRadixSolution<T>(radix)
                XCTAssertEqual(solution.base, T(radix))

                var product =  HL(0 as T, 1 as T)
                for _ in 0 ..< solution.exponent {
                    XCTAssert(product.high.isZero)
                    product = product.low.multipliedFullWidth(by: T.Magnitude(radix))
                }

                XCTAssertEqual(product.low, solution.power)
                XCTAssertEqual(product.low.isZero, [2, 4, 16].contains(radix))
                XCTAssertEqual(product.high, /**/  [2, 4, 16].contains(radix) ? 1 : 0)
                XCTAssertEqual(product.low.multipliedReportingOverflow(by: T.Magnitude(radix)).overflow, ![2, 4, 16].contains(radix))
            }
        }

        for element: any (NBKCoreInteger & NBKUnsignedInteger).Type in [UInt.self, UInt8.self, UInt16.self, UInt32.self, UInt64.self] {
            whereIs(element)
        }
    }
}

#endif
