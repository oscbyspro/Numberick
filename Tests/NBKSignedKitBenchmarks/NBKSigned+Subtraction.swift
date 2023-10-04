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
import NBKSignedKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Signed x Subtraction x UIntXL
//*============================================================================*

final class NBKSignedBenchmarksOnSubtractionAsSIntXL: XCTestCase {
    
    typealias T = NBKSigned<UIntXL>
    typealias M = NBKSigned<UIntXL>.Magnitude
    typealias D = NBKSigned<UIntXL>.Digit
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSubtract() {
        var lhs = NBK.blackHoleIdentity(T(M(x64:[~0, ~1, ~2, ~3] as X)))
        var rhs = NBK.blackHoleIdentity(T(M(x64:[ 0,  1,  2,  3] as X)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs -= rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtracting() {
        var lhs = NBK.blackHoleIdentity(T(M(x64:[~0, ~1, ~2, ~3] as X)))
        var rhs = NBK.blackHoleIdentity(T(M(x64:[ 0,  1,  2,  3] as X)))
        
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
        var lhs = NBK.blackHoleIdentity(T(M(x64:[~0, ~1, ~2, ~3] as X)))
        var rhs = NBK.blackHoleIdentity(D.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs -= rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testSubtractingDigit() {
        var lhs = NBK.blackHoleIdentity(T(M(x64:[~0, ~1, ~2, ~3] as X)))
        var rhs = NBK.blackHoleIdentity(D.max)
        
        for _ in 0 ..< 1_000_000 {
            NBK.blackHole(lhs - rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif