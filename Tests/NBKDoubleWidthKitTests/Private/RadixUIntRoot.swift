//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
@testable import NBKDoubleWidthKit
import XCTest

//*============================================================================*
// MARK: * NBK x Radix UInt Root
//*============================================================================*

final class RadixUIntRootTests: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let radices = UInt(2) ... 36
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testTheGeneralCaseAlgorithmAlsoSolvesPowerOf2() {
        for radix in self.radices where radix.isPowerOf2 {
            let general = AnyRadixUIntRoot.rootAssumingRadixIsWhatever(unchecked: radix)
            let special = AnyRadixUIntRoot.rootAssumingRadixIsPowerOf2(unchecked: radix)
            XCTAssert(general == special)
        }
    }
}

#endif
