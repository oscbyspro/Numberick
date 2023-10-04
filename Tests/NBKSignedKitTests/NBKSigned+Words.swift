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
import NBKSignedKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Signed x Words
//*============================================================================*

final class NBKSignedTestsOnWords: XCTestCase {
    
    typealias T = NBKSigned<UInt>
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromWords() {
        NBKAssertFromWordsIsSigned([      ] as W, true,  T(sign: .plus,  magnitude:  0))
        NBKAssertFromWordsIsSigned([      ] as W, false, T(sign: .plus,  magnitude:  0))
        NBKAssertFromWordsIsSigned([ 0    ] as W, true,  T(sign: .plus,  magnitude:  0))
        NBKAssertFromWordsIsSigned([ 0    ] as W, false, T(sign: .plus,  magnitude:  0))
        NBKAssertFromWordsIsSigned([~0    ] as W, true,  T(sign: .minus, magnitude:  1))
        NBKAssertFromWordsIsSigned([~0    ] as W, false, T(sign: .plus,  magnitude: ~0))
        NBKAssertFromWordsIsSigned([~0,  0] as W, true,  T(sign: .plus,  magnitude: ~0))
        NBKAssertFromWordsIsSigned([~0,  0] as W, false, T(sign: .plus,  magnitude: ~0))
        NBKAssertFromWordsIsSigned([ 1, ~0] as W, true,  T(sign: .minus, magnitude: ~0))
        NBKAssertFromWordsIsSigned([ 1, ~0] as W, false, nil as T?)
        
        NBKAssertFromWordsIsSigned(W(repeating:  0, count: 2), true,  000 as T?)
        NBKAssertFromWordsIsSigned(W(repeating:  1, count: 2), true,  nil as T?)
        NBKAssertFromWordsIsSigned(W(repeating: ~0, count: 2), true,  -01 as T?)
        NBKAssertFromWordsIsSigned(W(repeating: ~1, count: 2), true,  nil as T?)
        
        NBKAssertFromWordsIsSigned(W(repeating:  0, count: 2), false, 000 as T?)
        NBKAssertFromWordsIsSigned(W(repeating:  1, count: 2), false, nil as T?)
        NBKAssertFromWordsIsSigned(W(repeating: ~0, count: 2), false, nil as T?)
        NBKAssertFromWordsIsSigned(W(repeating: ~1, count: 2), false, nil as T?)
    }
}

//*============================================================================*
// MARK: * NBK x Signed x Words x Assertions
//*============================================================================*

private func NBKAssertFromWords<M: NBKUnsignedInteger>(
_ words: [UInt], _ integer: NBKSigned<M>?,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBKSigned<M>
    //=------------------------------------------=
    NBKAssertIdentical(                  T(words:    words),    integer, file: file, line: line)
    //NBKAssertIdentical(integer.flatMap({ T(words: $0.words) }), integer, file: file, line: line)
}

private func NBKAssertFromWordsIsSigned<M: NBKUnsignedInteger>(
_ words: [UInt], _ isSigned: Bool, _ integer: NBKSigned<M>?,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBKSigned<M>
    //=------------------------------------------=
    if  isSigned == T.isSigned {
        NBKAssertFromWords(words, integer, file: file, line: line)
    }
    
    NBKAssertIdentical(                  T(words:    words, isSigned: isSigned),    integer, file: file, line: line)
    //NBKAssertIdentical(integer.flatMap({ T(words: $0.words, isSigned: isSigned) }), integer, file: file, line: line)
}

#endif
