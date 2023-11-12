//=----------------------------------------------------------------------------=
// This source file is part of the Numberick open source project.
//
// Copyright (c) 2022 Oscar Byström Ericsson
// Licensed under Apache License, Version 2.0
//
// See http://www.apache.org/licenses/LICENSE-2.0 for license information.
//=----------------------------------------------------------------------------=

import NBKCoreKit
import XCTest

//*============================================================================*
// MARK: * NBK x Core Integer x Bits
//*============================================================================*

final class NBKCoreIntegerTestsOnBits: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests
    //=------------------------------------------------------------------------=
    
    func testFromBit() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(T(bit: false), T( ))
            XCTAssertEqual(T(bit: true ), T(1))
        }
        
        for type in types {
            whereIs(type)
        }
    }
    
    func testFromRepeatingBit() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(T(repeating: false),  T( ))
            XCTAssertEqual(T(repeating: true ), ~T( ))
        }
        
        for type in types {
            whereIs(type)
        }
    }
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Accessors
    //=------------------------------------------------------------------------=
    
    func testMostSignificantBit() {
        for type: T in types {
            XCTAssertEqual(type.min .mostSignificantBit,  type.isSigned)
            XCTAssertEqual(type.zero.mostSignificantBit,  false)
            XCTAssertEqual(type.max .mostSignificantBit, !type.isSigned)
        }
    }
    
    func testLeastSignificantBit() {
        for type: T in types {
            XCTAssertEqual(type.min .leastSignificantBit, false)
            XCTAssertEqual(type.zero.leastSignificantBit, false)
            XCTAssertEqual(type.max .leastSignificantBit, true )
        }
    }
}
