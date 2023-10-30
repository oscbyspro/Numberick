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
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor
//*============================================================================*

final class NBKProperBinaryIntegerBenchmarksOnGreatestCommonDivisor: XCTestCase {
 
    typealias T = NBK.PBI
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Binary Algorithm
    //=------------------------------------------------------------------------=
    
    func testBinaryAlgorithmForAllInt8s() {
        for _ in 0 ..< 50 {
            for lhs in Int8.min ... Int8.max {
                for rhs in Int8.min ... Int8.max {
                    NBK.blackHole(NBK.PBI.greatestCommonDivisorByBinaryAlgorithm(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testBinaryAlgorithmForAllUInt8s() {
        for _ in 0 ..< 50 {
            for lhs in UInt8.min ... UInt8.max {
                for rhs in UInt8.min ... UInt8.max {
                    NBK.blackHole(NBK.PBI.greatestCommonDivisorByBinaryAlgorithm(of: lhs, and: rhs))
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Euclidean Algorithm
    //=------------------------------------------------------------------------=
    
    func testEuclideanAlgorithm100ForAllInt8s() {
        for _ in 0 ..< 50 {
            for lhs in Int8.min ... Int8.max {
                for rhs in Int8.min ... Int8.max {
                    NBK.blackHole(NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm100(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm110ForAllInt8s() {
        for _ in 0 ..< 50 {
            for lhs in Int8.min ... Int8.max {
                for rhs in Int8.min ... Int8.max {
                    NBK.blackHole(NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm110(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm101ForAllInt8s() {
        for _ in 0 ..< 50 {
            for lhs in Int8.min ... Int8.max {
                for rhs in Int8.min ... Int8.max {
                    NBK.blackHole(NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm101(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm111ForAllInt8s() {
        for _ in 0 ..< 50 {
            for lhs in Int8.min ... Int8.max {
                for rhs in Int8.min ... Int8.max {
                    NBK.blackHole(NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm111(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm100ForAllUInt8s() {
        for _ in 0 ..< 50 {
            for lhs in UInt8.min ... UInt8.max {
                for rhs in UInt8.min ... UInt8.max {
                    NBK.blackHole(NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm100(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm110ForAllUInt8s() {
        for _ in 0 ..< 50 {
            for lhs in UInt8.min ... UInt8.max {
                for rhs in UInt8.min ... UInt8.max {
                    NBK.blackHole(NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm110(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm101ForAllUInt8s() {
        for _ in 0 ..< 50 {
            for lhs in UInt8.min ... UInt8.max {
                for rhs in UInt8.min ... UInt8.max {
                    NBK.blackHole(NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm101(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm111ForAllUInt8s() {
        for _ in 0 ..< 50 {
            for lhs in UInt8.min ... UInt8.max {
                for rhs in UInt8.min ... UInt8.max {
                    NBK.blackHole(NBK.PBI.greatestCommonDivisorByEuclideanAlgorithm111(of: lhs, and: rhs))
                }
            }
        }
    }
}

#endif
