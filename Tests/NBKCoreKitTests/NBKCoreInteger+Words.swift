//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Core Integer x Words
//*============================================================================*

final class NBKCoreIntegerTestsOnWords: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWordsHaveIndicesFromZeroToCount() {
        func whereIs(_ integer: some BinaryInteger) {
            XCTAssertEqual(integer.words.startIndex, 0 as Int)
            XCTAssertEqual(integer.words.endIndex, integer.words.count)
        }
        
        for type: T in types {
            whereIs(type.min)
            whereIs(type.max)
        }
    }
}

#endif
