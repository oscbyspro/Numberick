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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Maybe Two's Complement
//*============================================================================*

final class NBKMaybeTwosComplementBenchmarks: XCTestCase {
    
    typealias T = NBK.MaybeTwosComplement
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testArray() {
        var abc = NBK.blackHoleIdentity(W(repeating: 144, count: 144))
        var xyz = NBK.blackHoleIdentity(W(repeating: 144, count: 144))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(abc.reduce(0, &+))
            NBK.blackHole(xyz.reduce(0, &+))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testMaybeTwosComplement() {
        var abc = NBK.blackHoleIdentity(T(W(repeating: 144, count: 144), formTwosComplement: true ))
        var xyz = NBK.blackHoleIdentity(T(W(repeating: 144, count: 144), formTwosComplement: false))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(abc.reduce(0, &+))
            NBK.blackHole(xyz.reduce(0, &+))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
