//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKFlexibleWidthKit
import XCTest

private typealias X   = [UInt]
private typealias X64 = [UInt64]
private typealias X32 = [UInt32]

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
    
    
    /// ```
    /// ┌──────────────────────── = ───────────────────────────┐
    /// │ self                    │ words on a 64-bit machine  │
    /// ├──────────────────────── = ───────────────────────────┤
    /// │  IntXL(           )     │ [ 0                      ] │
    /// │  IntXL( Int256.max)     │ [~0, ~0, ~0, ~0/2 + 0    ] │
    /// │  IntXL( Int256.max) + 1 │ [ 0,  0,  0, ~0/2 + 1,  0] │
    /// │  IntXL( Int256.min)     │ [ 0,  0,  0, ~0/2 + 1    ] │
    /// │  IntXL( Int256.min) + 1 │ [~0, ~0, ~0, ~0/2 + 0, ~0] │
    /// │  IntXL(UInt256.max)     │ [~0, ~0, ~0, ~0/1 + 0,  0] │
    /// │  IntXL(UInt256.max) + 1 │ [ 0,  0,  0,  0/1 + 0,  1] │
    /// ├──────────────────────── = ───────────────────────────┤
    /// │ UIntXL(           )     │ [ 0                      ] │
    /// │ UIntXL( Int256.max)     │ [~0, ~0, ~0, ~0/2 + 0    ] │
    /// │ UIntXL( Int256.max) + 1 │ [ 0,  0,  0, ~0/2 + 1    ] │
    /// │ UIntXL(UInt256.max)     │ [~0, ~0, ~0, ~0/1 + 0    ] │
    /// │ UIntXL(UInt256.max) + 1 │ [ 0,  0,  0,  0/1 + 0,  1] │
    /// └──────────────────────── = ───────────────────────────┘
    /// ```
    func testToWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertToWords(T(x64:[0         ] as X64), [0         ])
        NBKAssertToWords(T(x64:[1         ] as X64), [1         ])
        NBKAssertToWords(T(x64:[1, 2      ] as X64), [1, 2      ])
        NBKAssertToWords(T(x64:[1, 2, 3   ] as X64), [1, 2, 3   ])
        NBKAssertToWords(T(x64:[1, 2, 3, 4] as X64), [1, 2, 3, 4])
        
        NBKAssertToWords(T(x64:[0, 0, 0, 0] as X64), [0         ])
        NBKAssertToWords(T(x64:[1, 0, 0, 0] as X64), [1         ])
        NBKAssertToWords(T(x64:[1, 2, 0, 0] as X64), [1, 2      ])
        NBKAssertToWords(T(x64:[1, 2, 3, 0] as X64), [1, 2, 3   ])
        NBKAssertToWords(T(x64:[1, 2, 3, 4] as X64), [1, 2, 3, 4])
        
        NBKAssertToWords(T(x64:[~0, ~0, ~0, ~0/2] as X64),     [~0, ~0, ~0, ~0/2 + 0    ] as X) //  Int256.max
        NBKAssertToWords(T(x64:[~0, ~0, ~0, ~0/2] as X64) + 1, [ 0,  0,  0, ~0/2 + 1    ] as X) //  Int256.max + 1
        NBKAssertToWords(T(x64:[~0, ~0, ~0, ~0/1] as X64),     [~0, ~0, ~0, ~0/1 + 0    ] as X) // UInt256.max
        NBKAssertToWords(T(x64:[~0, ~0, ~0, ~0/1] as X64) + 1, [ 0,  0,  0,  0/1 + 0,  1] as X) // UInt256.max + 1
    }
    
    func testToWordsX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertToWords(T(x32:[0                     ] as X32), [0                     ])
        NBKAssertToWords(T(x32:[1                     ] as X32), [1                     ])
        NBKAssertToWords(T(x32:[1, 2                  ] as X32), [1, 2                  ])
        NBKAssertToWords(T(x32:[1, 2, 3               ] as X32), [1, 2, 3               ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4            ] as X32), [1, 2, 3, 4            ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5         ] as X32), [1, 2, 3, 4, 5         ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 6      ] as X32), [1, 2, 3, 4, 5, 6      ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 6, 7   ] as X32), [1, 2, 3, 4, 5, 6, 7   ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 8] as X32), [1, 2, 3, 4, 5, 6, 7, 8])
        
        NBKAssertToWords(T(x32:[0, 0, 0, 0, 0, 0, 0, 0] as X32), [0                     ])
        NBKAssertToWords(T(x32:[1, 0, 0, 0, 0, 0, 0, 0] as X32), [1                     ])
        NBKAssertToWords(T(x32:[1, 2, 0, 0, 0, 0, 0, 0] as X32), [1, 2                  ])
        NBKAssertToWords(T(x32:[1, 2, 3, 0, 0, 0, 0, 0] as X32), [1, 2, 3               ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 0, 0, 0, 0] as X32), [1, 2, 3, 4            ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 0, 0, 0] as X32), [1, 2, 3, 4, 5         ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 6, 0, 0] as X32), [1, 2, 3, 4, 5, 6      ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 0] as X32), [1, 2, 3, 4, 5, 6, 7   ])
        NBKAssertToWords(T(x32:[1, 2, 3, 4, 5, 6, 7, 8] as X32), [1, 2, 3, 4, 5, 6, 7, 8])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Miscellaneous
    //=------------------------------------------------------------------------=
    
    func testSubscriptSignExtension() {
        XCTAssertEqual(T(words:[1, 2, 3, 4] as X)[Int( 0)], 1 as UInt)
        XCTAssertEqual(T(words:[1, 2, 3, 4] as X)[Int( 1)], 2 as UInt)
        XCTAssertEqual(T(words:[1, 2, 3, 4] as X)[Int( 2)], 3 as UInt)
        XCTAssertEqual(T(words:[1, 2, 3, 4] as X)[Int( 3)], 4 as UInt)
        XCTAssertEqual(T(words:[1, 2, 3, 4] as X)[Int( 4)], 0 as UInt)
        XCTAssertEqual(T(words:[1, 2, 3, 4] as X)[Int.max], 0 as UInt)
    }
}

