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
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Get, Set
    //=------------------------------------------------------------------------=
    
    func testGetBitAtIndex() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertGetBitAtIndex(T(2), 0, false)
            NBKAssertGetBitAtIndex(T(2), 1, true )
            NBKAssertGetBitAtIndex(T(2), 2, false)
            
            NBKAssertGetBitAtIndex(T(4), 1, false)
            NBKAssertGetBitAtIndex(T(4), 2, true )
            NBKAssertGetBitAtIndex(T(4), 3, false)
            
            NBKAssertGetBitAtIndex(T(8), 2, false)
            NBKAssertGetBitAtIndex(T(8), 3, true )
            NBKAssertGetBitAtIndex(T(8), 4, false)
        }
        
        for type in types {
            whereIs(type)
        }
    }
    
    func testSetBitAtIndex() {
        func whereIs<T>(_ type: T.Type) where T: NBKCoreInteger {
            NBKAssertSetBitAtIndex(T( 0), 0, true,  T( 1))
            NBKAssertSetBitAtIndex(T( 0), 1, true,  T( 2))
            NBKAssertSetBitAtIndex(T( 0), 2, true,  T( 4))
            NBKAssertSetBitAtIndex(T( 0), 3, true,  T( 8))
            
            NBKAssertSetBitAtIndex(T(15), 0, false, T(15 - 1))
            NBKAssertSetBitAtIndex(T(15), 1, false, T(15 - 2))
            NBKAssertSetBitAtIndex(T(15), 2, false, T(15 - 4))
            NBKAssertSetBitAtIndex(T(15), 3, false, T(15 - 8))
        }
        
        for type in types {
            whereIs(type)
        }
    }
}

#endif
