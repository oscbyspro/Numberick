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

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

//*============================================================================*
// MARK: * NBK x Succinct Int
//*============================================================================*

final class NBKSuccinctIntBenchmarks: XCTestCase {
    
    typealias T = NBK.SuccinctInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromStrictSignedInteger() {
        var abc = NBK.blackHoleIdentity([ 1,  0,  2,  0,  3,  0,  4,  0] as X)
        var xyz = NBK.blackHoleIdentity([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as X)
        
        for _ in 0 ..< 5_000_000 {
            abc.withUnsafeBufferPointer { abc in
            xyz.withUnsafeBufferPointer { xyz in
                NBK.blackHole(T(fromStrictSignedIntegerSubSequence: abc)!)
                NBK.blackHole(T(fromStrictSignedIntegerSubSequence: xyz)!)
            }}
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
    
    func testFromStrictUnsignedIntegerSubSequence() {
        var abc = NBK.blackHoleIdentity([ 1,  0,  2,  0,  3,  0,  4,  0] as X)
        var xyz = NBK.blackHoleIdentity([~1, ~0, ~2, ~0, ~3, ~0, ~4, ~0] as X)
        
        for _ in 0 ..< 5_000_000 {
            abc.withUnsafeBufferPointer { abc in
            xyz.withUnsafeBufferPointer { xyz in
                NBK.blackHole(T(fromStrictUnsignedIntegerSubSequence: abc))
                NBK.blackHole(T(fromStrictUnsignedIntegerSubSequence: xyz))
            }}
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
