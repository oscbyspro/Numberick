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
// MARK: * NBK x Flexible Width x Exponentiation x UIntXL
//*============================================================================*

final class NBKFlexibleWidthBenchmarksOnExponentiationAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func test2RaisedToPrime222() {
        var base: T  = NBK.blackHoleIdentity(T(000002))
        var exponent = NBK.blackHoleIdentity(Int(1399))
        
        for _ in 0 ..< 10_000 {
            NBK.blackHole(base.power(exponent))
            NBK.blackHoleInoutIdentity(&base)
            NBK.blackHoleInoutIdentity(&exponent)
        }
    }
    
    func test3RaisedToPrime333() {
        var base: T  = NBK.blackHoleIdentity(T(000003))
        var exponent = NBK.blackHoleIdentity(Int(2239))
        
        for _ in 0 ..< 10_000 {
            NBK.blackHole(base.power(exponent))
            NBK.blackHoleInoutIdentity(&base)
            NBK.blackHoleInoutIdentity(&exponent)
        }
    }
    
    func test5RaisedToPrime555() {
        var base: T  = NBK.blackHoleIdentity(T(000005))
        var exponent = NBK.blackHoleIdentity(Int(4019))
        
        for _ in 0 ..< 10_000 {
            NBK.blackHole(base.power(exponent))
            NBK.blackHoleInoutIdentity(&base)
            NBK.blackHoleInoutIdentity(&exponent)
        }
    }
    
    func test7RaisedToPrime777() {
        var base: T  = NBK.blackHoleIdentity(T(000007))
        var exponent = NBK.blackHoleIdentity(Int(5903))
        
        for _ in 0 ..< 10_000 {
            NBK.blackHole(base.power(exponent))
            NBK.blackHoleInoutIdentity(&base)
            NBK.blackHoleInoutIdentity(&exponent)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x No Loop
    //=------------------------------------------------------------------------=
    
    func testNoLoop5RaisedToPrime22222() {
        let base: T  = NBK.blackHoleIdentity(T(000002))
        let exponent = NBK.blackHoleIdentity(Int(252233))
        NBK.blackHole(base.power(exponent))
    }
    
    func testNoLoop5RaisedToPrime33333() {
        let base: T  = NBK.blackHoleIdentity(T(000003))
        let exponent = NBK.blackHoleIdentity(Int(393191))
        NBK.blackHole(base.power(exponent))
    }
    
    func testNoLoop5RaisedToPrime55555() {
        let base: T  = NBK.blackHoleIdentity(T(000005))
        let exponent = NBK.blackHoleIdentity(Int(686671))
        NBK.blackHole(base.power(exponent))
    }
    
    func testNoLoop7RaisedToPrime77777() {
        let base: T  = NBK.blackHoleIdentity(T(000007))
        let exponent = NBK.blackHoleIdentity(Int(989999))
        NBK.blackHole(base.power(exponent))
    }
}

#endif
