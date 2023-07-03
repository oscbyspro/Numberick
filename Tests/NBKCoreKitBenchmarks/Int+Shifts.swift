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
// MARK: * NBK x Int x Shifts
//*============================================================================*

final class IntBenchmarksOnShifts: XCTestCase {
    
    typealias T = Int
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitshiftingLeft() {
        var lhs = NBK.blackHoleIdentity(T(123))
        var rhs = NBK.blackHoleIdentity(T.bitWidth / 3)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitshiftedLeft(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRight() {
        var lhs = NBK.blackHoleIdentity(T(123))
        var rhs = NBK.blackHoleIdentity(T.bitWidth / 3)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitshiftedRight(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt x Shifts
//*============================================================================*

final class UIntBenchmarksOnShifts: XCTestCase {
    
    typealias T = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Left
    //=------------------------------------------------------------------------=
    
    func testBitshiftingLeft() {
        var lhs = NBK.blackHoleIdentity(T(123))
        var rhs = NBK.blackHoleIdentity(T.bitWidth / 3)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitshiftedLeft(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Right
    //=------------------------------------------------------------------------=
    
    func testBitshiftingRight() {
        var lhs = NBK.blackHoleIdentity(T(123))
        var rhs = NBK.blackHoleIdentity(T.bitWidth / 3)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.bitshiftedRight(by: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
