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
import NBKDoubleWidthKit
import XCTest

private typealias X = NBK256X64
private typealias Y = NBK256X32

//*============================================================================*
// MARK: * Int256 x Words
//*============================================================================*

final class Int256TestsOnWords: XCTestCase {
    
    typealias T = Int256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        XCTAssertEqual(T(x64: X(0, 0, 0, 0)).words.map({ $0 }), [0, 0, 0, 0])
        XCTAssertEqual(T(x64: X(1, 0, 0, 0)).words.map({ $0 }), [1, 0, 0, 0])
        XCTAssertEqual(T(x64: X(1, 2, 0, 0)).words.map({ $0 }), [1, 2, 0, 0])
        XCTAssertEqual(T(x64: X(1, 2, 3, 0)).words.map({ $0 }), [1, 2, 3, 0])
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)).words.map({ $0 }), [1, 2, 3, 4])
    }
    
    func testWordsX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 0, 0, 0)).words.map({ $0 }), [0, 0, 0, 0, 0, 0, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0)).words.map({ $0 }), [1, 0, 0, 0, 0, 0, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 0, 0, 0, 0, 0, 0)).words.map({ $0 }), [1, 2, 0, 0, 0, 0, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 3, 0, 0, 0, 0, 0)).words.map({ $0 }), [1, 2, 3, 0, 0, 0, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 3, 4, 0, 0, 0, 0)).words.map({ $0 }), [1, 2, 3, 4, 0, 0, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 3, 4, 5, 0, 0, 0)).words.map({ $0 }), [1, 2, 3, 4, 5, 0, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 3, 4, 5, 6, 0, 0)).words.map({ $0 }), [1, 2, 3, 4, 5, 6, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 3, 4, 5, 6, 7, 0)).words.map({ $0 }), [1, 2, 3, 4, 5, 6, 7, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 3, 4, 5, 6, 7, 8)).words.map({ $0 }), [1, 2, 3, 4, 5, 6, 7, 8])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Min Two's Complement Form
    //=------------------------------------------------------------------------=
    
    func testMinLastIndexReportingIsZeroOrMinusOneX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        XCTAssert(( T(x64: X(0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (0, true ) as (Int, Bool))
        XCTAssert(( T(x64: X(1, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (0, false) as (Int, Bool))
        XCTAssert(( T(x64: X(0, 1, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (1, false) as (Int, Bool))
        XCTAssert(( T(x64: X(0, 0, 1, 0))).minLastIndexReportingIsZeroOrMinusOne() == (2, false) as (Int, Bool))
        XCTAssert(( T(x64: X(0, 0, 0, 1))).minLastIndexReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        
        XCTAssert((~T(x64: X(0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (0, true ) as (Int, Bool))
        XCTAssert((~T(x64: X(1, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (0, false) as (Int, Bool))
        XCTAssert((~T(x64: X(0, 1, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (1, false) as (Int, Bool))
        XCTAssert((~T(x64: X(0, 0, 1, 0))).minLastIndexReportingIsZeroOrMinusOne() == (2, false) as (Int, Bool))
        XCTAssert((~T(x64: X(0, 0, 0, 1))).minLastIndexReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
    }
    
    func testMinWordCountReportingIsZeroOrMinusOneX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        XCTAssert(( T(x64: X(0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (1, true ) as (Int, Bool))
        XCTAssert(( T(x64: X(1, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (1, false) as (Int, Bool))
        XCTAssert(( T(x64: X(0, 1, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (2, false) as (Int, Bool))
        XCTAssert(( T(x64: X(0, 0, 1, 0))).minWordCountReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert(( T(x64: X(0, 0, 0, 1))).minWordCountReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
        
        XCTAssert((~T(x64: X(0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (1, true ) as (Int, Bool))
        XCTAssert((~T(x64: X(1, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (1, false) as (Int, Bool))
        XCTAssert((~T(x64: X(0, 1, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (2, false) as (Int, Bool))
        XCTAssert((~T(x64: X(0, 0, 1, 0))).minWordCountReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert((~T(x64: X(0, 0, 0, 1))).minWordCountReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
    }
    
    func testMinLastIndexReportingIsZeroOrMinusOneX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (0, true ) as (Int, Bool))
        XCTAssert(( T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (0, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 1, 0, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (1, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 1, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (2, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 1, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 1, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 1, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (5, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 0, 1, 0))).minLastIndexReportingIsZeroOrMinusOne() == (6, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 0, 0, 1))).minLastIndexReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (0, true ) as (Int, Bool))
        XCTAssert((~T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (0, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 1, 0, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (1, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 1, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (2, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 1, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 1, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 1, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (5, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 0, 1, 0))).minLastIndexReportingIsZeroOrMinusOne() == (6, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 0, 0, 1))).minLastIndexReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
    }
    
    func testMinWordCountReportingIsZeroOrMinusOneX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (1, true ) as (Int, Bool))
        XCTAssert(( T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (1, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 1, 0, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (2, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 1, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 1, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 1, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (5, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 1, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (6, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 0, 1, 0))).minWordCountReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 0, 0, 1))).minWordCountReportingIsZeroOrMinusOne() == (8, false) as (Int, Bool))
        
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (1, true ) as (Int, Bool))
        XCTAssert((~T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (1, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 1, 0, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (2, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 1, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 1, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 1, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (5, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 1, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (6, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 0, 1, 0))).minWordCountReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 0, 0, 1))).minWordCountReportingIsZeroOrMinusOne() == (8, false) as (Int, Bool))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Pointers
    //=------------------------------------------------------------------------=
    
    func testWithUnsafeWords() {
        let x0 = T(truncatingIfNeeded:  0)
        let x1 = T(truncatingIfNeeded: -1)
        
        x0.withUnsafeWords { words in
            XCTAssertEqual(words.count, T.count)
            XCTAssert(words.allSatisfy({  $0 == UInt.min }))
        }
        
        x1.withUnsafeWords { words in
            XCTAssertEqual(words.count, T.count)
            XCTAssert(words.allSatisfy({  $0 == UInt.max }))
        }
    }
    
    func testWithUnsafeMutableWords() {
        var x0 = T(truncatingIfNeeded:  0)
        let x1 = T(truncatingIfNeeded: -1)
                
        x0.withUnsafeMutableWords { words in
            XCTAssertEqual(words.count, T.count)
            XCTAssert(words.allSatisfy({  $0 == UInt.min }))
            words.indices.forEach({ words[$0] = UInt.max })
            XCTAssert(words.allSatisfy({  $0 == UInt.max }))
        };  XCTAssertEqual(x0, x1)
    }
    
    func testFromUnsafeMutableWords() {
        let x0 = T(truncatingIfNeeded:  0)
        let x1 = T(truncatingIfNeeded: -1)
                
        let y0 = T.fromUnsafeMutableWords { words in
            XCTAssertEqual(words.count, T.count)
            words.indices.forEach({ words[$0] = UInt.min })
            XCTAssert(words.allSatisfy({  $0 == UInt.min }))
        };  XCTAssertEqual(x0, y0)
        
        let y1 = T.fromUnsafeMutableWords { words in
            XCTAssertEqual(words.count, T.count)
            words.indices.forEach({ words[$0] = UInt.max })
            XCTAssert(words.allSatisfy({  $0 == UInt.max }))
        };  XCTAssertEqual(x1, y1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Pointers x Contiguous UInt Sequence
    //=------------------------------------------------------------------------=
    
    func testWithContiguousStorageIfAvailable() {
        let x0 = T(truncatingIfNeeded:  0)
        let x1 = T(truncatingIfNeeded: -1)
        
        let s0: Void? = x0.withContiguousStorageIfAvailable { words in
            XCTAssertEqual(words.count, T.count)
            XCTAssert(words.allSatisfy({  $0 == UInt.min }))
        };  XCTAssertNotNil(s0)
        
        let s1: Void? = x1.withContiguousStorageIfAvailable { words in
            XCTAssertEqual(words.count, T.count)
            XCTAssert(words.allSatisfy({  $0 == UInt.max }))
        };  XCTAssertNotNil(s1)
    }
    
    func testWithContiguousMutableStorageIfAvailable() {
        var x0 = T(truncatingIfNeeded:  0)
        let x1 = T(truncatingIfNeeded: -1)
                
        x0.withContiguousMutableStorageIfAvailable { words in
            XCTAssertEqual(words.count, T.count)
            XCTAssert(words.allSatisfy({  $0 == UInt.min }))
            words.indices.forEach({ words[$0] = UInt.max })
            XCTAssert(words.allSatisfy({  $0 == UInt.max }))
        };  XCTAssertEqual(x0, x1)
    }
}

//*============================================================================*
// MARK: * UInt256 x Words
//*============================================================================*

final class UInt256TestsOnWords: XCTestCase {
    
    typealias T = UInt256
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testWordsX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        XCTAssertEqual(T(x64: X(0, 0, 0, 0)).words.map({ $0 }), [0, 0, 0, 0])
        XCTAssertEqual(T(x64: X(1, 0, 0, 0)).words.map({ $0 }), [1, 0, 0, 0])
        XCTAssertEqual(T(x64: X(1, 2, 0, 0)).words.map({ $0 }), [1, 2, 0, 0])
        XCTAssertEqual(T(x64: X(1, 2, 3, 0)).words.map({ $0 }), [1, 2, 3, 0])
        XCTAssertEqual(T(x64: X(1, 2, 3, 4)).words.map({ $0 }), [1, 2, 3, 4])
    }
    
    func testWordsX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        XCTAssertEqual(T(x32: Y(0, 0, 0, 0, 0, 0, 0, 0)).words.map({ $0 }), [0, 0, 0, 0, 0, 0, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0)).words.map({ $0 }), [1, 0, 0, 0, 0, 0, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 0, 0, 0, 0, 0, 0)).words.map({ $0 }), [1, 2, 0, 0, 0, 0, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 3, 0, 0, 0, 0, 0)).words.map({ $0 }), [1, 2, 3, 0, 0, 0, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 3, 4, 0, 0, 0, 0)).words.map({ $0 }), [1, 2, 3, 4, 0, 0, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 3, 4, 5, 0, 0, 0)).words.map({ $0 }), [1, 2, 3, 4, 5, 0, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 3, 4, 5, 6, 0, 0)).words.map({ $0 }), [1, 2, 3, 4, 5, 6, 0, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 3, 4, 5, 6, 7, 0)).words.map({ $0 }), [1, 2, 3, 4, 5, 6, 7, 0])
        XCTAssertEqual(T(x32: Y(1, 2, 3, 4, 5, 6, 7, 8)).words.map({ $0 }), [1, 2, 3, 4, 5, 6, 7, 8])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Min Two's Complement Form
    //=------------------------------------------------------------------------=
    
    func testMinLastIndexReportingIsZeroOrMinusOneX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        XCTAssert(( T(x64: X(0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (0, true ) as (Int, Bool))
        XCTAssert(( T(x64: X(1, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (0, false) as (Int, Bool))
        XCTAssert(( T(x64: X(0, 1, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (1, false) as (Int, Bool))
        XCTAssert(( T(x64: X(0, 0, 1, 0))).minLastIndexReportingIsZeroOrMinusOne() == (2, false) as (Int, Bool))
        XCTAssert(( T(x64: X(0, 0, 0, 1))).minLastIndexReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        
        XCTAssert((~T(x64: X(0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert((~T(x64: X(1, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert((~T(x64: X(0, 1, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert((~T(x64: X(0, 0, 1, 0))).minLastIndexReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert((~T(x64: X(0, 0, 0, 1))).minLastIndexReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
    }
    
    func testMinWordCountReportingIsZeroOrMinusOneX64() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt64>.size else { throw XCTSkip() }
        
        XCTAssert(( T(x64: X(0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (1, true ) as (Int, Bool))
        XCTAssert(( T(x64: X(1, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (1, false) as (Int, Bool))
        XCTAssert(( T(x64: X(0, 1, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (2, false) as (Int, Bool))
        XCTAssert(( T(x64: X(0, 0, 1, 0))).minWordCountReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert(( T(x64: X(0, 0, 0, 1))).minWordCountReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
        
        XCTAssert((~T(x64: X(0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
        XCTAssert((~T(x64: X(1, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
        XCTAssert((~T(x64: X(0, 1, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
        XCTAssert((~T(x64: X(0, 0, 1, 0))).minWordCountReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
        XCTAssert((~T(x64: X(0, 0, 0, 1))).minWordCountReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
    }
    
    func testMinLastIndexReportingIsZeroOrMinusOneX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (0, true ) as (Int, Bool))
        XCTAssert(( T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (0, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 1, 0, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (1, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 1, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (2, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 1, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 1, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 1, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (5, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 0, 1, 0))).minLastIndexReportingIsZeroOrMinusOne() == (6, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 0, 0, 1))).minLastIndexReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 1, 0, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 1, 0, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 1, 0, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 1, 0, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 1, 0, 0))).minLastIndexReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 0, 1, 0))).minLastIndexReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 0, 0, 1))).minLastIndexReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
    }
    
    func testMinWordCountReportingIsZeroOrMinusOneX32() throws {
        guard MemoryLayout<UInt>.size == MemoryLayout<UInt32>.size else { throw XCTSkip() }
        
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (1, true ) as (Int, Bool))
        XCTAssert(( T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (1, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 1, 0, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (2, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 1, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (3, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 1, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (4, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 1, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (5, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 1, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (6, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 0, 1, 0))).minWordCountReportingIsZeroOrMinusOne() == (7, false) as (Int, Bool))
        XCTAssert(( T(x32: Y(0, 0, 0, 0, 0, 0, 0, 1))).minWordCountReportingIsZeroOrMinusOne() == (8, false) as (Int, Bool))
        
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (8, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(1, 0, 0, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (8, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 1, 0, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (8, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 1, 0, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (8, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 1, 0, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (8, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 1, 0, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (8, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 1, 0, 0))).minWordCountReportingIsZeroOrMinusOne() == (8, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 0, 1, 0))).minWordCountReportingIsZeroOrMinusOne() == (8, false) as (Int, Bool))
        XCTAssert((~T(x32: Y(0, 0, 0, 0, 0, 0, 0, 1))).minWordCountReportingIsZeroOrMinusOne() == (8, false) as (Int, Bool))
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Pointers
    //=------------------------------------------------------------------------=
    
    func testWithUnsafeWords() {
        let x0 = T(truncatingIfNeeded:  0)
        let x1 = T(truncatingIfNeeded: -1)
        
        x0.withUnsafeWords { words in
            XCTAssertEqual(words.count, T.count)
            XCTAssert(words.allSatisfy({  $0 == UInt.min }))
        }
        
        x1.withUnsafeWords { words in
            XCTAssertEqual(words.count, T.count)
            XCTAssert(words.allSatisfy({  $0 == UInt.max }))
        }
    }
    
    func testWithUnsafeMutableWords() {
        var x0 = T(truncatingIfNeeded:  0)
        let x1 = T(truncatingIfNeeded: -1)
                
        x0.withUnsafeMutableWords { words in
            XCTAssertEqual(words.count, T.count)
            XCTAssert(words.allSatisfy({  $0 == UInt.min }))
            words.indices.forEach({ words[$0] = UInt.max })
            XCTAssert(words.allSatisfy({  $0 == UInt.max }))
        };  XCTAssertEqual(x0, x1)
    }
    
    func testFromUnsafeMutableWords() {
        let x0 = T(truncatingIfNeeded:  0)
        let x1 = T(truncatingIfNeeded: -1)
                
        let y0 = T.fromUnsafeMutableWords { words in
            XCTAssertEqual(words.count, T.count)
            words.indices.forEach({ words[$0] = UInt.min })
            XCTAssert(words.allSatisfy({  $0 == UInt.min }))
        };  XCTAssertEqual(x0, y0)
        
        let y1 = T.fromUnsafeMutableWords { words in
            XCTAssertEqual(words.count, T.count)
            words.indices.forEach({ words[$0] = UInt.max })
            XCTAssert(words.allSatisfy({  $0 == UInt.max }))
        };  XCTAssertEqual(x1, y1)
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Pointers x Contiguous UInt Sequence
    //=------------------------------------------------------------------------=
    
    func testWithContiguousStorageIfAvailable() {
        let x0 = T(truncatingIfNeeded:  0)
        let x1 = T(truncatingIfNeeded: -1)
        
        let s0: Void? = x0.withContiguousStorageIfAvailable { words in
            XCTAssertEqual(words.count, T.count)
            XCTAssert(words.allSatisfy({  $0 == UInt.min }))
        };  XCTAssertNotNil(s0)
        
        let s1: Void? = x1.withContiguousStorageIfAvailable { words in
            XCTAssertEqual(words.count, T.count)
            XCTAssert(words.allSatisfy({  $0 == UInt.max }))
        };  XCTAssertNotNil(s1)
    }
    
    func testWithContiguousMutableStorageIfAvailable() {
        var x0 = T(truncatingIfNeeded:  0)
        let x1 = T(truncatingIfNeeded: -1)
                
        x0.withContiguousMutableStorageIfAvailable { words in
            XCTAssertEqual(words.count, T.count)
            XCTAssert(words.allSatisfy({  $0 == UInt.min }))
            words.indices.forEach({ words[$0] = UInt.max })
            XCTAssert(words.allSatisfy({  $0 == UInt.max }))
        };  XCTAssertEqual(x0, x1)
    }
}

#endif
