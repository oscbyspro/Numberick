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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Multiplication x UIntXL
//*============================================================================*

final class NBKFlexibleWidthBenchmarksOnMultiplicationAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMultiplying() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~1, ~2, ~3, ~4] as X))
        var rhs = NBK.blackHoleIdentity(T(x64:[ 1,  2,  3,  4] as X))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs * rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testMultiplyingByDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~1, ~2, ~3, ~4] as X))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs * rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Square
    //=------------------------------------------------------------------------=
    
    func testMultiplyingBySquaring() {
        var base = NBK.blackHoleIdentity(T(x64:[~1, ~2, ~3, ~4] as X))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(base.squared())
            NBK.blackHoleInoutIdentity(&base)
            NBK.blackHoleInoutIdentity(&base)
        }
    }
}

#endif
