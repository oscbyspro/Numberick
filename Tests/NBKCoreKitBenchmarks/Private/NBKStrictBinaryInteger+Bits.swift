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
// MARK: * NBK x Strict Binary Integer x Bits x Sub Sequence
//*============================================================================*

final class NBKStrictBinaryIntegerBenchmarksOnBitsAsSubSequence: XCTestCase {
    
    private typealias U64 = [UInt64]
    private typealias U32 = [UInt32]
    
    private typealias T64 = NBK.StrictBinaryInteger<U64>.SubSequence
    private typealias T32 = NBK.StrictBinaryInteger<U32>.SubSequence
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLeadingZeroBitCount() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0,  0,  0,  0,  0] as U64)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as U64)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T64.leadingZeroBitCount(of: abc))
            NBK.blackHole(T64.leadingZeroBitCount(of: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTrailingZeroBitCount() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0,  0,  0,  0,  0] as U64)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as U64)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T64.trailingZeroBitCount(of: abc))
            NBK.blackHole(T64.trailingZeroBitCount(of: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testMostSignificantBitTwosComplementOf() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0,  0,  0,  0,  0] as U64)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as U64)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T64.mostSignificantBit(twosComplementOf: abc)!)
            NBK.blackHole(T64.mostSignificantBit(twosComplementOf: xyz)!)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Nonzero Bit Count
    //=------------------------------------------------------------------------=
    
    func testNonzeroBitCount() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0,  0,  0,  0,  0] as U64)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as U64)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T64.nonzeroBitCount(of: abc))
            NBK.blackHole(T64.nonzeroBitCount(of: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testNonzeroBitCountEquals() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0,  0,  0,  0,  0] as U64)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as U64)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T64.nonzeroBitCount(of: abc, equals: 1))
            NBK.blackHole(T64.nonzeroBitCount(of: xyz, equals: 1))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testNonzeroBitCountTwosComplementOf() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0,  0,  0,  0,  0] as U64)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as U64)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T64.nonzeroBitCount(twosComplementOf: abc))
            NBK.blackHole(T64.nonzeroBitCount(twosComplementOf: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
