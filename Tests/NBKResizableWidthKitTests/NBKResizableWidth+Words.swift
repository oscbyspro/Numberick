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
import NBKResizableWidthKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Resizable Width x Words x UIntXR
//*============================================================================*

final class NBKResizableWidthTestsOnWordsAsUIntXR: XCTestCase {
    
    typealias T = UIntXR
    typealias M = UIntXR
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWords() {
        NBKAssertWords(T(words:[0         ]), [0         ])
        NBKAssertWords(T(words:[1         ]), [1         ])
        NBKAssertWords(T(words:[1, 2      ]), [1, 2      ])
        NBKAssertWords(T(words:[1, 2, 3   ]), [1, 2, 3   ])
        NBKAssertWords(T(words:[1, 2, 3, 4]), [1, 2, 3, 4])
        
        NBKAssertWords(T(words:[0, 0, 0, 0]), [0, 0, 0, 0])
        NBKAssertWords(T(words:[1, 0, 0, 0]), [1, 0, 0, 0])
        NBKAssertWords(T(words:[1, 2, 0, 0]), [1, 2, 0, 0])
        NBKAssertWords(T(words:[1, 2, 3, 0]), [1, 2, 3, 0])
        NBKAssertWords(T(words:[1, 2, 3, 4]), [1, 2, 3, 4])
    }
    
    func testWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }

        NBKAssertWords(T(x64:[0         ] as X), [0         ])
        NBKAssertWords(T(x64:[1         ] as X), [1         ])
        NBKAssertWords(T(x64:[1, 2      ] as X), [1, 2      ])
        NBKAssertWords(T(x64:[1, 2, 3   ] as X), [1, 2, 3   ])
        NBKAssertWords(T(x64:[1, 2, 3, 4] as X), [1, 2, 3, 4])

        NBKAssertWords(T(x64:[0, 0, 0, 0] as X), [0, 0, 0, 0])
        NBKAssertWords(T(x64:[1, 0, 0, 0] as X), [1, 0, 0, 0])
        NBKAssertWords(T(x64:[1, 2, 0, 0] as X), [1, 2, 0, 0])
        NBKAssertWords(T(x64:[1, 2, 3, 0] as X), [1, 2, 3, 0])
        NBKAssertWords(T(x64:[1, 2, 3, 4] as X), [1, 2, 3, 4])
    }
    
    func testWordsX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }

        NBKAssertWords(T(x32:[0                     ] as Y), [0                     ])
        NBKAssertWords(T(x32:[1                     ] as Y), [1                     ])
        NBKAssertWords(T(x32:[1, 2                  ] as Y), [1, 2                  ])
        NBKAssertWords(T(x32:[1, 2, 3               ] as Y), [1, 2, 3               ])
        NBKAssertWords(T(x32:[1, 2, 3, 4            ] as Y), [1, 2, 3, 4            ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5         ] as Y), [1, 2, 3, 4, 5         ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 6      ] as Y), [1, 2, 3, 4, 5, 6      ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 6, 7   ] as Y), [1, 2, 3, 4, 5, 6, 7   ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 8] as Y), [1, 2, 3, 4, 5, 6, 7, 8])

        NBKAssertWords(T(x32:[0, 0, 0, 0, 0, 0, 0, 0] as Y), [0, 0, 0, 0, 0, 0, 0, 0])
        NBKAssertWords(T(x32:[1, 0, 0, 0, 0, 0, 0, 0] as Y), [1, 0, 0, 0, 0, 0, 0, 0])
        NBKAssertWords(T(x32:[1, 2, 0, 0, 0, 0, 0, 0] as Y), [1, 2, 0, 0, 0, 0, 0, 0])
        NBKAssertWords(T(x32:[1, 2, 3, 0, 0, 0, 0, 0] as Y), [1, 2, 3, 0, 0, 0, 0, 0])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 0, 0, 0, 0] as Y), [1, 2, 3, 4, 0, 0, 0, 0])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 0, 0, 0] as Y), [1, 2, 3, 4, 5, 0, 0, 0])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 6, 0, 0] as Y), [1, 2, 3, 4, 5, 6, 0, 0])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 0] as Y), [1, 2, 3, 4, 5, 6, 7, 0])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 8] as Y), [1, 2, 3, 4, 5, 6, 7, 8])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Indices
    //=------------------------------------------------------------------------=
    
    func testIndexOffsetByLimitedBy() {
        NBKAssertIndexOffsetByLimitedBy(T.zero,  1,  2,  2,  nil)
        NBKAssertIndexOffsetByLimitedBy(T.zero,  1,  1,  2,  2)
        NBKAssertIndexOffsetByLimitedBy(T.zero,  1,  0,  2,  1)
        NBKAssertIndexOffsetByLimitedBy(T.zero,  1, -1,  2,  0)
        NBKAssertIndexOffsetByLimitedBy(T.zero,  1, -2,  2, -1)
        
        NBKAssertIndexOffsetByLimitedBy(T.zero,  2,  2,  2,  nil)
        NBKAssertIndexOffsetByLimitedBy(T.zero,  2,  1,  2,  nil)
        NBKAssertIndexOffsetByLimitedBy(T.zero,  2,  0,  2,  2)
        NBKAssertIndexOffsetByLimitedBy(T.zero,  2, -1,  2,  nil)
        NBKAssertIndexOffsetByLimitedBy(T.zero,  2, -2,  2,  nil)
        
        NBKAssertIndexOffsetByLimitedBy(T.zero,  3,  2,  2,  5)
        NBKAssertIndexOffsetByLimitedBy(T.zero,  3,  1,  2,  4)
        NBKAssertIndexOffsetByLimitedBy(T.zero,  3,  0,  2,  3)
        NBKAssertIndexOffsetByLimitedBy(T.zero,  3, -1,  2,  2)
        NBKAssertIndexOffsetByLimitedBy(T.zero,  3, -2,  2,  nil)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Elements
    //=------------------------------------------------------------------------=
    
    func testFirstLastTail() {        
        NBKAssertFirstLastTail( T(words:[1, 2, 3, 4]), first:  1, last:  4, tail:  4)
        NBKAssertFirstLastTail(~T(words:[1, 2, 3, 4]), first: ~1, last: ~4, tail: ~4)
    }
}

