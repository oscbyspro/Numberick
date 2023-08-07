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
// MARK: * NBK x Comparisons
//*============================================================================*

final class NBKBenchmarksOnComparisons: XCTestCase {
 
    //=------------------------------------------------------------------------=
    // MARK: Tests x Words As Binary Integer
    //=------------------------------------------------------------------------=
    
    func testCompareWordsAsSignedInteger() {
        var lhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var rhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var xyz = NBK.blackHoleIdentity((1) as Int)
        
        for _ in 0 ..< 2_500_000 {
            lhs.withUnsafeBufferPointer { lhs in
            rhs.withUnsafeBufferPointer { rhs in
                NBK.blackHole(NBK.compareAsSignedIntegers(lhs, to: rhs))
            }}
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testCompareWordsAsSignedIntegerAtIndex() {
        var lhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var rhs = NBK.blackHoleIdentity([0, 2, 3, 4] as W)
        var xyz = NBK.blackHoleIdentity((1) as Int)
        
        for _ in 0 ..< 2_500_000 {
            lhs.withUnsafeBufferPointer { lhs in
            rhs.withUnsafeBufferPointer { rhs in
                NBK.blackHole(NBK.compareAsSignedIntegers(lhs, to: rhs, at: xyz))
            }}
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testCompareWordsAsUnsignedInteger() {
        var lhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var rhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var xyz = NBK.blackHoleIdentity((1) as Int)
        
        for _ in 0 ..< 2_500_000 {
            lhs.withUnsafeBufferPointer { lhs in
            rhs.withUnsafeBufferPointer { rhs in
                NBK.blackHole(NBK.compareAsUnsignedIntegers(lhs, to: rhs))
            }}
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testCompareWordsAsUnsignedIntegerAtIndex() {
        var lhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var rhs = NBK.blackHoleIdentity([0, 2, 3, 4] as W)
        var xyz = NBK.blackHoleIdentity((1) as Int)
        
        for _ in 0 ..< 2_500_000 {
            lhs.withUnsafeBufferPointer { lhs in
            rhs.withUnsafeBufferPointer { rhs in
                NBK.blackHole(NBK.compareAsUnsignedIntegers(lhs, to: rhs, at: xyz))
            }}
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
