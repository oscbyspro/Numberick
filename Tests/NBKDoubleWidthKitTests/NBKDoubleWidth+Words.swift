//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import NBKDoubleWidthKit
import XCTest

private typealias X64 = NBK.U256X64
private typealias X32 = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Words x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnWordsAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromWords() {
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
    
    func testFromWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertFromWords([             ] as [UInt], T(x64: X64(0, 0, 0, 0)))
        NBKAssertFromWords([1            ] as [UInt], T(x64: X64(1, 0, 0, 0)))
        NBKAssertFromWords([1, 2         ] as [UInt], T(x64: X64(1, 2, 0, 0)))
        NBKAssertFromWords([1, 2, 3      ] as [UInt], T(x64: X64(1, 2, 3, 0)))
        NBKAssertFromWords([1, 2, 3, 4   ] as [UInt], T(x64: X64(1, 2, 3, 4)))
        NBKAssertFromWords([1, 2, 3, 4, 5] as [UInt], nil as T?)
    }
    
    func testFromWordsX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertFromWords([                         ] as [UInt], T(x32: X32(0, 0, 0, 0, 0, 0, 0, 0)))
        NBKAssertFromWords([1                        ] as [UInt], T(x32: X32(1, 0, 0, 0, 0, 0, 0, 0)))
        NBKAssertFromWords([1, 2                     ] as [UInt], T(x32: X32(1, 2, 0, 0, 0, 0, 0, 0)))
        NBKAssertFromWords([1, 2, 3                  ] as [UInt], T(x32: X32(1, 2, 3, 0, 0, 0, 0, 0)))
        NBKAssertFromWords([1, 2, 3, 4               ] as [UInt], T(x32: X32(1, 2, 3, 4, 0, 0, 0, 0)))
        NBKAssertFromWords([1, 2, 3, 4, 5            ] as [UInt], T(x32: X32(1, 2, 3, 4, 5, 0, 0, 0)))
        NBKAssertFromWords([1, 2, 3, 4, 5, 6         ] as [UInt], T(x32: X32(1, 2, 3, 4, 5, 6, 0, 0)))
        NBKAssertFromWords([1, 2, 3, 4, 5, 6, 7      ] as [UInt], T(x32: X32(1, 2, 3, 4, 5, 6, 7, 0)))
        NBKAssertFromWords([1, 2, 3, 4, 5, 6, 7, 8   ] as [UInt], T(x32: X32(1, 2, 3, 4, 5, 6, 7, 8)))
        NBKAssertFromWords([1, 2, 3, 4, 5, 6, 7, 8, 9] as [UInt], nil as T?)
    }
    
    func testToWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertToWords(T(x64: X64(0, 0, 0, 0)), [0, 0, 0, 0])
        NBKAssertToWords(T(x64: X64(1, 0, 0, 0)), [1, 0, 0, 0])
        NBKAssertToWords(T(x64: X64(1, 2, 0, 0)), [1, 2, 0, 0])
        NBKAssertToWords(T(x64: X64(1, 2, 3, 0)), [1, 2, 3, 0])
        NBKAssertToWords(T(x64: X64(1, 2, 3, 4)), [1, 2, 3, 4])
    }
    
    func testToWordsX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertToWords(T(x32: X32(0, 0, 0, 0, 0, 0, 0, 0)), [0, 0, 0, 0, 0, 0, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 0, 0, 0, 0, 0, 0, 0)), [1, 0, 0, 0, 0, 0, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 0, 0, 0, 0, 0, 0)), [1, 2, 0, 0, 0, 0, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 3, 0, 0, 0, 0, 0)), [1, 2, 3, 0, 0, 0, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 3, 4, 0, 0, 0, 0)), [1, 2, 3, 4, 0, 0, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 3, 4, 5, 0, 0, 0)), [1, 2, 3, 4, 5, 0, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 3, 4, 5, 6, 0, 0)), [1, 2, 3, 4, 5, 6, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 3, 4, 5, 6, 7, 0)), [1, 2, 3, 4, 5, 6, 7, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 3, 4, 5, 6, 7, 8)), [1, 2, 3, 4, 5, 6, 7, 8])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x First, Last, Tail
    //=------------------------------------------------------------------------=
    
    func testFirstLastTailX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertFirstLastTail( T(x64: X64(1, 2, 3, 4)), first:  1, last:  4, tail:  4)
        NBKAssertFirstLastTail(~T(x64: X64(1, 2, 3, 4)), first: ~1, last: ~4, tail: ~4)
    }
    
    func testFirstLastTailX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertFirstLastTail( T(x32: X32(1, 2, 3, 4, 5, 6, 7, 8)), first:  1, last:  8, tail:  8)
        NBKAssertFirstLastTail(~T(x32: X32(1, 2, 3, 4, 5, 6, 7, 8)), first: ~1, last: ~8, tail: ~8)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Words x UInt256
