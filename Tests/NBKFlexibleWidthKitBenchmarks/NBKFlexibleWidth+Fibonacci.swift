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
// MARK: * NBK x Flexible Width x Fibonacci x UIntXL
//*============================================================================*

final class NBKFlexibleWidthBenchmarksOnFibonacciAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testPrime222() {
        var index = NBK.blackHoleIdentity(Int(1399))
        
        for _ in 0 ..< 10_000 {
            NBK.blackHole(T.fibonacci(index))
            NBK.blackHoleInoutIdentity(&index)
        }
    }
    
    func testPrime333() {
        var index = NBK.blackHoleIdentity(Int(2239))
        
        for _ in 0 ..< 10_000 {
            NBK.blackHole(T.fibonacci(index))
            NBK.blackHoleInoutIdentity(&index)
        }
    }
    
    func testPrime555() {
        var index = NBK.blackHoleIdentity(Int(4019))
        
        for _ in 0 ..< 10_000 {
            NBK.blackHole(T.fibonacci(index))
            NBK.blackHoleInoutIdentity(&index)
        }
    }
    
    func testPrime777() {
        var index = NBK.blackHoleIdentity(Int(5903))
        
        for _ in 0 ..< 10_000 {
            NBK.blackHole(T.fibonacci(index))
            NBK.blackHoleInoutIdentity(&index)
        }
    }
}

#endif
