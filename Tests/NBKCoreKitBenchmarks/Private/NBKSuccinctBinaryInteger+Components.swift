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
// MARK: * NBK x Succinct Binary Integer
//*============================================================================*

final class NBKSuccinctBinaryIntegerBenchmarksOnComponents: XCTestCase {
    
    typealias T = NBK.SuccinctBinaryInteger<UnsafeBufferPointer<UInt>>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testMakeComponentsFromStrictSignedInteger() {
        var abc = NBK.blackHoleIdentity([ 1,  0,  2,  0,  3,  0,  4,  0] as W)
        var xyz = NBK.blackHoleIdentity([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as W)
        
        for _ in 0 ..< 5_000_000 {
            abc.withUnsafeBufferPointer { abc in
            xyz.withUnsafeBufferPointer { xyz in
                NBK.blackHole(T.components(fromStrictSignedInteger: abc))
                NBK.blackHole(T.components(fromStrictSignedInteger: xyz))
            }}
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testMakeComponentsFromStrictUnsignedIntegerSubSequence() {
        var abc = NBK.blackHoleIdentity([ 1,  0,  2,  0,  3,  0,  4,  0] as W)
        var xyz = NBK.blackHoleIdentity([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as W)
        
        for _ in 0 ..< 5_000_000 {
            abc.withUnsafeBufferPointer { abc in
            xyz.withUnsafeBufferPointer { xyz in
                NBK.blackHole(T.components(fromStrictUnsignedIntegerSubSequence: abc))
                NBK.blackHole(T.components(fromStrictUnsignedIntegerSubSequence: xyz))
            }}
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
