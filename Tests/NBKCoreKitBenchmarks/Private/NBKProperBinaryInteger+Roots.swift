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
// MARK: * NBK x Proper Binary Integer x Roots
//*============================================================================*

final class NBKProperBinaryIntegerBenchmarksOnRoots: XCTestCase {
    
    typealias T = NBK.PBI
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testSquareRootAsInt32() {
        var power = NBK.blackHoleIdentity(Int32.max)

        for _ in 0 ... 5_000_000 {
            NBK.blackHole(T.squareRootByNewtonsMethod(of: power))
            NBK.blackHoleInoutIdentity(&power)
        }
    }
    
    func testSquareRootAsInt64() {
        var power = NBK.blackHoleIdentity(Int64.max)

        for _ in 0 ... 5_000_000 {
            NBK.blackHole(T.squareRootByNewtonsMethod(of: power))
            NBK.blackHoleInoutIdentity(&power)
        }
    }
    
    func testSquareRootAsUInt32() {
        var power = NBK.blackHoleIdentity(UInt32.max)
        
        for _ in 0 ... 5_000_000 {
            NBK.blackHole(T.squareRootByNewtonsMethod(of: power))
            NBK.blackHoleInoutIdentity(&power)
        }
    }
    
    func testSquareRootAsUInt64() {
        var power = NBK.blackHoleIdentity(UInt64.max)
        
        for _ in 0 ... 5_000_000 {
            NBK.blackHole(T.squareRootByNewtonsMethod(of: power))
            NBK.blackHoleInoutIdentity(&power)
        }
    }
}

#endif
