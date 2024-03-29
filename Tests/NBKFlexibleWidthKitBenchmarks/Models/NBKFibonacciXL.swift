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

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

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
    
    /// https://www.wolframalpha.com/input?i2d=true&i=fibonacci+10000000
    ///
    /// - Note: The 10,000,000th element contains 2,089,877 decimal digits.
    ///
    func testNoLoop10000000() {
        NBK.blackHole(T(NBK.blackHoleIdentity(10_000_000)))
    }
}

#endif
