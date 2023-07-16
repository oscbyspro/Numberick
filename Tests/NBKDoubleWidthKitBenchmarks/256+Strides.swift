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
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Int256 x Strides
//*============================================================================*

final class Int256BenchmarksOnStrides: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAdvancedBy() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~1, ~2, ~3, ~4)))
        var rhs = NBK.blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.advanced(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testDistanceTo() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~1, ~2, ~3, ~4)))
        var rhs = NBK.blackHoleIdentity(T(x64: X(~1, ~2, ~3, ~4)).advanced(by: Int.max))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.distance(to: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Strides
//*============================================================================*

final class UInt256BenchmarksOnStrides: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testAdvancedBy() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~1, ~2, ~3, ~4)))
        var rhs = NBK.blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.advanced(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testDistanceTo() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(~1, ~2, ~3, ~4)))
        var rhs = NBK.blackHoleIdentity(T(x64: X(~1, ~2, ~3, ~4)).advanced(by: Int.max))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.distance(to: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
