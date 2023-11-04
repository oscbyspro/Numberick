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
import NBKFlexibleWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x FibonacciXL
//*============================================================================*

final class NBKFibonacciXLBenchmarks: XCTestCase {
    
    typealias T = NBKFibonacciXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testPrime222() {
        var index = NBK.blackHoleIdentity(UInt(1399))
        
        for _ in 0 ..< 10_000 {
            NBK.blackHole(T(index))
            NBK.blackHoleInoutIdentity(&index)
        }
    }
    
    func testPrime333() {
        var index = NBK.blackHoleIdentity(UInt(2239))
        
        for _ in 0 ..< 10_000 {
            NBK.blackHole(T(index))
            NBK.blackHoleInoutIdentity(&index)
        }
    }
    
    func testPrime555() {
        var index = NBK.blackHoleIdentity(UInt(4019))
        
        for _ in 0 ..< 10_000 {
            NBK.blackHole(T(index))
            NBK.blackHoleInoutIdentity(&index)
        }
    }
    
    func testPrime777() {
        var index = NBK.blackHoleIdentity(UInt(5903))
        
        for _ in 0 ..< 10_000 {
            NBK.blackHole(T(index))
            NBK.blackHoleInoutIdentity(&index)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x No Loop
    //=------------------------------------------------------------------------=
    
    ///  The 1,000,000th element has 208,988 decimal digits.
    func testNoLoop1000000() {
        NBK.blackHole(T(NBK.blackHoleIdentity(UInt(1_000_000))))
    }
}

#endif
