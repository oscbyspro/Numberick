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
// MARK: * NBK x Swift x Floating Point Sign
//*============================================================================*

final class SwiftBenchmarksOnFloatingPointSign: XCTestCase {
    
    typealias T = FloatingPointSign
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testToBit() {
        var abc = NBK.blackHoleIdentity(T.plus )
        var xyz = NBK.blackHoleIdentity(T.minus)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.bit)
            NBK.blackHole(xyz.bit)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testFromBit() {
        var abc = NBK.blackHoleIdentity(true )
        var xyz = NBK.blackHoleIdentity(false)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T(bit: abc))
            NBK.blackHole(T(bit: xyz))
            
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
            NBK.blackHole(~abc)
            NBK.blackHole(~xyz)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testAnd() {
        var lhs = NBK.blackHoleIdentity(T.plus )
        var rhs = NBK.blackHoleIdentity(T.minus)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs & rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testOr() {
        var lhs = NBK.blackHoleIdentity(T.plus )
        var rhs = NBK.blackHoleIdentity(T.minus)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs | rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testXor() {
        var lhs = NBK.blackHoleIdentity(T.plus )
        var rhs = NBK.blackHoleIdentity(T.minus)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs ^ rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
