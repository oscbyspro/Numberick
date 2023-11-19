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
import NBKFlexibleWidthKit
import XCTest

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Complements x UIntXL
//*============================================================================*

final class NBKFlexibleWidthBenchmarksOnComplementsAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        var abc = NBK.blackHoleIdentity( T(x64:[0, 0, 0, 0] as X64))
        var xyz = NBK.blackHoleIdentity(~T(x64:[0, 0, 0, 0] as X64))
        
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
        var abc = NBK.blackHoleIdentity( T(x64:[0, 0, 0, 0] as X64))
        var xyz = NBK.blackHoleIdentity(~T(x64:[0, 0, 0, 0] as X64))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(abc.onesComplement())
            NBK.blackHole(xyz.onesComplement())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testOnesComplementInout() {
        var abc = NBK.blackHoleIdentity( T(x64:[0, 0, 0, 0] as X64))
        var xyz = NBK.blackHoleIdentity(~T(x64:[0, 0, 0, 0] as X64))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.formOnesComplement())
            NBK.blackHole(xyz.formOnesComplement())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Two's Complement
    //=------------------------------------------------------------------------=
    
    func testTwosComplement() {
        var abc = NBK.blackHoleIdentity( T(x64:[0, 0, 0, 0] as X64))
        var xyz = NBK.blackHoleIdentity(~T(x64:[0, 0, 0, 0] as X64))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(abc.twosComplement())
            NBK.blackHole(xyz.twosComplement())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTwosComplementInout() {
        var abc = NBK.blackHoleIdentity( T(x64:[0, 0, 0, 0] as X64))
        var xyz = NBK.blackHoleIdentity(~T(x64:[0, 0, 0, 0] as X64))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.formTwosComplement())
            NBK.blackHole(xyz.formTwosComplement())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTwosComplementReportingOverflow() {
        var abc = NBK.blackHoleIdentity( T(x64:[0, 0, 0, 0] as X64))
        var xyz = NBK.blackHoleIdentity(~T(x64:[0, 0, 0, 0] as X64))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(abc.twosComplementReportingOverflow())
            NBK.blackHole(xyz.twosComplementReportingOverflow())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    
    func testTwosComplementReportingOverflowInout() {
        var abc = NBK.blackHoleIdentity( T(x64:[0, 0, 0, 0] as X64))
        var xyz = NBK.blackHoleIdentity(~T(x64:[0, 0, 0, 0] as X64))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.formTwosComplementReportingOverflow())
            NBK.blackHole(xyz.formTwosComplementReportingOverflow())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTwosComplementSubsequence() {
        var abc = NBK.blackHoleIdentity( T(x64:[0, 0, 0, 0] as X64))
        var xyz = NBK.blackHoleIdentity(~T(x64:[0, 0, 0, 0] as X64))
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(abc.twosComplementSubsequence(true))
            NBK.blackHole(xyz.twosComplementSubsequence(true))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testTwosComplementSubsequenceInout() {
        var abc = NBK.blackHoleIdentity( T(x64:[0, 0, 0, 0] as X64))
        var xyz = NBK.blackHoleIdentity(~T(x64:[0, 0, 0, 0] as X64))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.formTwosComplementSubsequence(true))
            NBK.blackHole(xyz.formTwosComplementSubsequence(true))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
