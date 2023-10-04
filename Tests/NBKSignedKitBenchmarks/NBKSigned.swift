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

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Signed x SIntXL
//*============================================================================*

final class NBKSignedBenchmarksAsSIntXL: XCTestCase {
    
    typealias T = NBKSigned<UIntXL>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInit() {
        var abc = NBK.blackHoleIdentity(SM(sign: .plus,  magnitude: UIntXL(1)))
        var xyz = NBK.blackHoleIdentity(SM(sign: .minus, magnitude: UIntXL(1)))
        
        for _ in 0 ..< 5_000_000 {
            NBK.blackHole(T(sign: abc.sign, magnitude: abc.magnitude))
            NBK.blackHole(T(sign: xyz.sign, magnitude: xyz.magnitude))
            
            NBK.blackHoleInoutIdentity(&abc)
            NBK.blackHoleInoutIdentity(&xyz)
        }
    }
}

#endif
