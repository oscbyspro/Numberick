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
// MARK: * NBK x Limbs
//*============================================================================*

final class NBKBenchmarksOnLimbs: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt64AsUInt32() {
        var abc = NBK.blackHoleIdentity([ 1,  2,  3,  4] as X)
        var xyz = NBK.blackHoleIdentity([~1, ~2, ~3, ~4] as X)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(NBK.limbs(abc, as: Y.self))
            NBK.blackHole(NBK.limbs(xyz, as: Y.self))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt32AsUInt64() {
        var abc = NBK.blackHoleIdentity([ 1,  0,  2,  0,  3,  0,  4,  0] as Y)
        var xyz = NBK.blackHoleIdentity([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as Y)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(NBK.limbs(abc, as: X.self))
            NBK.blackHole(NBK.limbs(xyz, as: X.self))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Succinct
    //=------------------------------------------------------------------------=
    
    func testMakeSuccinctSignedIntegerLimbs() {
        var abc = NBK.blackHoleIdentity([ 1,  0,  2,  0,  3,  0,  4,  0] as W)
        var xyz = NBK.blackHoleIdentity([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as W)
        
        for _ in 0 ..< 5_000_000 {
            abc.withUnsafeBufferPointer { abc in
            xyz.withUnsafeBufferPointer { xyz in
                NBK.blackHole(NBK.makeSuccinctSignedIntegerLimbs(abc))
                NBK.blackHole(NBK.makeSuccinctSignedIntegerLimbs(xyz))
            }}
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testMakeSuccinctUnsignedIntegerLimbsLenient() {
        var abc = NBK.blackHoleIdentity([ 1,  0,  2,  0,  3,  0,  4,  0] as W)
        var xyz = NBK.blackHoleIdentity([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as W)
        
        for _ in 0 ..< 5_000_000 {
            abc.withUnsafeBufferPointer { abc in
            xyz.withUnsafeBufferPointer { xyz in
                NBK.blackHole(NBK.makeSuccinctUnsignedIntegerLimbsLenient(abc))
                NBK.blackHole(NBK.makeSuccinctUnsignedIntegerLimbsLenient(xyz))
            }}
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
