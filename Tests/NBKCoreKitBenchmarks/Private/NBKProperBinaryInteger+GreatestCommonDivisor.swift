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

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Proper Binary Integer x Greatest Common Divisor
//*============================================================================*

final class NBKProperBinaryIntegerBenchmarksOnGreatestCommonDivisor: XCTestCase {
 
    typealias T = NBK.PBI
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Binary Algorithm
    //=------------------------------------------------------------------------=
    
    func testBinaryAlgorithmForEachPairOfInt8s() {
        for _ in 0 ..< 50 {
            for lhs in Int8.min ... Int8.max {
                for rhs in Int8.min ... Int8.max {
                    NBK.blackHole(T.greatestCommonDivisorByBinaryAlgorithm(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testBinaryAlgorithmForEachPairOfUInt8s() {
        for _ in 0 ..< 50 {
            for lhs in UInt8.min ... UInt8.max {
                for rhs in UInt8.min ... UInt8.max {
                    NBK.blackHole(T.greatestCommonDivisorByBinaryAlgorithm(of: lhs, and: rhs))
                }
            }
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Euclidean Algorithm
    //=------------------------------------------------------------------------=
    
    func testEuclideanAlgorithm00ForEachPairOfInt8s() {
        for _ in 0 ..< 50 {
            for lhs in Int8.min ... Int8.max {
                for rhs in Int8.min ... Int8.max {
                    NBK.blackHole(T.greatestCommonDivisorByEuclideanAlgorithm00(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm10ForEachPairOfInt8s() {
        for _ in 0 ..< 50 {
            for lhs in Int8.min ... Int8.max {
                for rhs in Int8.min ... Int8.max {
                    NBK.blackHole(T.greatestCommonDivisorByEuclideanAlgorithm10(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm01ForEachPairOfInt8s() {
        for _ in 0 ..< 50 {
            for lhs in Int8.min ... Int8.max {
                for rhs in Int8.min ... Int8.max {
                    NBK.blackHole(T.greatestCommonDivisorByEuclideanAlgorithm01(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm11ForEachPairOfInt8s() {
        for _ in 0 ..< 50 {
            for lhs in Int8.min ... Int8.max {
                for rhs in Int8.min ... Int8.max {
                    NBK.blackHole(T.greatestCommonDivisorByEuclideanAlgorithm11(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm00ForEachPairOfUInt8s() {
        for _ in 0 ..< 50 {
            for lhs in UInt8.min ... UInt8.max {
                for rhs in UInt8.min ... UInt8.max {
                    NBK.blackHole(T.greatestCommonDivisorByEuclideanAlgorithm00(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm10ForEachPairOfUInt8s() {
        for _ in 0 ..< 50 {
            for lhs in UInt8.min ... UInt8.max {
                for rhs in UInt8.min ... UInt8.max {
                    NBK.blackHole(T.greatestCommonDivisorByEuclideanAlgorithm10(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm01ForEachPairOfUInt8s() {
        for _ in 0 ..< 50 {
            for lhs in UInt8.min ... UInt8.max {
                for rhs in UInt8.min ... UInt8.max {
                    NBK.blackHole(T.greatestCommonDivisorByEuclideanAlgorithm01(of: lhs, and: rhs))
                }
            }
        }
    }
    
    func testEuclideanAlgorithm11ForEachPairOfUInt8s() {
        for _ in 0 ..< 50 {
            for lhs in UInt8.min ... UInt8.max {
                for rhs in UInt8.min ... UInt8.max {
                    NBK.blackHole(T.greatestCommonDivisorByEuclideanAlgorithm11(of: lhs, and: rhs))
                }
            }
        }
    }
}

#endif
