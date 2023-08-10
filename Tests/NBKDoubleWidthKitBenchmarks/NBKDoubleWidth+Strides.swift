//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !DEBUG

import XCTest
#if !COCOAPODS
import NBKCoreKit
import NBKDoubleWidthKit
#else
import Numberick
#endif

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Strides x Int256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnStridesAsInt256: XCTestCase {
    
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
// MARK: * NBK x Double Width x Strides x UInt256
//*============================================================================*

final class NBKDoubleWidthBenchmarksOnStridesAsUInt256: XCTestCase {
    
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
