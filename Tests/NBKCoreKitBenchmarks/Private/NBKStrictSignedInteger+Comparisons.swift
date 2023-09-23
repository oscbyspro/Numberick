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
// MARK: * NBK x Strict Signed Integer x Comparisons
//*============================================================================*

final class NBKStrictSignedIntegerBenchmarksOnComparisons: XCTestCase {
 
    typealias T = NBK.StrictSignedInteger<UnsafeBufferPointer<UInt>>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCompare() {
        var lhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var rhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var xyz = NBK.blackHoleIdentity((1) as Int)
        
        for _ in 0 ..< 2_500_000 {
            lhs.withUnsafeBufferPointer { lhs in
            rhs.withUnsafeBufferPointer { rhs in
                NBK.blackHole(T.compare(lhs, to: rhs))
            }}
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testCompareAtIndex() {
        var lhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var rhs = NBK.blackHoleIdentity([2, 3, 4, 0] as W)
        var xyz = NBK.blackHoleIdentity((1) as Int)
        
        for _ in 0 ..< 2_500_000 {
            lhs.withUnsafeBufferPointer { lhs in
            rhs.withUnsafeBufferPointer { rhs in
                NBK.blackHole(T.compare(lhs, to: rhs, at: xyz))
            }}
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
