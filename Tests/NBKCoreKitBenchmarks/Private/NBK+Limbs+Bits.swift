//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !DEBUG

import XCTest
#if !COCOAPODS
import NBKCoreKit
#else
import Numberick
#endif

//*============================================================================*
// MARK: * NBK x Limbs x Bits
//*============================================================================*

final class NBKBenchmarksOnLimbsByBits: XCTestCase {
    
    private typealias U64 = [UInt64]
    private typealias U32 = [UInt32]
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testLeadingZeroBitCount() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0,  0,  0,  0,  0] as U64)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as U64)
                
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.leadingZeroBitCount(of: abc))
            NBK.blackHole(NBK.leadingZeroBitCount(of: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTrailingZeroBitCount() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0,  0,  0,  0,  0] as U64)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as U64)
                
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.trailingZeroBitCount(of: abc))
            NBK.blackHole(NBK.trailingZeroBitCount(of: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testMostSignificantBitTwosComplementOf() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0,  0,  0,  0,  0] as U64)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as U64)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.mostSignificantBit(twosComplementOf: abc)!)
            NBK.blackHole(NBK.mostSignificantBit(twosComplementOf: xyz)!)
            
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
            NBK.blackHole(NBK.nonzeroBitCount(of: abc))
            NBK.blackHole(NBK.nonzeroBitCount(of: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testNonzeroBitCountEquals() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0,  0,  0,  0,  0] as U64)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as U64)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.nonzeroBitCount(of: abc, equals: 1))
            NBK.blackHole(NBK.nonzeroBitCount(of: xyz, equals: 1))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testNonzeroBitCountTwosComplementOf() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0,  0,  0,  0,  0] as U64)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0, ~0, ~0, ~0, ~0] as U64)

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(NBK.nonzeroBitCount(twosComplementOf: abc))
            NBK.blackHole(NBK.nonzeroBitCount(twosComplementOf: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
