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
// MARK: * NBK x Flexible Width x Subtraction x UIntXL
//*============================================================================*

final class NBKFlexibleWidthBenchmarksOnSubtractionAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtract() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(T(x64:[ 0,  1,  2,  3] as X64))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs -= rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtracting() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(T(x64:[ 0,  1,  2,  3] as X64))
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs - rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Digit
    //=------------------------------------------------------------------------=
    
    func testSubtractDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs -= rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64:[~0, ~1, ~2, ~3] as X64))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs - rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
