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
// MARK: * NBK x Int x Comparisons
//*============================================================================*

final class IntBenchmarksOnComparisons: XCTestCase {
    
    typealias T =  Int
    typealias M = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSignumAsInt() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.signum() as Int)
            NBK.blackHole(xyz.signum() as Int)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testSignumAsSelf() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.signum() as T)
            NBK.blackHole(xyz.signum() as T)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt x Comparisons
//*============================================================================*

final class UIntBenchmarksOnComparisons: XCTestCase {
    
    typealias T = UInt
    typealias M = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSignumAsInt() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.signum() as Int)
            NBK.blackHole(xyz.signum() as Int)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testSignumAsSelf() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.signum() as T)
            NBK.blackHole(xyz.signum() as T)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
