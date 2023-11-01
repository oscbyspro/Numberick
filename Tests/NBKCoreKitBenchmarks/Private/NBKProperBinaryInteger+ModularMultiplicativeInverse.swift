//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !DEBUG

import NBKCoreKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Modular Multiplicative Inverse
//*============================================================================*

final class NBKProperBinaryIntegerBenchmarksOnModularMultiplicativeInverse: XCTestCase {
 
    typealias T = NBK.PBI
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInt8s() {
        for _ in 0 ..< 50 {
            for lhs in Int8.min ... Int8.max {
                for rhs in Int8.min ... Int8.max {
                    NBK.blackHole(T.modularMultiplicativeInverse(of: lhs, modulo: rhs))
                }
            }
        }
    }
    
    func testUInt8s() {
        for _ in 0 ..< 50 {
            for lhs in UInt8.min ... UInt8.max {
                for rhs in UInt8.min ... UInt8.max {
                    NBK.blackHole(T.modularMultiplicativeInverse(of: lhs, modulo: rhs))
                }
            }
        }
    }
}

#endif
