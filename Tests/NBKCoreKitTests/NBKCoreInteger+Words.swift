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
    
    func testFromWords() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertFromWordsIsSigned(Array(           ), true, T(  ))
            NBKAssertFromWordsIsSigned(Array(T(  ).words), true, T(  ))
            NBKAssertFromWordsIsSigned(Array(T.min.words), true, T.min)
            NBKAssertFromWordsIsSigned(Array(T.max.words), true, T.max)

            NBKAssertFromWordsIsSigned(Array(           ), false, T(  ))
            NBKAssertFromWordsIsSigned(Array(T(  ).words), false, T(  ))
            NBKAssertFromWordsIsSigned(Array(T.min.words), false, nil as T?)
            NBKAssertFromWordsIsSigned(Array(T.max.words), false, T.max)

            NBKAssertFromWordsIsSigned([UInt](repeating:  0, count: T.bitWidth / UInt.bitWidth + 2), true,   00 as T?)
            NBKAssertFromWordsIsSigned([UInt](repeating:  1, count: T.bitWidth / UInt.bitWidth + 2), true,  nil as T?)
            NBKAssertFromWordsIsSigned([UInt](repeating: ~0, count: T.bitWidth / UInt.bitWidth + 2), true,  -01 as T?)
            NBKAssertFromWordsIsSigned([UInt](repeating: ~1, count: T.bitWidth / UInt.bitWidth + 2), true,  nil as T?)

            NBKAssertFromWordsIsSigned([UInt](repeating:  0, count: T.bitWidth / UInt.bitWidth + 2), false,  00 as T?)
            NBKAssertFromWordsIsSigned([UInt](repeating:  1, count: T.bitWidth / UInt.bitWidth + 2), false, nil as T?)
            NBKAssertFromWordsIsSigned([UInt](repeating: ~0, count: T.bitWidth / UInt.bitWidth + 2), false, nil as T?)
            NBKAssertFromWordsIsSigned([UInt](repeating: ~1, count: T.bitWidth / UInt.bitWidth + 2), false, nil as T?)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertFromWordsIsSigned(Array(           ), true,  T(  ))
            NBKAssertFromWordsIsSigned(Array(T(  ).words), true,  T(  ))
            NBKAssertFromWordsIsSigned(Array(T.min.words), true,  T.min)
            NBKAssertFromWordsIsSigned(Array(T.max.words), true,  T.bitWidth % UInt.bitWidth == 0 ? nil : T.max)

            NBKAssertFromWordsIsSigned(Array(           ), false, T(  ))
            NBKAssertFromWordsIsSigned(Array(T(  ).words), false, T(  ))
            NBKAssertFromWordsIsSigned(Array(T.min.words), false, T.min)
            NBKAssertFromWordsIsSigned(Array(T.max.words), false, T.max)

            NBKAssertFromWordsIsSigned([UInt](repeating:  0, count: T.bitWidth / UInt.bitWidth + 2), true,  000 as T?)
            NBKAssertFromWordsIsSigned([UInt](repeating:  1, count: T.bitWidth / UInt.bitWidth + 2), true,  nil as T?)
            NBKAssertFromWordsIsSigned([UInt](repeating: ~0, count: T.bitWidth / UInt.bitWidth + 2), true,  nil as T?)
            NBKAssertFromWordsIsSigned([UInt](repeating: ~1, count: T.bitWidth / UInt.bitWidth + 2), true,  nil as T?)

            NBKAssertFromWordsIsSigned([UInt](repeating:  0, count: T.bitWidth / UInt.bitWidth + 2), false, 000 as T?)
            NBKAssertFromWordsIsSigned([UInt](repeating:  1, count: T.bitWidth / UInt.bitWidth + 2), false, nil as T?)
            NBKAssertFromWordsIsSigned([UInt](repeating: ~0, count: T.bitWidth / UInt.bitWidth + 2), false, nil as T?)
            NBKAssertFromWordsIsSigned([UInt](repeating: ~1, count: T.bitWidth / UInt.bitWidth + 2), false, nil as T?)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
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

//*============================================================================*
// MARK: * NBK x Core Integer x Words x Assertions
//*============================================================================*

private func NBKAssertFromWordsIsSigned<T: NBKCoreInteger>(
_ words: [UInt], _ isSigned: Bool, _ integer: T?,
file: StaticString = #file, line: UInt = #line) {

    if  isSigned == T.isSigned {
        XCTAssertEqual(                  T(words:    words),    integer, file: file, line: line)
        XCTAssertEqual(integer.flatMap({ T(words: $0.words) }), integer, file: file, line: line)
    }
    
    XCTAssertEqual(                  T(words:    words, isSigned: isSigned),    integer, file: file, line: line)
    XCTAssertEqual(integer.flatMap({ T(words: $0.words, isSigned: isSigned) }), integer, file: file, line: line)
}

#endif
