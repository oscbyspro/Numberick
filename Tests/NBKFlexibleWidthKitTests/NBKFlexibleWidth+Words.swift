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

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnWordsAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromWords() {
        NBKAssertFromWordsIsSigned(Array(              ), true,  T(  ))
        NBKAssertFromWordsIsSigned(Array(T(     ).words), true,  T(  ))
        NBKAssertFromWordsIsSigned(Array(T.min256.words), true,  T.min256)
        NBKAssertFromWordsIsSigned(Array(T.max256.words), true,  nil as T?)

        NBKAssertFromWordsIsSigned(Array(              ), false, T(  ))
        NBKAssertFromWordsIsSigned(Array(T(     ).words), false, T(  ))
        NBKAssertFromWordsIsSigned(Array(T.min256.words), false, T.min256)
        NBKAssertFromWordsIsSigned(Array(T.max256.words), false, T.max256)
        
        NBKAssertFromWordsIsSigned(Array([~0/2 + 1]), true,  nil as T?)
        NBKAssertFromWordsIsSigned(Array([~0/2 + 0]), true,  T(words:[~0/2 + 0]))
        
        NBKAssertFromWordsIsSigned(Array([~0/2 + 1]), false, T(words:[~0/2 + 1]))
        NBKAssertFromWordsIsSigned(Array([~0/2 + 0]), false, T(words:[~0/2 + 0]))
    }
    
    func testToWords() {
        NBKAssertToWords(T(words:[0         ]), [0         ])
        NBKAssertToWords(T(words:[1         ]), [1         ])
        NBKAssertToWords(T(words:[1, 2      ]), [1, 2      ])
        NBKAssertToWords(T(words:[1, 2, 3   ]), [1, 2, 3   ])
        NBKAssertToWords(T(words:[1, 2, 3, 4]), [1, 2, 3, 4])
        
        NBKAssertToWords(T(words:[0, 0, 0, 0]), [0         ])
        NBKAssertToWords(T(words:[1, 0, 0, 0]), [1         ])
        NBKAssertToWords(T(words:[1, 2, 0, 0]), [1, 2      ])
        NBKAssertToWords(T(words:[1, 2, 3, 0]), [1, 2, 3   ])
        NBKAssertToWords(T(words:[1, 2, 3, 4]), [1, 2, 3, 4])
    }
    
    func testToWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertToWords(T(x64:[0         ] as X), [0         ])
        NBKAssertToWords(T(x64:[1         ] as X), [1         ])
        NBKAssertToWords(T(x64:[1, 2      ] as X), [1, 2      ])
        NBKAssertToWords(T(x64:[1, 2, 3   ] as X), [1, 2, 3   ])
        NBKAssertToWords(T(x64:[1, 2, 3, 4] as X), [1, 2, 3, 4])
        
        NBKAssertToWords(T(x64:[0, 0, 0, 0] as X), [0         ])
        NBKAssertToWords(T(x64:[1, 0, 0, 0] as X), [1         ])
        NBKAssertToWords(T(x64:[1, 2, 0, 0] as X), [1, 2      ])
        NBKAssertToWords(T(x64:[1, 2, 3, 0] as X), [1, 2, 3   ])
        NBKAssertToWords(T(x64:[1, 2, 3, 4] as X), [1, 2, 3, 4])
    }
    
    func testToWordsX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertToWords(T(x32:[0                     ] as Y), [0                     ])
        NBKAssertToWords(T(x32:[1                     ] as Y), [1                     ])
        NBKAssertToWords(T(x32:[1, 2                  ] as Y), [1, 2                  ])
        NBKAssertToWords(T(x32:[1, 2, 3               ] as Y), [1, 2, 3               ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4            ] as Y), [1, 2, 3, 4            ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5         ] as Y), [1, 2, 3, 4, 5         ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 6      ] as Y), [1, 2, 3, 4, 5, 6      ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 6, 7   ] as Y), [1, 2, 3, 4, 5, 6, 7   ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 8] as Y), [1, 2, 3, 4, 5, 6, 7, 8])
        
        NBKAssertToWords(T(x32:[0, 0, 0, 0, 0, 0, 0, 0] as Y), [0                     ])
        NBKAssertToWords(T(x32:[1, 0, 0, 0, 0, 0, 0, 0] as Y), [1                     ])
        NBKAssertToWords(T(x32:[1, 2, 0, 0, 0, 0, 0, 0] as Y), [1, 2                  ])
        NBKAssertToWords(T(x32:[1, 2, 3, 0, 0, 0, 0, 0] as Y), [1, 2, 3               ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 0, 0, 0, 0] as Y), [1, 2, 3, 4            ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 0, 0, 0] as Y), [1, 2, 3, 4, 5         ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 6, 0, 0] as Y), [1, 2, 3, 4, 5, 6      ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 0] as Y), [1, 2, 3, 4, 5, 6, 7   ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 8] as Y), [1, 2, 3, 4, 5, 6, 7, 8])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testSubscriptSignExtension() {
        XCTAssertEqual(T(words:[1, 2, 3, 4] as W)[Int( 0)], 1 as UInt)
        XCTAssertEqual(T(words:[1, 2, 3, 4] as W)[Int( 1)], 2 as UInt)
        XCTAssertEqual(T(words:[1, 2, 3, 4] as W)[Int( 2)], 3 as UInt)
        XCTAssertEqual(T(words:[1, 2, 3, 4] as W)[Int( 3)], 4 as UInt)
        XCTAssertEqual(T(words:[1, 2, 3, 4] as W)[Int( 4)], 0 as UInt)
        XCTAssertEqual(T(words:[1, 2, 3, 4] as W)[Int.max], 0 as UInt)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x Assertions
//*============================================================================*

private func NBKAssertFromWords<T: IntXLOrUIntXL>(
_ words: [UInt], _ integer: T?,
file: StaticString = #file, line: UInt = #line) {
    
    XCTAssertEqual(                  T(words:    words),    integer, file: file, line: line)
    XCTAssertEqual(integer.flatMap({ T(words: $0.words) }), integer, file: file, line: line)
}

private func NBKAssertFromWordsIsSigned<T: IntXLOrUIntXL>(
_ words: [UInt], _ isSigned: Bool, _ integer: T?,
file: StaticString = #file, line: UInt = #line) {
    
    if  isSigned == T.isSigned {
        NBKAssertFromWords(words, integer, file: file, line: line)
    }
    
    XCTAssertEqual(                  T(words:    words, isSigned: isSigned),    integer, file: file, line: line)
    XCTAssertEqual(integer.flatMap({ T(words: $0.words, isSigned: isSigned) }), integer, file: file, line: line)
}

private func NBKAssertToWords<T: NBKBinaryInteger>(
_ integer: T, _ words: [UInt],
file: StaticString = #file, line: UInt = #line) {
    
    XCTAssertEqual(Array(integer.words),            Array(words),            file: file, line: line)
    XCTAssertEqual(Array(integer.words.reversed()), Array(words.reversed()), file: file, line: line)
}

#endif
