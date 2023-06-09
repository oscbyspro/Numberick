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
// MARK: * NBK x Int256
//*============================================================================*

final class Int256Benchmarks: XCTestCase {
    
    typealias T =  Int256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromComponents() {
        var abc = NBK.blackHoleIdentity(LH( T.Low .zero, T.High.zero ))
        var xyz = NBK.blackHoleIdentity(HL( T.High.zero, T.Low .zero ))

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T(ascending:  abc))
            NBK.blackHole(T(descending: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt256
//*============================================================================*

final class UInt256Benchmarks: XCTestCase {
    
    typealias T = UInt256
    typealias M = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromComponents() {
        var abc = NBK.blackHoleIdentity(LH( T.Low .zero, T.High.zero ))
        var xyz = NBK.blackHoleIdentity(HL( T.High.zero, T.Low .zero ))

        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T(ascending:  abc))
            NBK.blackHole(T(descending: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
