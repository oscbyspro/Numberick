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
            XCTAssertEqual(T(bitPattern: T.Magnitude.min), T( 0))
            XCTAssertEqual(T(bitPattern: T.Magnitude.max), T(-1))
            
            XCTAssertEqual(T(bitPattern:  (T.Magnitude(1) << (T.bitWidth - 1))), T.min)
            XCTAssertEqual(T(bitPattern: ~(T.Magnitude(1) << (T.bitWidth - 1))), T.max)
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(T(bitPattern: T.Magnitude.min), T.min)
            XCTAssertEqual(T(bitPattern: T.Magnitude.max), T.max)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
    
    func testValueAsBitPattern() {
        func whereIsSigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(T( 0).bitPattern, T.Magnitude.min)
            XCTAssertEqual(T(-1).bitPattern, T.Magnitude.max)
            
            XCTAssertEqual(T.min.bitPattern,  (T.Magnitude(1) << (T.bitWidth - 1)))
            XCTAssertEqual(T.max.bitPattern, ~(T.Magnitude(1) << (T.bitWidth - 1)))
        }
        
        func whereIsUnsigned<T>(_ type: T.Type) where T: NBKCoreInteger {
            XCTAssertEqual(T.min.bitPattern, T.Magnitude.min)
            XCTAssertEqual(T.max.bitPattern, T.Magnitude.max)
        }
        
        for type: T in types {
            type.isSigned ? whereIsSigned(type) : whereIsUnsigned(type)
        }
    }
}

#endif
