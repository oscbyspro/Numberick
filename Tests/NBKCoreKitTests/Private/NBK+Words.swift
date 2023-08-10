//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

#if DEBUG

import XCTest
#if !COCOAPODS
import NBKCoreKit
#else
import Numberick
#endif

//*============================================================================*
// MARK: * NBK x Words
//*============================================================================*

final class NBKTestsOnWords: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWithUnsafeWordsOfInt() {
        NBKAssertWithUnsafeWordsOf(Int(-4), [~3])
        NBKAssertWithUnsafeWordsOf(Int(-3), [~2])
        NBKAssertWithUnsafeWordsOf(Int(-2), [~1])
        NBKAssertWithUnsafeWordsOf(Int(-1), [~0])
        NBKAssertWithUnsafeWordsOf(Int( 0), [ 0])
        NBKAssertWithUnsafeWordsOf(Int( 1), [ 1])
        NBKAssertWithUnsafeWordsOf(Int( 2), [ 2])
        NBKAssertWithUnsafeWordsOf(Int( 3), [ 3])
    }
    
    func testWithUnsafeWordsOfUInt() {
        NBKAssertWithUnsafeWordsOf(UInt(0), [ 0])
        NBKAssertWithUnsafeWordsOf(UInt(1), [ 1])
        NBKAssertWithUnsafeWordsOf(UInt(2), [ 2])
        NBKAssertWithUnsafeWordsOf(UInt(3), [ 3])
        NBKAssertWithUnsafeWordsOf(UInt(4), [ 4])
        NBKAssertWithUnsafeWordsOf(UInt(5), [ 5])
        NBKAssertWithUnsafeWordsOf(UInt(6), [ 6])
        NBKAssertWithUnsafeWordsOf(UInt(7), [ 7])
    }
}

//*============================================================================*
// MARK: * NBK x Words x Assertions
//*============================================================================*

private func NBKAssertWithUnsafeWordsOf(
_ lhs: some NBKCoreInteger<UInt>, _ rhs: [UInt],
file: StaticString = #file, line: UInt  = #line) {
    NBK.withUnsafeWords(of: lhs) {
        XCTAssertEqual(Array($0), rhs, file: file, line: line)
    }
}

#endif
