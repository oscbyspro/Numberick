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
// MARK: * NBK x Double Width x Complements x Int256
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
final class NBKDoubleWidthBenchmarksOnComplementsAsInt256: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Pattern
    //=------------------------------------------------------------------------=
    
    func testToBitPattern() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.bitPattern)
            NBK.blackHole(xyz.bitPattern)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testFromBitPattern() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T(bitPattern: abc))
            NBK.blackHole(T(bitPattern: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.magnitude)
            NBK.blackHole(xyz.magnitude)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x One's Complement
    //=------------------------------------------------------------------------=
    
    func testOnesComplement() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.onesComplement())
            NBK.blackHole(xyz.onesComplement())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.twosComplement())
            NBK.blackHole(xyz.twosComplement())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTwosComplementReportingOverflow() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.twosComplementReportingOverflow())
            NBK.blackHole(xyz.twosComplementReportingOverflow())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTwosComplementSubsequence() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.twosComplementSubsequence(true))
            NBK.blackHole(xyz.twosComplementSubsequence(true))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Additive Inverse
    //=------------------------------------------------------------------------=
    
    func testAdditiveInverse() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.negated())
            NBK.blackHole(xyz.negated())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testAdditiveInverseReportingOverflow() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.negatedReportingOverflow())
            NBK.blackHole(xyz.negatedReportingOverflow())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Complements x UInt256
//*============================================================================*

#if SBI && swift(>=5.8)
@available(iOS 16.4, macCatalyst 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
#endif
final class NBKDoubleWidthBenchmarksOnComplementsAsUInt256: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Pattern
    //=------------------------------------------------------------------------=
    
    func testToBitPattern() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.bitPattern)
            NBK.blackHole(xyz.bitPattern)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testFromBitPattern() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T(bitPattern: abc))
            NBK.blackHole(T(bitPattern: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.magnitude)
            NBK.blackHole(xyz.magnitude)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x One's Complement
    //=------------------------------------------------------------------------=
    
    func testOnesComplement() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.onesComplement())
            NBK.blackHole(xyz.onesComplement())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.twosComplement())
            NBK.blackHole(xyz.twosComplement())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTwosComplementReportingOverflow() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.twosComplementReportingOverflow())
            NBK.blackHole(xyz.twosComplementReportingOverflow())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTwosComplementSubsequence() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.twosComplementSubsequence(true))
            NBK.blackHole(xyz.twosComplementSubsequence(true))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