//*============================================================================*
// MARK: * NBK x Resizable Width x Words x Assertions
//*============================================================================*

private func NBKAssertWords<T: IntXROrUIntXR>(
_ integer: T, _ words: [UInt],
file: StaticString = #file, line: UInt = #line) {
    var integer: T = integer
    var generic: some RandomAccessCollection<UInt> & MutableCollection = integer
    
    XCTAssertEqual(Array(integer.words),            Array(words),            file: file, line: line)
    XCTAssertEqual(Array(integer.words.reversed()), Array(words.reversed()), file: file, line: line)
    
    XCTAssertEqual(integer.withContiguousStorage({        Array($0) }), words, file: file, line: line)
    XCTAssertEqual(integer.withContiguousMutableStorage({ Array($0) }), words, file: file, line: line)
    
    XCTAssertEqual(integer.withContiguousStorageIfAvailable({        Array($0) }), words, file: file, line: line)
    XCTAssertEqual(integer.withContiguousMutableStorageIfAvailable({ Array($0) }), words, file: file, line: line)
    
    XCTAssertEqual(generic.withContiguousStorageIfAvailable({        Array($0) }), words, file: file, line: line)
    XCTAssertEqual(generic.withContiguousMutableStorageIfAvailable({ Array($0) }), words, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Indices
//=----------------------------------------------------------------------------=

private func NBKAssertIndexOffsetByLimitedBy<T: IntXROrUIntXR>(
_ integer: T, _ index: Int, _ distance: Int, _ limit: Int, _ expectation: Int?,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    let wordsIndex = /*-*/(integer).index(index, offsetBy: distance, limitedBy: limit)
    let arrayIndex = Array(integer).index(index, offsetBy: distance, limitedBy: limit)
    //=------------------------------------------=
    XCTAssertEqual(wordsIndex, expectation, file: file, line: line)
    XCTAssertEqual(arrayIndex, expectation, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Elements
//=----------------------------------------------------------------------------=

private func NBKAssertFirstLastTail<T: IntXROrUIntXR>(
_ integer: T, first: UInt, last: UInt, tail: T.Digit,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(integer.first, first, file: file, line: line)
    XCTAssertEqual(integer.last,  last,  file: file, line: line)
    XCTAssertEqual(integer.tail,  tail,  file: file, line: line)
    //=------------------------------------------=
    XCTAssertEqual({ var x = T.zero; x.first = first; return x.first }(), first, file: file, line: line)
    XCTAssertEqual({ var x = T.zero; x.last  = last;  return x.last  }(), last,  file: file, line: line)
    XCTAssertEqual({ var x = T.zero; x.tail  = tail;  return x.tail  }(), tail,  file: file, line: line)
}

#endif
