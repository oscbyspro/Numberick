//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if !DEBUG

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * Int256 x Bits
//*============================================================================*

final class Int256BenchmarksOnBits: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        var abc = _blackHoleIdentity(true )
        var xyz = _blackHoleIdentity(false)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(bit: abc))
            _blackHole(T(bit: xyz))
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testInitRepeatingBit() {
        var abc = _blackHoleIdentity(true )
        var xyz = _blackHoleIdentity(false)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(repeating: abc))
            _blackHole(T(repeating: xyz))
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testBitWidth() {
        var abc = _blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = _blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(abc.bitWidth)
            _blackHole(xyz.bitWidth)
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testNonzeroBitCount() {
        var abc = _blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = _blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(abc.nonzeroBitCount)
            _blackHole(xyz.nonzeroBitCount)
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testLeadingZeroBitCount() {
        var abc = _blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = _blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(abc.leadingZeroBitCount)
            _blackHole(xyz.leadingZeroBitCount)
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTrailingZeroBitCount() {
        var abc = _blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = _blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(abc.trailingZeroBitCount)
            _blackHole(xyz.trailingZeroBitCount)
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testMostSignificantBit() {
        var abc = _blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = _blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(abc.mostSignificantBit)
            _blackHole(xyz.mostSignificantBit)
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testLeastSignificantBit() {
        var abc = _blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = _blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(abc.leastSignificantBit)
            _blackHole(xyz.leastSignificantBit)
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
}

//*============================================================================*
// MARK: * UInt256 x Bits
//*============================================================================*

final class UInt256BenchmarksOnBits: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitBit() {
        var abc = _blackHoleIdentity(true )
        var xyz = _blackHoleIdentity(false)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(bit: abc))
            _blackHole(T(bit: xyz))
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testInitRepeatingBit() {
        var abc = _blackHoleIdentity(true )
        var xyz = _blackHoleIdentity(false)
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(T(repeating: abc))
            _blackHole(T(repeating: xyz))
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testBitWidth() {
        var abc = _blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = _blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(abc.bitWidth)
            _blackHole(xyz.bitWidth)
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testNonzeroBitCount() {
        var abc = _blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = _blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(abc.nonzeroBitCount)
            _blackHole(xyz.nonzeroBitCount)
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testLeadingZeroBitCount() {
        var abc = _blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = _blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(abc.leadingZeroBitCount)
            _blackHole(xyz.leadingZeroBitCount)
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTrailingZeroBitCount() {
        var abc = _blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = _blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(abc.trailingZeroBitCount)
            _blackHole(xyz.trailingZeroBitCount)
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testMostSignificantBit() {
        var abc = _blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = _blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(abc.mostSignificantBit)
            _blackHole(xyz.mostSignificantBit)
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testLeastSignificantBit() {
        var abc = _blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = _blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            _blackHole(abc.leastSignificantBit)
            _blackHole(xyz.leastSignificantBit)
            
            _blackHoleInoutIdentity(&abc)
            _blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
