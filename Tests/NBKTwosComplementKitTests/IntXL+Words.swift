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
import NBKTwosComplementKit
import XCTest

private typealias W = [UInt]
private typealias X = [UInt64]
private typealias Y = [UInt32]

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x IntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnWordsAsIntXL: XCTestCase {
    
    typealias T =  IntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWords() {
        NBKAssertWords(T(words:[0         ]), [0         ])
        NBKAssertWords(T(words:[1         ]), [1         ])
        NBKAssertWords(T(words:[1, 2      ]), [1, 2      ])
        NBKAssertWords(T(words:[1, 2, 3   ]), [1, 2, 3   ])
        NBKAssertWords(T(words:[1, 2, 3, 4]), [1, 2, 3, 4])
        
        NBKAssertWords(T(words:[0, 0, 0, 0]), [0         ])
        NBKAssertWords(T(words:[1, 0, 0, 0]), [1         ])
        NBKAssertWords(T(words:[1, 2, 0, 0]), [1, 2      ])
        NBKAssertWords(T(words:[1, 2, 3, 0]), [1, 2, 3   ])
        NBKAssertWords(T(words:[1, 2, 3, 4]), [1, 2, 3, 4])
    }
    
    func testWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertWords(T(x64:[0         ] as X), [0         ])
        NBKAssertWords(T(x64:[1         ] as X), [1         ])
        NBKAssertWords(T(x64:[1, 2      ] as X), [1, 2      ])
        NBKAssertWords(T(x64:[1, 2, 3   ] as X), [1, 2, 3   ])
        NBKAssertWords(T(x64:[1, 2, 3, 4] as X), [1, 2, 3, 4])
        
        NBKAssertWords(T(x64:[0, 0, 0, 0] as X), [0         ])
        NBKAssertWords(T(x64:[1, 0, 0, 0] as X), [1         ])
        NBKAssertWords(T(x64:[1, 2, 0, 0] as X), [1, 2      ])
        NBKAssertWords(T(x64:[1, 2, 3, 0] as X), [1, 2, 3   ])
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
        
        NBKAssertWords(T(x32:[0, 0, 0, 0, 0, 0, 0, 0] as Y), [0                     ])
        NBKAssertWords(T(x32:[1, 0, 0, 0, 0, 0, 0, 0] as Y), [1                     ])
        NBKAssertWords(T(x32:[1, 2, 0, 0, 0, 0, 0, 0] as Y), [1, 2                  ])
        NBKAssertWords(T(x32:[1, 2, 3, 0, 0, 0, 0, 0] as Y), [1, 2, 3               ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 0, 0, 0, 0] as Y), [1, 2, 3, 4            ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 0, 0, 0] as Y), [1, 2, 3, 4, 5         ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 6, 0, 0] as Y), [1, 2, 3, 4, 5, 6      ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 0] as Y), [1, 2, 3, 4, 5, 6, 7   ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 8] as Y), [1, 2, 3, 4, 5, 6, 7, 8])
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x UIntXL
//*============================================================================*

final class NBKFlexibleWidthTestsOnWordsAsUIntXL: XCTestCase {
    
    typealias T = UIntXL
    typealias M = UIntXL
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWords() {
        NBKAssertWords(T(words:[0         ]), [0         ])
        NBKAssertWords(T(words:[1         ]), [1         ])
        NBKAssertWords(T(words:[1, 2      ]), [1, 2      ])
        NBKAssertWords(T(words:[1, 2, 3   ]), [1, 2, 3   ])
        NBKAssertWords(T(words:[1, 2, 3, 4]), [1, 2, 3, 4])
        
        NBKAssertWords(T(words:[0, 0, 0, 0]), [0         ])
        NBKAssertWords(T(words:[1, 0, 0, 0]), [1         ])
        NBKAssertWords(T(words:[1, 2, 0, 0]), [1, 2      ])
        NBKAssertWords(T(words:[1, 2, 3, 0]), [1, 2, 3   ])
        NBKAssertWords(T(words:[1, 2, 3, 4]), [1, 2, 3, 4])
    }
    
    func testWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertWords(T(x64:[0         ] as X), [0         ])
        NBKAssertWords(T(x64:[1         ] as X), [1         ])
        NBKAssertWords(T(x64:[1, 2      ] as X), [1, 2      ])
        NBKAssertWords(T(x64:[1, 2, 3   ] as X), [1, 2, 3   ])
        NBKAssertWords(T(x64:[1, 2, 3, 4] as X), [1, 2, 3, 4])
        
        NBKAssertWords(T(x64:[0, 0, 0, 0] as X), [0         ])
        NBKAssertWords(T(x64:[1, 0, 0, 0] as X), [1         ])
        NBKAssertWords(T(x64:[1, 2, 0, 0] as X), [1, 2      ])
        NBKAssertWords(T(x64:[1, 2, 3, 0] as X), [1, 2, 3   ])
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
        
        NBKAssertWords(T(x32:[0, 0, 0, 0, 0, 0, 0, 0] as Y), [0                     ])
        NBKAssertWords(T(x32:[1, 0, 0, 0, 0, 0, 0, 0] as Y), [1                     ])
        NBKAssertWords(T(x32:[1, 2, 0, 0, 0, 0, 0, 0] as Y), [1, 2                  ])
        NBKAssertWords(T(x32:[1, 2, 3, 0, 0, 0, 0, 0] as Y), [1, 2, 3               ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 0, 0, 0, 0] as Y), [1, 2, 3, 4            ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 0, 0, 0] as Y), [1, 2, 3, 4, 5         ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 6, 0, 0] as Y), [1, 2, 3, 4, 5, 6      ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 0] as Y), [1, 2, 3, 4, 5, 6, 7   ])
        NBKAssertWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 8] as Y), [1, 2, 3, 4, 5, 6, 7, 8])
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x Assertions
//*============================================================================*

private func NBKAssertWords<T: IntXLOrUIntXL>(
_ integer: T, _ words: [UInt],
file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(Array(integer.words),            Array(words),            file: file, line: line)
    XCTAssertEqual(Array(integer.words.reversed()), Array(words.reversed()), file: file, line: line)
}

#endif
