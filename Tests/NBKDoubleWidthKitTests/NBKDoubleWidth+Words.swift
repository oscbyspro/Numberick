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
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK.U256X64
private typealias Y = NBK.U256X32

//*============================================================================*
// MARK: * NBK x Double Width x Words x Int256
//*============================================================================*

final class NBKDoubleWidthTestsOnWordsAsInt256: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertWords(T(x64: X(0, 0, 0, 0)), [0, 0, 0, 0])
        NBKAssertWords(T(x64: X(1, 0, 0, 0)), [1, 0, 0, 0])
        NBKAssertWords(T(x64: X(1, 2, 0, 0)), [1, 2, 0, 0])
        NBKAssertWords(T(x64: X(1, 2, 3, 0)), [1, 2, 3, 0])
        NBKAssertWords(T(x64: X(1, 2, 3, 4)), [1, 2, 3, 4])
    }
    
    func testWordsX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertWords(T(x32: Y(0, 0, 0, 0, 0, 0, 0, 0)), [0, 0, 0, 0, 0, 0, 0, 0])
        NBKAssertWords(T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0)), [1, 0, 0, 0, 0, 0, 0, 0])
        NBKAssertWords(T(x32: Y(1, 2, 0, 0, 0, 0, 0, 0)), [1, 2, 0, 0, 0, 0, 0, 0])
        NBKAssertWords(T(x32: Y(1, 2, 3, 0, 0, 0, 0, 0)), [1, 2, 3, 0, 0, 0, 0, 0])
        NBKAssertWords(T(x32: Y(1, 2, 3, 4, 0, 0, 0, 0)), [1, 2, 3, 4, 0, 0, 0, 0])
        NBKAssertWords(T(x32: Y(1, 2, 3, 4, 5, 0, 0, 0)), [1, 2, 3, 4, 5, 0, 0, 0])
        NBKAssertWords(T(x32: Y(1, 2, 3, 4, 5, 6, 0, 0)), [1, 2, 3, 4, 5, 6, 0, 0])
        NBKAssertWords(T(x32: Y(1, 2, 3, 4, 5, 6, 7, 0)), [1, 2, 3, 4, 5, 6, 7, 0])
        NBKAssertWords(T(x32: Y(1, 2, 3, 4, 5, 6, 7, 8)), [1, 2, 3, 4, 5, 6, 7, 8])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x First, Last, Tail
    //=------------------------------------------------------------------------=
    
    func testFirstLastTailX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertFirstLastTail( T(x64: X(1, 2, 3, 4)), first:  1, last:  4, tail:  4)
        NBKAssertFirstLastTail(~T(x64: X(1, 2, 3, 4)), first: ~1, last: ~4, tail: ~4)
    }
    
    func testFirstLastTailX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertFirstLastTail( T(x32: Y(1, 2, 3, 4, 5, 6, 7, 8)), first:  1, last:  8, tail:  8)
        NBKAssertFirstLastTail(~T(x32: Y(1, 2, 3, 4, 5, 6, 7, 8)), first: ~1, last: ~8, tail: ~8)
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
    
    func testWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertWords(T(x64: X(0, 0, 0, 0)), [0, 0, 0, 0])
        NBKAssertWords(T(x64: X(1, 0, 0, 0)), [1, 0, 0, 0])
        NBKAssertWords(T(x64: X(1, 2, 0, 0)), [1, 2, 0, 0])
        NBKAssertWords(T(x64: X(1, 2, 3, 0)), [1, 2, 3, 0])
        NBKAssertWords(T(x64: X(1, 2, 3, 4)), [1, 2, 3, 4])
    }
    
    func testWordsX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertWords(T(x32: Y(0, 0, 0, 0, 0, 0, 0, 0)), [0, 0, 0, 0, 0, 0, 0, 0])
        NBKAssertWords(T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0)), [1, 0, 0, 0, 0, 0, 0, 0])
        NBKAssertWords(T(x32: Y(1, 2, 0, 0, 0, 0, 0, 0)), [1, 2, 0, 0, 0, 0, 0, 0])
        NBKAssertWords(T(x32: Y(1, 2, 3, 0, 0, 0, 0, 0)), [1, 2, 3, 0, 0, 0, 0, 0])
        NBKAssertWords(T(x32: Y(1, 2, 3, 4, 0, 0, 0, 0)), [1, 2, 3, 4, 0, 0, 0, 0])
        NBKAssertWords(T(x32: Y(1, 2, 3, 4, 5, 0, 0, 0)), [1, 2, 3, 4, 5, 0, 0, 0])
        NBKAssertWords(T(x32: Y(1, 2, 3, 4, 5, 6, 0, 0)), [1, 2, 3, 4, 5, 6, 0, 0])
        NBKAssertWords(T(x32: Y(1, 2, 3, 4, 5, 6, 7, 0)), [1, 2, 3, 4, 5, 6, 7, 0])
        NBKAssertWords(T(x32: Y(1, 2, 3, 4, 5, 6, 7, 8)), [1, 2, 3, 4, 5, 6, 7, 8])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x First, Last, Tail
    //=------------------------------------------------------------------------=
    
    func testFirstLastTailX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        NBKAssertFirstLastTail( T(x64: X(1, 2, 3, 4)), first:  1, last:  4, tail:  4)
        NBKAssertFirstLastTail(~T(x64: X(1, 2, 3, 4)), first: ~1, last: ~4, tail: ~4)
    }
    
    func testFirstLastTailX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        NBKAssertFirstLastTail( T(x32: Y(1, 2, 3, 4, 5, 6, 7, 8)), first:  1, last:  8, tail:  8)
        NBKAssertFirstLastTail(~T(x32: Y(1, 2, 3, 4, 5, 6, 7, 8)), first: ~1, last: ~8, tail: ~8)
    }
}

//*============================================================================*
// MARK: * NBK x Double Width x Words x Assertions
//*============================================================================*

private func NBKAssertWords<H: NBKFixedWidthInteger>(
_ integer: NBKDoubleWidth<H>, _ words: [UInt],
file: StaticString = #file, line: UInt = #line) {
    var integer: NBKDoubleWidth<H> = integer
    var generic: some RandomAccessCollection<UInt> & MutableCollection = integer
    
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

#endif
