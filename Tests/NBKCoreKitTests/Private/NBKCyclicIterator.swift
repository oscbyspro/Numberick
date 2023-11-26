//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2023 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Cyclic Iterator
//*============================================================================*

final class NBKCyclicIteratorTests: XCTestCase {
    
    typealias T = NBK.CyclicIterator
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testInit() {
        XCTAssertNil(   T([       ] as [UInt]))
        XCTAssertNotNil(T([1      ] as [UInt]))
        XCTAssertNotNil(T([1, 2   ] as [UInt]))
        XCTAssertNotNil(T([1, 2, 3] as [UInt]))
    }
    
    func testIterating() {
        NBKAssertCyclicIterator(T([1, 2, 3] as [UInt])!, 0, [                ] as [UInt])
        NBKAssertCyclicIterator(T([1, 2, 3] as [UInt])!, 1, [1               ] as [UInt])
        NBKAssertCyclicIterator(T([1, 2, 3] as [UInt])!, 2, [1, 2            ] as [UInt])
        NBKAssertCyclicIterator(T([1, 2, 3] as [UInt])!, 3, [1, 2, 3         ] as [UInt])
        NBKAssertCyclicIterator(T([1, 2, 3] as [UInt])!, 4, [1, 2, 3, 1      ] as [UInt])
        NBKAssertCyclicIterator(T([1, 2, 3] as [UInt])!, 5, [1, 2, 3, 1, 2   ] as [UInt])
        NBKAssertCyclicIterator(T([1, 2, 3] as [UInt])!, 6, [1, 2, 3, 1, 2, 3] as [UInt])
    }
}

//*============================================================================*
// MARK: * NBK x Cyclic Iterator x Assertions
//*============================================================================*

private func NBKAssertCyclicIterator<Base>(
_ iterator: NBK.CyclicIterator<Base>, _ count: Int, _ expectation: [Base.Element],
file: StaticString = #file, line: UInt = #line) where Base.Element: Equatable {
    var iterator = iterator
    var elements = [Base.Element]()
    
    for _ in 0 ..< count {
        elements.append(iterator.next())
    }
    
    XCTAssertEqual(elements, expectation, file: file, line: line)
}
