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
// MARK: * NBK x Endianness
//*============================================================================*

final class NBKEndiannessBenchmarks: XCTestCase {
    
    typealias T = NBKEndianness
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsEqualTo() {
        var abc = NBK.blackHoleIdentity(T.little)
        var xyz = NBK.blackHoleIdentity(T.big   )
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc == T.system)
            NBK.blackHole(xyz == T.system)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testHashValue() {
        var abc = NBK.blackHoleIdentity(T.little)
        var xyz = NBK.blackHoleIdentity(T.big   )
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(abc.hashValue)
            NBK.blackHole(xyz.hashValue)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
