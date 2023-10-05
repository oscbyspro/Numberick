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
import NBKFlexibleWidthKit
import NBKSignedKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Signed x Complements x SIntXL
//*============================================================================*

final class NBKSignedBenchmarksOnComplementsAsSIntXL: XCTestCase {
    
    typealias T = NBKSigned<UIntXL>
    typealias M = NBKSigned<UIntXL>.Magnitude
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Magnitude
    //=------------------------------------------------------------------------=
    
    func testMagnitude() {
        var abc = NBK.blackHoleIdentity(T(M(x64:[ 1,  2,  3,  4] as X)))
        var xyz = NBK.blackHoleIdentity(T(M(x64:[~1, ~2, ~3, ~4] as X)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(abc.magnitude)
            NBK.blackHole(xyz.magnitude)
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
