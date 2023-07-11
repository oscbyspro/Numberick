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
import XCTest

private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x UIntXL x Logic
//*============================================================================*

final class UIntXLTestsOnLogic: XCTestCase {
    
    typealias T = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testNot() {
        NBKAssertNot(T(words:[ 0,  0,  0,  0] as [UInt]), T(words:[~0,  0,  0,  0] as [UInt]))
        NBKAssertNot(T(words:[~0, ~0, ~0, ~0] as [UInt]), T(words:[ 0,  0,  0,  0] as [UInt]))
        
        NBKAssertNot(T(words:[ 0,  1,  2,  3] as [UInt]), T(words:[~0, ~1, ~2, ~3] as [UInt]))
        NBKAssertNot(T(words:[~0, ~1, ~2, ~3] as [UInt]), T(words:[ 0,  1,  2,  3] as [UInt]))
    }
    
    func testAnd() {
        NBKAssertAnd(T(words:[ 0,  1,  2,  3] as [UInt]), T(words:[ 0,  0,  0,  0] as [UInt]), T(words:[ 0,  0,  0,  0] as [UInt]))
        NBKAssertAnd(T(words:[ 3,  2,  1,  0] as [UInt]), T(words:[ 0,  0,  0,  0] as [UInt]), T(words:[ 0,  0,  0,  0] as [UInt]))
        
        NBKAssertAnd(T(words:[ 0,  1,  2,  3] as [UInt]), T(words:[~0, ~0, ~0, ~0] as [UInt]), T(words:[ 0,  1,  2,  3] as [UInt]))
        NBKAssertAnd(T(words:[ 3,  2,  1,  0] as [UInt]), T(words:[~0, ~0, ~0, ~0] as [UInt]), T(words:[ 3,  2,  1,  0] as [UInt]))
        
        NBKAssertAnd(T(words:[ 0,  1,  2,  3] as [UInt]), T(words:[ 1,  1,  1,  1] as [UInt]), T(words:[ 0,  1,  0,  1] as [UInt]))
        NBKAssertAnd(T(words:[ 3,  2,  1,  0] as [UInt]), T(words:[ 1,  1,  1,  1] as [UInt]), T(words:[ 1,  0,  1,  0] as [UInt]))
    }
    
    func testOr() {
        NBKAssertOr (T(words:[ 0,  1,  2,  3] as [UInt]), T(words:[ 0,  0,  0,  0] as [UInt]), T(words:[ 0,  1,  2,  3] as [UInt]))
        NBKAssertOr (T(words:[ 3,  2,  1,  0] as [UInt]), T(words:[ 0,  0,  0,  0] as [UInt]), T(words:[ 3,  2,  1,  0] as [UInt]))
        
        NBKAssertOr (T(words:[ 0,  1,  2,  3] as [UInt]), T(words:[~0, ~0, ~0, ~0] as [UInt]), T(words:[~0, ~0, ~0, ~0] as [UInt]))
        NBKAssertOr (T(words:[ 3,  2,  1,  0] as [UInt]), T(words:[~0, ~0, ~0, ~0] as [UInt]), T(words:[~0, ~0, ~0, ~0] as [UInt]))
        
        NBKAssertOr (T(words:[ 0,  1,  2,  3] as [UInt]), T(words:[ 1,  1,  1,  1] as [UInt]), T(words:[ 1,  1,  3,  3] as [UInt]))
        NBKAssertOr (T(words:[ 3,  2,  1,  0] as [UInt]), T(words:[ 1,  1,  1,  1] as [UInt]), T(words:[ 3,  3,  1,  1] as [UInt]))
    }
    
    func testXor() {
        NBKAssertXor(T(words:[ 0,  1,  2,  3] as [UInt]), T(words:[ 0,  0,  0,  0] as [UInt]), T(words:[ 0,  1,  2,  3] as [UInt]))
        NBKAssertXor(T(words:[ 3,  2,  1,  0] as [UInt]), T(words:[ 0,  0,  0,  0] as [UInt]), T(words:[ 3,  2,  1,  0] as [UInt]))
        
        NBKAssertXor(T(words:[ 0,  1,  2,  3] as [UInt]), T(words:[~0, ~0, ~0, ~0] as [UInt]), T(words:[~0, ~1, ~2, ~3] as [UInt]))
        NBKAssertXor(T(words:[ 3,  2,  1,  0] as [UInt]), T(words:[~0, ~0, ~0, ~0] as [UInt]), T(words:[~3, ~2, ~1, ~0] as [UInt]))
        
        NBKAssertXor(T(words:[ 0,  1,  2,  3] as [UInt]), T(words:[ 1,  1,  1,  1] as [UInt]), T(words:[ 1,  0,  3,  2] as [UInt]))
        NBKAssertXor(T(words:[ 3,  2,  1,  0] as [UInt]), T(words:[ 1,  1,  1,  1] as [UInt]), T(words:[ 2,  3,  0,  1] as [UInt]))
    }
}

#endif
