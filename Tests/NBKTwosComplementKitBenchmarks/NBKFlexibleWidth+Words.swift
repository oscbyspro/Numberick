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
// MARK: * NBK x Flexible Width x Words x IntXL
//*============================================================================*

final class NBKFlexibleWidthBenchmarksOnWordsAsIntXL: XCTestCase {
    
    typealias T = IntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromWords() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0] as W)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0] as W)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(words: abc))
            NBK.blackHole(T(words: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x UIntXL
//*============================================================================*

final class NBKFlexibleWidthBenchmarksOnWordsAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromWords() {
        var abc = NBK.blackHoleIdentity([ 0,  0,  0,  0] as W)
        var xyz = NBK.blackHoleIdentity([~0, ~0, ~0, ~0] as W)
        
        for _ in 0 ..< 250_000 {
            NBK.blackHole(T(words: abc))
            NBK.blackHole(T(words: xyz))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
