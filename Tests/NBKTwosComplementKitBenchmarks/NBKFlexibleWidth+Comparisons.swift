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
import NBKTwosComplementKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Comparisons x IntXL
//*============================================================================*

final class NBKFlexibleWidthBenchmarksOnComparisonsAsIntXL: XCTestCase {
    
    typealias T = IntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsZero() {
        var abc = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isZero)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testIsLessThanZero() {
        var abc = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isLessThanZero)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testIsMoreThanZero() {
        var abc = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isMoreThanZero)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testIsPowerOf2() {
        var abc = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isPowerOf2)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testSignum() {
        var abc = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.signum())
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsEqualTo() {
        var lhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        var rhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs == rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testIsLessThan() {
        var lhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        var rhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs < rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testComparedTo() {
        var lhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        var rhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.compared(to: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testComparedToAtIndex() {
        var lhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        var rhs = NBK.blackHoleIdentity(T(x64:[1, 2, 3, 0] as X))
        let xyz = NBK.blackHoleIdentity(1 as Int)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.compared(to: rhs, at: xyz))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testComparedToDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        var rhs = NBK.blackHoleIdentity(Int.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.compared(to: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testComparedToDigitAtIndex() {
        var lhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        var rhs = NBK.blackHoleIdentity(3 as Int)
        let xyz = NBK.blackHoleIdentity(3 as Int)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.compared(to: rhs, at: xyz))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Comparisons x UIntXL
//*============================================================================*

final class NBKFlexibleWidthBenchmarksOnComparisonsAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsZero() {
        var abc = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isZero)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testIsLessThanZero() {
        var abc = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isLessThanZero)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testIsMoreThanZero() {
        var abc = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isMoreThanZero)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testIsPowerOf2() {
        var abc = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isPowerOf2)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testSignum() {
        var abc = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.signum())
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsEqualTo() {
        var lhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        var rhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs == rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testIsLessThan() {
        var lhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        var rhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs < rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testComparedTo() {
        var lhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        var rhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.compared(to: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testComparedToAtIndex() {
        var lhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        var rhs = NBK.blackHoleIdentity(T(x64:[1, 2, 3, 0] as X))
        let xyz = NBK.blackHoleIdentity(1 as Int)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.compared(to: rhs, at: xyz))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testComparedToDigit() {
        var lhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        var rhs = NBK.blackHoleIdentity(UInt.max)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.compared(to: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testComparedToDigitAtIndex() {
        var lhs = NBK.blackHoleIdentity(T(x64:[0, 1, 2, 3] as X))
        var rhs = NBK.blackHoleIdentity(UInt( 3))
        let xyz = NBK.blackHoleIdentity(3 as Int)
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.compared(to: rhs, at: xyz))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
}

#endif
