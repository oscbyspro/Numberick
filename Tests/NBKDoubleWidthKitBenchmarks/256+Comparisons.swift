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
// MARK: * NBK x Int256 x Comparisons
//*============================================================================*

final class Int256BenchmarksOnComparisons: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsEqualTo() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs == rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testIsLessThan() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs < rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testComparedTo() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.compared(to: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsZero() {
        var abc = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isZero)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testIsLessThanZero() {
        var abc = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isLessThanZero)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testIsMoreThanZero() {
        var abc = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isMoreThanZero)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testIsPowerOf2() {
        var abc = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isPowerOf2)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
}

//*============================================================================*
// MARK: * NBK x UInt256 x Comparisons
//*============================================================================*

final class UInt256BenchmarksOnComparisons: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsEqualTo() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs == rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testIsLessThan() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs < rhs)
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    func testComparedTo() {
        var lhs = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        var rhs = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(lhs.compared(to: rhs))
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testIsZero() {
        var abc = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isZero)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testIsLessThanZero() {
        var abc = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isLessThanZero)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testIsMoreThanZero() {
        var abc = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isMoreThanZero)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
    
    func testIsPowerOf2() {
        var abc = NBK.blackHoleIdentity(T(x64: X(0, 1, 2, 3)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.isPowerOf2)
            NBK.blackHoleInoutIdentity(&abc)
        }
    }
}

#endif
