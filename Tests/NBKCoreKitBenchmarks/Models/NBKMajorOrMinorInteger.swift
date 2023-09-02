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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Major Or Minor Integer
//*============================================================================*

final class NBKMajorOrMinorIntegerBenchmarks: XCTestCase {
    
    typealias T = NBKMajorOrMinorInteger
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt64AsUInt32() {
        var abc = NBK.blackHoleIdentity([ 1,  2,  3,  4] as X)
        var xyz = NBK.blackHoleIdentity([~1, ~2, ~3, ~4] as X)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(Y(T(abc)))
            NBK.blackHole(Y(T(xyz)))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt64AsUInt32AsMinor() {
        var abc = NBK.blackHoleIdentity([ 1,  2,  3,  4] as X)
        var xyz = NBK.blackHoleIdentity([~1, ~2, ~3, ~4] as X)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(Y(T.Minor(abc)))
            NBK.blackHole(Y(T.Minor(xyz)))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt32AsUInt64() {
        var abc = NBK.blackHoleIdentity([ 1,  0,  2,  0,  3,  0,  4,  0] as Y)
        var xyz = NBK.blackHoleIdentity([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as Y)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(X(T(abc)))
            NBK.blackHole(X(T(xyz)))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt32AsUInt64AsMajor() {
        var abc = NBK.blackHoleIdentity([ 1,  0,  2,  0,  3,  0,  4,  0] as Y)
        var xyz = NBK.blackHoleIdentity([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as Y)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(X(T.Major(abc)))
            NBK.blackHole(X(T.Major(xyz)))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
