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
    
    func testToWords() {
        NBKAssertToWords(T(sign: .plus,  magnitude: ~0/1 - 0), [~0/1 - 0,  0] as W)
        NBKAssertToWords(T(sign: .plus,  magnitude: ~0/1 - 1), [~0/1 - 1,  0] as W)
        NBKAssertToWords(T(sign: .minus, magnitude: ~0/1 - 0), [ 0/1 + 1, ~0] as W)
        NBKAssertToWords(T(sign: .minus, magnitude: ~0/1 - 1), [ 0/1 + 2, ~0] as W)
        
        NBKAssertToWords(T(sign: .plus,  magnitude: ~0/2 + 2), [~0/2 + 2,  0] as W)
        NBKAssertToWords(T(sign: .plus,  magnitude: ~0/2 + 1), [~0/2 + 1,  0] as W)
        NBKAssertToWords(T(sign: .plus,  magnitude: ~0/2 + 0), [~0/2 + 0,   ] as W)
        
        NBKAssertToWords(T(sign: .minus, magnitude: ~0/2 + 2), [~0/2 + 0, ~0] as W)
        NBKAssertToWords(T(sign: .minus, magnitude: ~0/2 + 1), [~0/2 + 1,   ] as W)
        NBKAssertToWords(T(sign: .minus, magnitude: ~0/2 + 0), [~0/2 + 2,   ] as W)
        
        NBKAssertToWords(T(sign: .plus,  magnitude:  0/1 + 0), [ 0/1 + 0,   ] as W)
        NBKAssertToWords(T(sign: .plus,  magnitude:  0/1 + 1), [ 0/1 + 1,   ] as W)
        NBKAssertToWords(T(sign: .minus, magnitude:  0/1 + 0), [ 0/1 + 0,   ] as W)
        NBKAssertToWords(T(sign: .minus, magnitude:  0/1 + 1), [~0/1 + 0,   ] as W)
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
    NBKAssertIdentical(integer.flatMap({ T(words: $0.words) }), integer, file: file, line: line)
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
    NBKAssertIdentical(integer.flatMap({ T(words: $0.words, isSigned: isSigned) }), integer, file: file, line: line)
}

private func NBKAssertToWords<M: NBKUnsignedInteger>(
_ integer: NBKSigned<M>, _ words: [UInt],
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    NBKAssertElementsEqual(integer.words, words,    file: file, line: line)
    NBKAssertFromWords(words, integer.normalized(), file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Collection
//=----------------------------------------------------------------------------=

private func NBKAssertElementsEqual<Base: RandomAccessCollection>(
_ base: Base, _ expectation: [Base.Element],
file: StaticString = #file, line: UInt = #line) where Base.Element: Equatable {
    //=------------------------------------------=
    XCTAssertEqual(Array(base), expectation, file: file,  line: line)
    XCTAssertEqual(Array(base.indices.map({ base[$0] })), expectation, file: file, line: line)
    //=------------------------------------------=
    for distance in 0 ..< base.count {
        //=--------------------------------------=
        let index0 = base.index(base.startIndex, offsetBy: distance + 0)
        let index1 = base.index(base.startIndex, offsetBy: distance + 1)
        //=--------------------------------------=
        XCTAssertEqual(base[index0],expectation[distance], file: file, line: line)
        //=--------------------------------------=
        XCTAssertEqual(base.index(before: index1), index0, file: file, line: line)
        XCTAssertEqual(base.index(after:  index0), index1, file: file, line: line)

        XCTAssertEqual(base.index(base.endIndex, offsetBy: distance + 0 - base.count), index0, file: file, line: line)
        XCTAssertEqual(base.index(base.endIndex, offsetBy: distance + 1 - base.count), index1, file: file, line: line)
        //=--------------------------------------=
        XCTAssertEqual(base.distance(from: base.startIndex, to: index0), distance + 0, file: file, line: line)
        XCTAssertEqual(base.distance(from: base.startIndex, to: index1), distance + 1, file: file, line: line)
        
        XCTAssertEqual(base.distance(from: index0, to: base.endIndex), base.count - distance - 0, file: file, line: line)
        XCTAssertEqual(base.distance(from: index1, to: base.endIndex), base.count - distance - 1, file: file, line: line)
    }
    //=------------------------------------------=
    for distance in 0 ... base.count + 1 {
        XCTAssert(base.prefix(distance).elementsEqual(expectation.prefix(distance)), file: file, line: line)
        XCTAssert(base.suffix(distance).elementsEqual(expectation.suffix(distance)), file: file, line: line)
    }
}

#endif
