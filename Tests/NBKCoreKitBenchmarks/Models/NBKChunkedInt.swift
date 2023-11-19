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

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Chunked Int
//*============================================================================*

final class NBKChunkedIntBenchmarks: XCTestCase {
    
    typealias T = NBKChunkedInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testUInt32AsUInt32() {
        var abc = NBK.blackHoleIdentity(X32(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X32(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X32(T(abc)))
            NBK.blackHole(X32(T(xyz)))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt32AsUInt64() {
        var abc = NBK.blackHoleIdentity(X32(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X32(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X64(T(abc)))
            NBK.blackHole(X64(T(xyz)))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt64AsUInt32() {
        var abc = NBK.blackHoleIdentity(X64(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X64(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X32(T(abc)))
            NBK.blackHole(X32(T(xyz)))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt64AsUInt64() {
        var abc = NBK.blackHoleIdentity(X64(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X64(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X64(T(abc)))
            NBK.blackHole(X64(T(xyz)))
            
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
        var abc = NBK.blackHoleIdentity(X32(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X32(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X32(abc.reversed()))
            NBK.blackHole(X32(xyz.reversed()))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testWithReversedCollectionUInt64AsUInt64() {
        var abc = NBK.blackHoleIdentity(X64(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X64(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X64(abc.reversed()))
            NBK.blackHole(X64(xyz.reversed()))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testWithUnsafeBufferPointerUInt32AsUInt32() {
        var abc = NBK.blackHoleIdentity(X32(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X32(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(abc.withUnsafeBufferPointer(X32.init))
            NBK.blackHole(xyz.withUnsafeBufferPointer(X32.init))
                        
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testWithUnsafeBufferPointerUInt64AsUInt64() {
        var abc = NBK.blackHoleIdentity(X64(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X64(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(abc.withUnsafeBufferPointer(X64.init))
            NBK.blackHole(xyz.withUnsafeBufferPointer(X64.init))
            
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
        var abc = NBK.blackHoleIdentity(X32(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X32(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X32(T(abc.reversed()).reversed()))
            NBK.blackHole(X32(T(xyz.reversed()).reversed()))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt32AsUInt64() {
        var abc = NBK.blackHoleIdentity(X32(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X32(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X64(T(abc.reversed()).reversed()))
            NBK.blackHole(X64(T(xyz.reversed()).reversed()))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt64AsUInt32() {
        var abc = NBK.blackHoleIdentity(X64(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X64(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X32(T(abc.reversed()).reversed()))
            NBK.blackHole(X32(T(xyz.reversed()).reversed()))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testUInt64AsUInt64() {
        var abc = NBK.blackHoleIdentity(X64(repeating: .min, count: 144))
        var xyz = NBK.blackHoleIdentity(X64(repeating: .max, count: 144))
        
        for _ in 0 ..< 144_000 {
            NBK.blackHole(X64(T(abc.reversed()).reversed()))
            NBK.blackHole(X64(T(xyz.reversed()).reversed()))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
