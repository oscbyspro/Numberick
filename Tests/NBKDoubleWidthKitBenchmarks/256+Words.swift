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

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * NBK x Int256 x Words
//*============================================================================*

final class Int256BenchmarksOnWords: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Min Two's Complement
    //=------------------------------------------------------------------------=
    
    func testMinLastIndexReportingIsZeroOrMinusOne() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(abc.minLastIndexReportingIsZeroOrMinusOne())
            NBK.blackHole(xyz.minLastIndexReportingIsZeroOrMinusOne())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Words
//*============================================================================*

final class UInt256BenchmarksOnWords: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Min Two's Complement
    //=------------------------------------------------------------------------=
    
    func testMinLastIndexReportingIsZeroOrMinusOne() {
        var abc = NBK.blackHoleIdentity( T(x64: X(0, 0, 0, 0)))
        var xyz = NBK.blackHoleIdentity(~T(x64: X(0, 0, 0, 0)))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(abc.minLastIndexReportingIsZeroOrMinusOne())
            NBK.blackHole(xyz.minLastIndexReportingIsZeroOrMinusOne())
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
