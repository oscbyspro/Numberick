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
// MARK: * NBK x Int256 x Words
//*============================================================================*

final class Int256TestsOnWords: XCTestCase {
    
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
    
    //=----------------------------------------------------------------------------=
    // MARK: + Indices
    //=----------------------------------------------------------------------------=
    
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
}

//*============================================================================*
// MARK: * NBK x UInt256 x Words
//*============================================================================*

final class UInt256TestsOnWords: XCTestCase {
    
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
    
    //=----------------------------------------------------------------------------=
    // MARK: + Indices
    //=----------------------------------------------------------------------------=
    
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
}

#endif