//*============================================================================*

final class NBKDoubleWidthTestsOnWordsAsUInt256: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromWords() {
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
    
    func testFromWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertFromWords([             ] as [UInt], T(x64: X64(0, 0, 0, 0)))
        NBKAssertFromWords([1            ] as [UInt], T(x64: X64(1, 0, 0, 0)))
        NBKAssertFromWords([1, 2         ] as [UInt], T(x64: X64(1, 2, 0, 0)))
        NBKAssertFromWords([1, 2, 3      ] as [UInt], T(x64: X64(1, 2, 3, 0)))
        NBKAssertFromWords([1, 2, 3, 4   ] as [UInt], T(x64: X64(1, 2, 3, 4)))
        NBKAssertFromWords([1, 2, 3, 4, 5] as [UInt], nil as T?)
    }
    
    func testFromWordsX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertFromWords([                         ] as [UInt], T(x32: X32(0, 0, 0, 0, 0, 0, 0, 0)))
        NBKAssertFromWords([1                        ] as [UInt], T(x32: X32(1, 0, 0, 0, 0, 0, 0, 0)))
        NBKAssertFromWords([1, 2                     ] as [UInt], T(x32: X32(1, 2, 0, 0, 0, 0, 0, 0)))
        NBKAssertFromWords([1, 2, 3                  ] as [UInt], T(x32: X32(1, 2, 3, 0, 0, 0, 0, 0)))
        NBKAssertFromWords([1, 2, 3, 4               ] as [UInt], T(x32: X32(1, 2, 3, 4, 0, 0, 0, 0)))
        NBKAssertFromWords([1, 2, 3, 4, 5            ] as [UInt], T(x32: X32(1, 2, 3, 4, 5, 0, 0, 0)))
        NBKAssertFromWords([1, 2, 3, 4, 5, 6         ] as [UInt], T(x32: X32(1, 2, 3, 4, 5, 6, 0, 0)))
        NBKAssertFromWords([1, 2, 3, 4, 5, 6, 7      ] as [UInt], T(x32: X32(1, 2, 3, 4, 5, 6, 7, 0)))
        NBKAssertFromWords([1, 2, 3, 4, 5, 6, 7, 8   ] as [UInt], T(x32: X32(1, 2, 3, 4, 5, 6, 7, 8)))
        NBKAssertFromWords([1, 2, 3, 4, 5, 6, 7, 8, 9] as [UInt], nil as T?)
    }
    
    func testWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertToWords(T(x64: X64(0, 0, 0, 0)), [0, 0, 0, 0])
        NBKAssertToWords(T(x64: X64(1, 0, 0, 0)), [1, 0, 0, 0])
        NBKAssertToWords(T(x64: X64(1, 2, 0, 0)), [1, 2, 0, 0])
        NBKAssertToWords(T(x64: X64(1, 2, 3, 0)), [1, 2, 3, 0])
        NBKAssertToWords(T(x64: X64(1, 2, 3, 4)), [1, 2, 3, 4])
    }
    
    func testWordsX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertToWords(T(x32: X32(0, 0, 0, 0, 0, 0, 0, 0)), [0, 0, 0, 0, 0, 0, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 0, 0, 0, 0, 0, 0, 0)), [1, 0, 0, 0, 0, 0, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 0, 0, 0, 0, 0, 0)), [1, 2, 0, 0, 0, 0, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 3, 0, 0, 0, 0, 0)), [1, 2, 3, 0, 0, 0, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 3, 4, 0, 0, 0, 0)), [1, 2, 3, 4, 0, 0, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 3, 4, 5, 0, 0, 0)), [1, 2, 3, 4, 5, 0, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 3, 4, 5, 6, 0, 0)), [1, 2, 3, 4, 5, 6, 0, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 3, 4, 5, 6, 7, 0)), [1, 2, 3, 4, 5, 6, 7, 0])
        NBKAssertToWords(T(x32: X32(1, 2, 3, 4, 5, 6, 7, 8)), [1, 2, 3, 4, 5, 6, 7, 8])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x First, Last, Tail
    //=------------------------------------------------------------------------=
    
    func testFirstLastTailX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertFirstLastTail( T(x64: X64(1, 2, 3, 4)), first:  1, last:  4, tail:  4)
        NBKAssertFirstLastTail(~T(x64: X64(1, 2, 3, 4)), first: ~1, last: ~4, tail: ~4)
    }
    
    func testFirstLastTailX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertFirstLastTail( T(x32: X32(1, 2, 3, 4, 5, 6, 7, 8)), first:  1, last:  8, tail:  8)
        NBKAssertFirstLastTail(~T(x32: X32(1, 2, 3, 4, 5, 6, 7, 8)), first: ~1, last: ~8, tail: ~8)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Words x Assertions
