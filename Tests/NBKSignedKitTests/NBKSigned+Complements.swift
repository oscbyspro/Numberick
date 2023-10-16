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
import NBKFlexibleWidthKit
import NBKSignedKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Signed x Complements x Open Source Issues
//*============================================================================*

final class NBKSignedTestsOnComplementsOpenSourceIssues: XCTestCase {
    
    typealias SIntXL = NBKSigned<UIntXL>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    /// https://github.com/apple/swift-numerics/pull/252
    ///
    /// - Note: Said to return incorrect values.
    ///
    func testSwiftNumericsPull252() {
        XCTAssertEqual(SIntXL(Int.min          ).magnitude, UIntXL(Int.min.magnitude))
        XCTAssertEqual(SIntXL(Int.min.magnitude).magnitude, UIntXL(Int.min.magnitude))
    }
}

#endif
