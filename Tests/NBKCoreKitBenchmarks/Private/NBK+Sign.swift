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

//*============================================================================*
// MARK: * NBK x Sign
//*============================================================================*

final class NBKBenchmarksOnSign: XCTestCase {
    
    typealias T = FloatingPointSign
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testASCII() {
        var abc = NBK.blackHoleIdentity(T.plus )
        var xyz = NBK.blackHoleIdentity(T.minus)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.ascii(abc))
            NBK.blackHole(NBK.ascii(xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testBit() {
        var abc = NBK.blackHoleIdentity(T.plus )
        var xyz = NBK.blackHoleIdentity(T.minus)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.bit(abc))
            NBK.blackHole(NBK.bit(xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testSign() {
        var abc = NBK.blackHoleIdentity(true )
        var xyz = NBK.blackHoleIdentity(false)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.sign(abc))
            NBK.blackHole(NBK.sign(xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Transformations
    //=------------------------------------------------------------------------=
    
    func testNot() {
        var abc = NBK.blackHoleIdentity(T.plus )
        var xyz = NBK.blackHoleIdentity(T.minus)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.not(abc))
            NBK.blackHole(NBK.not(xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testAnd() {
        var lhs = NBK.blackHoleIdentity(T.plus )
        var rhs = NBK.blackHoleIdentity(T.minus)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.and(lhs, rhs))
            NBK.blackHole(NBK.and(rhs, lhs))
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testOr() {
        var lhs = NBK.blackHoleIdentity(T.plus )
        var rhs = NBK.blackHoleIdentity(T.minus)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.or(lhs, rhs))
            NBK.blackHole(NBK.or(rhs, lhs))
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testXor() {
        var lhs = NBK.blackHoleIdentity(T.plus )
        var rhs = NBK.blackHoleIdentity(T.minus)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.xor(lhs, rhs))
            NBK.blackHole(NBK.xor(rhs, lhs))
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
