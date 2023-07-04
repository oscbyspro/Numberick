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
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Int256 x Bits
//*============================================================================*

final class Int256BenchmarksOnBits: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        var abc = NBK.blackHoleIdentity(true )
        var xyz = NBK.blackHoleIdentity(false)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T(bit: abc))
            NBK.blackHole(T(bit: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testInitRepeatingBit() {
        var abc = NBK.blackHoleIdentity(true )
        var xyz = NBK.blackHoleIdentity(false)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T(repeating: abc))
            NBK.blackHole(T(repeating: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testBitWidth() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.bitWidth)
            NBK.blackHole(xyz.bitWidth)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testNonzeroBitCount() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.nonzeroBitCount)
            NBK.blackHole(xyz.nonzeroBitCount)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testLeadingZeroBitCount() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.leadingZeroBitCount)
            NBK.blackHole(xyz.leadingZeroBitCount)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTrailingZeroBitCount() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.trailingZeroBitCount)
            NBK.blackHole(xyz.trailingZeroBitCount)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testMostSignificantBit() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.mostSignificantBit)
            NBK.blackHole(xyz.mostSignificantBit)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testLeastSignificantBit() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.leastSignificantBit)
            NBK.blackHole(xyz.leastSignificantBit)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Bits
//*============================================================================*

final class UInt256BenchmarksOnBits: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        var abc = NBK.blackHoleIdentity(true )
        var xyz = NBK.blackHoleIdentity(false)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T(bit: abc))
            NBK.blackHole(T(bit: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testInitRepeatingBit() {
        var abc = NBK.blackHoleIdentity(true )
        var xyz = NBK.blackHoleIdentity(false)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T(repeating: abc))
            NBK.blackHole(T(repeating: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testBitWidth() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.bitWidth)
            NBK.blackHole(xyz.bitWidth)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testNonzeroBitCount() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.nonzeroBitCount)
            NBK.blackHole(xyz.nonzeroBitCount)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testLeadingZeroBitCount() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.leadingZeroBitCount)
            NBK.blackHole(xyz.leadingZeroBitCount)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTrailingZeroBitCount() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.trailingZeroBitCount)
            NBK.blackHole(xyz.trailingZeroBitCount)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testMostSignificantBit() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.mostSignificantBit)
            NBK.blackHole(xyz.mostSignificantBit)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testLeastSignificantBit() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.leastSignificantBit)
            NBK.blackHole(xyz.leastSignificantBit)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
