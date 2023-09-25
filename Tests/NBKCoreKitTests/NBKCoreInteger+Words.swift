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
            NBKAssertFromWords(Array(           ), T(  ))
            NBKAssertFromWords(Array(T(  ).words), T(  ))
            NBKAssertFromWords(Array(T.min.words), T.min)
            NBKAssertFromWords(Array(T.max.words), T.max)
            
            NBKAssertFromWords([UInt](repeating:  0, count: T.bitWidth / UInt.bitWidth + 2),  00 as T?)
            NBKAssertFromWords([UInt](repeating:  1, count: T.bitWidth / UInt.bitWidth + 2), nil as T?)
            NBKAssertFromWords([UInt](repeating: ~0, count: T.bitWidth / UInt.bitWidth + 2), -01 as T?)
            NBKAssertFromWords([UInt](repeating: ~1, count: T.bitWidth / UInt.bitWidth + 2), nil as T?)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertFromWords(Array(           ), T(  ))
            NBKAssertFromWords(Array(T(  ).words), T(  ))
            NBKAssertFromWords(Array(T.min.words), T.min)
            NBKAssertFromWords(Array(T.max.words), T.max)
            
            NBKAssertFromWords([UInt](repeating:  0, count: T.bitWidth / UInt.bitWidth + 2), 000 as T?)
            NBKAssertFromWords([UInt](repeating:  1, count: T.bitWidth / UInt.bitWidth + 2), nil as T?)
            NBKAssertFromWords([UInt](repeating: ~0, count: T.bitWidth / UInt.bitWidth + 2), nil as T?)
            NBKAssertFromWords([UInt](repeating: ~1, count: T.bitWidth / UInt.bitWidth + 2), nil as T?)
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

private func NBKAssertFromWords<T: NBKCoreInteger>(
_ words: [UInt], _ integer: T?,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(T(words: words),  integer, file: file, line: line)
    XCTAssertEqual(integer.flatMap({ T(words: $0.words) }), integer, file: file, line: line)
}

#endif
