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
// MARK: * NBK x Int x Bits
//*============================================================================*

final class IntBenchmarksOnBits: XCTestCase {
    
    typealias T =  Int
    typealias M = UInt
    
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
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.bitWidth)
            NBK.blackHole(xyz.bitWidth)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testNonzeroBitCount() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.nonzeroBitCount)
            NBK.blackHole(xyz.nonzeroBitCount)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testLeadingZeroBitCount() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.leadingZeroBitCount)
            NBK.blackHole(xyz.leadingZeroBitCount)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTrailingZeroBitCount() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.trailingZeroBitCount)
            NBK.blackHole(xyz.trailingZeroBitCount)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testMostSignificantBit() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.mostSignificantBit)
            NBK.blackHole(xyz.mostSignificantBit)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testLeastSignificantBit() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.leastSignificantBit)
            NBK.blackHole(xyz.leastSignificantBit)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Get, Set, Clear, Toggle
    //=------------------------------------------------------------------------=
    
    func testGetBit() {
        var lhs = NBK.blackHoleIdentity(T.max)
        var rhs = NBK.blackHoleIdentity(T.bitWidth * 2/3)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.get(bit: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSetBit() {
        var lhs = NBK.blackHoleIdentity(T.max)
        var rhs = NBK.blackHoleIdentity(T.bitWidth * 2/3)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.set(bit: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testClearBit() {
        var lhs = NBK.blackHoleIdentity(T.max)
        var rhs = NBK.blackHoleIdentity(T.bitWidth * 2/3)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.clear(bit: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testToggleBit() {
        var lhs = NBK.blackHoleIdentity(T.max)
        var rhs = NBK.blackHoleIdentity(T.bitWidth * 2/3)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.toggle(bit: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt x Bits
//*============================================================================*

final class UIntBenchmarksOnBits: XCTestCase {
    
    typealias T = UInt
    typealias M = UInt
    
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
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.bitWidth)
            NBK.blackHole(xyz.bitWidth)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testNonzeroBitCount() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.nonzeroBitCount)
            NBK.blackHole(xyz.nonzeroBitCount)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testLeadingZeroBitCount() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.leadingZeroBitCount)
            NBK.blackHole(xyz.leadingZeroBitCount)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTrailingZeroBitCount() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.trailingZeroBitCount)
            NBK.blackHole(xyz.trailingZeroBitCount)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testMostSignificantBit() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.mostSignificantBit)
            NBK.blackHole(xyz.mostSignificantBit)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testLeastSignificantBit() {
        var abc = NBK.blackHoleIdentity( T(123))
        var xyz = NBK.blackHoleIdentity(~T(123))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.leastSignificantBit)
            NBK.blackHole(xyz.leastSignificantBit)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Get, Set, Clear, Toggle
    //=------------------------------------------------------------------------=
    
    func testGetBit() {
        var lhs = NBK.blackHoleIdentity(T.max)
        var rhs = NBK.blackHoleIdentity(T.bitWidth * 2/3)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.get(bit: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSetBit() {
        var lhs = NBK.blackHoleIdentity(T.max)
        var rhs = NBK.blackHoleIdentity(T.bitWidth * 2/3)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.set(bit: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testClearBit() {
        var lhs = NBK.blackHoleIdentity(T.max)
        var rhs = NBK.blackHoleIdentity(T.bitWidth * 2/3)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.clear(bit: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testToggleBit() {
        var lhs = NBK.blackHoleIdentity(T.max)
        var rhs = NBK.blackHoleIdentity(T.bitWidth * 2/3)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.toggle(bit: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
