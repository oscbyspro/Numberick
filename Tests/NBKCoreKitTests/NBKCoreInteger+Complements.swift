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
// MARK: * NBK x Core Integer x Complements
//*============================================================================*

final class NBKCoreIntegerTestsOnComplements: XCTestCase {
    
    typealias T = any NBKCoreInteger.Type
    
    //=------------------------------------------------------------------------=
    // MARK: State
    //=------------------------------------------------------------------------=
    
    let types: [T] = NBKCoreIntegerTests.types
    
    //=------------------------------------------------------------------------=
    // MARK: Tests x Bit Pattern
    //=------------------------------------------------------------------------=
    
    func testInitBitPattern() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(M(bitPattern: T( 0)), M.min)
            XCTAssertEqual(M(bitPattern: T(-1)), M.max)
            
            XCTAssertEqual(T(bitPattern: M.min), T( 0))
            XCTAssertEqual(T(bitPattern: M.max), T(-1))
            
            XCTAssertEqual(T(bitPattern:  (M(1) << (T.bitWidth - 1))), T.min)
            XCTAssertEqual(T(bitPattern: ~(M(1) << (T.bitWidth - 1))), T.max)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T(bitPattern: M.min), T.min)
            XCTAssertEqual(T(bitPattern: M.max), T.max)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testValueAsBitPattern() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T( 0).bitPattern, M.min)
            XCTAssertEqual(T(-1).bitPattern, M.max)
            
            XCTAssertEqual(T.min.bitPattern,  (M(1) << (T.bitWidth - 1)))
            XCTAssertEqual(T.max.bitPattern, ~(M(1) << (T.bitWidth - 1)))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            typealias M = T.Magnitude
            
            XCTAssertEqual(T.min.bitPattern, M.min)
            XCTAssertEqual(T.max.bitPattern, M.max)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}

#endif