//*============================================================================*
// MARK: * NBK x Flexible Width x Words x Assertions
//*============================================================================*

private func NBKAssertFromWords<T: IntXLOrUIntXL>(
_ words: [UInt], _ integer: T?,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    XCTAssertEqual(                  T(words:    words),    integer, file: file, line: line)
    XCTAssertEqual(integer.flatMap({ T(words: $0.words) }), integer, file: file, line: line)
    //=------------------------------------------=
    if  let integer {
        NBKAssertFromWordsByTruncating(words, words.count, integer)
    }
}

private func NBKAssertFromWordsIsSigned<T: IntXLOrUIntXL>(
_ words: [UInt], _ isSigned: Bool, _ integer: T?,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  isSigned == T.isSigned {
        NBKAssertFromWords(words, integer, file: file, line: line)
    }
    //=------------------------------------------=
    XCTAssertEqual(                  T(words:    words, isSigned: isSigned),    integer, file: file, line: line)
    XCTAssertEqual(integer.flatMap({ T(words: $0.words, isSigned: isSigned) }), integer, file: file, line: line)
    //=------------------------------------------=
    if  let integer {
        NBKAssertFromWordsByTruncating(words, words.count, integer)
    }
}

private func NBKAssertFromWordsByTruncating<T: IntXLOrUIntXL>(
_ words: [UInt], _ count: Int, _ integer: T,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    if  count == words.count {
        let initialized = T.uninitialized(count: count, init:{ let _ = $0.initialize(from: words) })
        XCTAssertEqual(initialized, integer, file: file, line: line)
    }
    
    brr: do {
        let capacity: Int = count
        let initialized = T.uninitialized(capacity: capacity, init:{ $1 = $0.initialize(from: words.prefix(count)).index })
        XCTAssertEqual(initialized, integer, file: file, line: line)
    }
    
    brr: do {
        let capacity: Int = count + 1
        let initialized = T.uninitialized(capacity: capacity, init:{ $1 = $0.initialize(from: words.prefix(count)).index })
        XCTAssertEqual(initialized, integer, file: file, line: line)
    }
}

private func NBKAssertToWords<T: IntXLOrUIntXL>(
_ integer: T, _ words: [UInt],
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    var integer = integer
    //=------------------------------------------=
    NBKAssertFromWords(words, integer, file: file, line: line)
    //=------------------------------------------=
    NBKAssertElementsEqual(integer.words, words, file: file, line: line)
    integer.withUnsafeBufferPointer({        NBKAssertElementsEqual($0, words, file: file, line: line) })
    integer.withUnsafeMutableBufferPointer({ NBKAssertElementsEqual($0, words, file: file, line: line) })    
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