//*============================================================================*

private func NBKAssertFromWords<H: NBKFixedWidthInteger>(
_ words: [UInt], _ integer: NBKDoubleWidth<H>?,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    XCTAssertEqual(                  T(words:    words),    integer, file: file, line: line)
    XCTAssertEqual(integer.flatMap({ T(words: $0.words) }), integer, file: file, line: line)
}

private func NBKAssertFromWordsIsSigned<H: NBKFixedWidthInteger>(
_ words: [UInt], _ isSigned: Bool, _ integer: NBKDoubleWidth<H>?,
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    if  isSigned == T.isSigned {
        NBKAssertFromWords(words, integer, file: file, line: line)
    }
    
    XCTAssertEqual(                  T(words:    words, isSigned: isSigned),    integer, file: file, line: line)
    XCTAssertEqual(integer.flatMap({ T(words: $0.words, isSigned: isSigned) }), integer, file: file, line: line)
}

private func NBKAssertToWords<H: NBKFixedWidthInteger>(
_ integer: NBKDoubleWidth<H>, _ words: [UInt],
file: StaticString = #file, line: UInt = #line) {
    //=------------------------------------------=
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    NBKAssertFromWordsIsSigned(words, T.isSigned, integer, file: file, line: line)
    //=------------------------------------------=
    var integer: NBKDoubleWidth<H> = integer
    var generic: some RandomAccessCollection<UInt> & MutableCollection = integer
    //=------------------------------------------=
    XCTAssertEqual(Array(integer),       words, file: file, line: line)
    XCTAssertEqual(Array(integer.words), words, file: file, line: line)
    
    XCTAssertEqual(Array(integer.reversed()),       words.reversed(), file: file, line: line)
    XCTAssertEqual(Array(integer.words.reversed()), words.reversed(), file: file, line: line)
    
    XCTAssertEqual(integer.withContiguousStorage({        Array($0) }), words, file: file, line: line)
    XCTAssertEqual(integer.withContiguousMutableStorage({ Array($0) }), words, file: file, line: line)
    
    XCTAssertEqual(integer.withContiguousStorageIfAvailable({        Array($0) }), words, file: file, line: line)
    XCTAssertEqual(integer.withContiguousMutableStorageIfAvailable({ Array($0) }), words, file: file, line: line)
    
    XCTAssertEqual(generic.withContiguousStorageIfAvailable({        Array($0) }), words, file: file, line: line)
    XCTAssertEqual(generic.withContiguousMutableStorageIfAvailable({ Array($0) }), words, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Elements x First, Last, Tail
//=----------------------------------------------------------------------------=

private func NBKAssertFirstLastTail<H: NBKFixedWidthInteger>(
_ integer: NBKDoubleWidth<H>, first: UInt, last: UInt, tail: H.Digit,
file: StaticString = #file, line: UInt = #line) {
    typealias T = NBKDoubleWidth<H>
    //=------------------------------------------=
    XCTAssertEqual(integer.first, first, file: file, line: line)
    XCTAssertEqual(integer.last,  last,  file: file, line: line)
    XCTAssertEqual(integer.tail,  tail,  file: file, line: line)
    //=------------------------------------------=
    XCTAssertEqual({ var x = T.zero; x.first = first; return x.first }(), first, file: file, line: line)
    XCTAssertEqual({ var x = T.zero; x.last  = last;  return x.last  }(), last,  file: file, line: line)
    XCTAssertEqual({ var x = T.zero; x.tail  = tail;  return x.tail  }(), tail,  file: file, line: line)
}
