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
// MARK: * Int256
//*============================================================================*

final class Int256Benchmarks: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitZero() {
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(   ))
            NBK.blackHole(T.zero)
        }
    }
    
    func testInitEdges() {
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T.min )
            NBK.blackHole(T.max )
        }
    }
    
    func testInitComponents() {
        var abc = NBK.blackHoleIdentity(LH( T.Low (), T.High() ))
        var xyz = NBK.blackHoleIdentity(HL( T.High(), T.Low () ))

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(ascending:  abc))
            NBK.blackHole(T(descending: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

//*============================================================================*
// MARK: * UInt256
//*============================================================================*

final class UInt256Benchmarks: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInitZero() {
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T())
            NBK.blackHole(T.zero)
        }
    }
    
    func testInitEdges() {
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T.min )
            NBK.blackHole(T.max )
        }
    }
    
    func testInitComponents() {
        var abc = NBK.blackHoleIdentity(LH( T.Low (), T.High() ))
        var xyz = NBK.blackHoleIdentity(HL( T.High(), T.Low () ))

        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(T(ascending:  abc))
            NBK.blackHole(T(descending: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
