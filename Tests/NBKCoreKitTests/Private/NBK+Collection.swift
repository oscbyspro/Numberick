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
import XCTest

//*============================================================================*
// MARK: * NBK x Collection
//*============================================================================*

final class NBKTestsOnCollection: XCTestCase {
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Drop
    //=------------------------------------------------------------------------=
    
    func testDropLastWhile() {
        NBKAssertDropLastWhile([1, 2, 3, 4, 5], { $0 > 0 }, [             ])
        NBKAssertDropLastWhile([1, 2, 3, 4, 5], { $0 > 1 }, [1            ])
        NBKAssertDropLastWhile([1, 2, 3, 4, 5], { $0 > 2 }, [1, 2         ])
        NBKAssertDropLastWhile([1, 2, 3, 4, 5], { $0 > 3 }, [1, 2, 3      ])
        NBKAssertDropLastWhile([1, 2, 3, 4, 5], { $0 > 4 }, [1, 2, 3, 4   ])
        NBKAssertDropLastWhile([1, 2, 3, 4, 5], { $0 > 5 }, [1, 2, 3, 4, 5])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Remove Count
    //=------------------------------------------------------------------------=
    
    func testRemovePrefixCount() {
        NBKAssertRemovePrefixCount(0, [             ], [1, 2, 3, 4, 5])
        NBKAssertRemovePrefixCount(1, [1            ], [   2, 3, 4, 5])
        NBKAssertRemovePrefixCount(2, [1, 2         ], [      3, 4, 5])
        NBKAssertRemovePrefixCount(3, [1, 2, 3      ], [         4, 5])
        NBKAssertRemovePrefixCount(4, [1, 2, 3, 4   ], [            5])
        NBKAssertRemovePrefixCount(5, [1, 2, 3, 4, 5], [             ])
    }
    
    func testRemoveSuffixCount() {
        NBKAssertRemoveSuffixCount(0, [1, 2, 3, 4, 5], [             ])
        NBKAssertRemoveSuffixCount(1, [1, 2, 3, 4   ], [            5])
        NBKAssertRemoveSuffixCount(2, [1, 2, 3      ], [         4, 5])
        NBKAssertRemoveSuffixCount(3, [1, 2         ], [      3, 4, 5])
        NBKAssertRemoveSuffixCount(4, [1            ], [   2, 3, 4, 5])
        NBKAssertRemoveSuffixCount(5, [             ], [1, 2, 3, 4, 5])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Remove Max Length
    //=------------------------------------------------------------------------=
    
    func testRemovePrefixMaxLength() {
        NBKAssertRemovePrefixMaxLength(0, [             ], [1, 2, 3, 4, 5])
        NBKAssertRemovePrefixMaxLength(1, [1            ], [   2, 3, 4, 5])
        NBKAssertRemovePrefixMaxLength(2, [1, 2         ], [      3, 4, 5])
        NBKAssertRemovePrefixMaxLength(3, [1, 2, 3      ], [         4, 5])
        NBKAssertRemovePrefixMaxLength(4, [1, 2, 3, 4   ], [            5])
        NBKAssertRemovePrefixMaxLength(5, [1, 2, 3, 4, 5], [             ])
        NBKAssertRemovePrefixMaxLength(6, [1, 2, 3, 4, 5], [             ])
        NBKAssertRemovePrefixMaxLength(7, [1, 2, 3, 4, 5], [             ])
        NBKAssertRemovePrefixMaxLength(8, [1, 2, 3, 4, 5], [             ])
        NBKAssertRemovePrefixMaxLength(9, [1, 2, 3, 4, 5], [             ])
    }
    
    func testRemoveSuffixMaxLength() {
        NBKAssertRemoveSuffixMaxLength(0, [1, 2, 3, 4, 5], [             ])
        NBKAssertRemoveSuffixMaxLength(1, [1, 2, 3, 4   ], [            5])
        NBKAssertRemoveSuffixMaxLength(2, [1, 2, 3      ], [         4, 5])
        NBKAssertRemoveSuffixMaxLength(3, [1, 2         ], [      3, 4, 5])
        NBKAssertRemoveSuffixMaxLength(4, [1            ], [   2, 3, 4, 5])
        NBKAssertRemoveSuffixMaxLength(5, [             ], [1, 2, 3, 4, 5])
        NBKAssertRemoveSuffixMaxLength(6, [             ], [1, 2, 3, 4, 5])
        NBKAssertRemoveSuffixMaxLength(7, [             ], [1, 2, 3, 4, 5])
        NBKAssertRemoveSuffixMaxLength(8, [             ], [1, 2, 3, 4, 5])
        NBKAssertRemoveSuffixMaxLength(9, [             ], [1, 2, 3, 4, 5])
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Array Index
    //=------------------------------------------------------------------------=
    
    func testArrayIndexOffsetByLimitedBy() {
        NBKAssertArrayIndexOffsetByLimitedBy(1,  2,  2,  nil)
        NBKAssertArrayIndexOffsetByLimitedBy(1,  1,  2,  2)
        NBKAssertArrayIndexOffsetByLimitedBy(1,  0,  2,  1)
        NBKAssertArrayIndexOffsetByLimitedBy(1, -1,  2,  0)
        NBKAssertArrayIndexOffsetByLimitedBy(1, -2,  2, -1)
        
        NBKAssertArrayIndexOffsetByLimitedBy(2,  2,  2,  nil)
        NBKAssertArrayIndexOffsetByLimitedBy(2,  1,  2,  nil)
        NBKAssertArrayIndexOffsetByLimitedBy(2,  0,  2,  2)
        NBKAssertArrayIndexOffsetByLimitedBy(2, -1,  2,  nil)
        NBKAssertArrayIndexOffsetByLimitedBy(2, -2,  2,  nil)
        
        NBKAssertArrayIndexOffsetByLimitedBy(3,  2,  2,  5)
        NBKAssertArrayIndexOffsetByLimitedBy(3,  1,  2,  4)
        NBKAssertArrayIndexOffsetByLimitedBy(3,  0,  2,  3)
        NBKAssertArrayIndexOffsetByLimitedBy(3, -1,  2,  2)
        NBKAssertArrayIndexOffsetByLimitedBy(3, -2,  2,  nil)
    }
}

//*============================================================================*
// MARK: * NBK x Collection x Assertions
//*============================================================================*
//=----------------------------------------------------------------------------=
// MARK: + Drop
//=----------------------------------------------------------------------------=

private func NBKAssertDropLastWhile(
_ collection: [Int], _ predicate: (Int) -> Bool, _ subsequence: [Int],
file: StaticString = #file, line: UInt = #line) {
    let result = NBK.dropLast(from: collection, while: predicate)
    XCTAssertEqual(Array(result),  subsequence, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Remove Count
//=----------------------------------------------------------------------------=

private func NBKAssertRemovePrefixCount(
_ count: Int, _ prefix: [Int], _ suffix: [Int],
file: StaticString = #file, line: UInt = #line) {
    var collection = (prefix + suffix)[...]
    let extraction = NBK.removePrefix(from: &collection, count: count)
    
    XCTAssertEqual(Array(extraction), prefix, file: file, line: line)
    XCTAssertEqual(Array(collection), suffix, file: file, line: line)
}

private func NBKAssertRemoveSuffixCount(
_ count: Int, _ prefix: [Int], _ suffix: [Int],
file: StaticString = #file, line: UInt = #line) {
    var collection = (prefix + suffix)[...]
    let extraction = NBK.removeSuffix(from: &collection, count: count)
    
    XCTAssertEqual(Array(collection), prefix, file: file, line: line)
    XCTAssertEqual(Array(extraction), suffix, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Remove Max Length
//=----------------------------------------------------------------------------=

private func NBKAssertRemovePrefixMaxLength(
_ maxLength: Int, _ prefix: [Int], _ suffix: [Int],
file: StaticString = #file, line: UInt = #line) {
    var collection = (prefix + suffix)[...]
    let extraction = NBK.removePrefix(from: &collection, maxLength: maxLength)
    
    XCTAssertEqual(Array(extraction), prefix, file: file, line: line)
    XCTAssertEqual(Array(collection), suffix, file: file, line: line)
}

private func NBKAssertRemoveSuffixMaxLength(
_ maxLength: Int, _ prefix: [Int], _ suffix: [Int],
file: StaticString = #file, line: UInt = #line) {
    var collection = (prefix + suffix)[...]
    let extraction = NBK.removeSuffix(from: &collection, maxLength: maxLength)
    
    XCTAssertEqual(Array(collection), prefix, file: file, line: line)
    XCTAssertEqual(Array(extraction), suffix, file: file, line: line)
}

//=----------------------------------------------------------------------------=
// MARK: + Array Index
//=----------------------------------------------------------------------------=

private func NBKAssertArrayIndexOffsetByLimitedBy(
_ index: Int, _ distance: Int, _ limit: Int, _ expectation: Int?,
file: StaticString = #file, line: UInt = #line) {
    
    XCTAssertEqual(NBK.arrayIndex(index, offsetBy: distance, limitedBy: limit), expectation, file: file, line: line)
    XCTAssertEqual([Int]( ).index(index, offsetBy: distance, limitedBy: limit), expectation, file: file, line: line)
}

#endif
