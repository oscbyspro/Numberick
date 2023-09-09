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
    // MARK: Tests x Versus Other Collections
    //=------------------------------------------------------------------------=
    // NOTE: The array conversions call Sequence/_copyToContiguousArray().
    //=------------------------------------------------------------------------=
    
    func testWithReversedCollectionUInt32AsUInt32() {
        var abc = NBK.blackHoleIdentity(Y(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(Y(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(Y(abc.reversed()))
            NBK.blackHole(Y(xyz.reversed()))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testWithReversedCollectionUInt64AsUInt64() {
        var abc = NBK.blackHoleIdentity(X(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X(abc.reversed()))
            NBK.blackHole(X(xyz.reversed()))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testWithUnsafeBufferPointerUInt32AsUInt32() {
        var abc = NBK.blackHoleIdentity(Y(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(Y(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(abc.withUnsafeBufferPointer(Y.init))
            NBK.blackHole(xyz.withUnsafeBufferPointer(Y.init))
                        
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testWithUnsafeBufferPointerUInt64AsUInt64() {
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

//*============================================================================*
// MARK: * NBK x Chunked Int x Reordering
//*============================================================================*

final class NBKChunkedIntBenchmarksByReordering: XCTestCase {
    
    typealias T = NBKChunkedInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    // NOTE: Makes arrays from lazily reversed inputs and outputs.
    //=------------------------------------------------------------------------=
    
    func testUInt32AsUInt32() {
        var abc = NBK.blackHoleIdentity(Y(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(Y(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(Y(T(abc.reversed()).reversed()))
            NBK.blackHole(Y(T(xyz.reversed()).reversed()))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt32AsUInt64() {
        var abc = NBK.blackHoleIdentity(Y(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(Y(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X(T(abc.reversed()).reversed()))
            NBK.blackHole(X(T(xyz.reversed()).reversed()))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt64AsUInt32() {
        var abc = NBK.blackHoleIdentity(X(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(Y(T(abc.reversed()).reversed()))
            NBK.blackHole(Y(T(xyz.reversed()).reversed()))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt64AsUInt64() {
        var abc = NBK.blackHoleIdentity(X(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X(T(abc.reversed()).reversed()))
            NBK.blackHole(X(T(xyz.reversed()).reversed()))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
