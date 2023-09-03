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
// MARK: * NBK x Chunked Int
//*============================================================================*

final class NBKChunkedIntBenchmarks: XCTestCase {
    
    typealias T = NBKChunkedInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt32AsUInt32() {
        var abc = NBK.blackHoleIdentity(Y(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(Y(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(Y(T(abc)))
            NBK.blackHole(Y(T(xyz)))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt32AsUInt64() {
        var abc = NBK.blackHoleIdentity(Y(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(Y(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X(T(abc)))
            NBK.blackHole(X(T(xyz)))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt64AsUInt32() {
        var abc = NBK.blackHoleIdentity(X(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(Y(T(abc)))
            NBK.blackHole(Y(T(xyz)))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt64AsUInt64() {
        var abc = NBK.blackHoleIdentity(X(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X(T(abc)))
            NBK.blackHole(X(T(xyz)))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testUInt32AsUInt32ByUnsafeBufferPointer() {
        var abc = NBK.blackHoleIdentity(Y(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(Y(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(abc.withUnsafeBufferPointer(Y.init))
            NBK.blackHole(xyz.withUnsafeBufferPointer(Y.init))
                        
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt64AsUInt64ByUnsafeBufferPointer() {
        var abc = NBK.blackHoleIdentity(X(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(abc.withUnsafeBufferPointer(X.init))
            NBK.blackHole(xyz.withUnsafeBufferPointer(X.init))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
