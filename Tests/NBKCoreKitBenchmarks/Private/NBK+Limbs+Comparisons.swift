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
// MARK: * NBK x Limbs x Comparisons
//*============================================================================*

final class NBKBenchmarksOnLimbsByComparisons: XCTestCase {
 
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testCompareStrictSignedInteger() {
        var lhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var rhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var xyz = NBK.blackHoleIdentity((1) as Int)
        
        for _ in 0 ..< 2_500_000 {
            lhs.withUnsafeBufferPointer { lhs in
            rhs.withUnsafeBufferPointer { rhs in
                NBK.blackHole(NBK.compareStrictSignedInteger(lhs, to: rhs))
            }}
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testCompareStrictSignedIntegerAtIndex() {
        var lhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var rhs = NBK.blackHoleIdentity([2, 3, 4, 0] as W)
        var xyz = NBK.blackHoleIdentity((1) as Int)
        
        for _ in 0 ..< 2_500_000 {
            lhs.withUnsafeBufferPointer { lhs in
            rhs.withUnsafeBufferPointer { rhs in
                NBK.blackHole(NBK.compareStrictSignedInteger(lhs, to: rhs, at: xyz))
            }}
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testCompareLenientUnsignedInteger() {
        var lhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var rhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var xyz = NBK.blackHoleIdentity((1) as Int)
        
        for _ in 0 ..< 2_500_000 {
            lhs.withUnsafeBufferPointer { lhs in
            rhs.withUnsafeBufferPointer { rhs in
                NBK.blackHole(NBK.compareLenientUnsignedInteger(lhs, to: rhs))
            }}
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testCompareLenientUnsignedIntegerAtIndex() {
        var lhs = NBK.blackHoleIdentity([1, 2, 3, 4] as W)
        var rhs = NBK.blackHoleIdentity([2, 3, 4, 0] as W)
        var xyz = NBK.blackHoleIdentity((1) as Int)
        
        for _ in 0 ..< 2_500_000 {
            lhs.withUnsafeBufferPointer { lhs in
            rhs.withUnsafeBufferPointer { rhs in
                NBK.blackHole(NBK.compareLenientUnsignedInteger(lhs, to: rhs, at: xyz))
            }}
            
            NBK.blackHoleInoutIdentity(&lhs)
            NBK.blackHoleInoutIdentity(&rhs)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
