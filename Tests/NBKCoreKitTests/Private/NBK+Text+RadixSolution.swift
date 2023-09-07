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
// MARK: * NBK x Text x Radix Solution
//*============================================================================*

final class NBKTestsOnTextByRadixSolution: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAnyRadixSolution() {
        func whereSizeIs<T>(_ size: T.Type) where T: NBKCoreInteger & NBKSignedInteger {
            for radix in 2 ... 36 {
                let solution = NBK.AnyRadixSolution<T>(radix)
                XCTAssertEqual(solution.base, T.Magnitude(radix))
                
                var product =  HL(T.Magnitude(0), T.Magnitude(1))
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
        
        for size: any (NBKCoreInteger & NBKSignedInteger).Type in [Int.self, Int8.self, Int16.self, Int32.self, Int64.self] {
            whereSizeIs(size)
        }
    }
}

#endif
