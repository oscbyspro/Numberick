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
// MARK: * NBK x Radix UInt Root
//*============================================================================*

final class NBKRadixUIntRootTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAnyRadixUIntRoot() {
        for radix in 2 ... 36 {
            let solution = NBK.AnyRadixUIntRoot(radix)
            XCTAssertEqual(solution.base, UInt(radix))
            
            var product = HL(UInt(0), UInt(1))
            for _ in 0 ..< solution.exponent {
                XCTAssert(product.high.isZero)
                product = product.low.multipliedFullWidth(by: UInt(radix))
            }
            
            XCTAssertEqual(product.low, solution.power)
            XCTAssertEqual(product.low.isZero, [2, 4, 16].contains(radix))
            XCTAssertEqual(product.high, /**/  [2, 4, 16].contains(radix) ? 1 : 0)
            XCTAssertEqual(product.low.multipliedReportingOverflow(by: UInt(radix)).overflow, ![2, 4, 16].contains(radix))
        }
    }
}

#endif
