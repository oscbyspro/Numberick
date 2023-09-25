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

//*============================================================================*
// MARK: * NBK x Core Integer x Words
//*============================================================================*

final class NBKCoreIntegerBenchmarksOnWords: XCTestCase {
    
    typealias T =  Int
    typealias M = UInt
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInt32FromWords() {
        var x0 = NBK.blackHoleIdentity([1   ] as [UInt])
        var x1 = NBK.blackHoleIdentity([1, 2] as [UInt])
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(Int32(words: x0))
            NBK.blackHole(Int32(words: x1))

            NBK.blackHoleInoutIdentity(&x0)
            NBK.blackHoleInoutIdentity(&x1)
        }
    }
    
    func testInt64FromWords() {
        var x0 = NBK.blackHoleIdentity([1   ] as [UInt])
        var x1 = NBK.blackHoleIdentity([1, 2] as [UInt])
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(Int64(words: x0))
            NBK.blackHole(Int64(words: x1))

            NBK.blackHoleInoutIdentity(&x0)
            NBK.blackHoleInoutIdentity(&x1)
        }
    }
    
    func testUInt32FromWords() {
        var x0 = NBK.blackHoleIdentity([1   ] as [UInt])
        var x1 = NBK.blackHoleIdentity([1, 2] as [UInt])
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(UInt32(words: x0))
            NBK.blackHole(UInt32(words: x1))

            NBK.blackHoleInoutIdentity(&x0)
            NBK.blackHoleInoutIdentity(&x1)
        }
    }
    
    func testUInt64FromWords() {
        var x0 = NBK.blackHoleIdentity([1   ] as [UInt])
        var x1 = NBK.blackHoleIdentity([1, 2] as [UInt])
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(UInt64(words: x0))
            NBK.blackHole(UInt64(words: x1))

            NBK.blackHoleInoutIdentity(&x0)
            NBK.blackHoleInoutIdentity(&x1)
        }
    }
}

#endif
